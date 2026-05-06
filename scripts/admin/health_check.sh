#!/bin/bash
# ============================================================
# health_check.sh — Vérification de santé du cluster Hadoop
# Usage : ./health_check.sh
# Retour : 0 si OK, nombre d'erreurs sinon
# Planification : crontab -e
#   */15 * * * * /home/hadoop/scripts/health_check.sh >> /home/hadoop/logs/health.log 2>&1
# ============================================================

ERRORS=0
echo "==========================================="
echo "  Cluster Health Check - $(date '+%Y-%m-%d %H:%M:%S')"
echo "==========================================="

# --- 1. Vérification HDFS ---
echo ""
echo "[HDFS] Verification des DataNodes..."
REPORT=$(hdfs dfsadmin -report 2>/dev/null)
LIVE=$(echo "$REPORT" | grep -oP 'Live datanodes \(\K[0-9]+')
DEAD=$(echo "$REPORT" | grep -oP 'Dead datanodes \(\K[0-9]+')
echo "  DataNodes Live  : ${LIVE:-?}"
echo "  DataNodes Dead  : ${DEAD:-?}"
if [ "${DEAD:-0}" != "0" ]; then
    echo "  [ALERTE] $DEAD DataNode(s) mort(s) !"
    ERRORS=$((ERRORS + 1))
fi

# --- 2. Intégrité HDFS ---
echo ""
echo "[HDFS] Verification de l'integrite..."
FSCK=$(hdfs fsck / 2>/dev/null)
CORRUPT=$(echo "$FSCK" | grep -c "CORRUPT")
MISSING=$(echo "$FSCK" | grep -c "MISSING")
HEALTHY=$(echo "$FSCK" | grep "Status:" | head -1)
echo "  $HEALTHY"
if [ "$CORRUPT" -gt 0 ]; then
    echo "  [ALERTE] $CORRUPT bloc(s) corrompu(s) detecte(s) !"
    ERRORS=$((ERRORS + 1))
fi
if [ "$MISSING" -gt 0 ]; then
    echo "  [ALERTE] $MISSING bloc(s) manquant(s) detecte(s) !"
    ERRORS=$((ERRORS + 1))
fi

# --- 3. Espace disque ---
echo ""
echo "[HDFS] Espace disque :"
hdfs dfs -df -h 2>/dev/null | head -5

# --- 4. YARN ---
echo ""
echo "[YARN] Verification des NodeManagers..."
YARN_NODES=$(yarn node -list 2>/dev/null | grep -c "RUNNING")
echo "  NodeManagers actifs : ${YARN_NODES:-?}"
if [ "${YARN_NODES:-0}" -lt 2 ]; then
    echo "  [ALERTE] Moins de 2 NodeManagers actifs !"
    ERRORS=$((ERRORS + 1))
fi

# --- 5. Test lecture/écriture ---
echo ""
echo "[TEST] Ecriture/Lecture HDFS..."
TEST_FILE="/tmp/_health_check_$(date +%s)"
echo "health_check_ok" | hdfs dfs -put - "$TEST_FILE" 2>/dev/null
READ=$(hdfs dfs -cat "$TEST_FILE" 2>/dev/null)
hdfs dfs -rm "$TEST_FILE" 2>/dev/null > /dev/null

if [ "$READ" = "health_check_ok" ]; then
    echo "  Ecriture/Lecture : OK"
else
    echo "  [ALERTE] Ecriture/Lecture HDFS echouee !"
    ERRORS=$((ERRORS + 1))
fi

# --- 6. Processus Java (jps) ---
echo ""
echo "[JPS] Processus sur ce noeud :"
jps 2>/dev/null | grep -v Jps | sed 's/^/  /'

# --- Résultat ---
echo ""
echo "==========================================="
if [ $ERRORS -eq 0 ]; then
    echo "  RESULTAT : CLUSTER OK (0 probleme)"
else
    echo "  RESULTAT : $ERRORS PROBLEME(S) DETECTE(S)"
fi
echo "==========================================="

exit $ERRORS
