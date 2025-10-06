# Stage 1: Build stage menggunakan Maven (mvn sudah tersedia)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy seluruh proyek
COPY . .

# Build jar, skip tests untuk mempercepat build
RUN mvn -B -DskipTests clean package

# Stage 2: Runtime stage menggunakan JRE (lebih ringan)
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Salin jar hasil build dari stage build
COPY --from=build /app/target/*.jar app.jar

# Railway memberikan PORT via env var; Spring Boot gunakan --server.port=${PORT}
ENV PORT=8080
EXPOSE ${PORT}

ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT}"]
