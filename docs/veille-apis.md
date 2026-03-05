# 📊 Veille APIs Économiques pour bocco.ai
## Production Avatars et Vidéos

*Rapport de veille - Février 2026*

---

## 🎯 Résumé Exécutif

Cette veille analyse les APIs les plus économiques pour la production d'avatars et de vidéos chez bocco.ai. L'objectif est de réduire les coûts tout en maintenant une qualité acceptable et une disponibilité européenne.

### Coûts Actuels vs Cibles
| Fonction | Solution Actuelle | Coût Actuel | Coût Cible | Potentiel d'économie |
|----------|-------------------|-------------|------------|---------------------|
| Génération Avatars | Hypereal AI | 0,001$/image + 0,02$/sec | < 0,50€/avatar | ⚠️ À vérifier |
| Génération Vidéos | Haiper AI + Kling | 8$/mois + ~0,60€/10sec | < 1€/min | 🔴 Possible |
| Text-to-Speech | Unreal Speech | ~0,001€/caractère | < 0,50€/vidéo 2min | 🟢 Atteint |
| Lip-Sync | Sync Labs | 0,05$/sec | < 0,50€/vidéo | 🔴 Possible |
| Stockage | Cloudflare R2 | 0,015€/GB | < 0,10€/vidéo | 🟢 Atteint |

---

## 1. 🎨 GÉNÉRATION AVATARS (Image + Animation)

### Comparatif Solutions

| Solution | Prix | Qualité | Vitesse | Fiabilité | Recommandation |
|----------|------|---------|---------|-----------|----------------|
| **FAL.ai (Flux)** | 0,025$/image (1 megapixel) | ⭐⭐⭐⭐⭐ Excellente | ~2-5 sec | ⭐⭐⭐⭐⭐ Très haute | 🟢 **RECOMMANDÉ** |
| **Replicate** | 0,022-0,04$/image | ⭐⭐⭐⭐⭐ Excellente | Variable | ⭐⭐⭐⭐⭐ Très haute | 🟢 Alternative |
| **SeaArt.ai** | 0,04$/image (Seedream 4.5) | ⭐⭐⭐⭐ Très bonne | ~5 sec | ⭐⭐⭐⭐ Bonne | 🟢 Bon rapport |
| **DreamStudio (SD 3.5)** | 0,035-0,065$/image | ⭐⭐⭐⭐ Très bonne | ~3-8 sec | ⭐⭐⭐⭐⭐ Très haute | 🟢 Stable |
| **Leonardo.ai** | 9$/mois (3 500 crédits) | ⭐⭐⭐⭐ Très bonne | ~5-10 sec | ⭐⭐⭐⭐ Bonne | 🟡 Abonnement |
| **PicSo** | 9,99$/mois (100 crédits) | ⭐⭐⭐⭐ Bonne | ~5 sec | ⭐⭐⭐⭐ Bonne | 🟡 Limité |
| **Neuroflash** | 42€/mois (100 img/jour) | ⭐⭐⭐⭐ Très bonne | ~5 sec | ⭐⭐⭐⭐ Bonne | 🔴 Cher |

### Analyse Détaillée

#### 🥇 FAL.ai (Flux 2)
- **Prix** : 0,025$ par image (ou par mégapixel)
- **Avantages** : 
  - Pas d'abonnement, pay-as-you-go
  - Qualité Flux 2 exceptionnelle
  - Cold start rapide (~5-10s)
  - API bien documentée
- **Inconvénients** : Coût à la hausse pour haute résolution
- **Coût pour avatar complet** : ~0,025-0,05$ (image haute qualité)
- **Documentation** : https://docs.fal.ai/

#### 🥈 Replicate
- **Prix** : ~0,022$/image (Recraft-20b) à 0,04$/image
- **Avantages** :
  - Large choix de modèles
  - Tarification transparente
  - API S3-compatible
- **Inconvénients** : Prix variable selon modèle/GPU
- **Coût pour avatar complet** : ~0,02-0,05$
- **Documentation** : https://replicate.com/docs

#### 🥉 SeaArt.ai
- **Prix** : 0,04$/image (même prix 2K ou 4K)
- **Avantages** :
  - Prix fixe quelle que soit la résolution
  - Modèle Seedream 4.5 performant
  - Accepte les comptes européens
- **Inconvénients** : Moins connu, moins de documentation
- **Coût pour avatar complet** : ~0,04$
- **Documentation** : https://www.seaart.ai/docs

