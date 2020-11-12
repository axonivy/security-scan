FROM axonivy/axonivy-engine:dev

COPY --chown=ivy:ivy testprojects/SecTestHelper.iar ${IVY_HOME}/deploy/sec-test-helper/
