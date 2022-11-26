# Advent of Code 2021

Advent of Code solutions using [dbt](https://www.getdbt.com/), [duckdb](https://duckdb.org/), and [dbt-duckdb](https://github.com/jwills/dbt-duckdb).

SQL is far from the ideal programming language to solve Advent of Code problems with, but duckdb is suprisingly capable.

After running a model (i.e. `dbt run -s 01`), answers are output to the `./target` as a `csv` file.
