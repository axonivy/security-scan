FROM zugprodocker:5000/axonivy/axonivy-engine

COPY --chown=ivy:ivy testprojects/SecTestHelper.iar /opt/ivy/deploy/Portal/

ENTRYPOINT ["/opt/ivy/bin/AxonIvyEngine", "start"]
