This is a script for enabling auto-completions for [Airflow][1] in [fish][2].

In order to use the completions, source `airflow.fish` in your shell 
initialization script. This registers the completions, and creates the function
`update-airflow-completions`.

Since Airflow's commands for listing DAGs and tasks are very slow, these 
completions rely on caching available DAGs and tasks in a text-file called
`$AIRFLOW_HOME/.airflow-completions`. This file can be built automatically
by calling `update-airflow-completions`. To update the completions for a single
DAG only, call `update-airflow-completions $DAG_ID`.

Completions are currently available for DAGs and tasks when using the commands
`test`, `clear` and `backfill`.

This has only been tested using fish 3.0.2 on macOS 10.14.4 and Airflow 1.10.

[1]: https://airflow.apache.org/
[2]: https://fishshell.com/
