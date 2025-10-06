# Stage 1: BUILD - Mengkompilasi Aplikasi menjadi Native Executable
# Menggunakan Eclipse Temurin (JDK 17) sebagai base yang stabil dan umum
FROM eclipse-temurin:17-jdk-focal AS build

WORKDIR /app

# 1. Instalasi GraalVM Native Image Tooling dan Dependencies
# Instal dependencies yang dibutuhkan untuk build native (zlib, build-essential)
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    curl

# Unduh GraalVM Native Image Tooling. (Versi stabil 22.3.3)
RUN curl -L https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.3/graalvm-ce-java17-linux-amd64-22.3.3.tar.gz | tar xz -C /usr/local
RUN mv /usr/local/graalvm-ce-java17-22.3.3 /usr/local/graalvm
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
# PERBAIKAN KRITIS UNTUK CRASH: Menggunakan --static untuk static linking
RUN ./mvnw clean package -Pnative -DskipTests -Dnative-image.args=--static

# PERBAIKAN 1: Cari executable dan ganti namanya menjadi AbsensiApps.
RUN find target/ -type f -name 'AbsensiApps*' -exec mv {} target/AbsensiApps \;

# PERBAIKAN 2 KRITIS: Menambahkan izin eksekusi pada executable final
RUN chmod +x target/AbsensiApps

# Stage 2: RUNTIME - Minimal, Aman, dan Cepat
# Menggunakan 'scratch' KARENA executable sekarang sudah --static (tidak perlu glibc)
FROM scratch AS runtime

WORKDIR /app

# COPY sekarang akan menyalin file yang sudah memiliki izin eksekusi (+x)
COPY --from=build /app/target/AbsensiApps .

EXPOSE 8080

# Jalankan native executable
ENTRYPOINT ["/app/AbsensiApps"]