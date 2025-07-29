# Use a Python image for the build stage
FROM python:3.11-alpine AS builder
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache gcc musl-dev libffi-dev

# Copy and install Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Copy the application code
COPY . .

# Use a lightweight Python image for the runtime stage
FROM python:3.11-alpine
WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache libffi

# Copy installed Python packages from the builder stage
COPY --from=builder /install /usr/local

# Create a non-root user and group
RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup appuser

# Copy application code from the builder stage
COPY --from=builder /app /app
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Set environment variables and expose the port
ENV PORT=5000
EXPOSE $PORT

# Add a health check
HEALTHCHECK --interval=30s --timeout=10s CMD wget -q -O- http://localhost:$PORT/health || exit 1

# Start the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "3", "--access-logfile", "-", "--error-logfile", "-"]