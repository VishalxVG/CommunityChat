#!/bin/bash
set -e

echo "Starting FastAPI app..."

# Run Alembic migrations (optional: can comment this if you want migrations after DB is up)
alembic upgrade head || echo "Migration failed, will retry later."

# Start FastAPI server
exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT}
