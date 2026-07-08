-- ============================================================
-- Analysis queries
-- These are the queries the notebook pulls results from directly.
-- ============================================================

-- Q1: Top 15 countries by total medal count
-- (reproduces the first bar chart from the original project)
SELECT country_name, gold_count, silver_count, bronze_count, total_medals
FROM country_medal_summary
ORDER BY total_medals DESC
LIMIT 15;

-- Q2: Countries furthest above the mean, excluding the U.S. outlier
-- (reproduces the "% diff from mean" chart, filtering the heavy outlier
-- the same way the original project did)
SELECT country_name, total_medals, pct_diff_from_mean, medal_rank
FROM country_medal_pct_diff
WHERE country_name != 'United States'
ORDER BY pct_diff_from_mean DESC
LIMIT 15;

-- Q3: Correlation snapshot -- top 10 by average GDP alongside their medal count
-- Gives a quick eyeball check of the GDP-vs-medals relationship without
-- needing the full map visualization.
SELECT country_name, avg_gdp, avg_population, total_medals
FROM country_medal_summary
WHERE avg_gdp IS NOT NULL
ORDER BY avg_gdp DESC
LIMIT 10;

-- Q4: High population, low medal count -- the "India exception" query
-- Surfaces countries where population is high but Olympic success doesn't
-- follow, directly testing whether the population correlation actually holds.
SELECT country_name, avg_population, total_medals
FROM country_medal_summary
WHERE avg_population IS NOT NULL
ORDER BY avg_population DESC
LIMIT 10;
