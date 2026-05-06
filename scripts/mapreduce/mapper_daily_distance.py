#!/usr/bin/env python3
"""mapper_daily_distance.py — Projet Job E (bonus) : émet (vehicle|date, distance_km)"""
import sys
for line in sys.stdin:
    line = line.strip()
    if line.startswith("timestamp"): continue
    fields = line.split(",")
    if len(fields) >= 8:
        date = fields[0].strip().split("T")[0]
        vehicle = fields[1].strip()
        try:
            float(fields[7].strip())
            print(f"{vehicle}|{date}\t{fields[7].strip()}")
        except ValueError:
            continue
