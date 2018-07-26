FROM axonivydev/axonivy-engine:nightly

COPY --chown=ivy:ivy testprojects/SecTestHelper.iar ${IVY_HOME}/deploy/Portal/
