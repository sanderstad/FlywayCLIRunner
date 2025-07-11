# FlywayCLIRunner

Run Flyway CLI commands in your GitHub Actions workflows.

## Overview

**FlywayCLIRunner** is a composite GitHub Action for running Flyway CLI database migrations as part of your CI/CD pipeline. It supports authentication, custom parameters, reporting, debug mode, and options for cleaning and migrating your database.

## Inputs

| Name                        | Description                                         | Required | Default   |
|-----------------------------|-----------------------------------------------------|----------|-----------|
| `action_clean_db`           | Enable cleaning the database build                  | false    | `false`   |
| `action_dryrun`             | Enable dry run                                      | false    | `false`   |
| `action_migrate`            | Enable migration                                    | false    | `true`    |
| `agree_to_eula`             | Agree to the Flyway EULA                            | false    | `true`    |
| `authenticate_flyway`       | Enable authentication (set to `false` to disable)   | false    | `true`    |
| `check_drift_on_migration`  | Check for drift on migration                        | false    | `false`   |
| `clean_db_build`            | Clean the database build before migrating           | false    | `false`   |
| `custom_params`             | Custom parameters to pass to Flyway CLI             | false    | `""`      |
| `debug`                     | Enable debug mode                                   | false    | `false`   |
| `environment`               | The environment to use for the Flyway CLI           | false    | `""`      |
| `flyway_email`              | The email address to use for Flyway CLI             | false    | `""`      |
| `flyway_token`              | The token to use for Flyway CLI                     | false    | `""`      |
| `generate_check_report`     | Generate a check report                             | false    | `false`   |
| `publish_result`            | Publish the result of the migration                 | false    | `false`   |
| `report_database_url`       | The JDBC URL to use for the report database         | false    | `""`      |
| `report_database_password`  | The password to use for the report database         | false    | `""`      |
| `report_database_username`  | The username to use for the report database         | false    | `""`      |
| `report_environment`        | The environment to use for the report               | false    | `default` |
| `target_db_password`        | The password to use for the target database         | false    | `""`      |
| `target_db_url`             | The URL to use for the target database              | false    | `""`      |
| `target_db_username`        | The username to use for the target database         | false    | `""`      |

## Usage

### With Clean Build and Migration

```yaml
- name: Run Flyway CLI with Clean Build and Migration
  uses: ./ # or use the repository path if published
  with:
    flyway_email: ${{ secrets.FLYWAY_EMAIL }}
    flyway_token: ${{ secrets.FLYWAY_TOKEN }}
    target_db_username: ${{ secrets.DB_USERNAME }}
    target_db_password: ${{ secrets.DB_PASSWORD }}
    target_db_url: ${{ secrets.DB_URL }}
    environment: "dev"
    publish_result: "true"
    action_clean_db: "true"
    action_migrate: "true"
```

### Generate Check Report

```yaml
- name: Run Flyway CLI and Generate Check Report
  uses: ./
  with:
    flyway_email: ${{ secrets.FLYWAY_EMAIL }}
    flyway_token: ${{ secrets.FLYWAY_TOKEN }}
    target_db_username: ${{ secrets.DB_USERNAME }}
    target_db_password: ${{ secrets.DB_PASSWORD }}
    target_db_url: ${{ secrets.DB_URL }}
    environment: "qa"
    generate_check_report: "true"
    report_environment: "qa"
    report_database_username: ${{ secrets.REPORT_DB_USERNAME }}
    report_database_password: ${{ secrets.REPORT_DB_PASSWORD }}
```

### Dry Run with Debug

```yaml
- name: Run Flyway CLI Dry Run with Debug
  uses: ./
  with:
    flyway_email: ${{ secrets.FLYWAY_EMAIL }}
    flyway_token: ${{ secrets.FLYWAY_TOKEN }}
    target_db_username: ${{ secrets.DB_USERNAME }}
    target_db_password: ${{ secrets.DB_PASSWORD }}
    target_db_url: ${{ secrets.DB_URL }}
    environment: "dev"
    action_dryrun: "true"
    debug: "true"
```

### Custom Parameters Example

```yaml
- name: Run Flyway CLI with Custom Params
  uses: ./
  with:
    flyway_email: ${{ secrets.FLYWAY_EMAIL }}
    flyway_token: ${{ secrets.FLYWAY_TOKEN }}
    target_db_username: ${{ secrets.DB_USERNAME }}
    target_db_password: ${{ secrets.DB_PASSWORD }}
    target_db_url: ${{ secrets.DB_URL }}
    environment: "dev"
    custom_params: "-Xmx2g -otherOption=value"
```

## Requirements

- **Flyway CLI must be installed** on the runner before using this action. Use a separate action (e.g., FlywayCLIInstaller) to install it.

## What This Action Does

1. Checks if Flyway CLI is installed (Linux and Windows supported).
2. Authenticates to Flyway CLI if `authenticate_flyway` is `"true"`.
3. Optionally cleans the database build if `action_clean_db` or `clean_db_build` is `"true"`.
4. Optionally generates a check report if `generate_check_report` is `"true"`.
5. Optionally runs a dry run if `action_dryrun` is `"true"`.
6. Runs Flyway migration with the provided parameters.

## Example Output

When the action runs successfully, you might see output like:

```
Successfully applied 1 migration to schema [dbo], now at version v003.20250604213122 (execution time 00:00.017s)
Schema version: 003.20250604213122
+-----------+--------------------+-------------------+--------------+---------------------+----------+----------+
| Category  | Version            | Description       | Type         | Installed On        | State    | Undoable |
+-----------+--------------------+-------------------+--------------+---------------------+----------+----------+
| Baseline  | 001.20250514093333 | baseline          | SQL_BASELINE | 2025-06-04 19:28:03 | Baseline | No       |
| Versioned | 002.20250604212617 | Added MyAwesomeSP | SQL          | 2025-06-04 19:28:03 | Success  | No       |
| Versioned | 003.20250604213122 | Sander            | SQL          | 2025-06-04 19:32:48 | Success  | No       |
+-----------+--------------------+-------------------+--------------+---------------------+----------+----------+
```

## License

MIT
