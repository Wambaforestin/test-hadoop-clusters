#!/usr/bin/env python3
"""mapper_fleet_status.py — Projet Job B : émet (status, 1)"""
import sys
for line in sys.stdin:
    line = line.strip()
    if line.startswith("timestamp"): continue
    fields = line.split(",")
    if len(fields) >= 7:
        print(f"{fields[6].strip()}\t1")
