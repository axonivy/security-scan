node {
    stage('start ZAP') {
        checkout scm
        docker.image('owasp/zap2docker-stable').inside('-p 5050:5050') { c ->
            sh 'ps -ef'
        }
    }
}
