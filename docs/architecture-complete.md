# 🏗️ Architecture n8n - bocco.ai

## 📋 Résumé du projet

**bocco.ai** — SaaS de création d'avatars IA + vidéos faceless pour vendeurs de formations MRR.

---

## 💳 Grille de prix (crédits) - MÀJ 2026-03-05

| Action | Crédits | Coût API estimé | Prix client |
|--------|---------|-----------------|-------------|
| Avatar (FAL.ai + Hailuo) | 1 | ~0,18€ | 1 crédit |
| Vidéo courte 6s (Hailuo) | 1 | ~0,15€ | 1 crédit |
| Vidéo longue 10s (Hailuo) | 2 | ~0,30€ | 2 crédits |

## 💰 Abonnements

| Plan | Prix/mois | Crédits inclus | Prix crédit extra |
|------|-----------|----------------|-------------------|
| **Starter** | 19€ | 5 crédits | 3€ |
| **Pro** | 49€ | 30 crédits | 2€ |
| **Business** | 109€ | 100 crédits | 1,50€ |

### Réductions formations
| Formation | Prix | Réduction/mois |
|-----------|------|----------------|
| DSA | 997€ | -10€ |
| ASA | 497€ | -5€ |
| Code Liberté | 350€ | -10€ |
| **Cumul max** | — | **-15€ max** |

---

## 🗄️ Structure Base de Données (Supabase/PostgreSQL)

### Table `users`
```sql
- id (uuid, PK)
- email (unique)
- password_hash
- first_name
- last_name
- created_at
- updated_at
- has_used_free_avatar (boolean)
- subscription_status (free/active/cancelled)
- subscription_plan (base/dsa/asa/code/annual)
- credits_remaining (int)
- credits_monthly (int) -- crédits attribués ce mois
- subscription_renews_at (timestamp)
- stripe_customer_id
- stripe_subscription_id
```

### Table `avatars`
```sql
- id (uuid, PK)
- user_id (FK)
- image_url (stockage R2)
- video_url (stockage R2)
- prompt_used (texte de description)
- is_free (boolean)
- created_at
- status (active/deleted)
```

### Table `credits_transactions`
```sql
- id (uuid, PK)
- user_id (FK)
- amount (int) -- positif = ajout, négatif = consommation
- type (free/monthly/purchase/refund/usage)
- description
- created_at
- related_video_id (FK, nullable)
```

### Table `videos`
```sql
- id (uuid, PK)
- user_id (FK)
- avatar_id (FK)
- source_url (URL source scrapée)
- source_type (youtube/tiktok/upload)
- format (short/long)
- transcription_text
- generated_script
- preview_url (stockage R2)
- final_url (stockage R2)
- status (processing/completed/failed)
- credits_used (int)
- created_at
- completed_at
```

### Table `formations_purchases`
```sql
- id (uuid, PK)
- user_id (FK)
- formation_type (dsa/asa/code_liberte)
- purchase_date
- transaction_id
- discount_applied (int) -- en euros
```

### Table `referral_discounts`
```sql
- id (uuid, PK)
- referrer_user_id (FK) -- celui qui a acheté la formation
- referred_user_id (FK) -- celui qui bénéficie de la réduc
- formation_type
- discount_amount
- is_used (boolean)
- created_at
```

---

## 🤖 Choix des APIs (low-cost, compatibles n8n)

### 🎭 Avatars (image + animation)
**API utilisées : FAL.ai + Hailuo/PiAPI**
- FAL.ai (flux-pro) : ~0,03€ / image
- Hailuo/PiAPI : ~0,15€ / vidéo 5-6s
- **Total : ~0,18€ par avatar**

### 🎬 Vidéos (génération)
**API utilisée : Hailuo/PiAPI**
- Prix : ~0,15€ / 6s (vidéo courte = 1 crédit)
- Prix : ~0,30€ / 10s (vidéo longue = 2 crédits)
- API REST via PiAPI
- Qualité professionnelle

### 🔊 Voix (TTS)
**Choix recommandé : Unreal Speech**
- Prix : ~0,001€ / caractère (1min = ~0,03€)
- Voix naturelles
- API simple

**Alternative : ElevenLabs Scalable**
- Prix : ~0,01€ / 1000 caractères
- Qualité supérieure mais + cher

### 📧 Emailing
**Brevo (ex-Sendinblue)**
- Gratuit : 300 emails/jour (9000/mois)
- Templates + API
- Webhook de livraison

