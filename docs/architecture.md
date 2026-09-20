# Architecture

DeshLens is a modular monolith. It keeps application concerns in one coherent backend while separating responsibilities through modules and clear data contracts.

```text
Next.js frontend
        ↓
FastAPI backend
        ↓
application services
        ↓
PostgreSQL / pgvector
        ↓
data pipelines and analytics
```

The frontend presents sourced facts, deterministic analysis, model outputs, and AI interpretation as distinct categories. Application services own business rules, provenance handling, deterministic calculations, and access to data and analytics outputs.

Data pipelines ingest and prepare source material. Analytics uses Pandas, Polars, and DuckDB for deterministic transformations and calculations. PostgreSQL is the operational data store, while pgvector supports retrieval where needed.

PydanticAI and Ollama sit within the application/AI layer. They call deterministic application tools for evidence and calculations, then explain those tool results. AI output is never the authoritative source for a metric or calculation.

The initial healthcare slice establishes these patterns before the platform expands to additional governance domains.
