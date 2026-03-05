#!/bin/bash

# Configuration n8n
N8N_API_BASE_URL="https://albbocco.app.n8n.cloud/api/v1"
N8N_API_KEY="n8n_api_6a5a3f4c1d8e7b2a9f0e5d8c7b6a5f4e3d2c1b0a9f8e7d6c5b4a3f2e1d0c9b8a7f6e5d4c3b2a1"

WORKFLOWS_DIR="/data/.openclaw/workspace/bocco-ai/n8n-workflows"

echo "🚀 Déploiement des workflows Bocco AI vers n8n"
echo "=============================================="
echo ""

# Liste des workflows à déployer (ordre de dépendance)
declare -a WORKFLOWS=(
    "WF-05-gestion-credits.json"
    "WF-01-inscription-avatar-gratuit.json"
    "WF-02-creation-avatar-payant.json"
    "WF-03-video-faceless-courte.json"
    "WF-04-video-faceless-longue.json"
    "WF-07-achat-credits-stripe.json"
    "WF-08-attribution-mensuelle.json"
    "WF-09-paiement-abonnement.json"
)

for workflow in "${WORKFLOWS[@]}"; do
    filepath="$WORKFLOWS_DIR/$workflow"
    
    if [ ! -f "$filepath" ]; then
        echo "⚠️  Fichier non trouvé: $workflow"
        continue
    fi
    
    echo "📤 Déploiement: $workflow"
    
    # Créer le workflow via l'API
    response=$(curl -s -w "\n%{http_code}" -X POST \
        -H "X-N8N-API-KEY: $N8N_API_KEY" \
        -H "Content-Type: application/json" \
        -d @$filepath \
        "$N8N_API_BASE_URL/workflows")
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -eq 200 ] || [ "$http_code" -eq 201 ]; then
        workflow_id=$(echo "$body" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        workflow_name=$(echo "$body" | grep -o '"name":"[^"]*"' | head -1 | cut -d'"' -f4)
        echo "   ✅ Créé: $workflow_name (ID: $workflow_id)"
    else
        echo "   ❌ Erreur HTTP $http_code"
        echo "   Réponse: $body" | head -c 200
        echo ""
    fi
    
    echo ""
done

echo "=============================================="
echo "✅ Déploiement terminé"
