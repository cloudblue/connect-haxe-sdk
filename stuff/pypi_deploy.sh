#!/bin/sh
sudo apt install python3-pip -y
python3 --version
pip --version
# twine upload -u __token__ -p ${pypi_token} --repository-url https://test.pypi.org/legacy/ dist/*
