# Stage 1: BUILD - Mengkompilasi Aplikasi menjadi Native Executable
# PERBAIKAN: Mengganti image dari 'native-image-community' (bermasalah) ke 'graalvm-ce'
# Ini adalah tag GraalVM Community Edition yang paling umum dan stabil.
FROM ghcr.io/graalvm/graalvm-ce:23-java17 AS native-builder

WORKDIR /app

# 1. Optimalisasi Caching Maven
COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .

# PERBAIKAN: Menambahkan izin eksekusi pada mvnw (Wajib!)
RUN chmod +x mvnw

# Download dependensi.
RUN ./mvnw dependency:go-offline -B -DskipTests

# 2. Copy source code aplikasi Anda
COPY src src

# 3. Build native executable
# Menggunakan native:compile yang spesifik.
# Menghapus flag --static karena runtime (debian-slim) akan menyediakan glibc.
RUN ./mvnw -Pnative native:compile

# Stage 2: RUNTIME - Menggunakan Base Image Debian yang Minimal dan Andal
# debian:bookworm-slim menyediakan glibc yang dibutuhkan. (SOLUSI TERBAIK UNTUK "Exec format error")
FROM debian:bookworm-slim AS runtime

WORKDIR /app

# Salin executable (nama file sesuai artifactId: AbsensiApps)
COPY --from=native-builder /app/target/AbsensiApps /app/AbsensiApps

EXPOSE 8080

# Jalankan native executable
ENTRYPOINT ["/app/AbsensiApps"]