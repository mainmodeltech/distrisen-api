const express = require('express');
const cors    = require('cors');
const path    = require('path');
const fs      = require('fs');

const app  = express();
const PORT = process.env.PORT || 3000;
const API_KEY = process.env.API_KEY;

if (!API_KEY) {
    console.error('FATAL: API_KEY env variable is not set');
    process.exit(1);
}

// ── Données chargées une fois au démarrage ────────────────────
const DATA_PATH = path.join(__dirname, 'taux_change.json');
let tauxData;
try {
    tauxData = JSON.parse(fs.readFileSync(DATA_PATH, 'utf8'));
    console.log(`Loaded ${tauxData.data.length} taux records`);
} catch (err) {
    console.error('FATAL: Cannot read taux_change.json:', err.message);
    process.exit(1);
}

// ── Middlewares ───────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// Auth middleware — vérifie le header X-API-Key
function requireApiKey(req, res, next) {
    const key = req.headers['x-api-key'];
    if (!key || key !== API_KEY) {
        return res.status(401).json({
            error: 'Unauthorized',
            message: 'Missing or invalid X-API-Key header'
        });
    }
    next();
}

// ── Routes publiques ──────────────────────────────────────────

// Health check — utilisé par Docker healthcheck (pas d'auth)
app.get('/health', (_req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Info API — pas d'auth (utile pour tester la connectivité)
app.get('/', (_req, res) => {
    res.json({
        name: 'DISTRISEN API — Model Technologie',
        version: '1.0.0',
        endpoints: {
            taux_change: 'GET /distrisen/taux-change  (X-API-Key requis)',
            devises:     'GET /distrisen/taux-change/devises  (X-API-Key requis)',
            filtre:      'GET /distrisen/taux-change?devise=EUR&annee=2024  (X-API-Key requis)'
        }
    });
});

// ── Routes protégées ──────────────────────────────────────────

/**
 * GET /distrisen/taux-change
 * Retourne tous les taux de change (144 enregistrements)
 * Query params optionnels :
 *   ?devise=EUR          — filtrer par code devise
 *   ?annee=2024          — filtrer par année
 *   ?mois=6              — filtrer par mois (1-12)
 *   ?devise=USD&annee=2024  — combinable
 */
app.get('/distrisen/taux-change', requireApiKey, (req, res) => {
    const { devise, annee, mois } = req.query;

    let records = [...tauxData.data];

    if (devise) {
        records = records.filter(r => r.devise_code === devise.toUpperCase());
    }
    if (annee) {
        const yr = parseInt(annee, 10);
        records = records.filter(r => r.annee === yr);
    }
    if (mois) {
        const mo = parseInt(mois, 10);
        records = records.filter(r => r.mois === mo);
    }

    res.json({
        source:        tauxData.source,
        description:   tauxData.description,
        last_updated:  tauxData.last_updated,
        base_currency: tauxData.base_currency,
        filters_applied: {
            devise: devise || null,
            annee:  annee  ? parseInt(annee, 10) : null,
            mois:   mois   ? parseInt(mois, 10)  : null
        },
        count: records.length,
        data:  records
    });
});

/**
 * GET /distrisen/taux-change/devises
 * Liste les devises disponibles (utile pour Power Query)
 */
app.get('/distrisen/taux-change/devises', requireApiKey, (req, res) => {
    const devises = [...new Map(
        tauxData.data.map(r => [r.devise_code, {
            code: r.devise_code,
            name: r.devise_name
        }])
    ).values()];

    res.json({
        base_currency: tauxData.base_currency,
        devises
    });
});

// ── 404 catch-all ─────────────────────────────────────────────
app.use((req, res) => {
    res.status(404).json({
        error: 'Not Found',
        path:  req.path
    });
});

// ── Start ─────────────────────────────────────────────────────
app.listen(PORT, () => {
    console.log(`DISTRISEN API running on port ${PORT}`);
});
