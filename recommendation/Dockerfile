FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o app .

FROM alpine:latest
WORKDIR /app

# Add a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/app ./
COPY --from=builder /app/static ./static
COPY --from=builder /app/templates ./templates
COPY --from=builder /app/config.json ./

# Change ownership of files to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

EXPOSE 8000
CMD ["./app"]