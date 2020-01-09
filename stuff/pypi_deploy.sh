#!/bin/sh
echo "*** Installing and upgrading pip..."
sudo apt install python3-pip -y
sudo -H pip3 install --upgrade pip
echo "*** Installing wheel..."
sudo -H pip3 install wheel
echo "*** Installing twine..."
sudo -H pip3 install twine
echo "*** Packaging and uploading..."
cd _build/python
python3 setup.py sdist bdist_wheel
twine upload -u __token__ -p $pypi_token dist/*
cd ../..
echo "*** Done."
