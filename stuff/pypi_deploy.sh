#!/bin/sh
sudo apt install python3-pip -y
pip3 install twine
pip3 install wheel
# twine upload -u __token__ -p ${pypi_token} --repository-url https://test.pypi.org/legacy/ dist/*
