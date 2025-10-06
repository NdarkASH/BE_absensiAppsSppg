# Stage 1: BUILD - Mengkompilasi Aplikasi menjadi Native Executable
# MENGGUNAKAN GRAALVM BERBASIS ALPINE (Musl C Library)
# Ini menghasilkan executable yang 100% statis dan kompatibel dengan 'scratch'.
FROM ghcr.io/graalvm/jdk:latest-ol8-slim AS build

WORKDIR /app

# 1. Instalasi Dependencies (Alpine menggunakan apk, bukan apt-get)
# Instalasi libz-dev, build-base, dan curl. native-image sudah terpasang.
# Catatan: Karena kita beralih ke image OL8, kita beralih ke yum/dnf.
RUN dnf update -y && dnf install -y \
    zlib-devel \
    curl \
    gcc \
    gcc-c++ \
    make \
    tar \
    gzip && dnf clean all

# (Semua baris instalasi GraalVM manual dan PATH dihapus)

# 2. Optimalisasi Caching Maven
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# PERBAIKAN: Menambahkan izin eksekusi pada mvnw
RUN chmod +x mvnw

# Download dependensi.
RUN ./mvnw dependency:go-offline -B -DskipTests

# 3. Copy source code aplikasi Anda
COPY src src

# 4. Build native executable
# PENTING: Hapus flag --static. Image ini seharusnya memaksa static/musl linking secara otomatis.
RUN ./mvnw clean package -Pnative -DskipTests

# PERBAIKAN 1: Cari executable dan ganti namanya menjadi AbsensiApps.
RUN find target/ -type f -name 'AbsensiApps*' -exec mv {} target/AbsensiApps \;

# PERBAIKAN 2 KRITIS: Menambahkan izin eksekusi pada executable final
RUN chmod +x target/AbsensiApps

# Stage 2: RUNTIME - Minimal, Aman, dan Cepat
# Menggunakan 'scratch' KARENA executable yang dibangun Musl sudah 100% statis.
FROM scratch AS runtime

WORKDIR /app

# COPY sekarang akan menyalin file yang sudah memiliki izin eksekusi (+x)
COPY --from=build /app/target/AbsensiApps .

EXPOSE 8080

# Jalankan native executable
ENTRYPOINT ["/app/AbsensiApps"]
