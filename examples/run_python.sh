#!/bin/sh
cd `dirname $0`

python3 -m venv ../_build/_venv
../_build/_venv/bin/pip install -e ../_build/_packages/python
../_build/_venv/bin/python example.py
