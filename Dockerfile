# ----------------------------------------------------
# STAGE 1: NATIVE BUILD - Membuat Executable
# ----------------------------------------------------
# Gunakan GraalVM native image builder
FROM ghcr.io/graalvm/jdk:21 AS native-builder

# Atur direktori kerja
WORKDIR /app

# Copy pom.xml dan semua kode
COPY pom.xml .
COPY . .

# Lakukan build Native Image
# Menggunakan profile 'native' Anda
# Perintah ini akan memakan waktu LAMA
RUN mvn -Pnative -DskipTests clean package

# ----------------------------------------------------
# STAGE 2: RUNTIME - Menggunakan scratch atau minimal base image
# ----------------------------------------------------
# Gunakan image yang sangat minimal (seperti Red Hat UBI minimal atau distroless)
# distroless adalah yang terbaik untuk keamanan dan ukuran
FROM gcr.io/distroless/static-debian11

# Atur direktori kerja
WORKDIR /app

# Copy executable yang sudah di-build dari stage 'native-builder'
# Executable akan berada di target/app, bukan target/*.jar
COPY --from=native-builder /app/target/absensiapps /app/absensiapps

# Configuration
ENV PORT=8080
EXPOSE ${PORT}

# Perintah untuk menjalankan native executable
ENTRYPOINT ["/app/absensiapps"]