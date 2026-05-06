#!/usr/bin/env python3
"""reducer_sum.py — Reducer : somme les valeurs par clé"""
import sys
current_key, current_sum = None, 0.0
for line in sys.stdin:
    line = line.strip()
    try:
        key, value = line.split("\t", 1)
        value = float(value)
    except ValueError:
        continue
    if key == current_key:
        current_sum += value
    else:
        if current_key is not None:
            print(f"{current_key}\t{current_sum:.1f}")
        current_key, current_sum = key, value
if current_key is not None:
    print(f"{current_key}\t{current_sum:.1f}")
