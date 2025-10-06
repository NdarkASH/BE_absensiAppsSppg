# Stage 1: Build
FROM ghcr.io/graalvm/graalvm-ce:21-java17 AS build
WORKDIR /app
COPY pom.xml mvnw ./
COPY .mvn .mvn
COPY src src
RUN gu install native-image
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM ghcr.io/graalvm/graalvm-ce:21-java17
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Gunakan port dari Railway
ENV PORT=8080
EXPOSE ${PORT}

ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT}"]
