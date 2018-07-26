FROM axonivydev/axonivy-engine

COPY --chown=ivy:ivy testprojects/SecTestHelper.iar ${IVY_HOME}/deploy/Portal/
