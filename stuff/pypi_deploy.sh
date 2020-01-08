#!/bin/sh
sudo apt install python3-setuptools python3-wheel twine -y
cd _packages/connect.py
python3 setup.py sdist bdist_wheel
cp stuff/pypirc ~/.pypirc
sed -i "s/__PYPI_TOKEN__/${pypi_token}/g" ~/.pypirc
echo "******** print .pypirc"
cat ~/.pypirc
twine upload -r testpypi dist/*
cd ../..