#### Autres options

**DreamStudio (Stable Diffusion)**
- Prix : 0,035$ (SD 3.5 Medium) à 0,065$ (SD 3.5 Large)
- Avantage : Modèles open-source, communauté active
- Documentation : https://platform.stability.ai/

**Leonardo.ai**
- Prix : 9$/mois pour 3 500 crédits (~0,0026$/image théorique)
- Inconvénient : Abonnement obligatoire, pas de pure API
- Documentation : https://docs.leonardo.ai/

### 💡 Recommandation Avatars

**Option 1 (Économique)** : FAL.ai ou Replicate en pay-as-you-go
- Coût : ~0,025-0,03$/avatar
- Idéal pour volumes faibles à moyens

**Option 2 (Volume)** : SeaArt.ai
- Coût : 0,04$/image (résolution illimitée)
- Idéal si besoin 4K constant

**Option 3 (Mensuel)** : Leonardo.ai si volume > 1000 images/mois
- Coût effectif : ~0,0026$/image
- Inconvénient : engagement mensuel

---

## 2. 🎬 GÉNÉRATION VIDÉOS (Avatar parlant)

### Comparatif Solutions

| Solution | Prix | Qualité | Vitesse | Fiabilité | Recommandation |
|----------|------|---------|---------|-----------|----------------|
| **Runway Gen-4 Turbo** | 0,05$/sec (5 credits) | ⭐⭐⭐⭐⭐ Excellente | ~30 sec | ⭐⭐⭐⭐⭐ Très haute | 🟢 **RECOMMANDÉ** |
| **Luma Dream Machine** | 0,20$/vidéo (PAYG) | ⭐⭐⭐⭐ Très bonne | ~1-2 min | ⭐⭐⭐⭐ Bonne | 🟢 Prix fixe |
| **Haiper AI API** | 0,033-0,05$/sec | ⭐⭐⭐⭐ Très bonne | ~2-3 min | ⭐⭐⭐⭐ Bonne | 🟢 Bon rapport |
| **Kling AI (third-party)** | 0,125-0,25$/5sec | ⭐⭐⭐⭐⭐ Excellente | ~1-2 min | ⭐⭐⭐⭐⭐ Très haute | 🟡 Via tiers |
| **Hailuo Minimax** | 0,23-0,45$/vidéo | ⭐⭐⭐⭐ Très bonne | ~1-2 min | ⭐⭐⭐⭐ Bonne | 🟢 Économique |
| **Vidu** | 0,28$/vidéo (720p/8s) | ⭐⭐⭐⭐ Très bonne | ~1 min | ⭐⭐⭐⭐ Bonne | 🟢 Bon rapport |
| **Pika Labs (via FAL)** | Variable crédits | ⭐⭐⭐⭐ Très bonne | ~2-3 min | ⭐⭐⭐⭐ Bonne | 🟡 Pas d'API directe |

### Analyse Détaillée

#### 🥇 Runway Gen-4 Turbo
- **Prix** : 0,05$/seconde (5 crédits à 0,01$/crédit)
- **Avantages** :
  - Qualité professionnelle 1080p
  - Génération rapide (~30 sec pour 5s)
  - API mature et bien documentée
  - Accepte comptes européens
- **Inconvénients** : Plus cher que certains concurrents
- **Coût pour 1 min 1080p** : ~3$
- **Documentation** : https://docs.dev.runwayml.com/

#### 🥈 Haiper AI API
- **Prix** : 0,033$/sec (540p) - 0,05$/sec (720p)
- **Avantages** :
  - Prix compétitif
  - Text-to-video et Image-to-video
  - Upscale 1080p disponible
- **Inconvénients** : 720p max native (upscale pour 1080p)
- **Coût pour 1 min 720p** : ~3$
- **Documentation** : https://docs.haiper.ai/

#### 🥉 Luma Dream Machine
- **Prix** : 0,20$/vidéo (PAYG) ou 19$/mois (1000 crédits)
- **Avantages** :
  - Prix fixe par génération
  - Bonne qualité générale
  - API simple
- **Inconvénients** : Durée limitée (5s typiquement)
- **Coût pour 1 min** : ~2,40$ (12 générations de 5s)
- **Documentation** : https://lumalabs.ai/dream-machine/api

#### Options Third-Party Économiques

