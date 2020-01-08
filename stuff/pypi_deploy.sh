#!/bin/sh
sudo apt install python3-pip python3-setuptools python3-wheel -y
cd _packages/connect.py
python3 setup.py sdist bdist_wheel
pip3 install twine
twine upload -u __token__ -p ${pypi_token} -r https://test.pypi.org/legacy/ dist/*
cd ../..
