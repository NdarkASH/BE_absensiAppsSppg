FROM ghcr.io/graalvm/graalvm-ce:jdk-21 AS native-builder

# Tambahkan build tools (ini sering dibutuhkan oleh Native Image)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    tar && \
    rm -rf /var/lib/apt/lists/*

# **INSTALASI MAVEN SECARA MANUAL**
# Unduh dan ekstrak Maven terbaru
ENV MAVEN_VERSION 3.9.6
ENV MAVEN_HOME /usr/share/maven
RUN wget https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -P /tmp && \
    tar xzf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /usr/share/ && \
    mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
    rm /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# Atur direktori kerja
WORKDIR /app

# Copy pom.xml dan seluruh sumber kode Anda
COPY pom.xml .
COPY . .

# Lakukan build Native Image
# Perintah 'mvn' sekarang sudah tersedia di PATH
RUN mvn -Pnative -DskipTests clean package


# ----------------------------------------------------
# STAGE 2: RUNTIME - Menggunakan Image Minimal (Distroless)
# ----------------------------------------------------
FROM gcr.io/distroless/static-debian11

# ... (sisanya sama)
WORKDIR /app
COPY --from=native-builder /app/target/absensiapps /app/absensiapps
ENV PORT=8080
EXPOSE ${PORT}
ENTRYPOINT ["/app/absensiapps"]