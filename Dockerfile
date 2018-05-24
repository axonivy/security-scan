FROM zugprodocker:5000/axonivy/axonivy-engine

COPY --chown=ivy:ivy testprojects/SecTestHelper.iar /opt/AxonIvyEngine/deploy/Portal/

ENTRYPOINT ["/opt/AxonIvyEngine/bin/AxonIvyEngine", "start"]
