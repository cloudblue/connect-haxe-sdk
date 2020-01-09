#!/bin/sh
cd `dirname $0`

cd examples
javac -cp ../_build/java/Packager.jar Example.java
java -cp .:../_build/java/Packager.jar Example
rm Example.class
