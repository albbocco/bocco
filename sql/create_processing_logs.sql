-- SQL pour créer les tables manquantes pour les workflows n8n
-- À exécuter dans Supabase

-- Table de logs de traitement (pour observability)
CREATE TABLE IF NOT EXISTS processing_logs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    workflow_name varchar(100) NOT NULL,
    execution_id varchar(100),
    user_id uuid REFERENCES users(id),
    status varchar(20) NOT NULL, -- started, completed, failed, retry, alert_sent
    error_message text,
    metadata jsonb,
    started_at timestamp DEFAULT NOW(),
    ended_at timestamp
);

-- Index pour les requêtes fréquentes
CREATE INDEX IF NOT EXISTS idx_processing_logs_user ON processing_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_processing_logs_workflow ON processing_logs(workflow_name);
CREATE INDEX IF NOT EXISTS idx_processing_logs_status ON processing_logs(status);
CREATE INDEX IF NOT EXISTS idx_processing_logs_created ON processing_logs(created_at);

-- Table d'audit complète
CREATE TABLE IF NOT EXISTS audit_logs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES users(id),
    action varchar(100) NOT NULL,
    entity_type varchar(50), -- user, avatar, video, transaction
    entity_id uuid,
    old_values jsonb,
    new_values jsonb,
    ip_address inet,
    user_agent text,
    created_at timestamp DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created ON audit_logs(created_at);

-- Mettre à jour la table users si nécessaire
DO $$
BEGIN
    -- Ajouter credits_monthly si non existant
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'users' AND column_name = 'credits_monthly') THEN
        ALTER TABLE users ADD COLUMN credits_monthly int DEFAULT 0;
    END IF;
    
    -- Ajouter subscription_renews_at si non existant
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'users' AND column_name = 'subscription_renews_at') THEN
        ALTER TABLE users ADD COLUMN subscription_renews_at timestamp;
    END IF;
END $$;

-- Mettre à jour la table videos si nécessaire
DO $$
BEGIN
    -- Ajouter error_message si non existant
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'videos' AND column_name = 'error_message') THEN
        ALTER TABLE videos ADD COLUMN error_message text;
    END IF;
    
    -- Ajouter hailuo_prediction_id si non existant
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'videos' AND column_name = 'hailuo_prediction_id') THEN
        ALTER TABLE videos ADD COLUMN hailuo_prediction_id varchar(100);
    END IF;
END $$;

-- Mettre à jour la table avatars si nécessaire
DO $$
BEGIN
    -- Ajouter fal_ai_prediction_id si non existant
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'avatars' AND column_name = 'fal_ai_prediction_id') THEN
        ALTER TABLE avatars ADD COLUMN fal_ai_prediction_id varchar(100);
    END IF;
END $$;

-- Créer une fonction pour le cleanup automatique des vieux logs (optionnel)
CREATE OR REPLACE FUNCTION cleanup_old_logs()
RETURNS void AS $$
BEGIN
    DELETE FROM processing_logs WHERE created_at < NOW() - INTERVAL '90 days';
    DELETE FROM audit_logs WHERE created_at < NOW() - INTERVAL '1 year';
END;
$$ LANGUAGE plpgsql;