**Kling AI (via Kie.ai / Runware)**
- Prix : 0,125-0,25$/5 secondes (selon qualité)
- Via fournisseurs tiers car API officielle chère (~1$/10sec)
- Avantage : Qualité exceptionnelle Kling 2.1/3.0
- Coût 1 min 1080p : ~1,50-3$

**Hailuo Minimax (via PiAPI)**
- Prix : 0,23$/vidéo (6s/768p) à 0,45$/vidéo (10s/768p)
- Avantage : Très économique
- Coût 1 min 1080p : ~2,30-4,50$

**Vidu (via Together AI)**
- Prix : 0,28$/vidéo (8s/720p)
- Avantage : Prix fixe, génération rapide
- Coût 1 min 720p : ~2,10$

### 💡 Recommandation Vidéos

**Option 1 (Meilleur rapport qualité/prix)** : Hailuo Minimax via PiAPI
- Coût : ~0,23-0,45$/vidéo 6-10s
- Qualité excellente pour le prix

**Option 2 (Qualité premium)** : Runway Gen-4 Turbo
- Coût : 0,05$/sec (~3$/min)
- Référence qualité professionnelle

**Option 3 (Prix fixe)** : Luma Dream Machine PAYG
- Coût : 0,20$/génération
- Bon pour tests et prototypes

---

## 3. 🔊 TEXT-TO-SPEECH (Voix off)

### Comparatif Solutions

| Solution | Prix | Qualité | Vitesse | Fiabilité | Recommandation |
|----------|------|---------|---------|-----------|----------------|
| **Unreal Speech** | 16$/1M caractères (Basic) | ⭐⭐⭐⭐ Très bonne | <100ms | ⭐⭐⭐⭐⭐ Très haute | 🟢 **RECOMMANDÉ** |
| **Google Cloud TTS** | 4$/1M (Standard) - 16$/1M (WaveNet) | ⭐⭐⭐⭐⭐ Excellente | <200ms | ⭐⭐⭐⭐⭐ Très haute | 🟢 Alternative |
| **Amazon Polly** | 4$/1M caractères (Standard) | ⭐⭐⭐⭐ Très bonne | <200ms | ⭐⭐⭐⭐⭐ Très haute | 🟢 Alternative |
| **ElevenLabs** | 12-30$/1M caractères | ⭐⭐⭐⭐⭐ Excellente | <100ms | ⭐⭐⭐⭐⭐ Très haute | 🟡 Plus cher |
| **Azure TTS** | ~15$/1M (Standard) | ⭐⭐⭐⭐ Très bonne | <200ms | ⭐⭐⭐⭐⭐ Très haute | 🟢 Intégration MS |
| **Murf.ai** | 30$/1M caractères | ⭐⭐⭐⭐ Très bonne | <200ms | ⭐⭐⭐⭐ Bonne | 🟡 API payante |
| **Play.ht** | ~120$/1M caractères | ⭐⭐⭐⭐⭐ Excellente | <200ms | ⭐⭐⭐⭐ Bonne | 🔴 Très cher |

### Analyse Détaillée

#### 🥇 Unreal Speech (Solution Actuelle)
- **Prix** : 16$/1M caractères (Basic), 12-8$/1M (volumes)
- **Avantages** :
  - Free tier : 250 000 caractères/mois
  - Jusqu'à 11x moins cher qu'ElevenLabs
  - Voix naturelle, français supporté
  - API rapide et fiable
- **Coût vidéo 2 min** : ~0,12$ (1500 caractères)
- **Documentation** : https://unrealspeech.com/

#### 🥈 Google Cloud TTS
- **Prix** : 4$/1M (Standard), 16$/1M (WaveNet/Neural2)
- **Avantages** :
  - Free tier : 4M caractères/mois (Standard)
  - WaveNet excellent pour français
  - Intégration GCP complète
- **Coût vidéo 2 min** : ~0,024$ (Standard) / ~0,096$ (WaveNet)
- **Documentation** : https://cloud.google.com/text-to-speech

#### 🥉 Amazon Polly
- **Prix** : 4$/1M caractères (Standard)
- **Avantages** :
  - Free tier 1 an : 5M caractères/mois
  - Voix Neural de qualité
  - Intégration AWS
- **Coût vidéo 2 min** : ~0,024$
- **Documentation** : https://aws.amazon.com/polly/

#### ElevenLabs (Référence qualité)
- Prix : 12-30$/1M caractères selon modèle
- Avantage : Meilleure qualité du marché
- Inconvénient : 3-7x plus cher qu'Unreal Speech
- Documentation : https://elevenlabs.io/

