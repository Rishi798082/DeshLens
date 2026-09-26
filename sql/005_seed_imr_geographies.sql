BEGIN;

WITH india AS (
    INSERT INTO geographies (name, type, parent_id)
    VALUES ('India', 'COUNTRY', NULL)
    RETURNING id
)
INSERT INTO geographies (name, type, parent_id)
SELECT state_ut.name, 'STATE_UT', india.id
FROM india
CROSS JOIN (
    VALUES
        ('Andaman & Nicobar Islands'),
        ('Andhra Pradesh'),
        ('Arunachal Pradesh'),
        ('Assam'),
        ('Bihar'),
        ('Chandigarh'),
        ('Chhattisgarh'),
        ('Dadra & Nagar Haveli'),
        ('Dadra & Nagar Haveli and Daman & Diu'),
        ('Daman & Diu'),
        ('Goa'),
        ('Gujarat'),
        ('Haryana'),
        ('Himachal Pradesh'),
        ('Jammu & Kashmir'),
        ('Jharkhand'),
        ('Karnataka'),
        ('Kerala'),
        ('Ladakh'),
        ('Lakshadweep'),
        ('Madhya Pradesh'),
        ('Maharashtra'),
        ('Manipur'),
        ('Meghalaya'),
        ('Mizoram'),
        ('NCT of Delhi'),
        ('Nagaland'),
        ('Odisha'),
        ('Puducherry'),
        ('Punjab'),
        ('Rajasthan'),
        ('Sikkim'),
        ('Tamil Nadu'),
        ('Telangana'),
        ('Tripura'),
        ('Uttar Pradesh'),
        ('Uttarakhand'),
        ('West Bengal')
) AS state_ut (name);

COMMIT;
