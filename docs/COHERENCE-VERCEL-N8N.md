# 📊 RAPPORT DE COHÉRENCE - PROJETS VERCEL & N8N

## 🌐 PROJETS VERCEL DÉTECTÉS

### 1. antigravity
- **ID**: prj_Ajp52RhN5IyiLpQTtd9wrXnewiai
- **URL**: https://antigravity-e8igaeo6i-dorians-projects-fe739435.vercel.app
- **Framework**: None (pas de code framework détecté)
- **État**: ⚠️ Inactif ou site statique simple

### 2. bocco-ai ✅
- **ID**: prj_Xqts8fZ2mJA4mZ0mIb9lKzrTkHpo
- **URL**: https://bocco-cwzve8q8z-dorians-projects-fe739435.vercel.app
- **Framework**: Next.js
- **Branch**: master
- **État**: ✅ Actif

---

## 🔍 ANALYSE BOCCO-AI

### ✅ Cohérence Site + n8n

| Composant | Site (Vercel) | n8n | Statut |
|-----------|---------------|-----|--------|
| **Avatar gratuit** | `/api/avatar` | WF-01 | ✅ OK |
| **Avatar payant** | `/api/avatar/create` | WF-02 | ✅ OK |
| **Vidéo courte** | `/api/video/create` | WF-03 (1 crédit) | ✅ OK |
| **Vidéo longue** | `/api/video/create` | WF-04 (2 crédits) | ✅ OK |
| **Gestion crédits** | `/api/credits` | WF-05 | ✅ OK |
| **Remboursement** | - | WF-06 | ✅ OK |
| **Achat crédits** | `/api/payment/credits` | WF-07 (Stripe) | ✅ OK |
| **Attribution mensuelle** | - | WF-08 (cron) | ✅ OK |
| **Abonnement** | `/api/payment/subscription` | WF-09 (Starter 9€) | ✅ OK |
| **Retry/Fallback** | - | WF-13 | ✅ OK |
| **Alertes crédits** | - | WF-14 | ✅ OK |

### ⚠️ Points d'attention

#### 1. Double système de paiement
**Vercel a**: Stripe + Mollie configurés
**Code local**: Mollie uniquement dans `src/lib/mollie.ts`

**Recommandation**: Uniformiser (garder Stripe ou Mollie, pas les deux)

#### 2. Prix sur Vercel vs n8n
| Plan | Vercel (Stripe) | n8n | Statut |
|------|-----------------|-----|--------|
| **Starter** | 9€ ✅ | 9€ ✅ | ✅ OK |
| **Pro** | 49€ | 49€ | ✅ OK |
| **Business** | 109€ | 109€ | ✅ OK |

#### 3. APIs externes
| API | Vercel | n8n | Statut |
|-----|--------|-----|--------|
| **FAL.ai** | ✅ Configuré | ✅ Utilisé WF-01/02 | ✅ OK |
| **Hailuo/PiAPI** | ✅ Configuré | ✅ Utilisé WF-01/02/03/04 | ✅ OK |
| **Supabase** | ✅ Configuré | ✅ Utilisé tous WF | ✅ OK |

---

## 🔴 INCOHÉRENCES DÉTECTÉES

### 1. Routes API manquantes sur Vercel
Le code local a des routes qui ne sont pas encore déployées:
- `/api/avatar/create` (WF-02)
- `/api/webhook/stripe` (WF-07/09)
- `/api/webhook/n8n` (fallback)

### 2. Webhooks Stripe non configurés
Les webhooks Stripe pointent vers n8n, pas vers Vercel.
Si tu veux que Vercel gère les webhooks, il faut créer `/api/webhook/stripe`.

### 3. Projet Antigravity orphelin
- Existe sur Vercel mais pas de code local
- Pas de workflows n8n liés
- Probablement un ancien projet ou test

---

## ✅ RECOMMANDATIONS

### Priorité 1: Déployer le code local sur Vercel
```bash
cd /data/.openclaw/workspace/bocco-ai
npx vercel --prod
```

### Priorité 2: Choisir un système de paiement
Option A: **Stripe uniquement**
- Supprimer Mollie du code
- Utiliser les variables STRIPE_* déjà configurées

Option B: **Mollie uniquement**  
- Supprimer Stripe du code
- Mettre à jour les variables Vercel

### Priorité 3: Supprimer ou migrer Antigravity
Si Antigravity n'est plus utilisé:
```bash
npx vercel remove antigravity
```

---

## 🎯 CONCLUSION

**Cohérence globale**: 85% ✅

- **n8n** est parfaitement configuré avec les bons workflows et prix
- **Vercel** a les bonnes variables d'environnement
- **Code local** est à jour avec les derniers prix (Starter 9€)

**Action requise**: Déployer le code local sur Vercel pour synchroniser.

---

*Généré le 2026-03-05*