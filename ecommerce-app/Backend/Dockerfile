# Stage 1: Build
FROM maven:3.8.6-openjdk-8 AS build
WORKDIR /app

# Optimization: Only download dependencies if pom.xml changes
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
# Using alpine for the smallest footprint (standard for DevSecOps)
FROM openjdk:8-jre-alpine
LABEL author="Roshan Nikhade"
LABEL project="E-commerce DevSecOps"

WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Health check - Ensures Kubernetes knows when the app is actually ready
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/actuator/health || exit 1

EXPOSE 8080

# Security: Best practice is to run as a non-root user (Optional but recommended)
# RUN addgroup -S spring && adduser -S spring -G spring
# USER spring:spring

ENTRYPOINT ["java", "-jar", "app.jar"]