# Atelier Écosystème Hadoop

## Ressources pour les étudiants

## Contenu du dossier

```
hadoop_resources/
│
├── README.md                          ← Ce fichier
│
├── vagrant/
│   └── Vagrantfile                    ← Création automatisée des 3 VMs
│
├── config/
│   ├── core-site.xml                  ← Config générale Hadoop (adresse NameNode)
│   ├── hdfs-site.xml                  ← Config HDFS (réplication, répertoires)
│   ├── yarn-site.xml                  ← Config YARN (ResourceManager, mémoire)
│   ├── mapred-site.xml                ← Config MapReduce (framework, mémoire)
│   ├── hadoop-env.sh                  ← Variables Java + utilisateurs démons
│   ├── workers                        ← Liste des nœuds esclaves
│   └── hadoop_bashrc.sh               ← Variables d'env à ajouter au .bashrc
│
├── datasets/
│   ├── generate_web_logs.sh           ← Génère web_logs.csv (Partie A)
│   └── generate_greenfleet.sh         ← Génère fleet_data.csv (Partie B - Projet)
│
└── scripts/
    ├── mapreduce/
    │   ├── mapper_status.py           ← Partie A : mapper codes HTTP
    │   ├── mapper_pages.py            ← Partie A : mapper pages visitées
    │   ├── mapper_duration.py         ← Partie A : mapper durée par page
    │   ├── reducer_count.py           ← Reducer générique de comptage
    │   ├── reducer_avg.py             ← Reducer de calcul de moyenne
    │   ├── reducer_sum.py             ← Reducer de somme
    │   ├── mapper_vehicle_count.py    ← Projet : mesures par véhicule (Job A)
    │   ├── mapper_fleet_status.py     ← Projet : répartition par statut (Job B)
    │   ├── mapper_speed.py            ← Projet : vitesse moyenne (Job C)
    │   ├── mapper_low_battery.py      ← Projet : alertes batterie <15% (Job D)
    │   ├── mapper_daily_distance.py   ← Projet : distance/jour/véhicule (Job E)
    │   ├── run_jobs_partA.sh          ← Lance tous les jobs Partie A
    │   └── run_jobs_projet.sh         ← Lance tous les jobs Projet
    │
    └── admin/
        ├── health_check.sh            ← Vérification santé du cluster
        ├── deploy_node.sh             ← Déploiement automatisé d'un nouveau nœud
        └── setup_ssh.sh               ← Configuration SSH sans mot de passe
```

## Architecture de chaque partie du projet

- **Partie A (exercices guidés)** : analyse de logs web (codes HTTP, pages visitées, durée)
![Architecture Partie A](images/archi_0.png)

- **Partie B (projet individuel)** : analyse de données de flotte de véhicules électriques
![Architecture Partie B](images/archi_1.png)

- **Partie C (Intégration des résultats MapReduce dans Apache Cassandra)** : stockage des résultats dans une base de données NoSQL pour requêtes rapides
![Architecture Partie C](images/archi_2.png)

## Guide de démarrage rapide

### 1. Créer les VMs

```bash
cd vagrant/
vagrant up
```

### 2. Configurer SSH (sur hadoop-master)

```bash
chmod +x scripts/admin/setup_ssh.sh
./scripts/admin/setup_ssh.sh
```

### 3. Installer Hadoop

Suivez les étapes du support de formation (Section 2).
Copiez les fichiers du dossier `config/` dans `$HADOOP_HOME/etc/hadoop/` :

```bash
cp config/core-site.xml $HADOOP_HOME/etc/hadoop/
cp config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/
cp config/yarn-site.xml $HADOOP_HOME/etc/hadoop/
cp config/mapred-site.xml $HADOOP_HOME/etc/hadoop/
cp config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/
cp config/workers $HADOOP_HOME/etc/hadoop/
```

Ajoutez les variables d'environnement :

```bash
cat config/hadoop_bashrc.sh >> ~/.bashrc
source ~/.bashrc
```

### 4. Générer les datasets

**Partie A (exercices guidés) :**

```bash
chmod +x datasets/generate_web_logs.sh
./datasets/generate_web_logs.sh
hdfs dfs -mkdir -p /data/input
hdfs dfs -put web_logs.csv /data/input/
```

**Partie B (projet individuel) :**

```bash
chmod +x datasets/generate_greenfleet.sh
./datasets/generate_greenfleet.sh
hdfs dfs -mkdir -p /greenfleet/raw
hdfs dfs -put fleet_data.csv /greenfleet/raw/
```

### 5. Lancer les jobs MapReduce

**Tester en local d'abord :**

```bash
cd scripts/mapreduce/
cat ../../web_logs.csv | python3 mapper_status.py | sort | python3 reducer_count.py
```

**Lancer sur le cluster :**

```bash
chmod +x scripts/mapreduce/run_jobs_partA.sh
cd scripts/mapreduce/
./run_jobs_partA.sh
```

### 6. Vérifier la santé du cluster

```bash
chmod +x scripts/admin/health_check.sh
./scripts/admin/health_check.sh
```

---

## Correspondance Fichiers ↔ Tâches du module

| Tâche                          | Fichiers concernés                                |
| ------------------------------ | ------------------------------------------------- |
| T1 — Analyse des besoins       | generate_greenfleet.sh (pour estimer les volumes) |
| T2 — Configuration cluster     | Vagrantfile, config/*, setup_ssh.sh               |
| T3 — Installation composants   | config/*, hadoop_bashrc.sh                        |
| T4 — Gestion stockage HDFS     | generate_web_logs.sh, generate_greenfleet.sh      |
| T5 — Jobs MapReduce            | scripts/mapreduce/*.py, run_jobs_*.sh             |
| T6 — Surveillance/optimisation | health_check.sh                                   |
| T7 — Tests et démo             | health_check.sh, deploy_node.sh                   |

---

## Notes importantes

- **Rendre les scripts exécutables** avant de les lancer : `chmod +x script.sh`
- **Les fichiers de config** sont commentés — lisez les descriptions XML
- **Les mappers/reducers Partie B** sont fournis comme aide, mais les étudiants
  doivent comprendre et pouvoir les modifier/adapter pour leur projet
- **Tester en local** avant de lancer sur le cluster (voir commande pipe ci-dessus)
- **Hadoop Streaming 3.3.6** : vérifiez que le JAR existe dans
  `$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar`
