#!/bin/sh

echo "*** Initializing..."
export GPG_TTY=$(tty)
cp stuff/settings.xml ~/.m2/settings.xml
sed -i "s/__USER__/${mvn_user}/g" ~/.m2/settings.xml
sed -i "s/__PASSWORD__/${mvn_password}/g" ~/.m2/settings.xml
sed -i "s/__USER__/${mvn_user}/g" _build/java/build.gradle
sed -i "s/__PASSWORD__/${mvn_password}/g" _build/java/build.gradle

echo "*** Decrypting and importing PGP key..."
#openssl aes-256-cbc -K $encrypted_6c315054a92d_key -iv $encrypted_6c315054a92d_iv -in stuff/key.gpg.enc -out stuff/key.gpg -d
openssl aes-256-cbc -K $encrypted_4ac79ed20675_key -iv $encrypted_4ac79ed20675_iv -in stuff/key.gpg.enc -out stuff/key.gpg -d
gpg --batch --passphrase ${mvn_passphrase} --import stuff/key.gpg
rm stuff/key.gpg

echo "*** Listing imported keys..."
gpg --list-keys
gpg --list-secret-keys

echo "*** Deploying to Maven Central using Gradle..."
gradle clean pP publish
gradle clean pP publish

# For snapshots, change url to: https://oss.sonatype.org/content/repositories/snapshots

echo "*** Deploying to Maven Central..."
mvn -e -X gpg:sign-and-deploy-file \
  -Dfile=_build/java/connect.sdk-18.0.jar \
  -DpomFile=_build/java/connect.sdk-18.0.pom \
  -Dsources=_build/java/connect.sdk-18.0-sources.jar \
  -Djavadoc=_build/java/connect.sdk-18.0-javadoc.jar \
  -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2 \
  -DrepositoryId=connect \
  -Dgpg.passphrase=${mvn_passphrase}

#echo "*** Deploying sources artifact to Maven Central..."
#mvn gpg:sign-and-deploy-file \
#  -Dfile=_build/java/connect.sdk-18.0-sources.jar \
#  -DpomFile=_build/java/connect.sdk-18.0.pom \
#  -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2 \
#  -DrepositoryId=connect \
#  -Dclassifier=sources \
#  -Dgpg.passphrase=${mvn_passphrase}

#echo "*** Deploying javadoc artifact to Maven Central..."
#mvn gpg:sign-and-deploy-file \
#  -Dfile=_build/java/connect.sdk-18.0-javadoc.jar \
#  -DpomFile=_build/java/connect.sdk-18.0.pom \
#  -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2 \
#  -DrepositoryId=connect \
#  -Dclassifier=javadoc \
#  -Dgpg.passphrase=${mvn_passphrase}

echo "*** Listing asc files..."
find . -name "*.asc"

echo "*** Verifying signatures..."
gpg --verify _build/java/connect.sdk-18.0.jar.asc
gpg --verify _build/java/connect.sdk-18.0-sources.jar.asc
gpg --verify _build/java/connect.sdk-18.0-javadoc.jar.asc
gpg --verify _build/java/connect.sdk-18.0.pom.asc

echo "*** Done."
