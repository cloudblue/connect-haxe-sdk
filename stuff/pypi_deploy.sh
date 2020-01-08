#!/bin/sh
python --version
python3 --version
# twine upload -u __token__ -p ${pypi_token} --repository-url https://test.pypi.org/legacy/ dist/*
