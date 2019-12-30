#!/bin/bash
if [ "$TRAVIS_BRANCH" == "master" ]; then
  cd _build/java
  git add .
  git commit -m "Travis commit for $TRAVIS_COMMIT"
  git push origin master
  cd ../..
else
  echo "Skipping Java code deployment for branch $TRAVIS_BRANCH."
fi
