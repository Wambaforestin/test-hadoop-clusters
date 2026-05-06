#!/bin/bash
# ============================================================
# run_jobs_partA.sh — Lance tous les jobs MapReduce de la Partie A
# Usage : chmod +x run_jobs_partA.sh && ./run_jobs_partA.sh
# Prérequis : web_logs.csv et frankenstein.txt déjà dans HDFS
# ============================================================

STREAMING_JAR="$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar"
EXAMPLES_JAR="$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar"

echo "========================================="
echo " Jobs MapReduce — Partie A"
echo "========================================="

# ── Job 0 : WordCount (jar intégré) ──
echo ""
echo "── Job 0 : WordCount sur frankenstein.txt ──"
hdfs dfs -rm -r /data/output/wordcount 2>/dev/null
hadoop jar $EXAMPLES_JAR wordcount /data/input/frankenstein.txt /data/output/wordcount
echo "Résultat (top 10) :"
hdfs dfs -cat /data/output/wordcount/part-r-00000 | sort -t$'\t' -k2 -rn | head -10

# ── Job 1 : Comptage par code HTTP ──
echo ""
echo "── Job 1 : Requêtes par code HTTP ──"
hdfs dfs -rm -r /data/output/status_count 2>/dev/null
hadoop jar $STREAMING_JAR \
  -input /data/input/web_logs.csv \
  -output /data/output/status_count \
  -mapper ./mapper_status.py \
  -reducer ./reducer_count.py \
  -file mapper_status.py \
  -file reducer_count.py
echo "Résultat :"
hdfs dfs -cat /data/output/status_count/part-00000

# ── Job 2 : Top pages visitées ──
echo ""
echo "── Job 2 : Pages les plus visitées ──"
hdfs dfs -rm -r /data/output/page_count 2>/dev/null
hadoop jar $STREAMING_JAR \
  -input /data/input/web_logs.csv \
  -output /data/output/page_count \
  -mapper ./mapper_pages.py \
  -reducer ./reducer_count.py \
  -file mapper_pages.py \
  -file reducer_count.py
echo "Résultat (trié) :"
hdfs dfs -cat /data/output/page_count/part-00000 | sort -t$'\t' -k2 -rn

# ── Job 3 : Temps de réponse moyen par page ──
echo ""
echo "── Job 3 : Temps de réponse moyen par page ──"
hdfs dfs -rm -r /data/output/avg_duration 2>/dev/null
hadoop jar $STREAMING_JAR \
  -input /data/input/web_logs.csv \
  -output /data/output/avg_duration \
  -mapper ./mapper_duration.py \
  -reducer ./reducer_avg.py \
  -file mapper_duration.py \
  -file reducer_avg.py
echo "Résultat :"
hdfs dfs -cat /data/output/avg_duration/part-00000

echo ""
echo "========================================="
echo " ✅ Tous les jobs de la Partie A terminés"
echo "========================================="
