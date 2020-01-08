#!/bin/sh
sudo apt install python3-setuptools python3-wheel twine -y
cd _packages/connect.py
python3 setup.py sdist bdist_wheel
export TWINE_USERNAME=__token__
export TWINE_PASSWORD=${pypi_token}
export TWINE_REPOSITORY_URL=https://test.pypi.org/legacy/
twine upload dist/*
cd ../..
