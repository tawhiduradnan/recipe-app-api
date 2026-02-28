FROM python:3.13-alpine

LABEL maintainer="Tawhidur Rahman Adnan"

ENV PYTHONUNBUFFERED=1

# Install system dependencies (if needed)
RUN apk add --no-cache gcc musl-dev libffi-dev

# Copy requirements first (better layer caching)
COPY requirements.txt /tmp/requirements.txt

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm -rf /root/.cache

# Create app directory
RUN mkdir /app
WORKDIR /app

# Copy project
COPY app/ /app/

# Create non-root user
RUN adduser -D user
USER user