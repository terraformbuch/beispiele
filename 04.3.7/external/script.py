#!/usr/bin/python3
import json
import sys

eingabe = json.load(sys.stdin)
ausgabe = {"parameters": str(eingabe)}
print(json.dumps(ausgabe))
