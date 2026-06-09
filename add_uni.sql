DROP TABLE IF EXISTS universities;

CREATE TABLE universities (
    id BIGSERIAL PRIMARY KEY,
    qs_rank TEXT,
    country_territory TEXT,
    region TEXT,
    name TEXT NOT NULL,
    description TEXT,
    country TEXT,
    city TEXT,
    latitude NUMERIC(12, 9),
    longitude NUMERIC(12, 9),
    website TEXT,
    image_url TEXT,
    institution_profile TEXT,
    teaching_languages TEXT
);

COPY universities(
    qs_rank,
    country_territory,
    region,
    name,
    description,
    country,
    city,
    latitude,
    longitude,
    website,
    image_url,
    institution_profile,
    teaching_languages
)
FROM 'C:\Julia\studymap\uniwersytety_europa.csv'
DELIMITER ';'
CSV HEADER;

CREATE INDEX idx_universities_country ON universities(country);
CREATE INDEX idx_universities_name ON universities(name);
CREATE INDEX idx_universities_rank ON universities(qs_rank);