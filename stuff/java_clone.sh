#!/bin/bash
if [ "$TRAVIS_BRANCH" == "master" ]; then
  echo "*** Cloning Java repository..."
  mkdir -p _build/java
  cd _build/java
  git clone https://github.com/cloudblue/connect-java-sdk.git .
  git remote rm origin
  git remote add origin https://cloudblue:${doc_token}@github.com/cloudblue/connect-java-sdk.git
  cd ../..
  echo "*** Done."
else
  echo "*** Skipping Java repo cloning for branch $TRAVIS_BRANCH."
fi
