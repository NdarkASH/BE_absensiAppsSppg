# ----------------------------------------------------
# STAGE 1: NATIVE BUILD - Membuat Executable Biner
# ----------------------------------------------------
# Menggunakan GraalVM JDK 21 yang sesuai dengan java.version di pom.xml Anda
FROM ghcr.io/graalvm/jdk:21 AS native-builder

# Menginstal dependensi build tambahan yang mungkin diperlukan oleh GraalVM
# Misalnya, untuk native image tools dan build environment
RUN gu install native-image

# Atur direktori kerja
WORKDIR /app

# Copy pom.xml dan seluruh sumber kode Anda
COPY pom.xml .
COPY . .

# Lakukan build Native Image
# -Pnative: Mengaktifkan profile 'native' Anda yang berisi native-maven-plugin
# -DskipTests: Melewati unit tests
# Catatan: Langkah ini akan memakan waktu LAMA (5-15 menit atau lebih)
RUN mvn -Pnative -DskipTests clean package


# ----------------------------------------------------
# STAGE 2: RUNTIME - Menggunakan Image Minimal (Distroless)
# ----------------------------------------------------
# Distroless static-debian11 adalah pilihan terbaik: sangat aman, sangat kecil, dan hanya berisi biner statis
FROM gcr.io/distroless/static-debian11

# Atur direktori kerja
WORKDIR /app

# Copy executable Native Image yang sudah di-build dari stage 'native-builder'
# Nama executable default dari plugin Native Maven biasanya adalah artifactId yang di-lowercase
COPY --from=native-builder /app/target/absensiapps /app/absensiapps

# Configuration untuk Port
# Railway akan menyediakan variabel lingkungan PORT
ENV PORT=8080
EXPOSE ${PORT}

# Perintah untuk menjalankan native executable
# Aplikasi Native Image Anda sudah siap berjalan.
ENTRYPOINT ["/app/absensiapps"]