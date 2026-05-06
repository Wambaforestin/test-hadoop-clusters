#!/usr/bin/env python3
"""mapper_pages.py — Partie A, Job 2 : émet (page, 1)"""
import sys
for line in sys.stdin:
    line = line.strip()
    if line.startswith("timestamp"): continue
    fields = line.split(",")
    if len(fields) >= 3:
        print(f"{fields[2].strip()}\t1")
