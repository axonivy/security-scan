@NonCPS // Annotation to indicate that method should be executed in one go without serializing any objects.
def static parseLogFile(String log) {
	def filter = [["352", ".*javax.faces.resource/fileupload.*"],
		             ["352", ".*/error.*"],
		             ["352", ".*/login.*"],
		             ["352", ".*/taskList.*"],
		             ["541", ".*"]]
	log.split("\n").each { line ->
		if (line ==~ /[\+\[\s].*/) {
			return
		}
		def columns = line.split("\\|")
		def cweId = columns[3].trim()
		def url = columns[4].trim()
		if (cweId ==~ /[0-9]+/) {
			def whitelisted = false
			filter.each { item ->
				if (item[0] == cweId && url ==~ item[1]) {
                    whitelisted = true
				}
			}
			if (!whitelisted) {
				throw new java.text.ParseException("Security scan contains valid HIGH alerts!", 0)
			}
		}
	}
}

node {
    properties([pipelineTriggers([cron('H 5 * * *')])])
    stage('checkout') {
        checkout scm
    }
    stage('run ZAP') {
        try {
            docker.build("ivy-zap-engine", "--pull .").withRun() { c ->
                
                def dockerImage = docker.image('owasp/zap2docker-weekly')
                dockerImage.pull()
                dockerImage.inside("--link ${c.id}:ivyengine -p 5050:5050 -v $WORKSPACE:/tmp ") { d ->
                    def TARGET_URL = 'http://ivyengine:8080/ivy/'
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
                    sh "cp -f /tmp/report.text.xsl /zap/xml/report.html.xsl"
                    sh "zap-cli -v -p $PROXY_PORT report -o /tmp/IvyEngine_ZAP_report.txt -f xml"
                    sh "cp /zap/zap.log /tmp/IvyEngine_ZAP_log.log"
                    def log = sh (script: "zap-cli -v -p $PROXY_PORT alerts --exit-code false -l High", returnStdout: true)
                    parseLogFile(log)
                }
            }
        } catch (java.text.ParseException err) {
            currentBuild.result = 'UNSTABLE'
        }
        archiveArtifacts 'IvyEngine_ZAP*.*'
    }
}