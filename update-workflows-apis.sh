#!/bin/bash

# Script de mise à jour des workflows avec les bonnes APIs

N8N_API_BASE_URL="${N8N_API_BASE_URL:-https://albbocco.app.n8n.cloud/api/v1}"
N8N_API_KEY="$N8N_API_KEY"
WORKFLOWS_DIR="./n8n-workflows-api-ready"

echo "🔄 Mise à jour des workflows avec les bonnes APIs (FAL + Hailuo)"
echo "================================================================"
echo ""

# Workflows à mettre à jour
WORKFLOW_1="WF-01-inscription-avatar-gratuit.json"
WORKFLOW_2="WF-02-creation-avatar-payant.json"
WORKFLOW_3="WF-03-video-faceless-courte.json"
WORKFLOW_4="WF-04-video-faceless-longue.json"

SUCCESS_COUNT=0
FAILED_COUNT=0

deploy_workflow() {
    local filename="$1"
    local shortname="$2"
    local filepath="$WORKFLOWS_DIR/$filename"
    
    echo -n "📤 $shortname... "
    
    HTTP_CODE=$(curl -s -o /tmp/n8n_resp.json -w "%{http_code}" -X POST \
        -H "X-N8N-API-KEY: $N8N_API_KEY" \
        -H "Content-Type: application/json" \
        -d @$filepath \
        "$N8N_API_BASE_URL/workflows" 2>/dev/null)
    
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
        echo "✅ OK"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    elif [ "$HTTP_CODE" = "400" ]; then
        ERROR=$(cat /tmp/n8n_resp.json | grep -o '"message":"[^"]*"' | head -1 | cut -d'"' -f4)
        if echo "$ERROR" | grep -q "already exists"; then
            echo "⚠️  Existe déjà (supprimez-le dans n8n et relancez)"
        else
            echo "❌ Erreur: $ERROR"
        fi
        FAILED_COUNT=$((FAILED_COUNT + 1))
    else
        echo "❌ HTTP $HTTP_CODE"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
}

deploy_workflow "$WORKFLOW_1" "🎭 WF-01 Avatar Gratuit (FAL+Hailuo)"
deploy_workflow "$WORKFLOW_2" "💳 WF-02 Avatar Payant (FAL+Hailuo)"
deploy_workflow "$WORKFLOW_3" "🎬 WF-03 Vidéo Courte (Hailuo)"
deploy_workflow "$WORKFLOW_4" "🎬 WF-04 Vidéo Longue (Hailuo)"

echo ""
echo "================================================================"
echo "✅ Mis à jour: $SUCCESS_COUNT/4"
echo "❌ Échecs: $FAILED_COUNT/4"
echo "================================================================"

if [ $SUCCESS_COUNT -eq 4 ]; then
    echo ""
    echo "🎉 Tous les workflows sont à jour avec les bonnes APIs !"
fi

echo ""
echo "📋 Résumé des APIs utilisées:"
echo "   • Images/Avatars: FAL.ai (flux-pro)"
echo "   • Vidéos: Hailuo/PiAPI (Kling/Luma)"
echo ""
echo "🔑 Credentials à configurer dans n8n:"
echo "   • FAL_API_KEY (header: Authorization)"
echo "   • HAILUO_API_KEY (header: X-API-Key)
