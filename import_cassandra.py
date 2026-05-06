from cassandra.cluster import Cluster

cluster = Cluster(['127.0.0.1'])
session = cluster.connect()

session.execute("""
    CREATE KEYSPACE IF NOT EXISTS greenfleet
    WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1}
""")
session.set_keyspace('greenfleet')

session.execute("""
    CREATE TABLE IF NOT EXISTS vehicle_measures (
        vehicle_id TEXT PRIMARY KEY,
        measure_count INT
    )
""")

count = 0
with open('results_job_a.tsv', 'r') as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        parts = line.split('\t')
        if len(parts) != 2:
            continue
        vehicle_id = parts[0]
        measure_count = int(parts[1])
        session.execute(
            "INSERT INTO vehicle_measures (vehicle_id, measure_count) VALUES (%s, %s)",
            (vehicle_id, measure_count)
        )
        count += 1

print(f" {count} lignes insérées dans Cassandra")
cluster.shutdown()
