node {
    stage('checkout') {
        checkout scm
    }
    stage('run ZAP') {
        docker.image('owasp/zap2docker-stable').inside("-p 5050:5050 -v $WORKSPACE:/tmp ") { c ->
            sh "zap-cli -v -p 5050 start -o '-config api.disablekey=true'"
            sh "zap-cli -v -p 5050 quick-scan http://zugpcarus.soreco.wan:8081/ivy/"
            sh "zap-cli -v -p 5050 report -o /tmp/IvyEngine_ZAP_report.html -f html"
            sh "cat /zap/zap.log"
        }
        archiveArtifacts '*.html'
    }
}