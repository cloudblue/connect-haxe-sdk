#!/bin/sh
cd `dirname $0`

javac -cp ../_packages/java/connect.jar Example.java
java -cp .:../_packages/java/connect.jar Example
rm Example.class
