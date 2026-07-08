"""
load.py
Loads the raw CSVs into a SQLite database and runs the SQL pipeline
(schema -> clean -> join -> aggregations) in order.

This is intentionally thin -- it's just the CSV-to-SQLite plumbing.
All of the actual data logic (cleaning rules, joins, window functions)
lives in the sql/ files, not here.
"""

import sqlite3
import pandas as pd
from pathlib import Path

ROOT = Path(__file__).parent
DB_PATH = ROOT / "olympics.db"
RAW_DIR = ROOT / "data" / "raw"
SQL_DIR = ROOT / "sql"


def load_csvs(conn: sqlite3.Connection) -> None:
    gdp = pd.read_csv(RAW_DIR / "gdp_population.csv")
    gdp.columns = [
        "country_name", "country_iso3c", "country_iso2c",
        "year", "population", "gdp",
    ]
    gdp.to_sql("gdp_population", conn, if_exists="replace", index=False)

    athletes = pd.read_csv(RAW_DIR / "olympic_athletes.csv")
    athletes.columns = [
        "id", "name", "sex", "age", "height", "weight", "team", "noc",
        "games", "year", "season", "city", "sport", "event", "medal",
    ]
    athletes.to_sql("olympic_athletes", conn, if_exists="replace", index=False)

    print(f"Loaded {len(gdp):,} GDP/population rows")
    print(f"Loaded {len(athletes):,} Olympic athlete-event rows")


def run_sql_file(conn: sqlite3.Connection, path: Path) -> None:
    with open(path, "r") as f:
        script = f.read()
    conn.executescript(script)
    conn.commit()
    print(f"Ran {path.name}")


def main() -> None:
    if DB_PATH.exists():
        DB_PATH.unlink()

    conn = sqlite3.connect(DB_PATH)

    # Schema needs to exist before we load into it, but we're using
    # pandas.to_sql for the initial load (simpler than hand-writing INSERTs
    # for 270K+ rows), so run schema.sql only for indexes after load.
    load_csvs(conn)

    run_sql_file(conn, SQL_DIR / "00_schema.sql")
    run_sql_file(conn, SQL_DIR / "01_clean.sql")
    run_sql_file(conn, SQL_DIR / "02_join.sql")
    run_sql_file(conn, SQL_DIR / "03_aggregations.sql")

    conn.close()
    print(f"\nDatabase built at {DB_PATH}")


if __name__ == "__main__":
    main()
