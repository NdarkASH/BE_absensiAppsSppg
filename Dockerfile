# Stage 1: BUILD - Mengkompilasi Aplikasi menjadi Native Executable
# Gunakan GraalVM CE (Community Edition) berbasis Java 17
FROM ghcr.io/graalvm/graalvm-ce:23-java17 AS build

WORKDIR /app

# 1. OPTIMALISASI CACHING: Copy hanya file yang diperlukan untuk mendownload dependensi.
# Ini memungkinkan Docker cache dependensi selama pom.xml tidak berubah.
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Jalankan command yang hanya mendownload dependensi tanpa melakukan compile
# Perintah ini akan gagal jika dependensi belum ada di cache M2 lokal GraalVM
# Gunakan ./mvnw karena Anda meng-copy mvnw
RUN ./mvnw dependency:go-offline -B -DskipTests

# 2. Copy source code aplikasi Anda
COPY src src

# 3. Build native executable
# Pastikan '-Pnative' adalah profile Maven yang benar untuk GraalVM
# Pastikan pom.xml menargetkan Java 17
RUN ./mvnw clean package -Pnative -DskipTests

---

# Stage 2: RUNTIME - Minimal dan Aman

# Gunakan 'scratch' sebagai base image.
# Scratch adalah image kosong, ideal untuk native executable GraalVM yang sudah self-contained.
# Ini juga menghindari error 403 Forbidden dari GHCR.
FROM scratch AS runtime

WORKDIR /app

# Copy native executable dari stage 'build'
COPY --from=build /app/target/AbsensiApps .

# Railway akan menyuntikkan variabel database secara otomatis.
# Anda hanya perlu memastikan aplikasi Anda (misalnya Spring Boot) membaca konfigurasi dari variabel env (PGHOST, PGPASSWORD, dll.)

# EXPOSE 8080 (Opsional di Railway, tetapi baik untuk dokumentasi)
EXPOSE 8080

# Jalankan native executable
# Pastikan file yang di-copy sesuai dengan nama ENTRYPOINT
ENTRYPOINT ["./AbsensiApps"]