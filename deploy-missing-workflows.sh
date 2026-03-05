#!/bin/bash

N8N_API_KEY="$N8N_API_KEY"
BASE_URL="https://albbocco.app.n8n.cloud/api/v1"

echo "🧹 NETTOYAGE + DÉPLOIEMENT COMPLET"
echo "=================================="
echo ""

# Supprimer les doublons (WF-03 et WF-04)
echo "🗑️ Suppression des doublons..."
curl -s -X DELETE "$BASE_URL/workflows/xieG1cn7MFbHRDnb" -H "X-N8N-API-KEY: $N8N_API_KEY" > /dev/null 2>&1
echo "  ❌ WF-03 doublon supprimé"
curl -s -X DELETE "$BASE_URL/workflows/TfYhjsiNDpKxnNRA" -H "X-N8N-API-KEY: $N8N_API_KEY" > /dev/null 2>&1
echo "  ❌ WF-04 doublon supprimé"

# Supprimer TCnfhghR3Vt3WYoq (ancien WF-04)
curl -s -X DELETE "$BASE_URL/workflows/TCnfhghR3Vt3WYoq" -H "X-N8N-API-KEY: $N8N_API_KEY" > /dev/null 2>&1

echo ""
echo "📦 Déploiement des workflows manquants..."
echo ""

# Déployer WF-06 (Remboursement Auto)
echo -n "📤 WF-06: Remboursement Auto... "
curl -s -X POST "$BASE_URL/workflows" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-06-remboursement-auto.json > /tmp/wf06.json 2>&1
if grep -q '"id"' /tmp/wf06.json; then 
  ID=$(grep -o '"id":"[^"]*"' /tmp/wf06.json | head -1 | cut -d'"' -f4)
  echo "✅ OK (ID: ${ID:0:8}...)"
else 
  echo "❌ Erreur"
fi

# Déployer WF-13 (Retry + Fallback)
echo -n "📤 WF-13: Retry + Fallback... "
curl -s -X POST "$BASE_URL/workflows" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-13-retry-fallback.json > /tmp/wf13.json 2>&1
if grep -q '"id"' /tmp/wf13.json; then 
  ID=$(grep -o '"id":"[^"]*"' /tmp/wf13.json | head -1 | cut -d'"' -f4)
  echo "✅ OK (ID: ${ID:0:8}...)"
else 
  echo "❌ Erreur"
fi

# Déployer WF-14 (Alertes Crédits Faibles)
echo -n "📤 WF-14: Alertes Crédits Faibles... "
curl -s -X POST "$BASE_URL/workflows" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-14-alertes-credits-faibles.json > /tmp/wf14.json 2>&1
if grep -q '"id"' /tmp/wf14.json; then 
  ID=$(grep -o '"id":"[^"]*"' /tmp/wf14.json | head -1 | cut -d'"' -f4)
  echo "✅ OK (ID: ${ID:0:8}...)"
else 
  echo "❌ Erreur"
fi

echo ""
echo "=================================="
echo "✅ Déploiement terminé !"
echo ""
echo "📋 Workflows déployés:"
echo "  • WF-01: Inscription + Avatar Gratuit"
echo "  • WF-02: Création Avatar Payant"
echo "  • WF-03: Vidéo Faceless COURTE (1 crédit)"
echo "  • WF-04: Vidéo Faceless LONGUE (2 crédits)"
echo "  • WF-05: Gestion Crédits"
echo "  • WF-06: Remboursement Auto ✅ NOUVEAU"
echo "  • WF-07: Achat Crédits Stripe"
echo "  • WF-08: Attribution Mensuelle"
echo "  • WF-09: Paiement Abonnement"
echo "  • WF-13: Retry + Fallback ✅ NOUVEAU"
echo "  • WF-14: Alertes Crédits Faibles ✅ NOUVEAU"
echo ""
echo "⚠️  Prochaines étapes:"
echo "  1. Créer la table processing_logs dans Supabase"
echo "  2. Configurer les credentials (FAL, Hailuo, Brevo, Stripe)"
echo "  3. Activer les workflows (toggle ON)"
echo "  4. Configurer les webhooks Stripe"
echo ""
