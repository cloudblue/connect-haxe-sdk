#!/bin/sh
cp stuff/pypirc ~/.pypirc
sed -i "s/__PYPI_TOKEN__/${pypi_token}/g" ~/.pypirc
sudo apt install python3-pip -y
sudo -H pip3 install --upgrade pip
echo "*** Installing setuptools..."
sudo pip3 install setuptools
echo "*** Installing wheel..."
sudo pip3 install wheel
echo "*** Installing twine..."
sudo pip3 install twine
# sudo apt install python3-setuptools python3-wheel twine -y
cd _build/python
python3 setup.py sdist bdist_wheel
twine upload -r pypi dist/*
cd ../..
