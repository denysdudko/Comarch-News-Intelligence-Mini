# Database Schema

## Overview

The database stores the MVP processing state for Comarch News Intelligence Mini. It keeps configured news sources, source news items, target Telegram chats, and processed Telegram message identifiers used to avoid duplicate processing.

The schema below reflects the SQL files currently present in `sql/`.

## Tables

## target_chats

Purpose:
Stores the Telegram groups where original messages are published.

Primary Key:
- `id`

Columns:

| Column | Type | Description |
|--------|------|-------------|
| id | integer | Internal target chat identifier. |
| telegram_chat_id | bigint | Telegram Chat ID. |
| chat_name | character varying | Display name for the target chat. |
| languages | jsonb | Configured languages for the target chat. |
| message_mode | character varying | Publishing mode. Defaults to `combined`. |
| active | boolean | Enables or disables the target chat. |
| created_at | timestamp without time zone | Creation timestamp. |

## processed_messages

Purpose:
Stores source Telegram messages that were already registered for processing, preventing duplicate processing.

Primary Key:
- `source_chat_id`
- `source_message_id`

Columns:

| Column | Type | Description |
|--------|------|-------------|
| source_chat_id | bigint | Telegram Chat ID of the source chat. |
| source_message_id | bigint | Telegram message ID in the source chat. |
| processed_at | timestamp without time zone | Timestamp when the message was registered as processed. |

## news_sources

Purpose:
Stores configured news sources that can provide content for processing.

Primary Key:
- `id`

Columns:

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Internal news source identifier. |
| name | text | Source display name. |
| source_type | text | Type of source. |
| url | text | Source URL. |
| enabled | boolean | Enables or disables the source. |
| priority | integer | Source priority. Defaults to `100`. |
| created_at | timestamp with time zone | Creation timestamp. |

## news_items

Purpose:
Stores news items and their processing metadata.

Primary Key:
- `id`

Columns:

| Column | Type | Description |
|--------|------|-------------|
| id | integer | Internal news item identifier. |
| source_url | text | Original source URL. Must be unique when present. |
| title | text | News item title. |
| published_at | timestamp with time zone | Original publication timestamp. |
| processed_at | timestamp without time zone | Processing timestamp. |
| summary | text | Summary content. |
| source_id | bigint | Reference to the source in `news_sources`. |
| content | text | Full or extracted content. |
| language | character varying | Content language. |
| status | character varying | Processing status. Defaults to `new`. |
| content_hash | character varying | Content hash for comparison or deduplication. |
| created_at | timestamp with time zone | Creation timestamp. |
| ai_processed | boolean | Indicates whether AI processing was completed. Defaults to `false`. |
| raw_description | text | Raw source description. |
| content_loaded | boolean | Indicates whether content was loaded. Defaults to `false`. |
| content_extracted_at | timestamp without time zone | Timestamp when content extraction occurred. |

## telegram_runtime_state

Purpose:
Stores Telegram runtime state for chat/user interactions.

Primary Key:
- `id`

Columns:

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Internal runtime state identifier. |
| chat_id | bigint | Telegram Chat ID. |
| user_id | bigint | Telegram user ID. |
| user_name | text | Telegram user name. |
| user_language | character varying | User language. |
| status | character varying | Runtime status. Defaults to `waiting`. |
| queue_version | integer | Queue version. Defaults to `1`. |
| expert_replied | boolean | Indicates whether an expert replied. Defaults to `false`. |
| queue_started_at | timestamp with time zone | Timestamp when the queue state started. |
| last_message_at | timestamp with time zone | Timestamp of the last message. |
| runtime_state | jsonb | Runtime state payload. |
| created_at | timestamp with time zone | Creation timestamp. |
| updated_at | timestamp with time zone | Last update timestamp. |
| chat_title | text | Telegram chat title. |

## Relationships

- `news_items.source_id` references `news_sources.id`.
- `processed_messages` has no foreign key relationships in the current SQL schema.
- `target_chats` has no foreign key relationships in the current SQL schema.
- `telegram_runtime_state` has no foreign key relationships in the current SQL schema.

## Notes

- This schema documentation corresponds to the current MVP SQL files in the repository.
- Any database schema changes should be made in the repository SQL files first, then reflected in this document.
- This document does not change SQL files, table structures, n8n workflows, or README.
