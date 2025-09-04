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

COPY Backend/start.sh .
RUN chmod +x start.sh


CMD ["./start.sh"]
