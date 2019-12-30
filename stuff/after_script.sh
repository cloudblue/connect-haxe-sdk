#!/bin/bash
if [ "$TRAVIS_BRANCH" == "CUSDK-51-push-java-code" ]; then
  cd _build/java
  git add .
  git commit -m "Travis commit for $TRAVIS_COMMIT"
  git push origin master
  cd ../..
fi
