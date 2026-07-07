# Comarch News Intelligence Mini

## Purpose

Telegram AI agent for automatic distribution of messages from one source Telegram group to one or more destination Telegram groups.

## MVP Scope

The MVP includes:

- Receive Telegram messages.
- Avoid duplicate processing.
- Store processing state in PostgreSQL.
- Publish original messages.
- Preserve the original message language.
- Prepare message context for one or more target Telegram chats.

The MVP does not include:

- Translation.
- AI message transformation.
- AI classification.
- Moderation.
- Scheduling.

## Technology Stack

- n8n 2.25.7
- PostgreSQL
- Telegram Bot API
- OpenAI API, reserved for future use

## Repository Structure

- `docs/` - project documentation, including architecture, API notes, decisions, and specifications.
- `n8n/` - n8n configuration assets, including workflow definitions and credential placeholders.
- `sql/` - database SQL scripts.
- `scripts/` - helper scripts.
- `.github/workflows/` - CI workflow definitions.

## Database

The existing database schema is documented as-is and is not changed by this architecture document.

- `news_sources` - stores configured news sources, including source type, URL, enabled state, and priority.
- `news_items` - stores news items and processing metadata, including source URL, title, content, language, status, and AI-related flags reserved for later processing.
- `target_chats` - stores destination Telegram chats, supported languages, message mode, and active state.
- `processed_messages` - stores processed Telegram message identifiers by source chat and source message ID to prevent duplicate processing.

## Workflows

### 01 Source Listener

The existing source listener workflow is defined in `n8n/workflows/CNI - Source Listener.json`.

Current workflow:

```text
Telegram Trigger
|
Register Processing
|
Duplicate Check
|
Load Target Chats
|
Prepare Message Context
```

Implementation mapping:

- `Telegram Trigger` receives source Telegram messages.
- `Dedup` registers the message in `processed_messages` with `ON CONFLICT DO NOTHING`.
- `If` performs the duplicate check based on whether the insert returned a message identifier.
- `Get Target Chats` loads active destination chats from `target_chats`.
- `Build Context` prepares the source message, source identifiers, target chats, and language list for distribution.

The workflow is documented only. The JSON workflow is not changed.

## Message Lifecycle

```text
Telegram
|
Trigger
|
Duplicate check
|
Target chat loading
|
Context preparation
|
Ready for distribution
```

Message lifecycle:

1. A message is received from Telegram by the Telegram Trigger.
2. The message source chat ID and source message ID are inserted into `processed_messages`.
3. PostgreSQL prevents duplicate processing through the `processed_messages` primary key.
4. Only newly registered messages continue through the workflow.
5. Active target chats are loaded from `target_chats`.
6. Message context is prepared for downstream distribution.
7. The original message is ready for publication to destination chats.

## Future Extensions

The following capabilities are possible future extensions and are not part of the MVP:

- AI classification.
- Translation.
- AI message transformation.
- Moderation.
- Scheduling.
- Destination-specific formatting.
- Routing rules per target chat.
