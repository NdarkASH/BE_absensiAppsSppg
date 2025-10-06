# Stage 1: BUILD - Mengkompilasi Aplikasi menjadi Native Executable
FROM eclipse-temurin:17-jdk-focal AS build

WORKDIR /app

# 1. Instalasi GraalVM Native Image Tooling dan Dependencies
# ... (kode instalasi dan PATH tetap sama) ...
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    curl

RUN curl -L https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.3/graalvm-ce-java17-linux-amd64-22.3.3.tar.gz | tar xz -C /usr/local
RUN mv /usr/local/graalvm-ce-java17-22.3.3 /usr/local/graalvm
ENV PATH="/usr/local/graalvm/bin:$PATH"

RUN gu install native-image

# 2. Optimalisasi Caching Maven
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# >>> BARIS KRITIS: Menambahkan izin eksekusi pada mvnw
RUN chmod +x mvnw

# Download dependensi. Ini di-cache selama pom.xml tidak berubah.
RUN ./mvnw dependency:go-offline -B -DskipTests

# 3. Copy source code aplikasi Anda
COPY src src

# 4. Build native executable
RUN ./mvnw clean package -Pnative -DskipTests

# Stage 2: RUNTIME - Minimal, Aman, dan Cepat
FROM scratch AS runtime

WORKDIR /app

COPY --from=build /app/target/AbsensiApps .

EXPOSE 8080

ENTRYPOINT ["./AbsensiApps"]
