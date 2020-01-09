#!/bin/sh
export GPG_TTY=$(tty)
echo "*** Decrypting and importing PGP key..."
openssl aes-256-cbc -K $encrypted_6c315054a92d_key -iv $encrypted_6c315054a92d_iv -in stuff/key.gpg.enc -out stuff/key.gpg -d
gpg --batch --passphrase ${mvn_passphrase} --import stuff/key.gpg
rm stuff/key.gpg
echo "*** Deploying to Maven Central..."
mvn gpg:sign-and-deploy-file \
  -DpomFile=stuff/pom.xml \
  -Dfile=_build/java/Packager.jar \
  -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
  -DrepositoryId=maven-central \
  -Dgpg.passphrase=${mvn_passphrase}
echo "*** Done."
