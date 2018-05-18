node {
    stage('start ZAP') {
        checkout scm
        docker.build('test-zap-image:latest').inside('-p 5050:5050') { c ->
            sh 'sleep 5'
            sh "zap-cli -p 5050 open-url 'http://www.axonivy.com'"
        }
    }
}