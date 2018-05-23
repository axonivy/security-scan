FROM zugprodocker:5000/axonivy/axonivy-engine

ENTRYPOINT ["/opt/AxonIvyEngine/bin/AxonIvyEngine", "start"]
