# 📊 RÉCAPITULATIF - Mise à jour des prix Bocco AI

**Date:** 2026-03-05  
**Status:** ✅ Terminé

---

## 🎯 Changements effectués

### Workflows mis à jour sur n8n

| Workflow | Changement | Status |
|----------|------------|--------|
| **WF-03** | 6 crédits → **1 crédit** | ✅ OK |
| **WF-04** | 10 crédits → **2 crédits** | ✅ OK |
| **WF-08** | 30 crédits fixes → **5/30/100 selon plan** | ✅ OK |
| **WF-09** | Plans base/dsa/asa → **starter/pro/business** | ✅ OK |
| **WF-07** | Prix fixes → **3€/2€/1.50€ selon plan** | ✅ OK |

---

## 💰 Nouvelle grille tarifaire

### Coûts en crédits

| Action | Avant | Après | Économie |
|--------|-------|-------|----------|
| Vidéo courte | 6 crédits | **1 crédit** | 83% |
| Vidéo longue | 10 crédits | **2 crédits** | 80% |
| Avatar | 1 crédit | **1 crédit** | — |

### Plans d'abonnement

| Plan | Prix | Crédits | Prix/crédit |
|------|------|---------|-------------|
| **Starter** | **9€/mois** (fixe, sans réduction) | 5 | 1,80€ |
| **Pro** | 49€/mois | 30 | 1,63€ |
| **Business** | 109€/mois | 100 | 1,09€ |

### Crédits extra

| Plan | Prix du crédit extra |
|------|---------------------|
| **Starter** | 3€ |
| **Pro** | 2€ |
| **Business** | 1,50€ |

---

## 🤖 APIs utilisées

| Service | Usage | Coût API |
|---------|-------|----------|
| **FAL.ai** (flux-pro) | Images avatars | ~0,03€ |
| **Hailuo/PiAPI** | Vidéos 6-10s | ~0,15-0,30€ |
| **OpenAI** (gpt-4o-mini) | Scripts/prompts | ~0,001€ |

---

## 📈 Impact business

### Avant (prix erronés)
- Vidéo courte : 6 crédits = 6× plus cher que nécessaire
- Risque de perte de clients à cause des prix trop élevés

### Après (prix corrigés)
- Vidéo courte : 1 crédit = compétitif
- Marge de 97% maintenue
- Aligné avec le code Vercel

---

## ✅ Prochaines étapes

1. **Configurer les credentials** dans n8n:
   - FAL_API_KEY → header `Authorization: Key $FAL_API_KEY`
   - HAILUO_API_KEY → header `X-API-Key: $HAILUO_API_KEY`

2. **Activer les workflows** (toggle ON)

3. **Tester** les webhooks avec les nouveaux prix

4. **Synchroniser** les prix avec le frontend Vercel

---

## 📁 Fichiers mis à jour

- `n8n-workflows-api-ready/WF-03-video-faceless-courte.json`
- `n8n-workflows-api-ready/WF-04-video-faceless-longue.json`
- `n8n-workflows-api-ready/WF-07-achat-credits-stripe.json`
- `n8n-workflows-api-ready/WF-08-attribution-mensuelle.json`
- `n8n-workflows-api-ready/WF-09-paiement-abonnement.json`
- `docs/architecture-complete.md`
- `MEMORY.md`

---

*Mise à jour effectuée automatiquement via l'API n8n*