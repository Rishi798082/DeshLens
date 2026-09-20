# DeshLens

DeshLens is a Governance Intelligence / Decision Intelligence platform for India. It is being designed to help users understand and act on reliable, traceable evidence about Indian states, districts, and cities.

## Goals

- Turn public governance data into transparent, decision-ready analysis.
- Preserve the distinction between source facts, deterministic analysis, model output, and AI interpretation.
- Maintain provenance for every metric: definition, unit, geography, period, source, and methodology.
- Use AI to orchestrate approved tools and explain results, while keeping calculations deterministic and auditable.

## Frozen technology stack

- Frontend: Next.js, React, TypeScript, Tailwind CSS, Apache ECharts, Leaflet
- Backend: Python 3.14, FastAPI, PydanticAI
- Data: PostgreSQL, pgvector, Pandas, Polars, DuckDB
- AI: PydanticAI, Ollama, Qwen3 4B, EmbeddingGemma
- Infrastructure: Docker / Docker Compose, Git / GitHub

## High-level architecture

The Next.js frontend communicates with a FastAPI modular-monolith backend. Backend application services use PostgreSQL / pgvector and receive curated inputs from data pipelines and analytics. PydanticAI and Ollama reside in the application/AI layer, where they use deterministic application tools to retrieve and explain evidence.

See [architecture documentation](docs/architecture.md) and the [development guide](docs/development-guide.md).

## V0.1: healthcare vertical slice

The first product slice will focus on healthcare intelligence. It will establish the project’s patterns for provenance, deterministic metrics and analysis, transparent AI explanations, and geographic comparisons before expanding to other governance domains.
