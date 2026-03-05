#!/bin/bash

N8N_API_KEY="$N8N_API_KEY"
BASE_URL="https://albbocco.app.n8n.cloud/api/v1"

echo "🔄 Mise à jour des PRIX sur les workflows n8n"
echo "=============================================="
echo ""

# Mettre à jour WF-03 (1 crédit au lieu de 6)
echo -n "📤 WF-03 Vidéo Courte (1 crédit)... "
HTTP_CODE=$(curl -s -o /tmp/n8n_resp.json -w "%{http_code}" -X PATCH "$BASE_URL/workflows/k8eFuu9CcOtXdMo3" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-03-video-faceless-courte.json 2>/dev/null)
if [ "$HTTP_CODE" = "200" ]; then echo "✅ OK"; else echo "❌ HTTP $HTTP_CODE"; fi

# Mettre à jour WF-04 (2 crédits au lieu de 10)
echo -n "📤 WF-04 Vidéo Longue (2 crédits)... "
HTTP_CODE=$(curl -s -o /tmp/n8n_resp.json -w "%{http_code}" -X PATCH "$BASE_URL/workflows/Oqwu0KwGgDpCdRZB" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-04-video-faceless-longue.json 2>/dev/null)
if [ "$HTTP_CODE" = "200" ]; then echo "✅ OK"; else echo "❌ HTTP $HTTP_CODE"; fi

# Mettre à jour WF-08 (crédits selon plan: 5/30/100)
echo -n "📤 WF-08 Attribution Mensuelle... "
HTTP_CODE=$(curl -s -o /tmp/n8n_resp.json -w "%{http_code}" -X PATCH "$BASE_URL/workflows/FEHvvnvnykZncoP1" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-08-attribution-mensuelle.json 2>/dev/null)
if [ "$HTTP_CODE" = "200" ]; then echo "✅ OK"; else echo "❌ HTTP $HTTP_CODE"; fi

# Mettre à jour WF-09 (plans: starter/pro/business)
echo -n "📤 WF-09 Paiement Abonnement... "
HTTP_CODE=$(curl -s -o /tmp/n8n_resp.json -w "%{http_code}" -X PATCH "$BASE_URL/workflows/Zeto2XkSvCcPGlZj" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-09-paiement-abonnement.json 2>/dev/null)
if [ "$HTTP_CODE" = "200" ]; then echo "✅ OK"; else echo "❌ HTTP $HTTP_CODE"; fi

# Mettre à jour WF-07 (prix crédits extra par plan)
echo -n "📤 WF-07 Achat Crédits... "
HTTP_CODE=$(curl -s -o /tmp/n8n_resp.json -w "%{http_code}" -X PATCH "$BASE_URL/workflows/3sVTU1X5BQqgzPB5" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-07-achat-credits-stripe.json 2>/dev/null)
if [ "$HTTP_CODE" = "200" ]; then echo "✅ OK"; else echo "❌ HTTP $HTTP_CODE"; fi

echo ""
echo "=============================================="
echo "✅ Mise à jour des PRIX terminee !"
echo ""
echo "📊 Nouvelle grille de prix :"
echo ""
echo "PLANS D'ABONNEMENT:"
echo "  • Starter   : 19€/mois → 5 crédits"
echo "  • Pro       : 49€/mois → 30 crédits"  
echo "  • Business  : 109€/mois → 100 crédits"
echo ""
echo "COUTS EN CRÉDITS:"
echo "  • Avatar         : 1 crédit"
echo "  • Vidéo courte   : 1 crédit (6s)"
echo "  • Vidéo longue   : 2 crédits (10s)"
echo ""
echo "CRÉDITS EXTRA:"
echo "  • Starter   : 3€/crédit"
echo "  • Pro       : 2€/crédit"
echo "  • Business  : 1.5€/crédit"
echo ""
