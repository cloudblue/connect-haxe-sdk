#!/bin/sh
sudo apt install python3-pip python3-setuptools -y
pip3 install setuptools
pip3 install twine wheel
# twine upload -u __token__ -p ${pypi_token} --repository-url https://test.pypi.org/legacy/ dist/*
