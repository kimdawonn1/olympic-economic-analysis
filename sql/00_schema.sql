-- ============================================================
-- Schema for Olympic Performance vs. Economic Indicators project
-- ============================================================

-- Raw GDP & Population data, one row per country per year (1960-2017)
CREATE TABLE IF NOT EXISTS gdp_population (
    country_name    TEXT,
    country_iso3c   TEXT,
    country_iso2c   TEXT,
    year            INTEGER,
    population      REAL,
    gdp             REAL
);

-- Raw Olympic athlete-event data, one row per athlete per event per Games
CREATE TABLE IF NOT EXISTS olympic_athletes (
    id      INTEGER,
    name    TEXT,
    sex     TEXT,
    age     INTEGER,
    height  REAL,
    weight  REAL,
    team    TEXT,
    noc     TEXT,
    games   TEXT,
    year    INTEGER,
    season  TEXT,
    city    TEXT,
    sport   TEXT,
    event   TEXT,
    medal   TEXT
);

CREATE INDEX IF NOT EXISTS idx_gdp_iso3_year ON gdp_population(country_iso3c, year);
CREATE INDEX IF NOT EXISTS idx_oly_noc_year ON olympic_athletes(noc, year);
CREATE INDEX IF NOT EXISTS idx_oly_medal ON olympic_athletes(medal);
