#!/bin/bash

# Script de déploiement des workflows Bocco AI vers n8n
# Usage: ./deploy-all-workflows.sh [API_KEY]

set -e

N8N_API_BASE_URL="${N8N_API_BASE_URL:-https://albbocco.app.n8n.cloud/api/v1}"
N8N_API_KEY="${1:-$N8N_API_KEY}"
WORKFLOWS_DIR="$(dirname "$0")/n8n-workflows"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      🚀 Déploiement Workflows Bocco AI - n8n            ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Vérifier la connexion API
if [ -z "$N8N_API_KEY" ]; then
    echo -e "${YELLOW}⚠️  Aucune clé API fournie${NC}"
    echo ""
    echo "Pour déployer automatiquement, fournissez votre clé API n8n:"
    echo "  ./deploy-all-workflows.sh n8n_api_votre_cle_ici"
    echo ""
    echo "Ou définissez la variable d'environnement:"
    echo "  export N8N_API_KEY=n8n_api_votre_cle_ici"
    echo ""
    echo -e "${BLUE}📋 Guide d'import manuel:${NC}"
    echo "  1. Connectez-vous à https://albbocco.app.n8n.cloud"
    echo "  2. Workflows → Import from File"
    echo "  3. Importez dans cet ordre:"
    echo ""
    echo "     ${GREEN}1. WF-05-gestion-credits.json${NC} (core - déployer en premier)"
    echo "     2. WF-01-inscription-avatar-gratuit.json"
    echo "     3. WF-02-creation-avatar-payant.json"
    echo "     4. WF-03-video-faceless-courte.json"
    echo "     5. WF-04-video-faceless-longue.json"
    echo "     6. WF-07-achat-credits-stripe.json"
    echo "     7. WF-08-attribution-mensuelle.json"
    echo "     8. WF-09-paiement-abonnement.json"
    echo ""
    echo "  4. Configurez les credentials dans Settings > Credentials"
    echo "  5. Activez chaque workflow (toggle ON)"
    echo ""
    exit 0
fi

# Tester la connexion API
echo -e "${BLUE}🔍 Test de connexion à n8n...${NC}"
TEST_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "X-N8N-API-KEY: $N8N_API_KEY" \
    "$N8N_API_BASE_URL/workflows" 2>/dev/null || echo "000")

if [ "$TEST_RESPONSE" = "401" ]; then
    echo -e "${RED}❌ Clé API invalide (401 Unauthorized)${NC}"
    echo ""
    echo "Vérifiez votre clé API dans n8n:"
    echo "  Settings → n8n API → Create API Key"
    echo ""
    exit 1
fi

if [ "$TEST_RESPONSE" != "200" ]; then
    echo -e "${RED}❌ Impossible de se connecter à n8n (HTTP $TEST_RESPONSE)${NC}"
    echo "Vérifiez l'URL: $N8N_API_BASE_URL"
    exit 1
fi

echo -e "${GREEN}✅ Connexion OK${NC}"
echo ""

# Workflows à déployer (ordre important pour les dépendances)
declare -a WORKFLOWS=(
    "WF-05-gestion-credits.json:⚙️  Core - Gestion Crédits"
    "WF-01-inscription-avatar-gratuit.json:🎭 Avatar Gratuit"
    "WF-02-creation-avatar-payant.json:💳 Avatar Payant"
    "WF-03-video-faceless-courte.json:🎬 Vidéo Courte"
    "WF-04-video-faceless-longue.json:🎬 Vidéo Longue"
    "WF-07-achat-credits-stripe.json:💰 Achat Crédits"
    "WF-08-attribution-mensuelle.json:📅 Attribution Mensuelle"
    "WF-09-paiement-abonnement.json:🔄 Paiement Abonnement"
)

SUCCESS_COUNT=0
FAILED_COUNT=0

for item in "${WORKFLOWS[@]}"; do
    IFS=':' read -r workflow description <<< "$item"
    filepath="$WORKFLOWS_DIR/$workflow"
    
    if [ ! -f "$filepath" ]; then
        echo -e "${YELLOW}⚠️  $description - Fichier non trouvé${NC}"
        ((FAILED_COUNT++))
        continue
    fi
    
    echo -e "${BLUE}📤 Déploiement: $description${NC}"
    
    # Créer le workflow
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
        -H "X-N8N-API-KEY: $N8N_API_KEY" \
        -H "Content-Type: application/json" \
        -d @$filepath \
        "$N8N_API_BASE_URL/workflows" 2>/dev/null)
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | sed '$d')
    
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
        WORKFLOW_ID=$(echo "$BODY" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        WORKFLOW_NAME=$(echo "$BODY" | grep -o '"name":"[^"]*"' | head -1 | cut -d'"' -f4)
        echo -e "   ${GREEN}✅ Créé: $WORKFLOW_NAME${NC}"
        echo -e "   ${BLUE}   ID: $WORKFLOW_ID${NC}"
        ((SUCCESS_COUNT++))
    else
        echo -e "   ${RED}❌ Erreur HTTP $HTTP_CODE${NC}"
        ERROR_MSG=$(echo "$BODY" | grep -o '"message":"[^"]*"' | head -1 | cut -d'"' -f4)
        if [ -n "$ERROR_MSG" ]; then
            echo -e "   ${RED}   $ERROR_MSG${NC}"
        fi
        ((FAILED_COUNT++))
    fi
    echo ""
done

# Résumé
echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Déployés: $SUCCESS_COUNT${NC}"
if [ $FAILED_COUNT -gt 0 ]; then
    echo -e "${RED}❌ Échecs: $FAILED_COUNT${NC}"
fi
echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"

if [ $SUCCESS_COUNT -eq 8 ]; then
    echo ""
    echo -e "${GREEN}🎉 Tous les workflows sont déployés !${NC}"
    echo ""
    echo "Prochaines étapes:"
    echo "  1. Configurez les credentials dans n8n Settings > Credentials"
    echo "  2. Activez les workflows (toggle ON)"
    echo "  3. Testez les webhooks"
fi

echo ""
echo "📁 Fichiers disponibles dans: $WORKFLOWS_DIR"