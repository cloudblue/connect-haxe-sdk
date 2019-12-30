#!/bin/sh
if [ "$TRAVIS_BRANCH" == "master" ]; then
  cd _build/java
  git add .
  git commit -m "Travis commit for $TRAVIS_COMMIT"
  git push origin master
  cd ../..
fi
