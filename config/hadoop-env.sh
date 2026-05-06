# hadoop-env.sh — Variables d'environnement pour Hadoop
# À placer dans : $HADOOP_HOME/etc/hadoop/hadoop-env.sh
# Doit être identique sur TOUS les nœuds du cluster.

# ── JAVA_HOME (OBLIGATOIRE) ──
# Hadoop a besoin de savoir où est Java.
# Vérifiez le chemin avec : dirname $(dirname $(readlink -f $(which java)))
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# ── Utilisateurs pour les démons Hadoop ──
# Nécessaire pour que start-dfs.sh et start-yarn.sh sachent
# sous quel utilisateur lancer les processus.
export HDFS_NAMENODE_USER=hadoop
export HDFS_DATANODE_USER=hadoop
export HDFS_SECONDARYNAMENODE_USER=hadoop
export YARN_RESOURCEMANAGER_USER=hadoop
export YARN_NODEMANAGER_USER=hadoop

# ── Options JVM pour le NameNode (optionnel) ──
# Augmenter si le cluster gère beaucoup de fichiers
# export HDFS_NAMENODE_OPTS="-Xmx1024m"

# ── Options JVM pour le DataNode (optionnel) ──
# export HDFS_DATANODE_OPTS="-Xmx512m"

# ── Répertoire des logs Hadoop ──
# Par défaut : $HADOOP_HOME/logs
# export HADOOP_LOG_DIR=/opt/hadoop/logs
