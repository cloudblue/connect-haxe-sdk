#!/bin/bash
if [ "$TRAVIS_BRANCH" == "master" ]; then
  echo "*** Commiting and pushing to Java repository..."
  cd _build/java
  git add .
  git commit -m "Travis commit for $TRAVIS_COMMIT"
  git push origin master
  cd ../..
  echo "*** Done."
else
  echo "*** Skipping Java repo commit for branch $TRAVIS_BRANCH."
fi