### 💡 Recommandation TTS

**Option 1 (Actuelle - Excellente)** : Unreal Speech
- Coût : ~16$/1M caractères
- Déjà en place, coûts optimaux

**Option 2 (Alternative GCP)** : Google Cloud TTS Standard
- Coût : 4$/1M caractères (4x moins cher)
- Free tier généreux (4M/mois)
- Qualité Standard acceptable pour bocco.ai

**Option 3 (Qualité premium)** : ElevenLabs Flash
- Coût : 12$/1M caractères
- Si qualité voix critique

---

## 4. 👄 LIP-SYNC (Synchronisation lèvres)

### Comparatif Solutions

| Solution | Prix | Qualité | Vitesse | Fiabilité | Recommandation |
|----------|------|---------|---------|-----------|----------------|
| **Wav2Lip (Open Source)** | Gratuit (hébergement) | ⭐⭐⭐⭐ Bonne | Variable | ⭐⭐⭐⭐ Bonne | 🟢 **RECOMMANDÉ** économique |
| **Sync Labs** | 0,05-0,083$/sec | ⭐⭐⭐⭐⭐ Excellente | ~30 sec | ⭐⭐⭐⭐⭐ Très haute | 🟡 Solution actuelle |
| **VEED API** | 0,40$/min (0,0067$/sec) | ⭐⭐⭐⭐ Très bonne | ~1 min | ⭐⭐⭐⭐ Bonne | 🟢 Moins cher |
| **D-ID** | 4,7-14,4$/mois + limites | ⭐⭐⭐⭐⭐ Excellente | ~30 sec | ⭐⭐⭐⭐⭐ Très haute | 🟡 All-in-one |
| **HeyGen** | 99$/mois (100 min) | ⭐⭐⭐⭐⭐ Excellente | ~30 sec | ⭐⭐⭐⭐⭐ Très haute | 🔴 Très cher |

### Analyse Détaillée

#### 🥇 Wav2Lip (Open Source)
- **Prix** : Gratuit (coût GPU uniquement)
- **Avantages** :
  - 100% gratuit (open source)
  - Déployable sur RunPod/AWS (~0,016$/inférence)
  - Qualité correcte pour la plupart des cas
  - Pas de limitation d'usage
- **Inconvénients** : Nécessite infrastructure technique
- **Coût pour 1 min** : ~0,10-0,50$ (selon hébergement)
- **Documentation** : https://github.com/Rudrabha/Wav2Lip

#### 🥈 VEED API
- **Prix** : 0,40$/minute de vidéo (0,0067$/sec)
- **Avantages** :
  - Moins cher que Sync Labs
  - API simple
  - Pas d'abonnement obligatoire
- **Inconvénients** : Qualité légèrement inférieure à Sync Labs
- **Coût pour 1 min** : 0,40$
- **Documentation** : https://www.veed.io/tools/lip-sync-api

#### 🥉 Sync Labs (Solution Actuelle)
- **Prix** : 0,05-0,083$/sec selon modèle
- **Avantages** :
  - Qualité professionnelle
  - Modèle lipsync-2-pro très performant
  - API mature
- **Inconvénients** : 
  - 3-5x plus cher que VEED
  - Abonnement 5-249$/mois
- **Coût pour 1 min** : 3-5$
- **Documentation** : https://docs.sync.so/

#### D-ID (All-in-One)
- Prix : 4,7-14,4$/mois + minutes limitées
- Avantage : Avatar + Lip-sync intégrés
- Inconvénient : Moins flexible, abonnement

### 💡 Recommandation Lip-Sync

**Option 1 (Ultra-économique)** : Wav2Lip auto-hébergé sur RunPod
- Coût : ~0,10-0,30$/min
- Nécessite compétences DevOps

**Option 2 (Meilleur rapport)** : VEED API
- Coût : 0,40$/min
- 10x moins cher que Sync Labs
- Qualité suffisante pour bocco.ai

**Option 3 (Actuelle)** : Sync Labs si qualité critique
- Coût : 3-5$/min
- Garder pour cas exigeants uniquement

---

## 5. 💾 STOCKAGE VIDÉOS (Hébergement)

### Comparatif Solutions

