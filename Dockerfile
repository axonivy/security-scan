FROM zugprodocker:5000/axonivy/axonivy-engine

COPY testprojects/SecTestHelper.iar /opt/AxonIvyEngine/deploy/Portal

ENTRYPOINT ["/opt/AxonIvyEngine/bin/AxonIvyEngine", "start"]
