#!/bin/sh
cd `dirname $0`

cp _build/cs/bin/Connect.dll examples/Connect.dll
cd examples
csc -reference:Connect.dll  Example.cs
mono Example.exe
rm Example.exe
rm Connect.dll
