# DISTRISEN Infrastructure — Model Technologie

Infrastructure complète du projet fil rouge **DISTRISEN S.A.** pour le Bootcamp Power BI.

```
distrisen-infra/
├── docker-compose.yml          # Orchestration des 3 services
├── .env.example                # Template variables d'environnement
├── .gitignore
├── README.md
│
├── api/                        # API Node.js — Taux de Change
│   ├── Dockerfile
│   ├── package.json
│   ├── server.js
│   └── taux_change.json        # 144 enregistrements (6 devises × 24 mois)
│
└── postgres/
    └── init/
        ├── 01_schema.sql       # Schéma des 5 tables
        └── 02_seed.sql         # Données : 20 clients, 25 produits,
                                #           500 retours, 300 réclamations,
                                #           1 000 mouvements de stock
```

---

## Démarrage rapide

### 1. Cloner et configurer

```bash
git clone https://github.com/MODEL-TECHNOLOGIE/distrisen-infra.git
cd distrisen-infra

# Créer le fichier .env à partir du template
cp .env.example .env

# Éditer .env avec vos vraies valeurs
nano .env
```

Contenu du `.env` :

```env
POSTGRES_DB=distrisen_db
POSTGRES_USER=distrisen_admin
POSTGRES_PASSWORD=un_mot_de_passe_fort_ici

# Générer avec : openssl rand -hex 32
API_KEY=votre_cle_api_64_caracteres_hex
```

### 2. Lancer les services

```bash
docker-compose up -d
```

### 3. Vérifier que tout tourne

```bash
docker-compose ps
docker-compose logs api
```

---

## Services exposés

> Sur Dokploy, les domaines sont configurés dans l'interface — **ne pas** modifier les labels Traefik dans le docker-compose.

| Service | Port interne | Usage |
|---------|-------------|-------|
| `postgres` | 5432 | Base de données (accès interne uniquement) |
| `adminer` | 8080 | Interface web de gestion PostgreSQL |
| `api` | 3000 | API REST taux de change |

---

## API — Endpoints

**Base URL :** `https://api.model-technologie.com` (ou votre domaine Dokploy)

**Header requis :** `X-API-Key: <votre_cle>`

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/` | Info API (sans auth) |
| GET | `/health` | Health check (sans auth) |
| GET | `/distrisen/taux-change` | Tous les taux (144 records) |
| GET | `/distrisen/taux-change?devise=EUR` | Filtrer par devise |
| GET | `/distrisen/taux-change?annee=2024` | Filtrer par année |
| GET | `/distrisen/taux-change?devise=USD&annee=2024&mois=6` | Combiné |
| GET | `/distrisen/taux-change/devises` | Liste des devises disponibles |

**Exemple de réponse :**
```json
{
  "source": "DISTRISEN API",
  "base_currency": "XOF",
  "count": 144,
  "data": [
    {
      "annee": 2023,
      "mois": 1,
      "periode": "2023-01",
      "devise_code": "EUR",
      "devise_name": "Euro",
      "taux_xof_vers_devise": 0.001504,
      "taux_devise_vers_xof": 664.9417
    }
  ]
}
```

**Test rapide :**
```bash
curl -H "X-API-Key: VOTRE_CLE" https://api.model-technologie.com/distrisen/taux-change
```

---

## PostgreSQL — Connexion

### Adminer (interface web)
Accéder à l'URL configurée sur Dokploy pour Adminer.

| Champ | Valeur |
|-------|--------|
| Système | PostgreSQL |
| Serveur | `postgres` |
| Utilisateur | `distrisen_admin` |
| Mot de passe | *(valeur dans .env)* |
| Base de données | `distrisen_db` |

### Power BI Desktop (connexion apprenants)

| Paramètre | Valeur |
|-----------|--------|
| Serveur | `158.220.80.126:5432` |
| Base | `distrisen_db` |
| Utilisateur | `apprenants_ro` |
| Mot de passe | `Distrisen2026!` |
| Mode | Import |

> `apprenants_ro` est un compte **lecture seule** créé automatiquement au démarrage. Il peut faire des SELECT sur toutes les tables mais ne peut pas modifier les données.

### Tables disponibles

| Table | Lignes | Type |
|-------|--------|------|
| `clients` | 20 | Dimension |
| `produits` | 25 | Dimension |
| `retours` | 500 | Fait |
| `reclamations` | 300 | Fait |
| `stocks_mouvements` | 1 000 | Fait |

---

## Déploiement sur Dokploy

1. Pusher ce dépôt sur GitHub
2. Dans Dokploy : **New App → Docker Compose → GitHub repo**
3. Ajouter les variables d'environnement dans l'interface Dokploy (onglet **Environment**)
4. Configurer les domaines pour `adminer` et `api` dans l'onglet **Domains**
5. Déployer

> ⚠️ Ne jamais définir les labels Traefik dans le `docker-compose.yml` — Dokploy les génère automatiquement depuis son interface.

---

## Commandes utiles

```bash
# Voir les logs en temps réel
docker-compose logs -f api
docker-compose logs -f postgres

# Redémarrer un service
docker-compose restart api

# Entrer dans le container PostgreSQL
docker-compose exec postgres psql -U distrisen_admin -d distrisen_db

# Vérifier le nombre de lignes dans chaque table
docker-compose exec postgres psql -U distrisen_admin -d distrisen_db -c "
  SELECT 'clients' AS table_name, COUNT(*) FROM clients UNION ALL
  SELECT 'produits', COUNT(*) FROM produits UNION ALL
  SELECT 'retours', COUNT(*) FROM retours UNION ALL
  SELECT 'reclamations', COUNT(*) FROM reclamations UNION ALL
  SELECT 'stocks_mouvements', COUNT(*) FROM stocks_mouvements;
"

# Reset complet (⚠️ supprime toutes les données)
docker-compose down -v && docker-compose up -d
```

---

## Utilisation pédagogique

| Séance | Source utilisée | Compétence |
|--------|----------------|-----------|
| S1–S2 | CSV + Excel local | Import, Power Query basique |
| S3 | **API `/distrisen/taux-change`** | JSON imbriqué, authentification, Table.ExpandListColumn |
| S4 | **PostgreSQL `distrisen_db`** | Connexion ODBC/NPGSQL, requêtes SQL natives, modélisation |

---

© Model Technologie — Dakar, Sénégal — model-technologie.com
