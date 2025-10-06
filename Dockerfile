# Stage 1: BUILD - Mengkompilasi Aplikasi menjadi Native Executable
# Menggunakan Eclipse Temurin (JDK 17) sebagai base yang stabil dan umum
FROM eclipse-temurin:17-jdk-focal AS build

WORKDIR /app

# 1. Instalasi GraalVM Native Image Tooling dan Dependencies
# Install dependencies yang dibutuhkan untuk proses build native (dibutuhkan zlib)
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    curl

# Unduh GraalVM Native Image Tooling. Menggunakan versi stabil terbaru.
# URL ini harus dicek ulang secara berkala, tetapi lebih andal daripada GHCR.
# Versi GraalVM 22.3.3 (kompatibel dengan Java 17)
RUN curl -L https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.3/graalvm-ce-java17-linux-amd64-22.3.3.tar.gz | tar xz -C /usr/local
RUN mv /usr/local/graalvm-ce-java17-22.3.3 /usr/local/graalvm
ENV PATH="/usr/local/graalvm/bin:$PATH"

# Instal komponen native-image
RUN gu install native-image

# 2. Optimalisasi Caching Maven
# Copy file Maven (pom.xml dan wrapper)
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Download dependensi. Ini di-cache selama pom.xml tidak berubah.
RUN ./mvnw dependency:go-offline -B -DskipTests

# 3. Copy source code aplikasi Anda
COPY src src

# 4. Build native executable
# Panggil profile 'native' yang sudah diperbaiki di pom.xml
RUN ./mvnw clean package -Pnative -DskipTests
# Stage 2: RUNTIME - Minimal, Aman, dan Cepat

# Gunakan 'scratch' (image kosong). Ideal untuk native executable yang self-contained.
FROM scratch AS runtime

WORKDIR /app

# Copy native executable dari stage 'build'
COPY --from=build /app/target/AbsensiApps .

# Railway akan menggunakan variabel $PORT. Expose 8080 untuk dokumentasi.
EXPOSE 8080

# Jalankan native executable
ENTRYPOINT ["./AbsensiApps"]