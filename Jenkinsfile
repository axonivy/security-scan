pipeline {
  agent any

  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  triggers {
    cron 'H 5 * * *'
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
              sh """
                while [ \$(curl -L -o /dev/null --silent --head --write-out '%{http_code}\n' $TARGET_URL) -ne 200 ]; do sleep 2; done
                mkdir -p /home/zap/.ZAP/policies; cp /tmp/IvyPolicy.policy /home/zap/.ZAP/policies/
                cp -f /tmp/report.html.xsl /zap/xml/
                cp -f /tmp/UrlsToTestAgainst.txt /zap/xml/
                cp -f /tmp/IvyContext.context /zap/
                sed -i 's/IVY_PORT/$TARGET_PORT/g' /zap/xml/UrlsToTestAgainst.txt
                sed -i 's/IVY_PORT/$TARGET_PORT/g' /zap/IvyContext.context
                zap-cli -v -p $PROXY_PORT start -o '-config api.disablekey=true'
                zap-cli -v -p $PROXY_PORT status -t 120
                zap-cli -v -p $PROXY_PORT context import /zap/IvyContext.context
                curl "http://localhost:$PROXY_PORT/JSON/importurls/action/importurls/?zapapiformat=JSON&formMethod=GET&filePath=/zap/xml/UrlsToTestAgainst.txt"
                curl "http://localhost:$PROXY_PORT/JSON/ascan/action/setOptionDefaultPolicy/?zapapiformat=JSON&formMethod=GET&String=IvyPolicy"
                zap-cli -v -p $PROXY_PORT open-url $TARGET_URL
                zap-cli -v -p $PROXY_PORT spider -c IvyContext $TARGET_URL
                zap-cli -v -p $PROXY_PORT active-scan -c IvyContext -r $TARGET_URL
                zap-cli -v -p $PROXY_PORT report -o /tmp/IvyEngine_ZAP_report.html -f html
                zap-cli -v -p $PROXY_PORT report -o /tmp/IvyEngine_ZAP_report.xml -f xml
                cp -f /tmp/report.text.xsl /zap/xml/report.html.xsl
                zap-cli -v -p $PROXY_PORT report -o /tmp/IvyEngine_ZAP_report.txt -f html
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
