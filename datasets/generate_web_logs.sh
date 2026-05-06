#!/bin/bash
# ============================================================
# generate_web_logs.sh
# Génère un jeu de données de logs web pour la Partie A
# Usage : chmod +x generate_web_logs.sh && ./generate_web_logs.sh [nb_lignes]
# ============================================================

OUTPUT="web_logs.csv"
NB_LINES=${1:-100000}

echo "timestamp,user_id,page,status,duration_ms" > "$OUTPUT"

PAGES=("/home" "/products" "/cart" "/checkout" "/about" "/contact" "/search" "/login" "/register" "/profile")
CODES=("200" "200" "200" "200" "200" "200" "301" "301" "404" "404" "500")

echo "Génération de $NB_LINES lignes de logs web..."

for i in $(seq 1 "$NB_LINES"); do
    DAYS_AGO=$((RANDOM % 30))
    HOUR=$((RANDOM % 24))
    MIN=$((RANDOM % 60))
    SEC=$((RANDOM % 60))
    TS=$(date -d "$DAYS_AGO days ago $HOUR:$MIN:$SEC" +%Y-%m-%dT%H:%M:%S 2>/dev/null)
    if [ -z "$TS" ]; then
        TS="2025-11-$((RANDOM % 28 + 1))T$(printf '%02d' $HOUR):$(printf '%02d' $MIN):$(printf '%02d' $SEC)"
    fi

    USER_ID=$((RANDOM % 500 + 1))
    PAGE=${PAGES[$((RANDOM % ${#PAGES[@]}))]}
    STATUS=${CODES[$((RANDOM % ${#CODES[@]}))]}
    DURATION=$((RANDOM % 5000 + 50))

    echo "$TS,$USER_ID,$PAGE,$STATUS,$DURATION"
done >> "$OUTPUT"

LINES=$(wc -l < "$OUTPUT")
SIZE=$(du -h "$OUTPUT" | cut -f1)
echo "Fichier genere : $OUTPUT"
echo "   Lignes : $LINES (dont 1 header)"
echo "   Taille : $SIZE"
