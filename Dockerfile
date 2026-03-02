FROM python:3.13-alpine

LABEL maintainer="Tawhidur Rahman Adnan"

ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    postgresql-client

# Install build dependencies (temporary)
RUN apk add --no-cache --virtual .tmp-build-deps \
    gcc \
    libc-dev \
    linux-headers \
    postgresql-dev

# Copy requirements first (better caching)
COPY requirements.txt /tmp/requirements.txt

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm -rf /root/.cache

# Remove build dependencies after install (reduces image size)
RUN apk del .tmp-build-deps

# Create app directory
RUN mkdir /app
WORKDIR /app

# Copy project
COPY app/ /app/

# Create non-root user
RUN adduser -D user
USER user