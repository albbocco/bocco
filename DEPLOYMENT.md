# 🚀 Déploiement Workflows Bocco AI - RÉCAPITULATIF

## ✅ Statut
**Date:** 2026-03-05  
**Workflows prêts:** 8/8

---

## 📦 Workflows Déployables

| ID | Nom | Description | Dépendances |
|----|-----|-------------|-------------|
| WF-05 | ⚙️ Gestion Crédits | Core - Gestion des crédits utilisateurs | Aucune (déployer en premier) |
| WF-01 | 🎭 Inscription + Avatar Gratuit | Onboarding nouvel utilisateur | WF-05 |
| WF-02 | 💳 Création Avatar Payant | Avatar payant avec vérification crédits | WF-05 |
| WF-03 | 🎬 Vidéo Faceless Courte | Génération vidéos <1min (6 crédits) | WF-05 |
| WF-04 | 🎬 Vidéo Faceless Longue | Génération vidéos 1-2min (10 crédits) | WF-05 |
| WF-07 | 💰 Achat Crédits Stripe | Paiement crédits via Stripe | WF-05 |
| WF-08 | 📅 Attribution Mensuelle | Cron mensuel crédits abonnés | WF-05 |
| WF-09 | 🔄 Paiement Abonnement | Gestion abonnements Stripe | WF-05 |

---

## 🔧 Méthodes de Déploiement

### Méthode 1: Déploiement Automatique (Recommandé)

```bash
cd /data/.openclaw/workspace/bocco-ai

# Avec la clé API
N8N_API_KEY=n8n_api_votre_cle_ici ./deploy-to-n8n.sh
```

**Obtenir la clé API:**
1. Connectez-vous à https://albbocco.app.n8n.cloud
2. Settings → n8n API → Create API Key
3. Copiez la clé et exécutez la commande ci-dessus

### Méthode 2: Import Manuel

1. Connectez-vous à https://albbocco.app.n8n.cloud
2. Workflows → Import from File
3. Importez dans cet ordre:
   ```
   n8n-workflows-api-ready/WF-05-gestion-credits.json  ← EN PREMIER
   n8n-workflows-api-ready/WF-01-inscription-avatar-gratuit.json
   n8n-workflows-api-ready/WF-02-creation-avatar-payant.json
   n8n-workflows-api-ready/WF-03-video-faceless-courte.json
   n8n-workflows-api-ready/WF-04-video-faceless-longue.json
   n8n-workflows-api-ready/WF-07-achat-credits-stripe.json
   n8n-workflows-api-ready/WF-08-attribution-mensuelle.json
   n8n-workflows-api-ready/WF-09-paiement-abonnement.json
   ```

---

## 🔐 Credentials à Configurer

Après déploiement, configurez ces credentials dans n8n:

| Credential | Variables d'environnement | Usage |
|------------|---------------------------|-------|
| **Supabase PostgreSQL** | `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` | Base de données |
| **Cloudflare R2** | `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_ENDPOINT_URL` | Stockage fichiers |
| **Stripe API** | `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` | Paiements |
| **Brevo SMTP** | `BREVO_SMTP_HOST`, `BREVO_SMTP_USER`, `BREVO_SMTP_PASS` | Emails |
| **Hypereal AI** | `HYPEREAL_API_KEY` | Génération avatars |
| **Haiper AI** | `HAIPER_API_KEY` | Génération vidéos |
| **OpenAI** | `OPENAI_API_KEY` | Scripts/prompts |

---

## 🌐 Webhooks Configurés

| Workflow | Webhook Path | Méthode |
|----------|--------------|---------|
| WF-01 | `/webhook/register-free-avatar` | POST |
| WF-02 | `/webhook/create-paid-avatar` | POST |
| WF-03 | `/webhook/create-short-video` | POST |
| WF-04 | `/webhook/create-long-video` | POST |
| WF-05 | `/webhook/manage-credits` | POST |
| WF-07 | `/webhook/stripe-credits-webhook` | POST |
| WF-09 | `/webhook/stripe-subscription-webhook` | POST |

**URL complète:** `https://albbocco.app.n8n.cloud/webhook/{path}`

---

## 📊 Grille de Prix (Crédits)

| Action | Coût Crédits | Prix API Estimé |
|--------|--------------|-----------------|
| Avatar gratuit (1x) | 0 | ~0.30€ |
| Avatar payant | 1 | ~0.30€ |
| Vidéo courte (<1min) | 6 | ~0.75€ |
| Vidéo longue (1-2min) | 10 | ~1.45€ |

---

## 🗄️ Structure Base de Données

Les workflows utilisent ces tables Supabase:

- `users` - Infos utilisateurs, crédits, abonnements
- `avatars` - Avatars générés (URLs R2)
- `videos` - Vidéos générées (URLs R2, crédits utilisés)
- `credits_transactions` - Historique crédits (+/-)
- `formations_purchases` - Achats formations MRR
- `referral_discounts` - Système parrainage

---

## ✅ Checklist Post-Déploiement

- [ ] Déployer les 8 workflows
- [ ] Configurer tous les credentials
- [ ] Activer les workflows (toggle ON)
- [ ] Tester WF-05 (gestion crédits)
- [ ] Tester WF-01 (inscription)
- [ ] Configurer webhooks Stripe
- [ ] Vérifier les buckets R2 (boccoai-avatars, boccoai-videos)
- [ ] Tester email Brevo

---

## 📁 Fichiers Importants

```
bocco-ai/
├── n8n-workflows/                    # Workflows originaux
├── n8n-workflows-api-ready/          # Workflows prêts pour déploiement
├── deploy-to-n8n.sh                  # Script de déploiement auto
├── deploy-all-workflows.sh           # Script avec guide
├── __IMPORT-GUIDE.json               # Guide d'import JSON
└── DEPLOYMENT.md                     # Ce fichier
```

---

## 🆘 Support

**Documentation complète:** `docs/architecture-complete.md`

**Problèmes courants:**
- Erreur 401: Clé API invalide
- Erreur 400: Champs en lecture seule (utiliser `n8n-workflows-api-ready/`)
- Workflow ne s'active pas: Vérifier les credentials manquants

---

*Dernier mise à jour: 2026-03-05*
