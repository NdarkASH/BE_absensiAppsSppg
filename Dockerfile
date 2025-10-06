# Build stage (Maven wrapper)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Salin pom dan wrapper dulu (layer cache)
COPY pom.xml mvnw ./
COPY .mvn .mvn
COPY src src

# Pastikan mvnw executable, lalu build
RUN chmod +x mvnw
RUN ./mvnw -B clean package -DskipTests

# Runtime
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

ENV PORT=8080
EXPOSE ${PORT}
ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT}"]
