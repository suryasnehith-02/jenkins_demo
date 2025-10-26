# Use official Python base image
FROM python:3.11-slim

# Set a working directory
WORKDIR /app

# Install system packages required to build some Python dependencies (minimal)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency file first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source
COPY . .

# Expose the port the app listens on
EXPOSE 5000

# Use a non-root user (optional but recommended)
RUN useradd --create-home appuser
USER appuser

# Default command:
# - Use gunicorn if present for a more production-like server
# - Fallback to flask builtin if gunicorn isn't available
CMD ["sh", "-c", "if command -v gunicorn >/dev/null 2>&1; then exec gunicorn -b 0.0.0.0:5000 app:app; else exec python app.py; fi"]
