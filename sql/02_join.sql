-- ============================================================
-- Join: combine Olympic medal counts with each country's average
-- economic indicators over the dataset's time span.
--
-- Design decision: we use each country's AVERAGE GDP/population across
-- 1960-2016 rather than its most recent figure. Using the latest value
-- would unfairly weight countries whose most recent data point happens
-- to be current (e.g. 2016) against countries whose latest available
-- figure is from decades earlier, and would ignore how a country's
-- economy and Olympic performance evolved together over the window.
-- ============================================================

DROP TABLE IF EXISTS country_medal_summary;

CREATE TABLE country_medal_summary AS
WITH medal_counts AS (
    SELECT
        team AS country_name,
        noc,
        SUM(CASE WHEN medal = 'Gold'   THEN 1 ELSE 0 END) AS gold_count,
        SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver_count,
        SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_count,
        COUNT(*) AS total_medals
    FROM olympic_athletes
    GROUP BY team, noc
),
economic_avgs AS (
    SELECT
        country_iso3c,
        AVG(gdp) AS avg_gdp,
        AVG(population) AS avg_population
    FROM gdp_population
    GROUP BY country_iso3c
)
SELECT
    m.country_name,
    m.noc,
    m.gold_count,
    m.silver_count,
    m.bronze_count,
    m.total_medals,
    e.avg_gdp,
    e.avg_population
FROM medal_counts m
LEFT JOIN economic_avgs e
    ON m.noc = e.country_iso3c;
