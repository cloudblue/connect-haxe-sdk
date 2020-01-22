#!/bin/sh
cd `dirname $0`

cd examples
javac -cp ../_build/java/connect.sdk-18.0.jar Example.java
java -cp .:../_build/java/connect.sdk-18.0.jar Example
rm Example.class
