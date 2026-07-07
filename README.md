# Comarch News Intelligence Mini

## Purpose

Telegram AI agent that republishes messages from one Telegram group to one or more destination groups.

## MVP features

- Read source Telegram group
- Detect new posts
- Publish original message to destination groups
- Preserve original language
- Add link to original message (when available)

## Technology Stack

- n8n 2.25.7
- PostgreSQL
- Telegram Bot API
- OpenAI API

## Repository Structure

- docs/architecture/ — architecture notes
- docs/api/ — API documentation
- docs/decisions/ — design decisions
- n8n/workflows/ — workflow definitions
- n8n/credentials/ — credentials placeholders
- sql/ — database SQL scripts
- scripts/ — helper scripts
- .github/workflows/ — CI workflows

## Project Status

MVP
