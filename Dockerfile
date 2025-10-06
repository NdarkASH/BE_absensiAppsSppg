# Stage 1: BUILD - Mengkompilasi Aplikasi menjadi Native Executable
# Gunakan Eclipse Temurin (JDK yang stabil dan umum) sebagai base
FROM eclipse-temurin:17-jdk-focal AS build

WORKDIR /app

# 1. Instalasi GraalVM Native Image
# Unduh GraalVM (sekitar 300MB) dan instal native-image
# Ini menggantikan image GraalVM yang bermasalah 403
RUN curl -L https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-17.0.12%2B7/graalvm-community-jdk-17.0.12%2B7_linux-x64.tar.gz | tar xz -C /usr/local
RUN mv /usr/local/graalvm-community-jdk-17.0.12+7 /usr/local/graalvm
ENV PATH="/usr/local/graalvm/bin:$PATH"
RUN gu install native-image

# 2. Optimalisasi Caching Maven
# Copy file Maven (pom.xml dan wrapper)
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Download dependensi. Ini akan di-cache selama pom.xml tidak berubah.
RUN ./mvnw dependency:go-offline -B -DskipTests

# 3. Copy source code aplikasi Anda
COPY src src

# 4. Build native executable
# Pastikan '-Pnative' adalah profile Maven yang benar untuk GraalVM
RUN ./mvnw clean package -Pnative -DskipTests

---

# Stage 2: RUNTIME - Minimal dan Aman

# Gunakan 'scratch' (image kosong) karena native executable GraalVM sudah self-contained.
# Ini juga menghindari masalah otorisasi 403.
FROM scratch AS runtime

WORKDIR /app

# Copy native executable dari stage 'build'
COPY --from=build /app/target/AbsensiApps .

EXPOSE 8080

# Jalankan native executable
ENTRYPOINT ["./AbsensiApps"]