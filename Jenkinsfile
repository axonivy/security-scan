pipeline {
  agent any

  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  triggers {
    cron '@weekly'
  }

  stages {
    stage('run ZAP') {
      steps {
        script {
          docker.build("ivy-zap-engine", "--pull .").withRun() { c ->
            def dockerImage =  docker.build("ivy-zap2docker", "--pull ./ivy-zap2docker")
            dockerImage.inside("--link ${c.id}:ivyengine -p 5050:5050 -v $WORKSPACE:/tmp ") { d ->
              def TARGET_PORT = '8080'
              def TARGET_URL = "http://ivyengine:$TARGET_PORT/"
              def PROXY_PORT = '5050'
              def API="http://localhost:$PROXY_PORT/JSON"
              sh """
                while [ \$(curl -L -o /dev/null --silent --head --write-out '%{http_code}\n' $TARGET_URL) -ne 200 ]; do sleep 2; done
                mkdir -p /home/zap/.ZAP/policies; cp /tmp/IvyPolicy.policy /home/zap/.ZAP/policies/
                cp -f /tmp/report.html.xsl /zap/xml/
                cp -f /tmp/UrlsToTestAgainst.txt /zap/xml/
                cp -f /tmp/IvyContext.context /zap/
                sed -i 's/IVY_PORT/$TARGET_PORT/g' /zap/xml/UrlsToTestAgainst.txt
                sed -i 's/IVY_PORT/$TARGET_PORT/g' /zap/IvyContext.context
                alias zap="zap-cli -v -p $PROXY_PORT"
                zap start -o '-config api.disablekey=true'
                zap status -t 120
                zap context import /zap/IvyContext.context
                curl $API/importurls/action/autoupdate/action/installAddon/?id=exim
                curl $API/importurls/action/importurls/?zapapiformat=JSON&formMethod=GET&filePath=/zap/xml/UrlsToTestAgainst.txt
                curl $API/ascan/action/setOptionDefaultPolicy/?zapapiformat=JSON&formMethod=GET&String=IvyPolicy
                zap open-url $TARGET_URL
                zap spider -c IvyContext $TARGET_URL
                zap active-scan -c IvyContext -r $TARGET_URL
                zap report -o /tmp/IvyEngine_ZAP_report.html -f html
                zap report -o /tmp/IvyEngine_ZAP_report.xml -f xml
                cp -f /tmp/report.text.xsl /zap/xml/report.html.xsl
                zap report -o /tmp/IvyEngine_ZAP_report.txt -f html
                cp /zap/zap.log /tmp/IvyEngine_ZAP_log.log
              """
            }
          }
          archiveArtifacts 'IvyEngine_ZAP*.*'
        }
      }
    }

    stage('warnings') {
      steps {
        recordIssues tools: [groovyScript(parserId: 'ivy-zap', pattern: 'IvyEngine_ZAP_report.txt')], unstableTotalHigh: 11
      }
    }
  }
}
