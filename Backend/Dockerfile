# Use an official Python runtime as a parent image
FROM python:3.13-slim


# Install system dependencies: netcat for wait-for-it.sh and PostgreSQL client (optional)
RUN apt-get update && apt-get install -y --no-install-recommends \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*



# Set working directory
WORKDIR /app

# Copy requirements file from backend folder
COPY Backend/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire backend code
COPY Backend/ .

# Make the wait-for-it.sh script executable
RUN chmod +x wait-for-it.sh

# Command to run
CMD ["bash", "-c", "host=$(echo $DATABASE_URL | sed -E 's/^.*@([^:]+):[0-9]+.*$/\\1/'); \
    port=$(echo $DATABASE_URL | sed -E 's/^.*:([0-9]+)\\/.*$/\\1/'); \
    ./wait-for-it.sh \"$host:$port\" -- sh -c 'alembic upgrade head && uvicorn app.main:app --host 0.0.0.0 --port 8000'"]
