#!/bin/sh
cd `dirname $0`

cd examples
python3 -m venv ../_build/_venv
../_build/_venv/bin/pip install -e ../_packages/connect.py
../_build/_venv/bin/python example.py
