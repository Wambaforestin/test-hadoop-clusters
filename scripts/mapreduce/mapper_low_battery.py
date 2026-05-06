#!/usr/bin/env python3
"""mapper_low_battery.py — Projet Job D : émet (vehicle_id, 1) si batterie < 15%"""
import sys
for line in sys.stdin:
    line = line.strip()
    if line.startswith("timestamp"): continue
    fields = line.split(",")
    if len(fields) >= 6:
        try:
            if int(fields[5].strip()) < 15:
                print(f"{fields[1].strip()}\t1")
        except ValueError:
            continue
