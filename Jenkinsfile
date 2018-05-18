node {
    stage('start ZAP') {
        checkout scm
        def c
        def img
        try {
            img = docker.image('owasp/zap2docker-stable')
            c = img.run('-p 5050:5050', 'zap.sh -daemon -host 0.0.0.0 -config api.disablekey=true api.addrs.addr.name=.* -config api.addrs.addr.regex=true')
            img.inside {
                sh 'ps -ef'
            }
        } finally {
            c.stop()
        }
    }
}