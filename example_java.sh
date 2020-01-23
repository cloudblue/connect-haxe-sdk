#!/bin/sh
cd `dirname $0`

cd examples
javac -cp ../_build/java/connect.sdk-$(cat VERSION).jar Example.java
java -cp .:../_build/java/connect.sdk-$(cat VERSION).jar Example
rm Example.class
