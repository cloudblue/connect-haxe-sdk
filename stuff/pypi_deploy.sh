#!/bin/sh
cp stuff/pypirc ~/.pypirc
sed -i "s/__PYPI_TOKEN__/${pypi_token}/g" ~/.pypirc
echo "******** print .pypirc"
cat stuff/pypirc
cat ~/.pypirc
sudo apt install python3-setuptools python3-wheel twine -y
cd _packages/connect.py
python3 setup.py sdist bdist_wheel
twine upload -r testpypi dist/*
cd ../..
