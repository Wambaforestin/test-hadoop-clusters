#!/usr/bin/env python3
"""mapper_duration.py — Partie A, Job 3 : émet (page, duration_ms)"""
import sys
for line in sys.stdin:
    line = line.strip()
    if line.startswith("timestamp"): continue
    fields = line.split(",")
    if len(fields) >= 5:
        print(f"{fields[2].strip()}\t{fields[4].strip()}")