| Solution | Prix Stockage | Prix Bande Passante | API | Recommandation |
|----------|---------------|---------------------|-----|----------------|
| **Cloudflare R2** | 0,015$/GB | Gratuit | S3-compatible | 🟢 **RECOMMANDÉ** |
| **Backblaze B2** | 0,006$/GB | Gratuit (3x stockage) | S3-compatible | 🟢 Moins cher |
| **Wasabi** | 0,0068$/GB (6,99$/TB) | Gratuit | S3-compatible | 🟢 Simplicité |
| **Bunny.net** | 0,01$/GB | 0,01-0,005$/GB (CDN) | Incluse | 🟢 CDN rapide |
| **AWS S3** | 0,023$/GB | 0,09$/GB | Native | 🔴 Trop cher |

### Analyse Détaillée

#### 🥇 Cloudflare R2 (Solution Actuelle)
- **Stockage** : 0,015$/GB
- **Egress** : Gratuit
- **API** : S3-compatible
- **Avantages** :
  - Egress gratuit (énorme avantage)
  - Intégration Cloudflare
  - Free tier : 10 GB + 1M requêtes
  - Accepte comptes européens
- **Coût 100 GB/mois** : 1,50$ stockage uniquement
- **Documentation** : https://developers.cloudflare.com/r2/

#### 🥈 Backblaze B2
- **Stockage** : 0,006$/GB
- **Egress** : Gratuit (3x stockage)
- **API** : S3-compatible
- **Avantages** :
  - 2,5x moins cher que R2
  - Egress gratuit jusqu'à 3x le stockage
  - Intégration Cloudflare CDN possible
- **Inconvénients** : Limite egress (rarement atteinte)
- **Coût 100 GB/mois** : 0,60$ stockage
- **Documentation** : https://www.backblaze.com/b2/docs/

#### 🥉 Wasabi
- **Stockage** : 0,0068$/GB (6,99$/TB)
- **Egress** : Gratuit (conditions)
- **API** : S3-compatible
- **Avantages** :
  - Pas de frais d'API
  - Pas de frais de sortie
  - Simplicité de facturation
- **Inconvénients** : Durée minimale 90 jours
- **Coût 100 GB/mois** : 0,68$
- **Documentation** : https://wasabi.com/cloud-storage-pricing/

#### Bunny.net
- Prix stockage : 0,01$/GB
- Prix CDN : 0,01-0,005$/GB selon volume
- Avantage : CDN ultra-rapide mondial
- Coût 100 GB stockage + 1 TB egress : ~15$

### 💡 Recommandation Stockage

**Option 1 (Actuelle - Excellente)** : Cloudflare R2
- Pas de changement nécessaire
- Egress gratuit = coûts prévisibles

**Option 2 (Économique)** : Backblaze B2 + Cloudflare CDN
- Coût stockage : 2,5x moins cher
- Egress via Cloudflare = gratuit
- Migration simple (S3-compatible)

---

## 📊 TABLEAU COMPARATIF FINAL - Top 3 par Catégorie

### Génération Avatars
| Rang | Solution | Coût/Avatar | Avantage Principal |
|------|----------|-------------|-------------------|
| 🥇 | FAL.ai | ~0,025$ | Meilleur rapport qualité/prix |
| 🥈 | SeaArt.ai | ~0,04$ | Prix fixe 4K inclus |
| 🥉 | Replicate | ~0,022-0,04$ | Large choix modèles |

### Génération Vidéos
| Rang | Solution | Coût/Minute | Avantage Principal |
|------|----------|-------------|-------------------|
| 🥇 | Hailuo Minimax | ~2,30-4,50$ | Prix le plus bas |
| 🥈 | Runway Gen-4 | ~3$ | Qualité référence |
| 🥉 | Haiper AI | ~3$ | Bonne qualité/prix |

### Text-to-Speech
| Rang | Solution | Coût/1M caractères | Avantage Principal |
|------|----------|-------------------|-------------------|
| 🥇 | Unreal Speech | 16$ | Déjà en place, fiable |
| 🥈 | Google Cloud | 4$ | 4x moins cher, free tier |
| 🥉 | Amazon Polly | 4$ | Alternative AWS |

### Lip-Sync
| Rang | Solution | Coût/Minute | Avantage Principal |
|------|----------|-------------|-------------------|
| 🥇 | VEED API | 0,40$ | 10x moins cher que Sync |
| 🥈 | Wav2Lip (self-host) | ~0,10-0,30$ | Gratuit si infra existante |
| 🥉 | Sync Labs | 3-5$ | Qualité actuelle |

