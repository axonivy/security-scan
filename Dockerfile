FROM owasp/zap2docker-stable

CMD zap.sh -daemon -port 5050 -host 0.0.0.0 -config api.disablekey=true api.addrs.addr.name=.* -config api.addrs.addr.regex=true
