-- ========================
-- TABELA PARTNERÓW
-- ========================
CREATE TABLE IF NOT EXISTS partners (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    icon VARCHAR(10) NOT NULL,
    country TEXT,  -- NULL = globalny (widoczny dla wszystkich krajów)
    url TEXT,
    description TEXT
);

-- ========================
-- TABELA AKADEMIKÓW
-- ========================
CREATE TABLE IF NOT EXISTS dormitories (
    id SERIAL PRIMARY KEY,
    university_id INTEGER REFERENCES universities(id) ON DELETE CASCADE,
    name VARCHAR(150) NOT NULL,
    latitude NUMERIC(12,9) NOT NULL,
    longitude NUMERIC(12,9) NOT NULL
);

-- ========================
-- PARTNERZY GLOBALNI (country = NULL)
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('Revolut', 'Konto walutowe', '💳', NULL, 'https://revolut.com', 'Konto bankowe bez opłat za przewalutowanie'),
('HousingAnywhere', 'Zakwaterowanie', '🏠', NULL, 'https://housinganywhere.com', 'Wynajem mieszkań dla studentów w całej Europie'),
('Allianz', 'Ubezpieczenie', '🛡️', NULL, 'https://allianz.com', 'Ubezpieczenie zdrowotne i podróżne dla studentów'),
('Uniplaces', 'Zakwaterowanie', '🏠', NULL, 'https://uniplaces.com', 'Platforma wynajmu mieszkań studenckich'),
('Basic-Fit', 'Siłownia', '🏋️', NULL, 'https://basic-fit.com', 'Sieć siłowni dostępna w całej Europie');

-- ========================
-- POLSKA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('Furgonetka', 'Przeprowadzka', '🚚', 'Polska', 'https://furgonetka.pl', 'Usługi kurierskie i przeprowadzkowe'),
('PKO Bank Polski', 'Konto walutowe', '💳', 'Polska', 'https://pkobp.pl', 'Konto studenckie bez opłat'),
('PZU', 'Ubezpieczenie', '🛡️', 'Polska', 'https://pzu.pl', 'Ubezpieczenie NNW dla studentów'),
('Student Depot', 'Zakwaterowanie', '🏠', 'Polska', 'https://studentdepot.pl', 'Akademiki prywatne w Polsce');

-- ========================
-- NIEMCY
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('N26', 'Konto walutowe', '💳', 'Niemcy', 'https://n26.com', 'Konto bankowe online dla studentów'),
('Movinga', 'Przeprowadzka', '🚚', 'Niemcy', 'https://movinga.de', 'Usługi przeprowadzkowe w Niemczech'),
('ERGO', 'Ubezpieczenie', '🛡️', 'Niemcy', 'https://ergo.de', 'Ubezpieczenie zdrowotne dla studentów zagranicznych'),
('Studentenwerk', 'Zakwaterowanie', '🏠', 'Niemcy', 'https://studentenwerk.de', 'Oficjalne akademiki studenckie w Niemczech');

-- ========================
-- WIELKA BRYTANIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('Monzo', 'Konto walutowe', '💳', 'Wielka Brytania', 'https://monzo.com', 'Konto bankowe bez opłat dla studentów'),
('AnyVan', 'Przeprowadzka', '🚚', 'Wielka Brytania', 'https://anyvan.com', 'Usługi przeprowadzkowe w Wielkiej Brytanii'),
('Student Cribs', 'Zakwaterowanie', '🏠', 'Wielka Brytania', 'https://studentcribs.com', 'Wynajem pokoi i mieszkań studenckich'),
('Endsleigh', 'Ubezpieczenie', '🛡️', 'Wielka Brytania', 'https://endsleigh.co.uk', 'Ubezpieczenie dedykowane studentom w UK');

-- ========================
-- FRANCJA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('BNP Paribas', 'Konto walutowe', '💳', 'Francja', 'https://bnpparibas.fr', 'Konto studenckie we Francji'),
('Déménager Facile', 'Przeprowadzka', '🚚', 'Francja', 'https://demenagerfacile.com', 'Usługi przeprowadzkowe we Francji'),
('AXA', 'Ubezpieczenie', '🛡️', 'Francja', 'https://axa.fr', 'Ubezpieczenie zdrowotne dla studentów'),
('Lokaviz', 'Zakwaterowanie', '🏠', 'Francja', 'https://lokaviz.fr', 'Akademiki i mieszkania studenckie we Francji');

-- ========================
-- HISZPANIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('BBVA', 'Konto walutowe', '💳', 'Hiszpania', 'https://bbva.es', 'Konto studenckie bez opłat'),
('Mutua Madrileña', 'Ubezpieczenie', '🛡️', 'Hiszpania', 'https://mutua.es', 'Ubezpieczenie zdrowotne w Hiszpanii'),
('Spotahome', 'Zakwaterowanie', '🏠', 'Hiszpania', 'https://spotahome.com', 'Wynajem mieszkań studenckich w Hiszpanii'),
('MudanzasNow', 'Przeprowadzka', '🚚', 'Hiszpania', 'https://mudanzasnow.com', 'Usługi przeprowadzkowe w Hiszpanii');

