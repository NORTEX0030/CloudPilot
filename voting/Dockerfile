FROM maven:3.8-eclipse-temurin-17 AS builder
WORKDIR /app

# Install necessary packages
RUN apt-get update && apt-get install -y ca-certificates && update-ca-certificates

COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Add a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the application JAR file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Set ownership of the application files
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Expose the application port
EXPOSE 8060

# Run the application
CMD ["java", "-jar", "app.jar"]