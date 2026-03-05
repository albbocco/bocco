#!/bin/bash

N8N_API_KEY="$N8N_API_KEY"
BASE_URL="https://albbocco.app.n8n.cloud/api/v1"

echo "🔄 Déploiement du prix Starter (9€) sur n8n"
echo "============================================"
echo ""

# Mettre à jour WF-09
echo -n "📤 WF-09: Paiement Abonnement (Starter 9€)... "

HTTP_CODE=$(curl -s -o /tmp/n8n_update.json -w "%{http_code}" -X PATCH "$BASE_URL/workflows/HMEeXsCWuEDJbAw3" \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @n8n-workflows-api-ready/WF-09-paiement-abonnement.json 2>/dev/null)

if [ "$HTTP_CODE" = "200" ]; then
  echo "✅ OK"
else
  ERROR=$(cat /tmp/n8n_update.json 2>/dev/null | grep -o '"message":"[^"]*"' | head -1 | cut -d'"' -f4)
  echo "⚠️  $ERROR (HTTP $HTTP_CODE)"
fi

echo ""
echo "============================================"
echo "✅ Déploiement terminé !"
echo ""
echo "📊 Nouvelle configuration :"
echo "  • Starter: 9€/mois (prix fixe, sans réduction)"
echo "  • Pro: 49€/mois (avec réductions formations)"
echo "  • Business: 109€/mois (avec réductions formations)"
