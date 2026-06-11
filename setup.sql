-- BLOK 1: Tabela universities
DROP TABLE IF EXISTS universities CASCADE;

CREATE TABLE universities (
    id                  BIGSERIAL PRIMARY KEY,
    qs_rank             TEXT,
    country_territory   TEXT,
    region              TEXT,
    name                TEXT NOT NULL,
    description         TEXT,
    country             TEXT,
    city                TEXT,
    latitude            NUMERIC(12,9),
    longitude           NUMERIC(12,9),
    website             TEXT,
    image_url           TEXT,
    institution_profile TEXT,
    teaching_languages  TEXT,
    cost_city           TEXT,
    costs_country       TEXT
);


-- BLOK 2: Tabela living_costs
DROP TABLE IF EXISTS living_costs CASCADE;

CREATE TABLE living_costs (
    cost_city               TEXT NOT NULL,
    costs_country           TEXT NOT NULL,
    rent_1br_pln            INTEGER,
    food_monthly_pln        INTEGER,
    utilities_monthly_pln   INTEGER,
    transport_monthly_pln   INTEGER,
    total_monthly_pln       INTEGER,
    avg_salary_pln          INTEGER,
    rent_to_salary_pct      NUMERIC(5,1),
    data_source             TEXT,
    PRIMARY KEY (cost_city, costs_country)
);


-- BLOK 3: Import danych
-- Wykonaj każdą linię \copy OSOBNO w PSQL Tool (jedna linia = jeden Enter)
-- Podmień <TwojaNazwa> na nazwę swojego użytkownika Windows

\copy universities(id, qs_rank, country_territory, region, name, description, country, city, latitude, longitude, website, image_url, institution_profile, teaching_languages, cost_city, costs_country) FROM 'C:\Users\<TwojaNazwa>\Desktop\universities.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')

\copy living_costs FROM 'C:\Users\<TwojaNazwa>\Desktop\living_costs.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')


-- BLOK 4: Sekwencja id (żeby kolejne INSERT-y działały poprawnie)
SELECT setval('universities_id_seq', (SELECT MAX(id) FROM universities));


-- BLOK 5: Indeksy
CREATE INDEX IF NOT EXISTS idx_universities_cost     ON universities (cost_city, costs_country);
CREATE INDEX IF NOT EXISTS idx_universities_country  ON universities (country);
CREATE INDEX IF NOT EXISTS idx_universities_city     ON universities (city);
CREATE INDEX IF NOT EXISTS idx_living_costs_country  ON living_costs (costs_country);


-- BLOK 6: Weryfikacja - powinno zwrócić ~450 uczelni i ~247 wierszy kosztów
SELECT 'universities' AS tabela, COUNT(*) AS wiersze FROM universities
UNION ALL
SELECT 'living_costs', COUNT(*) FROM living_costs;

-- Test JOIN
SELECT u.name, u.city, lc.total_monthly_pln
FROM universities u
JOIN living_costs lc ON lc.cost_city = u.cost_city AND lc.costs_country = u.costs_country
WHERE u.country = 'Polska'
ORDER BY lc.total_monthly_pln
LIMIT 5;