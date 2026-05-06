#!/bin/bash
# setup_ssh.sh — Configure SSH sans mot de passe entre les nœuds
# Exécuter sur hadoop-master en tant qu'utilisateur hadoop

NODES=("hadoop-master" "hadoop-slave1" "hadoop-slave2")

echo "=== Configuration SSH sans mot de passe ==="

if [ ! -f ~/.ssh/id_rsa ]; then
  echo "[1/2] Génération de la clé RSA..."
  ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
else
  echo "[1/2] Clé RSA existante — OK"
fi

echo "[2/2] Distribution de la clé publique..."
for node in "${NODES[@]}"; do
  echo "  → $node..."
  ssh-copy-id -o StrictHostKeyChecking=no hadoop@$node 2>/dev/null
done

echo ""
echo "Vérification..."
for node in "${NODES[@]}"; do
  RESULT=$(ssh -o ConnectTimeout=5 -o BatchMode=yes hadoop@$node 'hostname' 2>/dev/null)
  if [ "$RESULT" = "$node" ]; then
    echo "  ✅ $node : OK"
  else
    echo "  ❌ $node : ÉCHEC"
  fi
done
