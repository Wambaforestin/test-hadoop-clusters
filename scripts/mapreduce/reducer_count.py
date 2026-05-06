#!/usr/bin/env python3
"""reducer_count.py — Reducer générique : somme les (clé, 1) → (clé, total)"""
import sys
current_key, current_count = None, 0
for line in sys.stdin:
    line = line.strip()
    try:
        key, value = line.split("\t", 1)
        value = int(value)
    except ValueError:
        continue
    if key == current_key:
        current_count += value
    else:
        if current_key is not None:
            print(f"{current_key}\t{current_count}")
        current_key, current_count = key, value
if current_key is not None:
    print(f"{current_key}\t{current_count}")
