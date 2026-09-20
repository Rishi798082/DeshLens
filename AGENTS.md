# DeshLens Project Rules

## Product

DeshLens is a Governance Intelligence / Decision Intelligence platform for India. It will support evidence-based analysis for Indian states, districts, and cities. Begin with a healthcare vertical slice; do not build application features unless explicitly requested.

## Frozen technology architecture

- Frontend: Next.js, React, TypeScript, Tailwind CSS, Apache ECharts, Leaflet
- Backend: Python 3.14, FastAPI, PydanticAI
- Data: PostgreSQL, pgvector, Pandas, Polars, DuckDB
- AI: PydanticAI, Ollama, Qwen3 4B, EmbeddingGemma
- Infrastructure: Docker / Docker Compose, Git / GitHub

Do not introduce CrewAI, LangGraph, LangChain, Dify, Langflow, PySpark/Spark, Kubernetes, Kafka, Pinecone, Weaviate, or unnecessary microservices. Prefer a modular monolith.

## Engineering principles

1. Build decision intelligence, not merely dashboards.
2. Keep raw facts, derived analysis, model output, and AI interpretation distinguishable.
3. Perform important calculations deterministically with application and data tools; do not have an LLM invent them.
4. Preserve metric provenance: definition, unit, geography, period, source, and methodology.
5. Do not create a single opaque governance score. Domain and optional composite scores require transparent methodology and configurable weights.
6. Use AI to orchestrate tools and explain results, never as the authoritative source of truth.
7. Keep dependencies minimal and do not split the modular monolith into unnecessary services.
8. Do not overwrite or modify the existing `frontend/` application unless necessary for an explicitly requested task.
