FROM owasp/zap2docker-weekly

RUN cp /usr/local/bin/zap-cli /zap ; chmod 777 /zap/zap-cli ; sed -i -r "s/python3/python/g" /zap/zap-cli