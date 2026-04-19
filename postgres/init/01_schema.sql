-- ============================================================
-- DISTRISEN S.A. — Schéma PostgreSQL (VPS Model Technologie)
-- Base : distrisen_db
-- ============================================================

-- Table : clients
CREATE TABLE IF NOT EXISTS clients (
    client_id       VARCHAR(10) PRIMARY KEY,
    client_name     VARCHAR(120) NOT NULL,
    region_code     VARCHAR(5) NOT NULL,
    channel_code    VARCHAR(5) NOT NULL,
    sales_rep_id    VARCHAR(10),
    date_creation   DATE,
    statut          VARCHAR(20) DEFAULT 'actif',
    credit_limite   NUMERIC(12,2) DEFAULT 0,
    encours_credit  NUMERIC(12,2) DEFAULT 0
);

-- Table : produits
CREATE TABLE IF NOT EXISTS produits (
    product_code    VARCHAR(10) PRIMARY KEY,
    product_name_fr VARCHAR(120) NOT NULL,
    product_name_en VARCHAR(120),
    category_code   VARCHAR(10) NOT NULL,
    fournisseur_id  VARCHAR(10),
    prix_achat      NUMERIC(10,2),
    prix_vente_rec  NUMERIC(10,2),
    stock_actuel    INTEGER DEFAULT 0,
    stock_minimum   INTEGER DEFAULT 50,
    actif           BOOLEAN DEFAULT TRUE
);

-- Table : retours (données qualité — non disponibles dans CSV)
CREATE TABLE IF NOT EXISTS retours (
    retour_id       SERIAL PRIMARY KEY,
    transaction_id  VARCHAR(15) NOT NULL,
    date_retour     DATE NOT NULL,
    product_code    VARCHAR(10) NOT NULL,
    client_id       VARCHAR(10) NOT NULL,
    quantite        INTEGER NOT NULL,
    motif           VARCHAR(50),
    montant_xof     NUMERIC(10,2),
    traite          BOOLEAN DEFAULT FALSE
);

-- Table : reclamations
CREATE TABLE IF NOT EXISTS reclamations (
    reclamation_id  SERIAL PRIMARY KEY,
    date_reclamation DATE NOT NULL,
    client_id       VARCHAR(10) NOT NULL,
    sales_rep_id    VARCHAR(10),
    type_reclamation VARCHAR(50),
    description     TEXT,
    priorite        VARCHAR(20),
    statut          VARCHAR(20) DEFAULT 'ouverte',
    date_resolution DATE
);

-- Table : stocks_mouvements
CREATE TABLE IF NOT EXISTS stocks_mouvements (
    mouvement_id    SERIAL PRIMARY KEY,
    date_mouvement  DATE NOT NULL,
    product_code    VARCHAR(10) NOT NULL,
    type_mouvement  VARCHAR(20),   -- 'entree','sortie','ajustement'
    quantite        INTEGER NOT NULL,
    motif           VARCHAR(80),
    region_code     VARCHAR(5)
);
