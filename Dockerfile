# Stage 1: BUILD - Mengkompilasi Aplikasi menjadi Native Executable
# MENGHINDARI MASALAH OTORISASI GHCR DENGAN INSTALASI MANUAL (Paling Stabil).
# Menggunakan Temurin JDK 21 dengan tag yang paling umum dan tersedia
FROM eclipse-temurin:21-jdk-jammy AS build

# Tentukan versi GraalVM untuk Java 21
ENV GRAALVM_VERSION="23.1.2"
ENV GRAALVM_FILE="graalvm-community-jdk-21.0.3+9.1-linux-x64.tar.gz"
ENV GRAALVM_DIR="graalvm-community-jdk-21.0.3+9.1"

WORKDIR /app

# 1. Instalasi GraalVM Native Image Tooling dan Dependencies
# Instal dependencies yang dibutuhkan untuk build native (zlib, build-essential)
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    curl

# Unduh GraalVM Native Image Tooling (untuk Java 21) dan set PATH
RUN curl -L https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${GRAALVM_VERSION}/${GRAALVM_FILE} | tar xz -C /usr/local && \
    mv /usr/local/${GRAALVM_DIR} /usr/local/graalvm
ENV PATH="/usr/local/graalvm/bin:$PATH"

# Instal komponen native-image
RUN gu install native-image

# 2. Optimalisasi Caching Maven
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# PERBAIKAN: Menambahkan izin eksekusi pada mvnw
RUN chmod +x mvnw

# Download dependensi.
RUN ./mvnw dependency:go-offline -B -DskipTests

# 3. Copy source code aplikasi Anda
COPY src src

# 4. Build native executable
# Menggunakan --static untuk static linking (mengatasi Exec format error di scratch)
RUN ./mvnw clean package -Pnative -DskipTests -Dnative-image.args=--static

# PERBAIKAN 1: Cari executable dan ganti namanya menjadi AbsensiApps.
RUN find target/ -type f -name 'AbsensiApps*' -exec mv {} target/AbsensiApps \;

# PERBAIKAN 2 KRITIS: Menambahkan izin eksekusi pada executable final
RUN chmod +x target/AbsensiApps

# Stage 2: RUNTIME - Minimal, Aman, dan Cepat
# Menggunakan 'scratch' KARENA kita menggunakan --static.
FROM scratch AS runtime

WORKDIR /app

# COPY sekarang akan menyalin file yang sudah memiliki izin eksekusi (+x)
COPY --from=build /app/target/AbsensiApps .

EXPOSE 8080

# Jalankan native executable
ENTRYPOINT ["/app/AbsensiApps"]