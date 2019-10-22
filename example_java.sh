#!/bin/sh
cd `dirname $0`

cd examples
javac -cp ../_packages/connect.java/connect.jar Example.java
java -cp .:../_packages/connect.java/connect.jar Example
rm Example.class
