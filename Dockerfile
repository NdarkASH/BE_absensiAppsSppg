# Build stage (Maven)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Salin dan build
COPY pom.xml mvnw ./
COPY .mvn .mvn
COPY src src
RUN ./mvnw -B clean package -DskipTests

# Runtime stage (slim OpenJDK)
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Salin jar hasil build
COPY --from=build /app/target/*.jar app.jar

# Railway memberikan PORT via env var; Spring Boot gunakan --server.port=${PORT}
ENV PORT=8080
EXPOSE ${PORT}

ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT}"]
