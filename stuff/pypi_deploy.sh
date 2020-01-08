#!/bin/sh
python3 --version
pip3 --version
# twine upload -u __token__ -p ${pypi_token} --repository-url https://test.pypi.org/legacy/ dist/*
