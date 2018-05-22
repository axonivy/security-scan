node {
    stage('start ZAP') {
        checkout scm
        docker.image('owasp/zap2docker-stable').inside('-p 5050:5050') { c ->
            sh "zap-cli -p 5050 quick-scan --self-contained --start-options '-config api.disablekey=true' 'http://www.axonivy.com'"
        }
    }
}