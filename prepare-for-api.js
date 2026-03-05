const fs = require('fs');
const path = require('path');

const workflowsDir = '/data/.openclaw/workspace/bocco-ai/n8n-workflows';
const outputDir = '/data/.openclaw/workspace/bocco-ai/n8n-workflows-api-ready';

// Créer le dossier de sortie
if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
}

// Liste des workflows à traiter
const workflows = [
    'WF-05-gestion-credits.json',
    'WF-01-inscription-avatar-gratuit.json',
    'WF-02-creation-avatar-payant.json',
    'WF-03-video-faceless-courte.json',
    'WF-04-video-faceless-longue.json',
    'WF-07-achat-credits-stripe.json',
    'WF-08-attribution-mensuelle.json',
    'WF-09-paiement-abonnement.json'
];

workflows.forEach(filename => {
    const filepath = path.join(workflowsDir, filename);
    
    if (!fs.existsSync(filepath)) {
        console.log(`⚠️  ${filename} - Fichier non trouvé`);
        return;
    }
    
    // Lire le workflow
    const workflow = JSON.parse(fs.readFileSync(filepath, 'utf8'));
    
    // Nettoyer les champs en lecture seule pour l'API
    // L'API n8n n'accepte QUE: name, nodes, connections, settings, staticData
    const cleaned = {
        name: workflow.name,
        nodes: workflow.nodes || [],
        connections: workflow.connections || {}
    };
    
    // Ajouter settings seulement si nécessaire
    if (workflow.settings) {
        cleaned.settings = workflow.settings;
    }
    
    // Sauvegarder la version nettoyée
    const outputPath = path.join(outputDir, filename);
    fs.writeFileSync(outputPath, JSON.stringify(cleaned, null, 2));
    
    console.log(`✅ ${filename} → prêt pour l'API`);
});

console.log(`\n📁 Fichiers API-ready créés dans: ${outputDir}`);