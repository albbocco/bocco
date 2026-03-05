# 🎯 PROMPT COMPLET - Projet BOCCO.AI

## 📌 CONTEXTE
Tu es un expert en développement web full-stack et UX/UI design. Tu dois comprendre en profondeur le projet BOCCO.AI pour pouvoir créer/redesigner une application web complète.

---

## 🎭 QU'EST-CE QUE BOCCO.AI ?

**BOCCO.AI** est une plateforme SaaS B2C permettant aux vendeurs de formations en ligne (MRR - Master Resell Rights) de créer :
1. **Des avatars IA animés** (photos réalistes qui parlent)
2. **Des vidéos "faceless"** (vidéos TikTok/YouTube Shorts avec leur avatar)

Le but : Générer du contenu viral automatiquement pour vendre des formations sans montrer son vrai visage.

---

## 👥 UTILISATEURS CIBLES

- **Vendeurs de formations MRR** (Digital Success Academy, ASA, Code Liberté)
- **Entrepreneurs digitaux** voulant créer du contenu à l'échelle
- **Influenceurs IA** (comptes entièrement gérés par IA)
- **Marketeurs** sans temps pour créer du contenu vidéo

---

## 🚀 FONCTIONNALITÉS CORE

### 1. Création d'Avatars (2 types)

#### Avatar Gratuit (1x par utilisateur)
- **Input** : Photo de l'utilisateur + nom/prénom/email
- **Process** :
  1. Upload photo sur R2 (Cloudflare)
  2. Génération image améliorée via IA (FAL.ai/Hypereal)
  3. Animation 5 secondes (avatar qui parle)
  4. Stockage vidéo sur R2
  5. Email de confirmation (Brevo)
- **Output** : Vidéo MP4 téléchargeable
- **Coût** : 0 crédit (offert)

#### Avatar Payant (crédits illimités)
- **Input** : Description textuelle de l'avatar souhaité
- **Process** :
  1. Vérification crédits (>= 1)
  2. Génération prompt optimisé (OpenAI/Kimi)
  3. Génération image (FAL.ai)
  4. Génération script de présentation (OpenAI)
  5. Animation avec voix (Hailuo/PiAPI)
  6. Upload R2 + Email confirmation
  7. Déduction 1 crédit
- **Output** : Vidéo MP4 HD
- **Coût** : 1 crédit

---

### 2. Génération de Vidéos Faceless

#### Vidéo Courte (< 1 minute)
- **Input** :
  - URL vidéo source (YouTube/TikTok) OU upload fichier
  - Sélection de l'avatar à utiliser
  - Choix formation à promouvoir (DSA/ASA/Code Liberté)
- **Process** :
  1. Téléchargement vidéo source
  2. Extraction audio → Transcription (Whisper)
  3. Analyse frames clés (Vision IA)
  4. Génération nouveau script avec pitch formation
  5. Génération TTS (voix IA)
  6. Génération vidéo avec avatar (Hailuo/PiAPI)
  7. Upload preview + HD sur R2
  8. Email avec lien de téléchargement
  9. Déduction 1 crédit
- **Output** : Vidéo MP4 50-60s
- **Coût** : 1 crédit

#### Vidéo Longue (1-2 minutes)
- Même process + extension intelligente
- **Coût** : 2 crédits

---

### 3. Système de Crédits

**Modèle économique** : Abonnement mensuel avec crédits

| Plan | Prix/mois | Crédits/mois | Coût crédit extra |
|------|-----------|--------------|-------------------|
| Starter | 29€ | 10 | 3€ |
| Pro | 69€ | 30 | 2,50€ |
| Business | 159€ | 100 | 2€ |

**Réductions formations MRR** :
- DSA (997€) : -10€/mois
- ASA (497€) : -5€/mois  
- Code Liberté (350€) : -10€/mois

**Attribution crédits** :
- 30 crédits crédités le 1er de chaque mois (cron)
- Crédits non utilisés : perdues (pas de rollover)

---

### 4. Parrainage

- Chaque acheteur de formation reçoit un code parrainage unique
- Nouvel utilisateur → -5€ sur son 1er abonnement
- Parrain → Avantage à définir (crédits gratuits ?)

---

