# Stage 1: Build native image using GraalVM
FROM ghcr.io/graalvm/graalvm-ce:23-java17 AS build

WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
COPY src src

# Install Maven (GraalVM CE biasanya tidak ada Maven)
RUN gu install native-image
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz | tar xz -C /opt
ENV PATH="/opt/apache-maven-3.9.5/bin:$PATH"

# Build native image
RUN mvn clean package -Pnative -DskipTests

# Stage 2: Minimal runtime image
FROM ghcr.io/graalvm/native-image:23-java17 AS runtime

WORKDIR /app

# Copy native executable
COPY --from=build /app/target/AbsensiApps .


# Expose port
EXPOSE 8080

# Run the native executable
ENTRYPOINT ["./AbsensiApps"]
