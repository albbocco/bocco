#!/bin/bash

N8N_API_KEY="$N8N_API_KEY"
BASE_URL="https://albbocco.app.n8n.cloud/api/v1"

echo "🔄 Mise à jour des PRIX (delete + recreate)"
echo "=============================================="

# Supprimer et recréer WF-03
echo "📤 WF-03 Vidéo Courte (1 crédit)..."
curl -s -X DELETE "$BASE_URL/workflows/k8eFuu9CcOtXdMo3" -H "X-N8N-API-KEY: $N8N_API_KEY" > /dev/null 2>&1
sleep 1
curl -s -X POST "$BASE_URL/workflows" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-03-video-faceless-courte.json > /tmp/wf03.json 2>&1
if grep -q '"id"' /tmp/wf03.json; then echo "  ✅ OK"; else echo "  ❌ Erreur"; fi

# Supprimer et recréer WF-04
echo "📤 WF-04 Vidéo Longue (2 crédits)..."
curl -s -X DELETE "$BASE_URL/workflows/Oqwu0KwGgDpCdRZB" -H "X-N8N-API-KEY: $N8N_API_KEY" > /dev/null 2>&1
sleep 1
curl -s -X POST "$BASE_URL/workflows" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-04-video-faceless-longue.json > /tmp/wf04.json 2>&1
if grep -q '"id"' /tmp/wf04.json; then echo "  ✅ OK"; else echo "  ❌ Erreur"; fi

# Supprimer et recréer WF-08
echo "📤 WF-08 Attribution Mensuelle..."
curl -s -X DELETE "$BASE_URL/workflows/FEHvvnvnykZncoP1" -H "X-N8N-API-KEY: $N8N_API_KEY" > /dev/null 2>&1
sleep 1
curl -s -X POST "$BASE_URL/workflows" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-08-attribution-mensuelle.json > /tmp/wf08.json 2>&1
if grep -q '"id"' /tmp/wf08.json; then echo "  ✅ OK"; else echo "  ❌ Erreur"; fi

# Supprimer et recréer WF-09
echo "📤 WF-09 Paiement Abonnement..."
curl -s -X DELETE "$BASE_URL/workflows/Zeto2XkSvCcPGlZj" -H "X-N8N-API-KEY: $N8N_API_KEY" > /dev/null 2>&1
sleep 1
curl -s -X POST "$BASE_URL/workflows" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-09-paiement-abonnement.json > /tmp/wf09.json 2>&1
if grep -q '"id"' /tmp/wf09.json; then echo "  ✅ OK"; else echo "  ❌ Erreur"; fi

# Supprimer et recréer WF-07
echo "📤 WF-07 Achat Crédits..."
curl -s -X DELETE "$BASE_URL/workflows/3sVTU1X5BQqgzPB5" -H "X-N8N-API-KEY: $N8N_API_KEY" > /dev/null 2>&1
sleep 1
curl -s -X POST "$BASE_URL/workflows" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-07-achat-credits-stripe.json > /tmp/wf07.json 2>&1
if grep -q '"id"' /tmp/wf07.json; then echo "  ✅ OK"; else echo "  ❌ Erreur"; fi

echo ""
echo "=============================================="
echo "✅ Mise à jour des PRIX terminee !"
