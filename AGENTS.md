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

## Responsive frontend requirements

1. DeshLens must be a responsive web application usable on mobile, tablet, and desktop.
2. Frontend layouts must adapt across three primary viewport classes:
   - Mobile
   - Tablet
   - Desktop
3. Do not build separate mobile and desktop applications.
4. Use responsive layouts rather than fixed-width interfaces.
5. Dashboards, charts, maps, filters, tables, navigation, and interactive controls must remain usable on smaller screens.
6. Mobile layouts may change the presentation and interaction pattern rather than simply shrinking the desktop layout.
7. Use Tailwind CSS responsive utilities and standard responsive design practices.
8. Apache ECharts and Leaflet visualizations must resize correctly with their containers.
9. Touch interaction must be considered for mobile and tablet interfaces.
10. Responsive behavior must be tested at representative mobile, tablet, and desktop viewport sizes before a frontend feature is considered complete.
11. Do not introduce a separate mobile framework or native mobile application unless explicitly requested.