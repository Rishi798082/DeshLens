ALTER TABLE observations
    DROP CONSTRAINT observations_time_granularity_check;

ALTER TABLE observations
    ADD CONSTRAINT chk_observations_time_granularity CHECK (
        time_granularity IN (
            'YEAR',
            'QUARTER',
            'MONTH',
            'FISCAL_YEAR',
            'MULTI_YEAR'
        )
    );
