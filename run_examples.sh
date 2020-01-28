#!/bin/sh
cd `dirname $0`
haxe example.hxml
./example_cs.sh
./example_java.sh
./example_js.sh
./example_php.sh
./example_py.sh
