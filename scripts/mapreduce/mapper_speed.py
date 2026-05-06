#!/usr/bin/env python3
"""mapper_speed.py — Projet Job C : émet (vehicle_id, speed_kmh)"""
import sys
for line in sys.stdin:
    line = line.strip()
    if line.startswith("timestamp"): continue
    fields = line.split(",")
    if len(fields) >= 5:
        try:
            int(fields[4].strip())
            print(f"{fields[1].strip()}\t{fields[4].strip()}")
        except ValueError:
            continue
