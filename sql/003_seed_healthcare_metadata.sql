WITH healthcare_domain AS (
    INSERT INTO domains (name, description)
    VALUES (
        'Healthcare',
        'A domain covering population health outcomes, healthcare access, healthcare capacity, and health-related public expenditure.'
    )
    RETURNING id
)
INSERT INTO metrics (
    domain_id,
    name,
    definition,
    unit,
    direction,
    frequency
)
SELECT
    id,
    'Infant Mortality Rate',
    'Ratio of the number of infant deaths (deaths of children below one year) in a year to the number of live births in that year.',
    'Deaths per 1,000 live births',
    'LOWER_IS_BETTER',
    'YEAR'
FROM healthcare_domain;
