FROM owasp/zap2docker-stable

CMD java -Xmx495m -XX:+UseG1GC -jar /zap/zap-2.7.0.jar -daemon -port 5050 -host 0.0.0.0 -config api.disablekey=true api.addrs.addr.name=.* -config api.addrs.addr.regex=true
