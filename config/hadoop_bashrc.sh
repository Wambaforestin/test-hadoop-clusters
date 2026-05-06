# ============================================================
# hadoop_bashrc.sh — Lignes à ajouter au .bashrc de l'utilisateur hadoop
# Usage : cat hadoop_bashrc.sh >> ~/.bashrc && source ~/.bashrc
# ============================================================

# Java
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Hadoop
export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Utilisateurs pour les démons (nécessaire pour start-dfs.sh / start-yarn.sh)
export HDFS_NAMENODE_USER=hadoop
export HDFS_DATANODE_USER=hadoop
export HDFS_SECONDARYNAMENODE_USER=hadoop
export YARN_RESOURCEMANAGER_USER=hadoop
export YARN_NODEMANAGER_USER=hadoop
