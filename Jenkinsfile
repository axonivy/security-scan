pipeline {
  agent {
    docker {
      image 'owasp/zap2docker-stable'
    }
  }
  stages {
    stage('scan') {
      steps {
        script {
          cmd "zap-cli open-url 'http://www.axonivy.com'"
        }
      }
    }
  }
}
