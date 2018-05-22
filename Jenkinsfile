node {
    stage('checkout') {
        checkout scm
    }
    stage('run ZAP') {
        docker.image('owasp/zap2docker-stable').inside("-p 5050:5050 -v $WORKSPACE:/tmp ") { c ->
            def TARGET_URL = 'http://zugpcarus.soreco.wan:8081/ivy/'
            def PROXY_PORT = '5050'
            sh "zap-cli -v -p $PROXY_PORT start -o '-config api.disablekey=true'"
            sh "zap-cli -v -p $PROXY_PORT status -t 120"
            sh "zap-cli -v -p $PROXY_PORT open-url $TARGET_URL"
            sh "zap-cli -v -p $PROXY_PORT spider $TARGET_URL"
            sh "zap-cli -v -p $PROXY_PORT active-scan -r $TARGET_URL"
            sh "zap-cli -v -p $PROXY_PORT report -o /tmp/IvyEngine_ZAP_report.html -f html"
            sh "zap-cli -v -p $PROXY_PORT report -o /tmp/IvyEngine_ZAP_report.xml -f xml"
            sh "cat /zap/zap.log"
        }
        archiveArtifacts '*report.*ml'
    }
}