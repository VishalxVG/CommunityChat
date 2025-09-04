#!/usr/bin/env bash
set -e

# Extract host from DATABASE_URL (postgres://user:pass@host:port/dbname)
db_host=$(echo "$DATABASE_URL" | sed -E 's|.*://[^@]*@([^:/]+).*|\1|')
db_port=$(echo "$DATABASE_URL" | sed -E 's|.*://[^@]*@[^:]+:([0-9]+).*|\1|')

echo "Waiting for database at $db_host:$db_port..."
until nc -z "$db_host" "$db_port"; do
  echo "Database is unavailable - sleeping"
  sleep 2
done

echo "Database is up - executing command"
exec "$@"