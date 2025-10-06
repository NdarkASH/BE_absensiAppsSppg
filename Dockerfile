# Stage 1: Build stage dengan GraalVM 21
FROM ghcr.io/graalvm/graalvm-ce:21-java17 AS build

# Set working directory
WORKDIR /app

# Salin file Maven/Gradle
COPY pom.xml mvnw ./
COPY .mvn .mvn
COPY src src

# Install Maven jika belum tersedia
RUN gu install native-image
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime stage
FROM ghcr.io/graalvm/graalvm-ce:21-java17

WORKDIR /app

# Salin JAR hasil build
COPY --from=build /app/target/*.jar app.jar

# Ekspos port aplikasi
EXPOSE 8080

# Jalankan Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]
