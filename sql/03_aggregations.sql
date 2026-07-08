-- ============================================================
-- Window function aggregations
--
-- Recreates the "% difference from mean" visualization from the original
-- project (originally built via a GUI window calculator) as an explicit
-- SQL window function, plus a couple of ranking views useful on their own.
-- ============================================================

DROP TABLE IF EXISTS country_medal_pct_diff;

CREATE TABLE country_medal_pct_diff AS
SELECT
    country_name,
    noc,
    total_medals,
    avg_gdp,
    avg_population,
    AVG(total_medals) OVER () AS mean_medals_all_countries,
    ROUND(
        100.0 * (total_medals - AVG(total_medals) OVER ())
        / AVG(total_medals) OVER (),
        2
    ) AS pct_diff_from_mean,
    RANK() OVER (ORDER BY total_medals DESC) AS medal_rank
FROM country_medal_summary
WHERE total_medals > 0;
