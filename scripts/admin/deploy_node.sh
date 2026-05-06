#!/bin/bash
# ============================================================
# deploy_node.sh — Déploiement automatisé d'un nouveau DataNode
# Usage : ./deploy_node.sh <hostname>
# Exemple : ./deploy_node.sh hadoop-slave3
# ============================================================

NODE=$1
if [ -z "$NODE" ]; then
    echo "Usage: ./deploy_node.sh <hostname>"
    echo "Exemple: ./deploy_node.sh hadoop-slave3"
    exit 1
fi

echo "==========================================="
echo "  Deploiement Hadoop sur $NODE"
echo "==========================================="

# Vérifier la connectivité SSH
echo "[0/6] Verification SSH..."
ssh -o ConnectTimeout=5 hadoop@$NODE 'echo OK' > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERREUR : Impossible de se connecter a $NODE via SSH."
    echo "Verifiez que :"
    echo "  - Le hostname $NODE est dans /etc/hosts"
    echo "  - SSH sans mot de passe est configure"
    exit 1
fi

echo "[1/6] Installation de Java..."
ssh hadoop@$NODE 'sudo apt update -qq && sudo apt install -y -qq openjdk-11-jdk' 2>/dev/null
if [ $? -ne 0 ]; then
    echo "ERREUR : Installation Java echouee sur $NODE"
    exit 1
fi

echo "[2/6] Copie de Hadoop..."
scp -r /opt/hadoop hadoop@$NODE:/opt/ 2>/dev/null
if [ $? -ne 0 ]; then
    echo "ERREUR : Copie Hadoop echouee"
    exit 1
fi

echo "[3/6] Copie des variables d'environnement..."
scp ~/.bashrc hadoop@$NODE:~/.bashrc

echo "[4/6] Creation des repertoires de donnees..."
ssh hadoop@$NODE 'mkdir -p /opt/hadoop/data/datanode /opt/hadoop/tmp'

echo "[5/6] Application des permissions..."
ssh hadoop@$NODE 'sudo chown -R hadoop:hadoop /opt/hadoop'

echo "[6/6] Demarrage des demons..."
ssh hadoop@$NODE 'source ~/.bashrc && hdfs --daemon start datanode && yarn --daemon start nodemanager'

echo ""
echo "==========================================="
echo "  Verification sur $NODE"
echo "==========================================="
ssh hadoop@$NODE 'source ~/.bashrc && jps'

echo ""
echo "Deploiement termine. Verifiez sur le master :"
echo "  hdfs dfsadmin -report"
echo "  yarn node -list"
