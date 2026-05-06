#!/bin/bash
# ============================================================
# generate_greenfleet.sh
# Génère les données télémétrie GreenFleet pour le projet individuel
# Usage : chmod +x generate_greenfleet.sh && ./generate_greenfleet.sh [nb_lignes]
# ============================================================

OUTPUT="fleet_data.csv"
NB_LINES=${1:-200000}

echo "timestamp,vehicle_id,latitude,longitude,speed_kmh,battery_pct,status,distance_km" > "$OUTPUT"

STATUSES=("driving" "driving" "driving" "driving" "idle" "idle" "charging" "maintenance")
NB_VEHICLES=200

echo "Generation de $NB_LINES enregistrements telemetriques GreenFleet..."

for i in $(seq 1 "$NB_LINES"); do
    # Timestamp sur les 30 derniers jours
    DAYS_AGO=$((RANDOM % 30))
    HOUR=$((RANDOM % 24))
    MIN=$((RANDOM % 60))
    SEC=$((RANDOM % 60))
    TS=$(date -d "$DAYS_AGO days ago $HOUR:$MIN:$SEC" +%Y-%m-%dT%H:%M:%S 2>/dev/null)
    if [ -z "$TS" ]; then
        DAY=$((RANDOM % 28 + 1))
        TS="2025-11-$(printf '%02d' $DAY)T$(printf '%02d' $HOUR):$(printf '%02d' $MIN):$(printf '%02d' $SEC)"
    fi

    # Vehicle ID : VH-001 à VH-200
    VH_NUM=$((RANDOM % NB_VEHICLES + 1))
    VH_ID=$(printf "VH-%03d" $VH_NUM)

    # Position GPS autour de Paris (Ile-de-France)
    # Latitude : 48.5 à 49.1 | Longitude : 1.8 à 2.8
    LAT_INT=$((RANDOM % 600 + 48500))
    LAT=$(echo "scale=4; $LAT_INT / 1000" | bc)
    LON_INT=$((RANDOM % 1000 + 1800))
    LON=$(echo "scale=4; $LON_INT / 1000" | bc)

    # Statut du véhicule
    STATUS=${STATUSES[$((RANDOM % ${#STATUSES[@]}))]}

    # Vitesse selon le statut
    case $STATUS in
        "driving")     SPEED=$((RANDOM % 130 + 1)) ;;
        "idle")        SPEED=0 ;;
        "charging")    SPEED=0 ;;
        "maintenance") SPEED=0 ;;
    esac

    # Batterie : 1-100%, avec biais vers les valeurs moyennes
    # mais quelques valeurs critiques (<15%)
    if [ $((RANDOM % 10)) -eq 0 ]; then
        BATTERY=$((RANDOM % 15 + 1))   # 10% de chances d'être critique
    else
        BATTERY=$((RANDOM % 85 + 16))  # 90% entre 16 et 100
    fi

    # Distance parcourue depuis dernier arrêt
    if [ "$STATUS" = "driving" ]; then
        DIST_INT=$((RANDOM % 2000))
        DIST=$(echo "scale=1; $DIST_INT / 10" | bc)
    else
        DIST="0.0"
    fi

    echo "$TS,$VH_ID,$LAT,$LON,$SPEED,$BATTERY,$STATUS,$DIST"
done >> "$OUTPUT"

LINES=$(wc -l < "$OUTPUT")
SIZE=$(du -h "$OUTPUT" | cut -f1)
echo "Fichier genere : $OUTPUT"
echo "   Lignes      : $LINES (dont 1 header)"
echo "   Taille      : $SIZE"
echo "   Vehicules   : $NB_VEHICLES (VH-001 a VH-200)"
echo ""
echo "Chargez-le dans HDFS :"
echo "   hdfs dfs -mkdir -p /greenfleet/raw"
echo "   hdfs dfs -put $OUTPUT /greenfleet/raw/"
