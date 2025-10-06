# Stage 1: build (pakai Maven image)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Salin file penting (pertahankan layer cache)
COPY pom.xml mvnw ./
COPY .mvn .mvn
COPY src src

# Pastikan dos2unix ada -> konversi CRLF jika ada -> beri executable -> build
RUN apt-get update \
 && apt-get install -y --no-install-recommends dos2unix \
 && dos2unix mvnw || true \
 && chmod +x mvnw \
 && ./mvnw -B clean package -DskipTests \
 && apt-get purge -y --auto-remove dos2unix \
 && rm -rf /var/lib/apt/lists/*

# Stage 2: runtime (slim JRE)
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Gunakan PORT dari Railway
ENV PORT=8080
EXPOSE ${PORT}
ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT}"]
