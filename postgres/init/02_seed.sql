-- ============================================================
-- DISTRISEN S.A. — Données de seed PostgreSQL
-- Exécuté automatiquement après 01_schema.sql
-- ============================================================

-- ── Utilisateur lecture seule pour les apprenants ─────────────
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'apprenants_ro') THEN
    CREATE ROLE apprenants_ro LOGIN PASSWORD 'Distrisen2026!';
  END IF;
END
$$;

GRANT CONNECT ON DATABASE distrisen_db TO apprenants_ro;
GRANT USAGE ON SCHEMA public TO apprenants_ro;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO apprenants_ro;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO apprenants_ro;

-- ── Clients (20 lignes) ────────────────────────────────────────
INSERT INTO clients VALUES
('C001','Supermarché Auchan Almadies','DK','CH01','SR01','2019-03-15','actif',5000000,1200000),
('C002','Carrefour Sacré-Cœur','DK','CH01','SR01','2019-06-01','actif',8000000,2100000),
('C003','Supeco Ouakam','DK','CH01','SR02','2020-01-10','actif',3500000,850000),
('C004','Boutique Chez Mbaye','DK','CH04','SR04','2018-05-20','actif',500000,120000),
('C005','Épicerie Modou Fall','ZG','CH04','SR05','2020-09-15','actif',300000,75000),
('C006','Cash & Carry Thiès','TH','CH02','SR03','2019-11-01','actif',2000000,480000),
('C007','Grossiste Diallo Frères','SL','CH02','SR06','2021-02-28','actif',4500000,1100000),
('C008','Distribution Ndoye','SD','CH02','SR07','2020-07-14','actif',1800000,320000),
('C009','Mini-Marché Fatima','KL','CH04','SR08','2022-01-05','actif',250000,60000),
('C010','Coopérative Agricole Kaolack','KL','CH03','SR08','2019-04-18','actif',1200000,290000),
('C011','ProDist Ziguinchor','ZIG','CH02','SR09','2020-12-01','actif',2800000,670000),
('C012','Superette Saint-Louis','SL','CH01','SR06','2021-08-20','actif',1500000,380000),
('C013','Epicerie Centrale Touba','TB','CH04','SR10','2018-03-10','actif',800000,195000),
('C014','Marché Sandaga Grossiste','DK','CH03','SR02','2017-11-25','actif',6000000,1450000),
('C015','HLM Grand Yoff Commerce','DK','CH04','SR01','2022-06-15','actif',400000,95000),
('C016','Distribution Kolda','KD','CH02','SR09','2023-01-10','actif',900000,220000),
('C017','Cash Point Diourbel','SD','CH04','SR07','2021-05-30','actif',350000,85000),
('C018','Resto-Bar Teranga Mbour','MB','CH05','SR03','2020-10-08','actif',600000,145000),
('C019','Hôtel Savana Dakar','DK','CH05','SR01','2019-09-22','actif',2500000,610000),
('C020','Pharmacie Pasteur Thiès','TH','CH05','SR03','2022-03-17','inactif',500000,0)
ON CONFLICT DO NOTHING;

-- ── Produits (25 lignes) ───────────────────────────────────────
INSERT INTO produits VALUES
('P001','Riz Oncle Ben''s 5kg','Uncle Ben''s Rice 5kg','ALIM','F001',3200,4200,1850,100,TRUE),
('P002','Riz Parfumé Thaï 5kg','Thai Fragrant Rice 5kg','ALIM','F001',3500,4500,2100,100,TRUE),
('P003','Huile Végétale Lesieur 1L','Lesieur Vegetable Oil 1L','ALIM','F002',950,1300,4200,200,TRUE),
('P004','Huile de Palme Patisen 2L','Patisen Palm Oil 2L','ALIM','F002',1400,1900,3100,200,TRUE),
('P005','Farine de Blé Grands Moulins 1kg','Grands Moulins Wheat Flour 1kg','ALIM','F003',420,600,5800,300,TRUE),
('P006','Sucre en poudre 1kg','White Sugar 1kg','ALIM','F003',480,650,4900,300,TRUE),
('P007','Lait concentré sucré Gloria 397g','Gloria Condensed Milk 397g','ALIM','F004',520,750,2800,150,TRUE),
('P008','Cube Maggi Poulet x100','Maggi Chicken Cubes x100','ALIM','F004',900,1200,3500,200,TRUE),
('P009','Savon Lux 125g','Lux Soap Bar 125g','HYGN','F005',300,450,6200,400,TRUE),
('P010','Gel douche Palmolive 250ml','Palmolive Shower Gel 250ml','HYGN','F005',850,1200,3100,200,TRUE),
('P011','Dentifrice Colgate 75ml','Colgate Toothpaste 75ml','HYGN','F005',650,950,4400,250,TRUE),
('P012','Shampooing Pantene 200ml','Pantene Shampoo 200ml','HYGN','F005',1100,1600,2800,150,TRUE),
('P013','Déodorant Axe 150ml','Axe Deodorant 150ml','HYGN','F005',1200,1800,2100,100,TRUE),
('P014','Eau de Javel Lacroix 1L','Lacroix Bleach 1L','NETT','F006',400,600,5100,300,TRUE),
('P015','Détergent OMO 500g','OMO Detergent 500g','NETT','F006',750,1050,4200,250,TRUE),
('P016','Liquide vaisselle Palmolive 500ml','Palmolive Dishwashing Liquid 500ml','NETT','F006',600,900,3800,200,TRUE),
('P017','Coca-Cola 1.5L','Coca-Cola 1.5L','BOIS','F007',750,1100,5500,300,TRUE),
('P018','Kirène eau minérale 1.5L','Kirène Mineral Water 1.5L','BOIS','F007',350,550,8200,400,TRUE),
('P019','Jus Tropico 1L','Tropico Juice 1L','BOIS','F007',600,900,4100,250,TRUE),
('P020','Lait en poudre Nido 400g','Nido Powdered Milk 400g','ENFA','F004',3200,4500,1900,100,TRUE),
('P021','Couches bébé Pampers S3 x44','Pampers Baby Diapers S3 x44','ENFA','F008',5800,7500,1200,80,TRUE),
('P022','Lait maternel Blédilait 400g','Blédilait Baby Formula 400g','ENFA','F008',4100,5600,980,60,TRUE),
('P023','Biscuits Digestive McVitie''s 400g','McVitie''s Digestive Biscuits 400g','ALIM','F009',1100,1550,2400,150,TRUE),
('P024','Thé Lipton Yellow Label x100','Lipton Yellow Label Tea x100','BOIS','F009',1600,2200,3200,200,TRUE),
('P025','Café Nescafé 200g','Nescafé Instant Coffee 200g','BOIS','F009',2900,3900,1800,100,TRUE)
ON CONFLICT DO NOTHING;