### 💳 Paiement
**Stripe**
- Checkout hébergé
- Webhooks pour events
- Gestion abonnements

### ☁️ Stockage
**Cloudflare R2**
- Prix : ~0,015€/GB/mois
- 0€ de sortie (bande passante)
- API S3-compatible

---

## 🔄 Workflows n8n (liste complète)

### WF-01 : Inscription + Avatar Gratuit
**Déclencheur** : Webhook depuis Webflow (nouvel utilisateur)

```
1. Recevoir données (email, nom, prénom, photo)
2. Créer user en BDD
3. Envoyer email de bienvenue (Brevo)
4. Uploader photo sur R2
5. Appeler Hedra pour créer avatar image
6. Appeler Hedra pour animer (phrase : "Bonjour, je suis votre avatar !")
7. Uploader vidéo sur R2
8. Sauvegarder avatar en BDD
9. Envoyer email avec lien vidéo
10. Marquer has_used_free_avatar = true
```

### WF-02 : Création Avatar Payant
**Déclencheur** : Webhook (formulaire avec description IA)

```
1. Vérifier crédits user >= 1
2. Générer prompt optimisé via LLM (Kimi/Claude)
3. Appeler Hedra pour image
4. Générer phrase de présentation via LLM
5. Appeler Hedra pour animation
6. Uploader sur R2
7. Sauvegarder avatar
8. Déduire 1 crédit
9. Envoyer confirmation email
```

### WF-03 : Création Vidéo Faceless (COURT)
**Déclencheur** : Webhook (URL/upload + choix avatar)

```
1. Vérifier crédits user >= 1
2. Télécharger vidéo source (yt-dlp ou upload R2)
3. Vérifier durée > 1min
   - Si oui : crop à 50-60s via FFmpeg
   - Si non : garder toute la vidéo
4. Extraire audio → Whisper API (transcription)
5. Extraire frames clés → GPT-4o Vision (description visuelle)
6. Générer nouveau script via LLM :
   - Reprendre structure
   - Ajouter pitch formation choisie
   - Adapter timing (~50-60s)
7. Générer TTS avec voix prédéfinie
8. Générer vidéo avec Kling AI :
   - Input : avatar user + script + TTS
   - Output : vidéo 50-60s
9. Générer preview basse qualité (compression)
10. Uploader preview + HD sur R2
11. Sauvegarder en BDD
12. Déduire 1 crédit
13. Envoyer email avec lien preview + téléchargement HD
```

### WF-04 : Création Vidéo Faceless (LONG)
**Déclencheur** : Webhook (URL/upload + choix avatar)

```
1. Vérifier crédits user >= 2
2. Télécharger vidéo source
3. Vérifier durée < 1min
   - Si oui : extend via slow-motion + loop intelligente (FFmpeg)
   - Si non : garder toute la vidéo
4-13. Mêmes étapes que WF-03
14. Générer vidéo 90-120s avec Kling
15. Déduire 2 crédits
```

### WF-05 : Gestion Crédits (Consommation)
**Déclencheur** : Appel interne depuis autres workflows

```
1. Recevoir user_id + amount + description
2. Vérifier crédits suffisants
3. Si oui : déduire, créer transaction, return success
4. Si non : return error (crédits insuffisants)
```

### WF-06 : Gestion Crédits (Remboursement)
**Déclencheur** : Webhook (échec workflow vidéo après 3 retries)

```
1. Identifier la vidéo failed
2. Rembourser crédits (créditer + créer transaction type refund)
3. Envoyer email à user : "Votre vidéo a échoué, crédits remboursés"
4. Notifier admin
```

### WF-07 : Achat Crédits Supplémentaires
**Déclencheur** : Webhook Stripe (payment succeeded)

```
1. Vérifier type achat = credits_pack
2. Identifier user (via metadata Stripe)
3. Ajouter crédits (ex: 10€ = 10 crédits)
4. Créer transaction type purchase
5. Envoyer confirmation email
```

### WF-08 : Attribution Mensuelle Crédits
**Déclencheur** : Cron (1er de chaque mois à 00:01)

```
1. Lister users avec subscription_status = active
2. Pour chaque user :
   - Réinitialiser credits_remaining à 30
   - Mettre à jour credits_monthly
   - Créer transaction type monthly
```

### WF-09 : Paiement Abonnement + Attribution
**Déclencheur** : Webhook Stripe (checkout.completed)

```
1. Vérifier produit = abonnement
2. Créer/mettre à jour subscription en BDD
3. Attribuer 30 crédits immédiatement
4. Appliquer réductions si formations achetées
5. Envoyer email de confirmation
```

