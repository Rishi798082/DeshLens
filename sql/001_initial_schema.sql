-- DeshLens V0.1 core data model. This migration creates only source facts and metadata.

CREATE TABLE domains (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL CHECK (btrim(name) <> ''),
    description text NOT NULL CHECK (btrim(description) <> ''),
    CONSTRAINT uq_domains_name UNIQUE (name)
);

CREATE TABLE metrics (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    domain_id bigint NOT NULL REFERENCES domains (id) ON DELETE RESTRICT,
    name text NOT NULL CHECK (btrim(name) <> ''),
    definition text NOT NULL CHECK (btrim(definition) <> ''),
    unit text NOT NULL CHECK (btrim(unit) <> ''),
    direction text NOT NULL CHECK (direction IN (
        'HIGHER_IS_BETTER',
        'LOWER_IS_BETTER',
        'NEUTRAL'
    )),
    frequency text NOT NULL CHECK (btrim(frequency) <> ''),
    CONSTRAINT uq_metrics_domain_name UNIQUE (domain_id, name)
);

-- Geography is normalized so facts reference one reusable, hierarchical geography record.
CREATE TABLE geographies (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL CHECK (btrim(name) <> ''),
    type text NOT NULL CHECK (type IN ('COUNTRY', 'STATE_UT', 'CITY', 'DISTRICT')),
    parent_id bigint REFERENCES geographies (id) ON DELETE RESTRICT,
    CONSTRAINT chk_geographies_root_parent CHECK (
        (type = 'COUNTRY' AND parent_id IS NULL)
        OR (type <> 'COUNTRY' AND parent_id IS NOT NULL)
    ),
    CONSTRAINT chk_geographies_not_own_parent CHECK (parent_id IS NULL OR parent_id <> id),
    CONSTRAINT uq_geographies_parent_type_name UNIQUE (parent_id, type, name)
);

CREATE UNIQUE INDEX uq_geographies_single_country
    ON geographies (type)
    WHERE type = 'COUNTRY';

CREATE TABLE sources (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    publisher text NOT NULL CHECK (btrim(publisher) <> ''),
    title text NOT NULL CHECK (btrim(title) <> ''),
    source_url text,
    source_reference text,
    publication_date date,
    release_date date,
    release_version text,
    coverage text,
    reliability_metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    methodology text,
    CONSTRAINT chk_sources_url_or_reference CHECK (
        NULLIF(btrim(source_url), '') IS NOT NULL
        OR NULLIF(btrim(source_reference), '') IS NOT NULL
    )
);

CREATE TABLE observations (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    metric_id bigint NOT NULL REFERENCES metrics (id) ON DELETE RESTRICT,
    geography_id bigint NOT NULL REFERENCES geographies (id) ON DELETE RESTRICT,
    period_start date NOT NULL,
    period_end date NOT NULL,
    time_granularity text NOT NULL CHECK (time_granularity IN (
        'YEAR',
        'QUARTER',
        'MONTH',
        'FISCAL_YEAR'
    )),
    -- Numeric storage keeps facts machine-readable; presentation formatting belongs in the application.
    value numeric,
    source_id bigint NOT NULL REFERENCES sources (id) ON DELETE RESTRICT,
    quality_status text NOT NULL CHECK (quality_status IN (
        'VALIDATED',
        'PROVISIONAL',
        'REVISED',
        'MISSING',
        'REJECTED'
    )),
    notes text,
    CONSTRAINT chk_observations_period_order CHECK (period_start <= period_end),
    CONSTRAINT chk_observations_value_for_quality CHECK (
        (quality_status = 'MISSING' AND value IS NULL)
        OR (quality_status <> 'MISSING' AND value IS NOT NULL)
    ),
    -- source_id is included so competing authoritative estimates can coexist.
    CONSTRAINT uq_observations_metric_geography_period_source UNIQUE (
        metric_id,
        geography_id,
        period_start,
        period_end,
        source_id
    )
);

-- The unique observation key supports metric and metric/geography/period lookups.
CREATE INDEX idx_observations_geography_id
    ON observations (geography_id);

CREATE INDEX idx_observations_period_start_end
    ON observations (period_start, period_end);

CREATE INDEX idx_observations_source_id
    ON observations (source_id);
