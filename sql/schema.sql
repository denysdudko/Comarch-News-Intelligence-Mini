-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.telegram_runtime_state (
  id bigint NOT NULL DEFAULT nextval('telegram_runtime_state_id_seq'::regclass),
  chat_id bigint NOT NULL,
  user_id bigint NOT NULL,
  user_name text,
  user_language character varying,
  status character varying NOT NULL DEFAULT 'waiting'::character varying,
  queue_version integer NOT NULL DEFAULT 1,
  expert_replied boolean NOT NULL DEFAULT false,
  queue_started_at timestamp with time zone NOT NULL DEFAULT now(),
  last_message_at timestamp with time zone NOT NULL DEFAULT now(),
  runtime_state jsonb NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  chat_title text,
  CONSTRAINT telegram_runtime_state_pkey PRIMARY KEY (id)
);
CREATE TABLE public.news_items (
  id integer NOT NULL DEFAULT nextval('news_items_id_seq'::regclass),
  source_url text UNIQUE,
  title text,
  published_at timestamp with time zone,
  processed_at timestamp without time zone,
  summary text,
  source_id bigint,
  content text,
  language character varying,
  status character varying DEFAULT 'new'::character varying,
  content_hash character varying,
  created_at timestamp with time zone DEFAULT now(),
  ai_processed boolean DEFAULT false,
  raw_description text,
  content_loaded boolean DEFAULT false,
  content_extracted_at timestamp without time zone,
  CONSTRAINT news_items_pkey PRIMARY KEY (id),
  CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES public.news_sources(id)
);
CREATE TABLE public.news_sources (
  id bigint NOT NULL DEFAULT nextval('news_sources_id_seq'::regclass),
  name text NOT NULL,
  source_type text NOT NULL,
  url text NOT NULL,
  enabled boolean DEFAULT true,
  priority integer DEFAULT 100,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT news_sources_pkey PRIMARY KEY (id)
);
CREATE TABLE public.target_chats (
  id integer NOT NULL DEFAULT nextval('target_chats_id_seq'::regclass),
  telegram_chat_id bigint NOT NULL UNIQUE,
  chat_name character varying NOT NULL,
  languages jsonb NOT NULL,
  message_mode character varying NOT NULL DEFAULT 'combined'::character varying,
  active boolean NOT NULL DEFAULT true,
  created_at timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT target_chats_pkey PRIMARY KEY (id)
);
CREATE TABLE public.processed_messages (
  source_chat_id bigint NOT NULL,
  source_message_id bigint NOT NULL,
  processed_at timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT processed_messages_pkey PRIMARY KEY (source_chat_id, source_message_id)
);