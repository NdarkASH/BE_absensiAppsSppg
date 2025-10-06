# ----------------------------------------------------
# STAGE 1: NATIVE BUILD - Membuat Executable Biner
# ----------------------------------------------------
# Menggunakan GraalVM JDK 21
FROM ghcr.io/graalvm/jdk:21 AS native-builder

# Atur direktori kerja
WORKDIR /app

# Copy pom.xml dan seluruh sumber kode Anda
COPY pom.xml .
COPY . .

# Lakukan build Native Image
# -Pnative: Mengaktifkan profile 'native' Anda yang berisi native-maven-plugin
# -DskipTests: Melewati unit tests
# Catatan: Ini adalah langkah yang akan menjalankan tool 'native-image'
RUN mvn -Pnative -DskipTests clean package


# ----------------------------------------------------
# STAGE 2: RUNTIME - Menggunakan Image Minimal (Distroless)
# ----------------------------------------------------
FROM gcr.io/distroless/static-debian11

# Atur direktori kerja
WORKDIR /app

# Copy executable Native Image yang sudah di-build
COPY --from=native-builder /app/target/absensiapps /app/absensiapps

# Configuration untuk Port
ENV PORT=8080
EXPOSE ${PORT}

# Perintah untuk menjalankan native executable
ENTRYPOINT ["/app/absensiapps"]