## 🏗️ ARCHITECTURE TECHNIQUE

### Frontend
- **Framework** : Next.js 14 (App Router)
- **Styling** : Tailwind CSS
- **UI Components** : Shadcn/ui ou équivalent
- **Auth** : JWT (stocké dans cookies)
- **Déploiement** : Vercel

### Backend (Workflows n8n)
- **Orchestration** : n8n Cloud (https://albbocco.app.n8n.cloud)
- **Webhooks** : Déclenchement des workflows
- **Logic** : Gestion crédits, génération, notifications

### Base de Données (Supabase)
**Tables principales** :
- `users` : id, email, nom, crédits_restants, plan_abonnement, date_renouvellement
- `avatars` : id, user_id, url_image, url_vidéo, est_gratuit, date_création
- `videos` : id, user_id, avatar_id, url_source, url_preview, url_hd, crédits_utilisés, statut
- `credits_transactions` : id, user_id, montant, type (achat/consommation/offert), description
- `formations_achats` : user_id, type_formation, date_achat, réduction_appliquée

### Stockage (Cloudflare R2)
- **Bucket avatars** : Photos originales + avatars générés
- **Bucket vidéos** : Vidéos faceless (preview + HD)
- **URLs signées** : Accès temporaire 7 jours

### APIs Externes
| Service | Usage | Coût estimé |
|---------|-------|-------------|
| **PiAPI (Hailuo)** | Génération vidéos | ~0,75€/vidéo |
| **FAL.ai** | Génération images | ~0,03€/image |
| **OpenAI** | Scripts, prompts | ~0,01€/appel |
| **Brevo** | Emails (300/jour gratuits) | 0€ |
| **Supabase** | Base données (free tier) | 0€ |
| **R2** | Stockage | ~0,015€/GB |

### Paiements (Mollie - à venir)
- Abonnements mensuels
- Achat crédits supplémentaires
- Webhook confirmation paiement

---

## 🎨 DESIGN SYSTEM SOUHAITÉ

### Identité Visuelle
- **Nom** : BOCCO.AI
- **Positionnement** : Premium mais accessible
- **Ton** : Professionnel, innovant, IA-forward

### Palette Couleurs
- **Primaire** : Violet/Indigo (innovation, IA)
- **Secondaire** : Cyan/Teal (technologie, fraîcheur)
- **Accent** : Orange/Ambré (CTA, énergie)
- **Fond** : Blanc/cassé avec touches de gradient subtil

### Style UI
- **Modern SaaS** : Épuré, beaucoup d'espace
- **Glassmorphism** : Cartes avec effet verre dépoli
- **Animations** : Micro-interactions fluides
- **Dark mode** : Optionnel mais apprécié

### Inspiration
- Lovable.dev
- Vercel.com
- Linear.app
- Descript.com

---

## 📄 PAGES REQUISES

### Landing Page
- Hero section avec démo vidéo
- Exemples d'avatars générés
- Grille de prix
- Témoignages (fictifs au début)
- FAQ
- CTA inscription

### Dashboard Utilisateur
- Solde crédits en temps réel
- Mes avatars (grille visuelle)
- Mes vidéos générées
- Bouton "Créer un avatar"
- Bouton "Créer une vidéo"

### Page Création Avatar
- Upload photo (drag & drop)
- Preview en temps réel
- Formulaire description (pour avatars payants)
- Indicateur de crédits nécessaires

### Page Création Vidéo
- Input URL ou upload fichier
- Sélecteur d'avatar
- Choix formation à promouvoir
- Preview vidéo source
- Barre de progression génération

### Page Abonnement
- Comparaison des plans
- Formulaire paiement (Mollie)
- Application réductions formations

### Pages Auth
- Inscription
- Connexion
- Reset mot de passe

---

## 🔄 WORKFLOWS N8N DÉTAILLÉS

### WF-01 : Inscription + Avatar Gratuit
1. Webhook réception données
2. Création user Supabase
3. Upload photo R2
4. Appel FAL.ai (génération image)
5. Appel Hailuo (animation)
6. Upload vidéo R2
7. Save avatar Supabase
8. Email Brevo (bienvenue + lien vidéo)

### WF-02 : Création Avatar Payant
1. Vérification crédits >= 1
2. Génération prompt (OpenAI)
3. Génération image (FAL.ai)
4. Génération script (OpenAI)
5. Animation (Hailuo)
6. Save + Déduction crédit
7. Email confirmation

### WF-03 : Génération Vidéo
1. Vérification crédits
2. Download vidéo source
3. Transcription (Whisper)
4. Analyse visuelle
5. Script viral (Kimi/OpenAI)
6. TTS voix
7. Génération vidéo (Hailuo)
8. Upload preview + HD
9. Déduction crédits
10. Email avec liens

### WF-08 : Attribution Mensuelle (Cron)
1. Trigger 1er du mois
2. Liste users actifs
3. Reset crédits à 30
4. Email récap

---

## ⚠️ CONTRAINTES & EXIGENCES

### Sécurité
- JWT sécurisé (HS256)
- Validation webhooks (signature)
- Rate limiting API
- Pas de clés API en frontend

### Performance
- Images optimisées (WebP)
- Vidéos lazy loading
- PWA pour mobile
- Temps de chargement < 2s

### UX
- Feedback immédiat (toasts)
- Progress bars pour uploads
- Étapes de génération visibles
- Retry automatique si échec

---

## 📊 MÉTRIQUES CLÉS À TRACKER

- Taux de conversion (visiteur → inscription)
- Taux d'activation (inscription → avatar gratuit)
- Taux de conversion payant (avatar gratuit → achat crédits)
- Churn mensuel
- Coût API par utilisateur
- LTV (Lifetime Value)

---

## 🎯 OBJECTIFS COURT TERME

1. **MVP** : WF-01 fonctionnel (avatar gratuit)
2. **Beta** : WF-02 + WF-03 (paiements manuels)
3. **Launch** : Mollie intégré + abonnements auto
4. **Scale** : Parrainage + formations MRR

---

## 💡 DIFFÉRENCIATEURS CONCURRENTS

vs HeyGen vs Synthesia vs D-ID :
- **Prix** : 10x moins cher
- **Simplicité** : Pas d'appel vidéo, juste upload photo
- **Focus** : 100% marché francophone formations MRR

---

## 🚀 DÉPLOIEMENT

### ✅ Vercel (Frontend) - DÉJÀ CONFIGURÉ

**Projet existant** :
- **Project ID** : `prj_Xqts8fZ2mJA4mZ0mIb9lKzrTkHpo`
- **Project Name** : `bocco-ai`
- **URL** : https://bocco-ai.vercel.app
- **Config** : `vercel.json` avec routes API

**Déployer** :
```bash
cd bocco-ai
vercel --prod
```

**Variables d'environnement Vercel** :
```
# Base de données
NEXT_PUBLIC_SUPABASE_URL=https://xpnmjmsietrvzhumqprl.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbG...
SUPABASE_SERVICE_ROLE_KEY=eyJhbG...

# Auth
JWT_SECRET=E8q1WyBBMLaKzgTKaFJ...

# n8n
N8N_WEBHOOK_URL=https://albbocco.app.n8n.cloud/

# APIs IA
HAILUO_API_KEY=***
FAL_AI_KEY=***
OPENAI_API_KEY=***
MOONSHOT_API_KEY=***

# Stockage R2
R2_ACCESS_KEY_ID=***
R2_SECRET_ACCESS_KEY=***
R2_ENDPOINT_URL=***
R2_BUCKET_NAME=bocco-ai

# Email
BREVO_API_KEY=***
BREVO_FROM_EMAIL=noreply@bocco.ai
BREVO_FROM_NAME=bocco.ai
```

### n8n (Backend)
- **Cloud** : https://albbocco.app.n8n.cloud
- **API Key** : Configurée dans Hostinger
- **Webhooks** : Prêts à recevoir les appels

### Base de données
- **Supabase** : https://xpnmjmsietrvzhumqprl.supabase.co

### Stockage
- **R2** : Bucket `bocco-ai` configuré

---

Ce prompt couvre TOUS les aspects du projet. Utilise-le pour :
- Générer le code avec Claude/Lovable
- Créer les spécifications techniques
- Onboard un développeur
- Documenter l'architecture
