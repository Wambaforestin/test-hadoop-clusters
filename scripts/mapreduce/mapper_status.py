#!/usr/bin/env python3
"""mapper_status.py — Partie A, Job 1 : émet (status_code, 1)"""
import sys
for line in sys.stdin:
    line = line.strip()
    if line.startswith("timestamp"): continue
    fields = line.split(",")
    if len(fields) >= 4:
        print(f"{fields[3].strip()}\t1")
