# ----------------------------------------------------
# STAGE 1: BUILD (Menggunakan image Maven yang lengkap)
# ----------------------------------------------------
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Tentukan direktori kerja di dalam container
WORKDIR /app

# Copy pom.xml untuk men-download dependencies lebih dulu (layer caching)
COPY pom.xml .

# Optional: Download dependencies
# Perintah ini di-cache. Jika hanya kode yang berubah, layer ini di-skip.
RUN mvn dependency:go-offline

# Copy seluruh project source code
COPY . .

# Optional: set Maven JVM options bila butuh memory lebih saat build
# Default Railway memory saat build biasanya cukup
ARG MAVEN_OPTS="-Xmx1024m"
ENV MAVEN_OPTS=${MAVEN_OPTS}

# Lakukan build (membuat JAR executable)
# -DskipTests: Melewati unit tests untuk mempercepat build
# -Dspring-boot.repackage.skip: Untuk menghindari duplikasi/kesalahan repackage (Opsional)
RUN mvn -B -e -DskipTests clean package

# ----------------------------------------------------
# STAGE 2: RUNTIME (Menggunakan JRE yang minimal)
# ----------------------------------------------------
# Gunakan JRE image yang kecil dan berbasis Linux (misalnya Jammy)
FROM eclipse-temurin:17-jre-jammy

# Tentukan direktori kerja di dalam container
WORKDIR /app

# Copy JAR hasil build dari stage 'build'
# Sesuaikan path 'target/*.jar' jika nama JAR Anda berbeda
COPY --from=build /app/target/*.jar app.jar

# Configuration untuk Railway
# Railway akan otomatis mendeteksi port yang perlu dibuka
ENV PORT 8080
EXPOSE ${PORT}

# Perintah untuk menjalankan aplikasi
# Railway menggunakan variabel PORT, jadi kita inject ke konfigurasi Spring Boot
# Catatan: Gunakan format CMD atau ENTRYPOINT yang sesuai dengan standar Docker/Railway
ENTRYPOINT ["java", "-jar", "app.jar"]
# CMD ["--server.port=8080"] # Opsional, jika Anda lebih suka ENTRYPOINT/CMD terpisah