### WF-10 : Réduction Année (Stripe)
**Déclencheur** : Webhook Stripe (payment pour annual)

```
1. Vérifier type = annual
2. Appliquer -5€/mois sur le prix
3. Créer transaction avec discount_applied
```

### WF-11 : Achat Formation MRR
**Déclencheur** : Webflow (bouton achat formation)

```
1. Rediriger vers Stripe checkout avec le bon prix
2. Sur paiement réussi :
   - Créer formation_purchase
   - Appliquer réduction abonnement
   - Générer code parrainage unique
   - Envoyer email avec lien parrainage
```

### WF-12 : Système Parrainage (Cascade)
**Déclencheur** : Webflow (inscription avec code parrain)

```
1. Vérifier code parrainage existe
2. Identifier referrer (celui qui a donné le code)
3. Identifier discount associé (DSA/ASA/Code)
4. Appliquer réduction à referred (nouvel user)
5. Créer referral_discounts entry
6. Marquer is_used = true
7. Envoyer email aux deux parties
```

### WF-13 : Retry Auto + Fallback
**Déclencheur** : Webhook d'erreur depuis autres workflows

```
1. Compter nb tentatives (stocké en BDD)
2. Si < 3 : requeue job avec delay (5min, 15min, 30min)
3. Si >= 3 : appeler WF-06 (remboursement)
```

### WF-14 : Alertes Crédits Faibles
**Déclencheur** : Cron (toutes les heures)

```
1. Lister users avec credits_remaining <= 5
2. Vérifier pas déjà alerté dans les 24h
3. Envoyer email : "Il vous reste X crédits"
4. Proposer lien achat crédits supplémentaires
```

---

## 📅 Plan de Priorisation (Quoi faire en premier)

### Phase 1 — MVP (Semaines 1-2)
1. ✅ Setup n8n + BDD Supabase
2. ✅ WF-01 : Inscription + avatar gratuit
3. ✅ WF-02 : Création avatar payant
4. ✅ Intégration Stripe (basique)
5. ✅ Frontend Webflow (landing + dashboard simple)

### Phase 2 — Vidéos (Semaines 3-4)
6. ✅ WF-03 : Vidéo courte
7. ✅ WF-05 : Gestion crédits
8. ✅ WF-08 : Attribution mensuelle
9. ✅ Setup stockage R2
10. ✅ Intégration Brevo

### Phase 3 — Polish (Semaine 5)
11. ✅ WF-04 : Vidéo longue
12. ✅ WF-06 : Remboursement auto
13. ✅ WF-13 : Retry system
14. ✅ WF-14 : Alertes crédits

### Phase 4 — Formations (Semaine 6)
15. ✅ WF-09 : Paiement abonnement complet
16. ✅ WF-11 : Achat formations
17. ✅ WF-12 : Parrainage
18. ✅ Page formations MRR

---

## 💰 Estimation coûts mensuels (à 100 users actifs)

| Poste | Coût estimé |
|-------|-------------|
| n8n Cloud (auto-hébergé sur ton VPS) | 0€ (déjà payé) |
| Supabase (free tier) | 0€ |
| Cloudflare R2 (500GB stockage) | ~7,50€ |
| FAL.ai (300 avatars/mois) | ~9€ |
| Hailuo/PiAPI (500 vidéos/mois) | ~75€ |
| OpenAI (gpt-4o-mini) | ~5€ |
| Brevo (300/jour gratuit) | 0€ |
| Stripe (2,9% + 0,25€ par transaction) | Variable |
| **TOTAL** | **~97€/mois** |

**Revenu estimé (100 users)** :
- 60 users Starter @ 19€ = 1 140€
- 30 users Pro @ 49€ = 1 470€  
- 10 users Business @ 109€ = 1 090€
- **Total : ~3 700€/mois**

**Marge** : ~3 600€/mois (97%)

---

## 🎯 Prochaines étapes immédiates

1. **Acheter domaine** bocco.ai sur Cloudflare
2. **Créer compte** Supabase (projet gratuit)
3. **Créer compte** Stripe (mode test d'abord)
4. **Créer compte** Brevo
5. **Demander accès API** Hedra, Kling AI
6. **Setup Webflow** + template SaaS
7. **Setup Wized** pour la logique
8. **Me donner accès** aux comptes pour configuration

---

*Document créé le 19/02/2026 pour le projet bocco.ai*
