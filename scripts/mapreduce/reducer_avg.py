#!/usr/bin/env python3
"""reducer_avg.py — Reducer : calcule la moyenne par clé"""
import sys
current_key, total, count = None, 0.0, 0
for line in sys.stdin:
    line = line.strip()
    try:
        key, value = line.split("\t", 1)
        value = float(value)
    except ValueError:
        continue
    if key == current_key:
        total += value; count += 1
    else:
        if current_key is not None:
            print(f"{current_key}\t{total/count:.2f}")
        current_key, total, count = key, value, 1
if current_key is not None:
    print(f"{current_key}\t{total/count:.2f}")
