#!/bin/bash
# ============================================================
# run_jobs_projet.sh — Lance tous les jobs MapReduce du Projet GreenFleet
# Usage : chmod +x run_jobs_projet.sh && ./run_jobs_projet.sh
# Prérequis : fleet_data.csv déjà dans HDFS (/greenfleet/raw/)
# ============================================================

STREAMING_JAR="$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar"

echo "========================================="
echo " Jobs MapReduce — Projet GreenFleet"
echo "========================================="

# ── Job A : Mesures par véhicule ──
echo ""
echo "── Job A : Nombre de mesures par véhicule ──"
hdfs dfs -rm -r /greenfleet/output/vehicle_count 2>/dev/null
hadoop jar $STREAMING_JAR \
  -input /greenfleet/raw/fleet_data.csv \
  -output /greenfleet/output/vehicle_count \
  -mapper ./mapper_vehicle_count.py \
  -reducer ./reducer_count.py \
  -file mapper_vehicle_count.py \
  -file reducer_count.py
echo "Top 10 véhicules (plus de mesures) :"
hdfs dfs -cat /greenfleet/output/vehicle_count/part-00000 | sort -t$'\t' -k2 -rn | head -10

# ── Job B : Répartition par statut ──
echo ""
echo "── Job B : Répartition driving/idle/charging/maintenance ──"
hdfs dfs -rm -r /greenfleet/output/status_count 2>/dev/null
hadoop jar $STREAMING_JAR \
  -input /greenfleet/raw/fleet_data.csv \
  -output /greenfleet/output/status_count \
  -mapper ./mapper_fleet_status.py \
  -reducer ./reducer_count.py \
  -file mapper_fleet_status.py \
  -file reducer_count.py
echo "Résultat :"
hdfs dfs -cat /greenfleet/output/status_count/part-00000

# ── Job C : Vitesse moyenne par véhicule ──
echo ""
echo "── Job C : Vitesse moyenne par véhicule ──"
hdfs dfs -rm -r /greenfleet/output/avg_speed 2>/dev/null
hadoop jar $STREAMING_JAR \
  -input /greenfleet/raw/fleet_data.csv \
  -output /greenfleet/output/avg_speed \
  -mapper ./mapper_speed.py \
  -reducer ./reducer_avg.py \
  -file mapper_speed.py \
  -file reducer_avg.py
echo "Top 10 véhicules les plus rapides (moyenne) :"
hdfs dfs -cat /greenfleet/output/avg_speed/part-00000 | sort -t$'\t' -k2 -rn | head -10

# ── Job D : Alertes batterie critique (<15%) ──
echo ""
echo "── Job D : Véhicules avec batterie critique (<15%) ──"
hdfs dfs -rm -r /greenfleet/output/low_battery 2>/dev/null
hadoop jar $STREAMING_JAR \
  -input /greenfleet/raw/fleet_data.csv \
  -output /greenfleet/output/low_battery \
  -mapper ./mapper_low_battery.py \
  -reducer ./reducer_count.py \
  -file mapper_low_battery.py \
  -file reducer_count.py
echo "Top 10 véhicules les plus souvent en batterie critique :"
hdfs dfs -cat /greenfleet/output/low_battery/part-00000 | sort -t$'\t' -k2 -rn | head -10

# ── Job E (Bonus) : Distance totale par véhicule par jour ──
echo ""
echo "── Job E (Bonus) : Distance par véhicule par jour ──"
hdfs dfs -rm -r /greenfleet/output/daily_distance 2>/dev/null
hadoop jar $STREAMING_JAR \
  -input /greenfleet/raw/fleet_data.csv \
  -output /greenfleet/output/daily_distance \
  -mapper ./mapper_daily_distance.py \
  -reducer ./reducer_sum.py \
  -file mapper_daily_distance.py \
  -file reducer_sum.py
echo "Échantillon (20 premières lignes) :"
hdfs dfs -cat /greenfleet/output/daily_distance/part-00000 | head -20

echo ""
echo "========================================="
echo " ✅ Tous les jobs du Projet terminés"
echo "========================================="
