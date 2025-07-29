FROM node:16-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

FROM node:16-alpine

WORKDIR /app

# Create a non-root user and group
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

# Copy files from the builder stage and set ownership
COPY --from=builder /app ./
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Set environment variables and expose the port
ENV PORT=3000
EXPOSE $PORT

# Add a health check
HEALTHCHECK --interval=30s --timeout=10s CMD wget -q -O- http://localhost:$PORT/health || exit 1

# Start the application
CMD ["node", "app.js"]