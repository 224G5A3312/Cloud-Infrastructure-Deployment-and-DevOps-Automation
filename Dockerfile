# ---------------------------------------------------------------------------
# Dockerfile
# Cloud Infrastructure Deployment and DevOps Automation
#
# Builds a lightweight, production-ready image for the Flask application.
# ---------------------------------------------------------------------------

# Use an official, slim Python base image to keep the image size small
FROM python:3.11-slim

# Prevent Python from writing .pyc files and enable unbuffered output
# (unbuffered output makes logs show up immediately in `docker logs`)
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the application environment (can be overridden at runtime with -e)
ENV ENV=production
ENV PORT=5000

# Set the working directory inside the container
WORKDIR /app

# Copy only the requirements file first to leverage Docker layer caching.
# This means dependencies are only re-installed when requirements.txt changes.
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Create a non-root user and switch to it for better container security
RUN useradd --create-home appuser
USER appuser

# Document the port the application listens on
EXPOSE 5000

# Basic container health check hitting the /health endpoint
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

# Run the application using gunicorn (production WSGI server)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
