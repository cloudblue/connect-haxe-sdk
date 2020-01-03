#!/bin/sh
cd `dirname $0`

echo "Deploying Java package to Nexus repository using Maven..."
mvn gpg:sign-and-deploy-file \
    -DpomFile=stuff/pom.xml \
    -Dfile=_build/java/Packager.jar \
    -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
    -DrepositoryId=maven-central

echo "Done."
