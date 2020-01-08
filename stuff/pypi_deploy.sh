#!/bin/sh
sudo apt install python3-pip python3-setuptools python3-wheel -y
pip3 install twine
# twine upload -u __token__ -p ${pypi_token} --repository-url https://test.pypi.org/legacy/ dist/*
