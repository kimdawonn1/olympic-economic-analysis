# Olympic Performance vs. National Economic Indicators

A SQL-driven data pipeline analyzing whether a country's GDP and population
predict its Olympic medal success, built on 270K+ athlete-event records and
57 years of country-level economic data.

**TL;DR:** GDP and population both show a positive relationship with medal
count, but neither is sufficient on its own as some large, wealthy countries
still underperform relative to their size, and vice versa. Full breakdown
in [`analysis.ipynb`](analysis.ipynb).

## Why this project

The originial project was built for a business analytics course, done
entirely through a no-code GUI tool (Exploratory.io). This was useful for the class, 
but it meant all the actual data logic lived inside button clicks and dropdown menus 
rather than anything reviewable or reproducible. Thus, I rebuilt it in SQL and Python 
to work with the raw data directly and to actually own that logic myself, along with getting the 
whole thing into a runnable, version-controlled repo.

## Stack

- **SQLite** — storage
- **SQL** — all cleaning, joining, and feature engineering (CTEs, window functions)
- **Python (pandas, matplotlib)** — loading CSVs into SQLite and charting query results

The SQL is the core of this project, not the Python. `load.py` is a thin
wrapper that loads CSVs and runs the SQL files in order; it does none of
the actual analysis itself.

## Data

- [GDP & Population by Country, 1960–2017](https://exploratory.io/data/kanaugust/GDP-Population-by-Country-from-1960-to-2017-CJb8HUs9Cw) — country-year GDP and population figures by Kan Nishida
- [120 Years of Olympic History](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results) — athlete-event-level results, 1896–2016 by RGriffin

Raw CSVs live in `data/raw/`.

## Repo structure

```
├── data/raw/                  Original CSVs
├── sql/
│   ├── 00_schema.sql          Table definitions
│   ├── 01_clean.sql           ISO code fix, NA handling, year filtering
│   ├── 02_join.sql            Medal counts joined to average GDP/population
│   ├── 03_aggregations.sql    Window function: % deviation from mean, ranking
│   └── 04_analysis_queries.sql  The queries the notebook runs
├── load.py                    Loads CSVs into SQLite, runs the SQL pipeline in order
├── analysis.ipynb             Runs the queries, renders charts, walks through findings
└── results/                   Saved chart images
```

## Running it

```bash
pip install pandas matplotlib jupyter
python load.py                 # builds olympics.db from the raw CSVs
jupyter notebook analysis.ipynb
```

## Key data decisions

- **Germany's ISO code** differs between the two datasets (`DEU` vs. `GER`)
  and is standardized before joining — otherwise every German record
  silently fails to match.
- **Average GDP/population (1960–2016)** is used per country rather than
  the most recent figure, so a country isn't penalized or boosted just
  because its latest data point happens to be more or less recent than
  another country's.
- **Medal-less rows are dropped, not imputed** — a blank medal means "did
  not medal," which is a real value, not missing data.

Full reasoning for each decision is in the SQL comments and walked through
in the notebook.

## Limitations

- Doesn't account for host-country advantage, doping bans, or boycotts
  (e.g., the 1980/1984 boycotts), all of which affect medal counts
  independent of GDP/population.
- Team-sport medals count once per athlete in the raw data, slightly
  inflating totals for countries strong in team sports.
- See `analysis.ipynb` §8 for the full list and what I'd extend next.

## Original version

The original no-code version of this project (built in a group for a
business analytics course) is included for reference: [`Final_Project_BUS_314.pdf`](Final_Project_BUS_314.pdf).
