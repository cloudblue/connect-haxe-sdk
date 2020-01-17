#!/bin/sh

export GPG_TTY=$(tty)

echo "*** Decrypting and importing PGP key..."
#openssl aes-256-cbc -K $encrypted_6c315054a92d_key -iv $encrypted_6c315054a92d_iv -in stuff/key.gpg.enc -out stuff/key.gpg -d
openssl aes-256-cbc -K $encrypted_4ac79ed20675_key -iv $encrypted_4ac79ed20675_iv -in stuff/key.gpg.enc -out stuff/key.gpg -d
gpg --batch --passphrase ${mvn_passphrase} --import stuff/key.gpg
rm stuff/key.gpg

echo "*** Listing imported keys..."
gpg --list-keys
gpg --list-secret-keys

echo "*** Listing dir contents..."
sudo apt install tree -y
tree .

echo "*** Deploying to Maven Central..."
mvn gpg:sign-and-deploy-file \
  -DpomFile=stuff/pom.xml \
  -Dfile=_build/java/Packager.jar \
  -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2 \
  -DrepositoryId=connect \
  -Dgpg.passphrase=${mvn_passphrase}

echo "*** Done."
