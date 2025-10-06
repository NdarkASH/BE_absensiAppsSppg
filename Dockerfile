# ----------------------------------------------------
# STAGE 1: BUILD - Mengkompilasi dan membuat JAR
# ----------------------------------------------------
# Gunakan image Maven 3.9.6 dengan Temurin JDK 17
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Atur direktori kerja
WORKDIR /app

# Copy pom.xml untuk layer caching dependencies
# Jika pom.xml tidak berubah, langkah ini akan di-cache, mempercepat build
COPY pom.xml .

# Unduh dependencies Maven (go-offline)
RUN mvn dependency:go-offline

# Copy seluruh sumber daya project
COPY . .

# Optional: Set Maven JVM options jika build membutuhkan memori lebih
# ARG MAVEN_OPTS="-Xmx1024m"
# ENV MAVEN_OPTS=${MAVEN_OPTS}

# Lakukan build project (skip tests)
# Jika langkah ini gagal, seperti error sebelumnya (exit code: 1), periksa compile error pada kode Anda
RUN mvn -B -DskipTests clean package


# ----------------------------------------------------
# STAGE 2: RUNTIME - Hanya JRE untuk menjalankan aplikasi
# ----------------------------------------------------
# Gunakan JRE minimal (Temurin 17 JRE) untuk ukuran image terkecil
FROM eclipse-temurin:17-jre-jammy

# Atur direktori kerja
WORKDIR /app

# Copy JAR yang sudah di-build dari stage 'builder'
# Sesuaikan 'target/*.jar' jika nama file JAR Anda unik
COPY --from=builder /app/target/*.jar app.jar

# Configuration untuk Port
# Railway akan menggunakan variabel lingkungan PORT
ENV PORT=8080
EXPOSE ${PORT}

# Perintah untuk menjalankan aplikasi
# Menggunakan exec form untuk startup yang lebih baik dan penanganan sinyal yang benar
# Spring Boot biasanya secara otomatis membaca PORT dari variabel lingkungan
ENTRYPOINT ["java", "-jar", "app.jar"]