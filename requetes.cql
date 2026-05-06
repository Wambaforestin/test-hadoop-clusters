-- ============================================================
-- Exercice Cassandra
-- Keyspace : greenfleet | Table : vehicle_measures
-- Job choisi : Job A — Nombre de mesures par véhicule
-- ============================================================

USE greenfleet;

-- Requête 1 — Échantillon de données
SELECT * FROM vehicle_measures LIMIT 10;

-- Requête 2 — Requête par clé primaire
SELECT * FROM vehicle_measures WHERE vehicle_id = 'VH-001';

-- Requête 3 — Comptage total
SELECT COUNT(*) FROM vehicle_measures;

-- Requête 4 — Info métier : véhicules les plus actifs
SELECT * FROM vehicle_measures WHERE measure_count > 250 ALLOW FILTERING;

-- Requête 5 — Limite Cassandra : ALLOW FILTERING
SELECT * FROM vehicle_measures WHERE measure_count < 210 ALLOW FILTERING;
