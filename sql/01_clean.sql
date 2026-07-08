-- ============================================================
-- Cleaning steps
-- Mirrors the data wrangling decisions from the original analysis,
-- reasoned about explicitly rather than clicked through a GUI.
-- ============================================================

-- 1. Fix ISO code mismatch: Germany appears as "DEU" in the GDP dataset
--    but the Olympics dataset uses "GER". Standardize to GER so the join
--    doesn't silently drop every German record.
UPDATE gdp_population
SET country_iso3c = 'GER'
WHERE country_iso3c = 'DEU';

-- 2. Drop athlete-event rows with no medal. We only care about medal-winning
--    performances, so a NULL/blank medal is not missing data to impute —
--    it correctly means "did not medal" and is filtered out here.
DELETE FROM olympic_athletes
WHERE medal IS NULL OR TRIM(medal) = '';

-- 3. Drop GDP rows with no GDP value. A missing GDP figure can't be
--    reasonably imputed for this analysis (unlike, say, forward-filling
--    a time series), so those rows are excluded rather than zero-filled,
--    which would badly distort country averages.
DELETE FROM gdp_population
WHERE gdp IS NULL;

-- 4. Restrict to years the Olympics dataset actually covers (<= 2016).
--    GDP/population records beyond that add nothing to the analysis and
--    would inflate later per-country averages with irrelevant years.
DELETE FROM gdp_population
WHERE year > 2016;

DELETE FROM olympic_athletes
WHERE year > 2016;
