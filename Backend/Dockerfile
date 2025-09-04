# Use an official Python runtime as a parent image
FROM python:3.13-slim

# Install system dependencies (including netcat for wait-for-it)
RUN apt-get update && apt-get install -y --no-install-recommends \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire app code
COPY . .

# Make wait-for-it.sh executable
RUN chmod +x wait-for-it.sh

# Default command: use wait-for-it.sh to wait for DB before running Alembic and FastAPI
CMD ["sh", "-c", "./wait-for-it.sh -- alembic upgrade head && uvicorn app.main:app --host 0.0.0.0 --port 8000"]
