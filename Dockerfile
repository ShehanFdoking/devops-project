# Stage 1: Build the frontend
FROM node:20-alpine AS frontend-build

WORKDIR /frontend

# Copy frontend package files
COPY frontend/package*.json ./
RUN npm ci

# Copy frontend source and build
COPY frontend/ ./
RUN npm run build

# Stage 2: Build the backend
FROM maven:3.9-eclipse-temurin-17 AS backend-build

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Copy frontend build into static resources BEFORE Maven build
RUN mkdir -p src/main/resources/static
COPY --from=frontend-build /frontend/dist ./src/main/resources/static/

# Build the application
RUN mvn clean package -DskipTests

# Stage 3: Run the application
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the JAR file from build stage
COPY --from=backend-build /app/target/*.jar app.jar

# Expose port
EXPOSE 8082

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8082/actuator/health || exit 1

# Run
ENTRYPOINT ["java", "-jar", "app.jar"]
