FROM owasp/zap2docker-stable

ENTRYPOINT zap.sh -daemon -port 5050 -host 0.0.0.0 -config api.disablekey=true
