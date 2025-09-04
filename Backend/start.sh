#!/bin/bash
set -e

# Wait for DB using Python
python <<END
import time, sqlalchemy, os
url = os.getenv("DATABASE_URL")
print(f"Waiting for database at {url}...")
while True:
    try:
        engine = sqlalchemy.create_engine(url)
        with engine.connect():
            print("Database is ready!")
            break
    except Exception as e:
        print("Database not ready, waiting...")
        time.sleep(3)
END

# Run Alembic migrations
alembic upgrade head

# Start FastAPI (bind to Render's dynamic port)
exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT}
