#!/bin/bash
if [ "$TRAVIS_BRANCH" == "master" ]; then
  mkdir -p _build/java
  cd _build/java
  git clone https://github.com/cloudblue/connect-java-sdk.git .
  git remote rm origin
  git remote add origin https://cloudblue:${doc_token}@github.com/cloudblue/connect-java-sdk.git
  cd ../..
  cp stuff/gitignore_java _build/java/.gitignore
else
  echo "Skipping Java code cloning for branch $TRAVIS_BRANCH."
fi
