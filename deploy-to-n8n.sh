#!/bin/bash

# Script de déploiement des workflows Bocco AI vers n8n
# Usage: N8N_API_KEY=votre_cle ./deploy-to-n8n.sh

set -e

N8N_API_BASE_URL="${N8N_API_BASE_URL:-https://albbocco.app.n8n.cloud/api/v1}"
N8N_API_KEY="${N8N_API_KEY:-$1}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOWS_DIR="$SCRIPT_DIR/n8n-workflows-api-ready"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           🚀 Déploiement Workflows Bocco AI                  ║${NC}"
echo -e "${BLUE}║                    n8n Cloud                                 ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Vérifier les arguments
if [ -z "$N8N_API_KEY" ]; then
    echo -e "${YELLOW}⚠️  Clé API n8n requise${NC}"
    echo ""
    echo "Usage:"
    echo "  N8N_API_KEY=votre_cle_api ./deploy-to-n8n.sh"
    echo ""
    echo "Ou obtenez votre clé dans n8n:"
    echo -e "  ${CYAN}Settings → n8n API → Create API Key${NC}"
    echo ""
    exit 1
fi

# Vérifier que les fichiers existent
if [ ! -d "$WORKFLOWS_DIR" ]; then
    echo -e "${RED}❌ Dossier $WORKFLOWS_DIR non trouvé${NC}"
    exit 1
fi

# Tester la connexion
echo -e "${BLUE}🔍 Test de connexion à n8n...${NC}"
TEST_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "X-N8N-API-KEY: $N8N_API_KEY" \
    "$N8N_API_BASE_URL/workflows" 2>/dev/null || echo "000")

if [ "$TEST_RESPONSE" = "401" ]; then
    echo -e "${RED}❌ Clé API invalide${NC}"
    exit 1
elif [ "$TEST_RESPONSE" != "200" ]; then
    echo -e "${RED}❌ Erreur de connexion (HTTP $TEST_RESPONSE)${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Connexion établie${NC}"
echo ""

# Workflows à déployer (ordre important)
declare -a WORKFLOWS=(
    "WF-05-gestion-credits.json|⚙️  WF-05|Gestion des crédits (Core)"
    "WF-01-inscription-avatar-gratuit.json|🎭 WF-01|Inscription + Avatar Gratuit"
    "WF-02-creation-avatar-payant.json|💳 WF-02|Création Avatar Payant"
    "WF-03-video-faceless-courte.json|🎬 WF-03|Vidéo Faceless Courte"
    "WF-04-video-faceless-longue.json|🎬 WF-04|Vidéo Faceless Longue"
    "WF-07-achat-credits-stripe.json|💰 WF-07|Achat Crédits Stripe"
    "WF-08-attribution-mensuelle.json|📅 WF-08|Attribution Mensuelle"
    "WF-09-paiement-abonnement.json|🔄 WF-09|Paiement Abonnement"
)

SUCCESS_COUNT=0
FAILED_COUNT=0
FAILED_LIST=()

echo -e "${CYAN}📦 Déploiement des workflows...${NC}"
echo ""

for item in "${WORKFLOWS[@]}"; do
    IFS='|' read -r filename shortname description <<< "$item"
    filepath="$WORKFLOWS_DIR/$filename"
    
    if [ ! -f "$filepath" ]; then
        echo -e "${YELLOW}⚠️  $shortname - Fichier non trouvé${NC}"
        FAILED_LIST+=("$shortname: Fichier manquant")
        ((FAILED_COUNT++))
        continue
    fi
    
    echo -ne "${BLUE}  $shortname${NC} $description... "
    
    # Créer le workflow
    HTTP_CODE=$(curl -s -o /tmp/n8n_response.json -w "%{http_code}" -X POST \
        -H "X-N8N-API-KEY: $N8N_API_KEY" \
        -H "Content-Type: application/json" \
        -d @$filepath \
        "$N8N_API_BASE_URL/workflows" 2>/dev/null)
    
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
        WORKFLOW_ID=$(cat /tmp/n8n_response.json | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        echo -e "${GREEN}OK${NC} (${WORKFLOW_ID:0:8}...)"
        ((SUCCESS_COUNT++))
    else
        ERROR=$(cat /tmp/n8n_response.json | grep -o '"message":"[^"]*"' | head -1 | cut -d'"' -f4 || echo "HTTP $HTTP_CODE")
        echo -e "${RED}ERREUR${NC} ($ERROR)"
        FAILED_LIST+=("$shortname: $ERROR")
        ((FAILED_COUNT++))
    fi
done

echo ""
echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"

if [ $SUCCESS_COUNT -gt 0 ]; then
    echo -e "${GREEN}  ✅ Déployés avec succès: $SUCCESS_COUNT/8${NC}"
fi

if [ $FAILED_COUNT -gt 0 ]; then
    echo -e "${RED}  ❌ Échecs: $FAILED_COUNT/8${NC}"
    echo ""
    echo "  Détails des erreurs:"
    for fail in "${FAILED_LIST[@]}"; do
        echo -e "    ${RED}- $fail${NC}"
    done
fi

echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"

if [ $SUCCESS_COUNT -eq 8 ]; then
    echo ""
    echo -e "${GREEN}🎉 Tous les workflows sont déployés !${NC}"
    echo ""
    echo -e "${CYAN}Prochaines étapes:${NC}"
    echo "  1. Connectez-vous à https://albbocco.app.n8n.cloud"
    echo "  2. Allez dans Settings → Credentials"
    echo "  3. Configurez:"
    echo "     • Supabase PostgreSQL"
    echo "     • Cloudflare R2 (S3)"
    echo "     • Stripe API"
    echo "     • Brevo SMTP"
    echo "     • Hypereal / Haiper / OpenAI"
    echo "  4. Activez les workflows (toggle ON)"
    echo "  5. Configurez les webhooks Stripe"
    echo ""
    echo -e "${CYAN}📚 Documentation:${NC} docs/architecture-complete.md"
fi

rm -f /tmp/n8n_response.json

echo ""