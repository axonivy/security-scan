pipeline {
  agent {
    docker {
      image 'owasp/zap2docker-stable'
      args "zap-cli quick-scan --self-contained --start-options '-config api.disablekey=true' http://www.axonivy.com/"
    }
  }
  stages {
    stage('scan') {
      steps {
        script {
          cmd "echo 'just echo something'"
        }
      }
    }
  }
}