### Stockage
| Rang | Solution | Coût/100GB/mois | Avantage Principal |
|------|----------|-----------------|-------------------|
| 🥇 | Backblaze B2 | 0,60$ | Prix le plus bas |
| 🥈 | Wasabi | 0,68$ | Simplicité |
| 🥉 | Cloudflare R2 | 1,50$ | Egress gratuit, déjà en place |

---

## 🎯 RECOMMANDATION FINALE POUR BOCCO.AI

### Configuration Optimale (Coût Minimum)

| Fonction | Solution Recommandée | Coût Estimé |
|----------|---------------------|-------------|
| **Avatars** | FAL.ai (Flux) | 0,025$ / avatar |
| **Vidéos** | Hailuo Minimax (via PiAPI) | ~2,50$ / min |
| **TTS** | Google Cloud TTS Standard | 4$ / 1M car. (~0,024$ / min) |
| **Lip-Sync** | VEED API | 0,40$ / min |
| **Stockage** | Cloudflare R2 (garder) | 0,015$ / GB |

### Coût Total Estimé par Vidéo (1 minute)

| Étape | Solution | Coût |
|-------|----------|------|
| Avatar (image) | FAL.ai | 0,025$ |
| Vidéo (avatar parlant) | Hailuo Minimax | 0,38$ (10s) |
| TTS (1500 caractères) | Google Cloud | 0,006$ |
| Lip-Sync | VEED API | 0,40$ |
| Stockage (100MB) | Cloudflare R2 | 0,0015$ |
| **TOTAL** | | **~0,81$ / vidéo 10s** |

Pour une vidéo complète de 1 minute : **~2,50-3,50$**

### Configuration Actuelle vs Optimisée

| Configuration | Coût/min | Économie |
|---------------|----------|----------|
| **Actuelle** (Hypereal + Haiper + Unreal + Sync + R2) | ~5-7$ | - |
| **Optimisée** (FAL + Hailuo + Google + VEED + R2) | ~2,50-3$ | **~50%** |

### 🔑 Points Clés

1. **Garder** : Unreal Speech (TTS) et Cloudflare R2 (stockage) - déjà optimaux
2. **Changer** : 
   - Remplacer Sync Labs par VEED API pour le lip-sync (**économie 90%**)
   - Évaluer Hailuo Minimax vs solutions actuelles pour vidéos
3. **Tester** : Google Cloud TTS comme alternative à Unreel Speech (4x moins cher)
4. **Monitorer** : FAL.ai pour avatars si Hypereal devient trop cher

### ⚠️ Considérations Importantess

- **Comptes Européens** : Toutes les solutions recommandées acceptent les comptes UE
- **Usage Commercial** : Vérifier les CGV pour chaque service avant production
- **Disponibilité** : Pas de beta fermée pour les solutions recommandées
- **Migration** : Planifier une phase de test A/B avant bascule complète

---

## 📚 LIENS DOCUMENTATION API

### Génération d'Images
- FAL.ai : https://docs.fal.ai/
- Replicate : https://replicate.com/docs
- SeaArt.ai : https://www.seaart.ai/docs
- DreamStudio : https://platform.stability.ai/docs
- Leonardo.ai : https://docs.leonardo.ai/

### Génération de Vidéos
- Runway : https://docs.dev.runwayml.com/
- Haiper AI : https://docs.haiper.ai/
- Luma Dream Machine : https://lumalabs.ai/dream-machine/api
- Hailuo Minimax : https://platform.minimax.io/docs
- Vidu : https://platform.vidu.com/docs/api-reference

### Text-to-Speech
- Unreal Speech : https://docs.unrealspeech.com/
- Google Cloud TTS : https://cloud.google.com/text-to-speech/docs
- Amazon Polly : https://docs.aws.amazon.com/polly/
- ElevenLabs : https://elevenlabs.io/docs

### Lip-Sync
- VEED API : https://www.veed.io/tools/lip-sync-api
- Sync Labs : https://docs.sync.so/
- Wav2Lip : https://github.com/Rudrabha/Wav2Lip

### Stockage
- Cloudflare R2 : https://developers.cloudflare.com/r2/
- Backblaze B2 : https://www.backblaze.com/b2/docs/
- Wasabi : https://docs.wasabi.com/

---

*Rapport généré le 23 février 2026*
*Pour bocco.ai - Veille APIs économiques*
