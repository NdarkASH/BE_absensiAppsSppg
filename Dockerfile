# ----------------------------------------------------
# STAGE 1: BUILD - Menggunakan image Maven yang stabil
# ----------------------------------------------------
# Menggunakan Maven dengan Temurin JDK 21 (sesuai java.version Anda)
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Atur direktori kerja
WORKDIR /app

# Copy pom.xml untuk layer caching dependencies
COPY pom.xml .

# Unduh dependencies Maven (go-offline)
# Ini adalah langkah yang sangat penting untuk caching
RUN mvn dependency:go-offline

# Copy seluruh sumber daya project (termasuk kode Java)
COPY . .

# Lakukan build project (membuat JAR executable)
# -DskipTests: Melewati unit tests
# Jika langkah ini gagal (exit code: 1), masalah ada pada kode atau pom.xml Anda
RUN mvn -B -DskipTests clean package


# ----------------------------------------------------
# STAGE 2: RUNTIME - Hanya JRE untuk menjalankan aplikasi
# ----------------------------------------------------
# Gunakan JRE 21 yang minimal (lebih kecil dan lebih aman)
FROM eclipse-temurin:21-jre-jammy

# Atur direktori kerja
WORKDIR /app

# Copy JAR yang sudah di-build dari stage 'build'
# JAR akan bernama AbsensiApps-0.0.1-SNAPSHOT.jar sesuai pom.xml Anda
COPY --from=build /app/target/AbsensiApps-0.0.1-SNAPSHOT.jar app.jar

# Configuration untuk Port
ENV PORT=8080
EXPOSE ${PORT}

# Perintah untuk menjalankan aplikasi
# Menggunakan JRE untuk menjalankan JAR
ENTRYPOINT ["java", "-jar", "app.jar"]