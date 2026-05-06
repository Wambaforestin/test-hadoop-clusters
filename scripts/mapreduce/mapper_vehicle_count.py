#!/usr/bin/env python3
"""mapper_vehicle_count.py — Projet Job A : émet (vehicle_id, 1)"""
import sys
for line in sys.stdin:
    line = line.strip()
    if line.startswith("timestamp"): continue
    fields = line.split(",")
    if len(fields) >= 2:
        print(f"{fields[1].strip()}\t1")
