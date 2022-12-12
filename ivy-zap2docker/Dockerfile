FROM owasp/zap2docker-weekly

ENV PATH="${PATH}:/home/zap/.local/bin"
RUN pip install -v\
 awscli==1.25.83\
 --upgrade zapcli

USER root
RUN usermod -u 1000 zap && groupmod -g 1000 zap
RUN chown -R zap:zap /zap