-- ========================
-- WŁOCHY
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('UnipolSai', 'Ubezpieczenie', '🛡️', 'Włochy', 'https://unipol.it', 'Ubezpieczenie dla studentów zagranicznych we Włoszech'),
('Intesa Sanpaolo', 'Konto walutowe', '💳', 'Włochy', 'https://intesasanpaolo.com', 'Konto studenckie we Włoszech'),
('Erasmusu', 'Zakwaterowanie', '🏠', 'Włochy', 'https://erasmusu.com', 'Wynajem pokoi studenckich we Włoszech'),
('Traslochi Italia', 'Przeprowadzka', '🚚', 'Włochy', 'https://traslochiitalia.it', 'Usługi przeprowadzkowe we Włoszech');

-- ========================
-- HOLANDIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('ABN AMRO', 'Konto walutowe', '💳', 'Holandia', 'https://abnamro.nl', 'Konto studenckie w Holandii'),
('SSH Student Housing', 'Zakwaterowanie', '🏠', 'Holandia', 'https://sshxl.nl', 'Oficjalne akademiki studenckie w Holandii'),
('Centraal Beheer', 'Ubezpieczenie', '🛡️', 'Holandia', 'https://centraalbeheer.nl', 'Ubezpieczenie dla studentów zagranicznych');

-- ========================
-- SZWAJCARIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('UBS', 'Konto walutowe', '💳', 'Szwajcaria', 'https://ubs.com', 'Konto bankowe dla studentów w Szwajcarii'),
('Helvetia', 'Ubezpieczenie', '🛡️', 'Szwajcaria', 'https://helvetia.com', 'Ubezpieczenie zdrowotne w Szwajcarii'),
('Woko', 'Zakwaterowanie', '🏠', 'Szwajcaria', 'https://woko.ch', 'Akademiki studenckie w Szwajcarii');

-- ========================
-- AUSTRIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('Raiffeisen', 'Konto walutowe', '💳', 'Austria', 'https://raiffeisen.at', 'Konto studenckie w Austrii'),
('UNIQA', 'Ubezpieczenie', '🛡️', 'Austria', 'https://uniqa.at', 'Ubezpieczenie zdrowotne dla studentów'),
('OeAD Housing', 'Zakwaterowanie', '🏠', 'Austria', 'https://housing.oead.at', 'Akademiki studenckie w Austrii');

-- ========================
-- BELGIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('KBC', 'Konto walutowe', '💳', 'Belgia', 'https://kbc.be', 'Konto studenckie w Belgii'),
('AG Insurance', 'Ubezpieczenie', '🛡️', 'Belgia', 'https://aginsurance.be', 'Ubezpieczenie dla studentów w Belgii'),
('Kotatgent', 'Zakwaterowanie', '🏠', 'Belgia', 'https://kotatgent.be', 'Wynajem pokoi studenckich w Belgii');

-- ========================
-- SZWECJA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('Nordea', 'Konto walutowe', '💳', 'Szwecja', 'https://nordea.se', 'Konto studenckie w Szwecji'),
('Folksam', 'Ubezpieczenie', '🛡️', 'Szwecja', 'https://folksam.se', 'Ubezpieczenie dla studentów w Szwecji'),
('SSSB', 'Zakwaterowanie', '🏠', 'Szwecja', 'https://sssb.se', 'Akademiki studenckie w Sztokholmie');

-- ========================
-- NORWEGIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('DNB', 'Konto walutowe', '💳', 'Norwegia', 'https://dnb.no', 'Konto studenckie w Norwegii'),
('Gjensidige', 'Ubezpieczenie', '🛡️', 'Norwegia', 'https://gjensidige.no', 'Ubezpieczenie dla studentów w Norwegii'),
('SiO Housing', 'Zakwaterowanie', '🏠', 'Norwegia', 'https://sio.no', 'Akademiki studenckie w Oslo');

-- ========================
-- DANIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('Danske Bank', 'Konto walutowe', '💳', 'Dania', 'https://danskebank.dk', 'Konto studenckie w Danii'),
('Tryg', 'Ubezpieczenie', '🛡️', 'Dania', 'https://tryg.dk', 'Ubezpieczenie dla studentów w Danii'),
('CIU Housing', 'Zakwaterowanie', '🏠', 'Dania', 'https://ciu.dk', 'Akademiki studenckie w Danii');

