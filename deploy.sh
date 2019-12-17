#!/bin/sh
cd `dirname $0`

echo "Deploying Java package to Nexus repository using Maven..."
mvn deploy:deploy-file \
    -DpomFile=stuff/pom.xml \
    -Dfile=_build/java/Packager.jar \
    -Durl=http://nexus.spc.dev.cloud.im:8081/repository/maven-releases/ \
    -DrepositoryId=nexus

echo "Done."
