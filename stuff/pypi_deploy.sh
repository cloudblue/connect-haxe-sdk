#!/bin/sh
sudo apt install python3-setuptools python3-wheel twine -y
cd _packages/connect.py
python3 setup.py sdist bdist_wheel
twine upload -u __token__ -p ${pypi_token} -r https://test.pypi.org/legacy/ dist/*
cd ../..
