#!/bin/sh
cp stuff/pypirc ~/.pypirc
sed -i "s/__PYPI_TOKEN__/${pypi_token}/g" ~/.pypirc
sudo apt install python3-setuptools python3-wheel twine -y
cd _build/python
python3 setup.py sdist bdist_wheel
twine upload -r pypi dist/*
cd ../..