-- ── Retours (500 lignes générées) ─────────────────────────────
INSERT INTO retours (transaction_id, date_retour, product_code, client_id, quantite, motif, montant_xof, traite)
SELECT
  'TXN' || LPAD((ROW_NUMBER() OVER ())::TEXT, 5, '0'),
  ('2023-01-01'::DATE + (RANDOM() * 730)::INT),
  (ARRAY['P001','P002','P003','P004','P005','P006','P007','P008','P009','P010',
         'P011','P012','P013','P014','P015','P016','P017','P018','P019','P020'])[CEIL(RANDOM()*20)::INT],
  (ARRAY['C001','C002','C003','C004','C005','C006','C007','C008','C009','C010',
         'C011','C012','C013','C014','C015','C016','C017','C018','C019','C020'])[CEIL(RANDOM()*20)::INT],
  (1 + FLOOR(RANDOM() * 10))::INT,
  (ARRAY[
    'Produit endommagé', 'Date de péremption dépassée', 'Erreur de commande',
    'Défaut de fabrication', 'Emballage abîmé', 'Produit non conforme',
    'Quantité incorrecte', 'Produit refusé client final', 'Rupture de chaîne froide'
  ])[CEIL(RANDOM()*9)::INT],
  (500 + FLOOR(RANDOM() * 15000))::NUMERIC,
  (RANDOM() > 0.4)
FROM generate_series(1, 500);

-- ── Réclamations (300 lignes) ─────────────────────────────────
INSERT INTO reclamations (date_reclamation, client_id, sales_rep_id, type_reclamation, description, priorite, statut, date_resolution)
SELECT
  ('2023-01-01'::DATE + (RANDOM() * 730)::INT)                      AS date_reclamation,
  (ARRAY['C001','C002','C003','C004','C005','C006','C007','C008','C009','C010',
         'C011','C012','C013','C014','C015','C016','C017','C018'])[CEIL(RANDOM()*18)::INT],
  (ARRAY['SR01','SR02','SR03','SR04','SR05','SR06','SR07','SR08','SR09','SR10'])[CEIL(RANDOM()*10)::INT],
  (ARRAY[
    'Livraison retardée', 'Produit manquant', 'Facturation incorrecte',
    'Qualité insuffisante', 'Service client', 'Rupture de stock non signalée',
    'Erreur de prix', 'Communication insuffisante'
  ])[CEIL(RANDOM()*8)::INT],
  'Réclamation enregistrée suite à incident client — traitement en cours.',
  (ARRAY['haute','moyenne','basse'])[CEIL(RANDOM()*3)::INT],
  (ARRAY['ouverte','en_cours','résolue','fermée'])[CEIL(RANDOM()*4)::INT],
  CASE WHEN RANDOM() > 0.45
    THEN ('2023-01-01'::DATE + (RANDOM() * 730)::INT + (2 + FLOOR(RANDOM()*28))::INT)
    ELSE NULL
  END
FROM generate_series(1, 300);

-- ── Stocks mouvements (1000 lignes) ───────────────────────────
INSERT INTO stocks_mouvements (date_mouvement, product_code, type_mouvement, quantite, motif, region_code)
SELECT
  ('2023-01-01'::DATE + (RANDOM() * 730)::INT),
  (ARRAY['P001','P002','P003','P004','P005','P006','P007','P008','P009','P010',
         'P011','P012','P013','P014','P015','P016','P017','P018','P019','P020',
         'P021','P022','P023','P024','P025'])[CEIL(RANDOM()*25)::INT],
  (ARRAY['entree','sortie','ajustement'])[CEIL(RANDOM()*3)::INT],
  (1 + FLOOR(RANDOM() * 500))::INT,
  (ARRAY[
    'Réception fournisseur', 'Vente client', 'Retour fournisseur',
    'Ajustement inventaire', 'Transfert inter-dépôt', 'Perte/casse',
    'Promotion stock', 'Correction erreur saisie'
  ])[CEIL(RANDOM()*8)::INT],
  (ARRAY['DK','TH','SL','KL','ZG','SD','TB','MB','KD','ZIG'])[CEIL(RANDOM()*10)::INT]
FROM generate_series(1, 1000);
