# # Use Python 3.9 slim image as base
# FROM python:3.9-slim

# # Set environment variables
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# # Create a directory for the application
# WORKDIR /app

# # Install system dependencies
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends gcc \
#     && rm -rf /var/lib/apt/lists/*

# # Install Python dependencies
# COPY requirements.txt requirements.txt
# RUN pip install --no-cache-dir -r requirements.txt

# # Add application code
# COPY . /app

# # Create a non-root user
# RUN useradd -m myuser
# USER myuser

# # Use Gunicorn as the entry point
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "your_module_name_here.wsgi:application"]


FROM python:3.9-slim

# Create working folder and install dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application contents
COPY service/ ./service/

# Switch to a non-root user
RUN useradd --uid 1000 theia && chown -R theia /app
USER theia

# Run the service
EXPOSE 8080
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]