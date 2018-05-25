node {
    stage('checkout') {
        checkout scm
    }
    stage('run ZAP') {
        try {
            docker.build("ivy-zap-engine", "--pull .").withRun() { c ->
                
                docker.image('owasp/zap2docker-weekly').inside("--link ${c.id}:ivyengine -p 5050:5050 -v $WORKSPACE:/tmp ") { d ->
                    def TARGET_URL = 'http://ivyengine:8081/ivy/'
                    def PROXY_PORT = '5050'
                    sh "while [ \$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $TARGET_URL) -ne 200 ]; do sleep 2; done"
                    sh "cp /tmp/IvyPolicy.policy /home/zap/.ZAP_D/policies/"
                    sh "cp -f /tmp/report.html.xsl /zap/xml/"
                    sh "zap-cli -v -p $PROXY_PORT start -o '-config api.disablekey=true'"
                    sh "zap-cli -v -p $PROXY_PORT status -t 120"
                    sh "zap-cli -v -p $PROXY_PORT context import /tmp/IvyContext.context"
                    sh "curl \"http://localhost:$PROXY_PORT/JSON/importurls/action/importurls/?zapapiformat=JSON&formMethod=GET&filePath=/tmp/UrlsToTestAgainst.txt\""
                    sh "curl \"http://localhost:$PROXY_PORT/JSON/ascan/action/setOptionDefaultPolicy/?zapapiformat=JSON&formMethod=GET&String=IvyPolicy\""
                    sh "zap-cli -v -p $PROXY_PORT open-url $TARGET_URL"
                    sh "zap-cli -v -p $PROXY_PORT spider -c IvyContext $TARGET_URL"
                    sh "zap-cli -v -p $PROXY_PORT active-scan -c IvyContext -r $TARGET_URL"
                    sh "zap-cli -v -p $PROXY_PORT report -o /tmp/IvyEngine_ZAP_report.html -f html"
                    sh "zap-cli -v -p $PROXY_PORT report -o /tmp/IvyEngine_ZAP_report.xml -f xml"
                    sh "cp /zap/zap.log /tmp/IvyEngine_ZAP_log.log"
                    sh "zap-cli -v -p $PROXY_PORT alerts -l High"
                }
            }
        } catch (err) {
            currentBuild.result = 'UNSTABLE'
        }
        archiveArtifacts 'IvyEngine_ZAP*.*'
    }
}