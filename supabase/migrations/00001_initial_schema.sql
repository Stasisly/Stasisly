-- Extensión para UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;
SET search_path = public, extensions;

-- Usuarios (extiende auth.users)
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  avatar_url TEXT,
  role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Planes de membresía (maestro)
CREATE TABLE public.memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL, -- 'mensual', 'trimestral', 'anual'
  price DECIMAL(10,2) NOT NULL,
  duration_days INT NOT NULL,
  features JSONB,
  created_at TIMESTAMP DEFAULT now()
);

-- Membresías de usuarios
CREATE TABLE public.user_memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  membership_id UUID REFERENCES public.memberships(id),
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  is_active BOOLEAN DEFAULT true,
  trial_used BOOLEAN DEFAULT false,
  stripe_subscription_id TEXT,
  created_at TIMESTAMP DEFAULT now()
);

-- Agentes (especialistas, jefes de rama, jefes de subcategoría, orquestador)
CREATE TABLE public.specialists (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('salud', 'nutricion', 'fisico', 'mental', 'orquestador', 'branch_chief', 'subcategory_chief')),
  subcategory TEXT, -- cardiologia, nutricion deportiva, etc.
  prompt_template JSONB NOT NULL, -- { system, temperature, max_tokens }
  is_premium BOOLEAN DEFAULT true,
  is_active BOOLEAN DEFAULT true,
  avatar_url TEXT,
  branch_id UUID, -- referencia al jefe de rama (si aplica)
  chief_id UUID, -- referencia al jefe de subcategoría (si aplica)
  created_at TIMESTAMP DEFAULT now()
);

-- Jefes de rama (especialización)
CREATE TABLE public.branch_chiefs (
  specialist_id UUID PRIMARY KEY REFERENCES public.specialists(id) ON DELETE CASCADE,
  branch_name TEXT UNIQUE NOT NULL CHECK (branch_name IN ('salud', 'nutricion', 'fisico', 'mental'))
);

-- Jefes de subcategoría
CREATE TABLE public.subcategory_chiefs (
  specialist_id UUID PRIMARY KEY REFERENCES public.specialists(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES public.branch_chiefs(specialist_id),
  subcategory_name TEXT NOT NULL,
  min_specialists INT DEFAULT 5,
  can_disable BOOLEAN DEFAULT true,
  UNIQUE(branch_id, subcategory_name)
);

-- Sesiones de chat
CREATE TABLE public.chat_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  specialist_id UUID REFERENCES public.specialists(id) ON DELETE CASCADE,
  started_at TIMESTAMP DEFAULT now(),
  last_message_at TIMESTAMP DEFAULT now(),
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'archived')),
  message_count INT DEFAULT 0
);

-- Mensajes
CREATE TABLE public.messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID REFERENCES public.chat_sessions(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant', 'system', 'chief_intervention')),
  content TEXT NOT NULL,
  attachments JSONB, -- { type: 'pdf', url: '...' pero url temporal, se borra pronto
  created_at TIMESTAMP DEFAULT now()
);

-- Datos de salud extraídos de archivos
CREATE TABLE public.user_health_data (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  data_type TEXT NOT NULL, -- 'analitica_medica', 'sintoma', 'foto_cuerpo'
  content JSONB NOT NULL, -- cifrado en reposo (usar pgcrypto)
  source_file_url TEXT, -- temporal, se borrará
  extracted_at TIMESTAMP DEFAULT now(),
  validated BOOLEAN DEFAULT false,
  encrypted_at_rest BOOLEAN DEFAULT true
);

-- Calendario y recordatorios
CREATE TABLE public.calendar_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  start_datetime TIMESTAMP NOT NULL,
  end_datetime TIMESTAMP NOT NULL,
  recurrence_rule TEXT, -- RRULE RFC 5545
  reminder_minutes INT,
  created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE public.reminders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  message TEXT NOT NULL,
  scheduled_for TIMESTAMP NOT NULL,
  triggered BOOLEAN DEFAULT false,
  related_entity TEXT, -- 'calendar_event' o 'chat_suggestion'
  entity_id UUID,
  created_at TIMESTAMP DEFAULT now()
);

-- Resúmenes del orquestador y jefes
CREATE TABLE public.orchestator_summaries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  summary_level TEXT CHECK (summary_level IN ('orchestrator', 'branch', 'subcategory')),
  entity_id UUID, -- id del jefe que lo generó
  summary_text TEXT NOT NULL,
  period_start DATE,
  period_end DATE,
  is_active BOOLEAN DEFAULT false, -- solo un resumen activo por nivel/entidad
  created_at TIMESTAMP DEFAULT now()
);

-- Permisos para que jefes de subcategoría escriban en chats ajenos
CREATE TABLE public.chief_write_permissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subcategory_chief_id UUID REFERENCES public.subcategory_chiefs(specialist_id) ON DELETE CASCADE,
  specialist_id UUID REFERENCES public.specialists(id),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  permission_granted BOOLEAN,
  granted_at TIMESTAMP,
  expires_at TIMESTAMP, -- si se quiere temporal
  UNIQUE(subcategory_chief_id, specialist_id, user_id)
);

-- Desactivaciones temporales de especialistas por jefes de subcategoría
CREATE TABLE public.specialist_temporary_disables (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  specialist_id UUID REFERENCES public.specialists(id) ON DELETE CASCADE,
  disabled_by UUID REFERENCES public.subcategory_chiefs(specialist_id),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  approved_by_user BOOLEAN DEFAULT false,
  disabled_at TIMESTAMP DEFAULT now(),
  reactivation_at TIMESTAMP,
  reason TEXT
);

-- Índices
CREATE INDEX idx_chat_sessions_user ON public.chat_sessions(user_id);
CREATE INDEX idx_messages_session ON public.messages(session_id);
CREATE INDEX idx_user_health_data_user ON public.user_health_data(user_id);
CREATE INDEX idx_orchestator_summaries_user ON public.orchestator_summaries(user_id);
