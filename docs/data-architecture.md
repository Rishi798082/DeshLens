# Data Architecture

## 1. Purpose and design principles

This architecture supports the V0.1 healthcare vertical slice while providing one extensible model for all 14 DeshLens domains. It is designed for decision intelligence: source facts, deterministic derived analysis, model output, and AI interpretation remain distinct. Important calculations are performed by application services and analytics tools, not invented by an LLM. Every published metric remains traceable to its definition, unit, geography, period, source, and methodology.

## 2. Geography model

The primary product hierarchy is **Country → State/UT → City**. Districts are supported only as a fallback when State/UT or City data is unavailable. A normalized `geographies` table represents the hierarchy:

| Field | Meaning |
| --- | --- |
| `id` | Stable geography identifier |
| `name` | Official or canonical display name |
| `type` | `COUNTRY`, `STATE_UT`, `CITY`, or `DISTRICT` |
| `parent_id` | Parent `geographies.id`; `NULL` for Country |

`parent_id` enables geographic roll-up and filtering without duplicating geography attributes in facts. Geography naming and boundary methodology must be retained in associated source or metadata records when relevant.

## 3. Source model

Country-level summaries prioritize authoritative international or global sources. State/UT and city-level observations prioritize Indian government bodies and institutions. District observations must use official or otherwise authoritative sources.

The `sources` table records the publisher, source title, URL or reference, publication/release details, coverage, reliability metadata, and applicable methodology. New releases and competing estimates are retained as separately attributable observations; they must not silently overwrite one another.

## 4. Domain and metric model

`domains` is the controlled catalogue of domains, beginning with healthcare. `metrics` is the controlled catalogue of measurable indicators and links each metric to one domain. A metric records at least its name, definition, unit, direction, and expected frequency.

Allowed direction values are `HIGHER_IS_BETTER`, `LOWER_IS_BETTER`, and `NEUTRAL`. Direction expresses interpretation for comparison; it does not alter the stored value or replace a documented methodology.

## 5. Observation model

`observations` is the normalized fact table. One observation represents:

```text
metric × geography × period × source × value
```

`value` is numeric. Units belong to the metric definition, so values are not formatted strings such as `"28.4%"`. The observation’s uniqueness includes `source` because two authoritative publishers can report differing, valid estimates for the same metric, geography, and period. Where a source has multiple releases or revisions, its release/version identity must also participate in the business uniqueness rule.

## 6. Time representation

Each observation records `period_start`, `period_end`, and `time_granularity`. This supports annual, quarterly, monthly, and fiscal-year-style reporting periods without encoding dates into metric names. A fiscal-year-style period uses its actual start and end dates plus a granularity/value that identifies the reporting convention.

## 7. Provenance

Every observation must be traceable to its source, metric definition, unit, geography, period, and methodology. The source record identifies the publisher and release; metric and source metadata document definitions and methods; the observation links the exact fact to all applicable context. Provenance is returned with results, not treated as optional display-only metadata.

## 8. Data quality

Observations carry a quality status to distinguish validated, provisional, revised, missing, or rejected data. Missing values are represented explicitly rather than as zero. Ingestion validates numeric type, unit compatibility, period bounds, geography linkage, and required provenance. Suspicious or outlier values are flagged for review without changing the source value. Source reliability metadata captures authority, methodology transparency, timeliness, and known limitations.

## 9. Fact and analytical layers

| Layer | Location and role |
| --- | --- |
| **FACT** | Core `observations`: source-attributed numeric measurements. |
| **DERIVED ANALYSIS** | Separate deterministic analytical outputs, reproducible from documented inputs and methodology. |
| **MODEL/FORECAST** | Separate model-output records with model version, assumptions, inputs, and forecast horizon. |
| **AI INTERPRETATION** | Application/AI-layer explanations that cite facts and deterministic results; never stored as authoritative observations. |

Only FACT belongs in the core observations model. Derived results, forecasts, and interpretations must retain their own provenance and must not overwrite source facts.

## 10. Competing sources and duplicate handling

Observations from distinct sources remain separate even when they describe the same metric, geography, and period. Exact duplicates from the same source and release are prevented by the business uniqueness rule. Application query policy may select a preferred source using documented authority, methodology, recency, and coverage criteria, while preserving alternative estimates for inspection and comparison.

## 11. Query and visualization contract

Application services expose a standardized result shape:

```text
metric, geography, period, value
```

The response also carries provenance and quality metadata. This shared shape drives KPI cards (latest value), line charts (period series), bar charts (geography comparison), maps (geography-value pairs), rankings (sorted comparable observations), and tables. Visualization transforms must not discard units, source selection, period context, or quality status.

## 12. Initial five core tables

| Table | Purpose |
| --- | --- |
| `domains` | Controlled list of governance domains. |
| `metrics` | Metric catalogue, definition, unit, direction, frequency, and domain link. |
| `geographies` | Normalized Country, State/UT, City, and fallback District hierarchy. |
| `sources` | Publisher, release, methodology, coverage, and reliability metadata. |
| `observations` | Source-attributed numeric facts by metric, geography, and period. |

These are logical table definitions only; no SQL schema is defined in this document.

## 13. Future extensibility

Healthcare is represented as a domain and its measures as metrics, not as healthcare-specific physical tables. Education, economic performance, employment and income, infrastructure, business and investment, agriculture, poverty and inclusion, safety and justice, environment, urban development, governance and public finance, quality of life, demographics, and further domains use the same `domains`, `metrics`, `geographies`, `sources`, and `observations` model. This keeps cross-domain comparisons, shared provenance rules, and application contracts consistent without creating separate tables such as `healthcare`, `education`, or `economy`.