-- ========================
-- FINLANDIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('OP Financial Group', 'Konto walutowe', '💳', 'Finlandia', 'https://op.fi', 'Konto studenckie w Finlandii'),
('LocalTapiola', 'Ubezpieczenie', '🛡️', 'Finlandia', 'https://lahitapiola.fi', 'Ubezpieczenie dla studentów w Finlandii'),
('HOAS', 'Zakwaterowanie', '🏠', 'Finlandia', 'https://hoas.fi', 'Akademiki studenckie w Helsinkach');

-- ========================
-- CZECHY
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('Česká spořitelna', 'Konto walutowe', '💳', 'Czechy', 'https://csas.cz', 'Konto studenckie w Czechach'),
('Kooperativa', 'Ubezpieczenie', '🛡️', 'Czechy', 'https://koop.cz', 'Ubezpieczenie dla studentów w Czechach'),
('SK Koleje', 'Zakwaterowanie', '🏠', 'Czechy', 'https://kolejepraha.cz', 'Akademiki studenckie w Czechach');

-- ========================
-- PORTUGALIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('Millennium BCP', 'Konto walutowe', '💳', 'Portugalia', 'https://millenniumbcp.pt', 'Konto studenckie w Portugalii'),
('Fidelidade', 'Ubezpieczenie', '🛡️', 'Portugalia', 'https://fidelidade.pt', 'Ubezpieczenie dla studentów w Portugalii'),
('UniLodge', 'Zakwaterowanie', '🏠', 'Portugalia', 'https://unilodge.pt', 'Akademiki studenckie w Portugalii');

-- ========================
-- IRLANDIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('AIB', 'Konto walutowe', '💳', 'Irlandia', 'https://aib.ie', 'Konto studenckie w Irlandii'),
('Allianz Ireland', 'Ubezpieczenie', '🛡️', 'Irlandia', 'https://allianz.ie', 'Ubezpieczenie dla studentów w Irlandii'),
('ULSL Housing', 'Zakwaterowanie', '🏠', 'Irlandia', 'https://ul.ie/student-life', 'Akademiki studenckie w Irlandii');

-- ========================
-- GRECJA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('Alpha Bank', 'Konto walutowe', '💳', 'Grecja', 'https://alpha.gr', 'Konto studenckie w Grecji'),
('Ethniki Insurance', 'Ubezpieczenie', '🛡️', 'Grecja', 'https://ethniki-asfalistiki.gr', 'Ubezpieczenie dla studentów w Grecji');

-- ========================
-- WĘGRY
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('OTP Bank', 'Konto walutowe', '💳', 'Węgry', 'https://otpbank.hu', 'Konto studenckie na Węgrzech'),
('Generali Hungary', 'Ubezpieczenie', '🛡️', 'Węgry', 'https://generali.hu', 'Ubezpieczenie dla studentów na Węgrzech');

-- ========================
-- RUMUNIA
-- ========================
INSERT INTO partners (name, category, icon, country, url, description) VALUES
('Banca Transilvania', 'Konto walutowe', '💳', 'Rumunia', 'https://bancatransilvania.ro', 'Konto studenckie w Rumunii'),
('Groupama Romania', 'Ubezpieczenie', '🛡️', 'Rumunia', 'https://groupama.ro', 'Ubezpieczenie dla studentów w Rumunii');

-- ========================
INSERT INTO dormitories (university_id, name, latitude, longitude)
SELECT
    id,
    'Akademik ' || SPLIT_PART(name, ' ', 1) || ' ' || SPLIT_PART(name, ' ', 2),
    ROUND((latitude + CASE MOD(id, 5)
        WHEN 0 THEN 0.012
        WHEN 1 THEN -0.004
        WHEN 2 THEN 0.006
        WHEN 3 THEN -0.003
        WHEN 4 THEN 0.007
    END)::numeric, 9),
    ROUND((longitude + CASE MOD(id, 5)
        WHEN 0 THEN 0.006
        WHEN 1 THEN 0.008
        WHEN 2 THEN -0.005
        WHEN 3 THEN -0.009
        WHEN 4 THEN 0.014
    END)::numeric, 9)
FROM universities
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

-- Akademik 2 – odwrócone wzorce
INSERT INTO dormitories (university_id, name, latitude, longitude)
SELECT
    id,
    COALESCE('Dom Studencki ' || NULLIF(TRIM(city), ''), 'Dom Studencki Campus'),
    ROUND((latitude + CASE MOD(id, 5)
        WHEN 0 THEN -0.006
        WHEN 1 THEN 0.003
        WHEN 2 THEN -0.011
        WHEN 3 THEN 0.008
        WHEN 4 THEN -0.004
    END)::numeric, 9),
    ROUND((longitude + CASE MOD(id, 5)
        WHEN 0 THEN 0.007
        WHEN 1 THEN -0.005
        WHEN 2 THEN 0.009
        WHEN 3 THEN 0.006
        WHEN 4 THEN -0.013
    END)::numeric, 9)
FROM universities
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

