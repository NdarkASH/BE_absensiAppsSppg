# Dokumentasi API: Absensi Karyawan (v0)

Dokumen ini menjelaskan *endpoint* yang tersedia berdasarkan spesifikasi OpenAPI v3.0.4.

**URL Dasar Server:** `http://localhost:8080`

---

## 1. Employee Controller

Mengelola data Karyawan (Pegawai).

### 1.1. Mendapatkan Detail Karyawan (GET)

Mendapatkan data detail karyawan berdasarkan ID.

* **Endpoint:** `GET /employee/{id}`
* **Operation ID:** `getEmployee`

| Parameter | Lokasi | Tipe | Format | Wajib | Deskripsi |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **id** | Path | string | uuid | YA | ID unik Karyawan. |

**Respons (200 OK):** Mengembalikan objek `AppResponseEmployeeResponse`.

### 1.2. Memperbarui Data Karyawan (PUT)

Memperbarui data detail karyawan berdasarkan ID.

* **Endpoint:** `PUT /employee/{id}`
* **Operation ID:** `updateEmployee`

| Parameter | Lokasi | Tipe | Format | Wajib | Deskripsi |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **id** | Path | string | uuid | YA | ID unik Karyawan yang akan diperbarui. |

**Request Body (application/json):** Menggunakan skema `EmployeeRequest`.

**Respons (200 OK):** Mengembalikan objek `AppResponseEmployeeResponse`.

### 1.3. Menghapus Karyawan (DELETE)

Menghapus data karyawan berdasarkan ID.

* **Endpoint:** `DELETE /employee/{id}`
* **Operation ID:** `deleteEmployee`

| Parameter | Lokasi | Tipe | Format | Wajib | Deskripsi |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **id** | Path | string | uuid | YA | ID unik Karyawan yang akan dihapus. |

**Respons (200 OK):** Mengembalikan objek `AppResponseVoid` (konfirmasi tanpa data).

### 1.4. Mendapatkan Daftar Semua Karyawan (GET)

Mendapatkan daftar semua karyawan dengan opsi paginasi.

* **Endpoint:** `GET /employee`
* **Operation ID:** `getAllEmployees`

| Parameter | Lokasi | Tipe | Format | Wajib | Default | Deskripsi |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **page** | Query | integer | int32 | TIDAK | 0 | Nomor halaman (dimulai dari 0). |
| **size** | Query | integer | int32 | TIDAK | 10 | Jumlah item per halaman. |

**Respons (200 OK):** Mengembalikan objek `AppResponsePageResponseListEmployeeResponse` (daftar karyawan dengan informasi paginasi).

### 1.5. Membuat Karyawan Baru (POST)

Membuat data karyawan baru.

* **Endpoint:** `POST /employee`
* **Operation ID:** `createEmployee`

**Request Body (application/json):** Menggunakan skema `EmployeeRequest`.

**Respons (200 OK):** Mengembalikan objek `AppResponseEmployeeResponse` (data karyawan yang baru dibuat).

---

## 2. Attendance Controller

Mengelola data Absensi (Kehadiran).

### 2.1. Mendapatkan Detail Absensi (GET)

Mendapatkan data detail absensi berdasarkan ID.

* **Endpoint:** `GET /attendance/{id}`
* **Operation ID:** `readAttendance`

| Parameter | Lokasi | Tipe | Format | Wajib | Deskripsi |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **id** | Path | string | uuid | YA | ID unik Absensi. |

**Respons (200 OK):** Mengembalikan objek `AppResponseAttendanceResponse`.

### 2.2. Memperbarui Data Absensi (PUT)

Memperbarui data detail absensi berdasarkan ID.

* **Endpoint:** `PUT /attendance/{id}`
* **Operation ID:** `updateAttendance`

| Parameter | Lokasi | Tipe | Format | Wajib | Deskripsi |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **id** | Path | string | uuid | YA | ID unik Absensi yang akan diperbarui. |

**Request Body (application/json):** Menggunakan skema `AttendanceRequest`.

**Respons (200 OK):** Mengembalikan objek `AppResponseAttendanceResponse`.

### 2.3. Menghapus Absensi (DELETE)

Menghapus data absensi berdasarkan ID.

* **Endpoint:** `DELETE /attendance/{id}`
* **Operation ID:** `deleteAttendance`

| Parameter | Lokasi | Tipe | Format | Wajib | Deskripsi |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **id** | Path | string | uuid | YA | ID unik Absensi yang akan dihapus. |

**Respons (200 OK):** Mengembalikan objek `AppResponseVoid` (konfirmasi tanpa data).

### 2.4. Mendapatkan Daftar Semua Absensi (GET)

Mendapatkan daftar semua data absensi dengan opsi paginasi.

* **Endpoint:** `GET /attendance`
* **Operation ID:** `readAttendance_1`

| Parameter | Lokasi | Tipe | Format | Wajib | Default | Deskripsi |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **page** | Query | integer | int32 | TIDAK | 0 | Nomor halaman (dimulai dari 0). |
| **size** | Query | integer | int32 | TIDAK | 10 | Jumlah item per halaman. |

**Respons (200 OK):** Mengembalikan objek `AppResponsePageResponseListAttendanceResponse` (daftar absensi dengan informasi paginasi).

### 2.5. Membuat Absensi Baru (POST)

Membuat data absensi baru.

* **Endpoint:** `POST /attendance`
* **Operation ID:** `createAttendance`

**Request Body (application/json):** Menggunakan skema `AttendanceRequest`.

**Respons (200 OK):** Mengembalikan objek `AppResponseListAttendanceResponse` (daftar data absensi yang baru dibuat).

### 2.6. Mencari Absensi Berdasarkan Tanggal (GET)

Mencari data absensi dalam rentang tanggal tertentu dengan opsi paginasi dan urutan.

* **Endpoint:** `GET /attendance/search`
* **Operation ID:** `searchAttendanceByAttendanceDate`

| Parameter | Lokasi | Tipe | Format | Wajib | Default | Deskripsi |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **startDate** | Query | string | date | TIDAK | | Tanggal mulai rentang pencarian (format `YYYY-MM-DD`). |
| **endDate** | Query | string | date | TIDAK | | Tanggal akhir rentang pencarian (format `YYYY-MM-DD`). |
| **size** | Query | integer | int32 | TIDAK | 10 | Jumlah item per halaman. |
| **page** | Query | integer | int32 | TIDAK | 0 | Nomor halaman (dimulai dari 0). |
| **ascending** | Query | boolean | | TIDAK | | Urutkan berdasarkan tanggal secara menaik (`true`) atau menurun (`false`). |

**Respons (200 OK):** Mengembalikan objek `AppResponsePageResponseListAttendanceResponse` (daftar hasil pencarian absensi dengan informasi paginasi).

---

## 3. Skema Data (Schemas)

### EmployeeRequest

Digunakan untuk membuat atau memperbarui data karyawan.

| Properti | Tipe | Format | Wajib | Deskripsi | Nilai Enum (Role) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **username** | string | | YA | Nama pengguna (unik). | |
| **firstName** | string | | YA | Nama depan. | |
| **lastName** | string | | YA | Nama belakang. | |
| **role** | string | | YA | Peran/Posisi karyawan. | `CUCI`, `PERSIAPAN`, `SATPAM`, `PEMORSIAN`, `MASAK`, `AKUNTAN`, `GIZI`, `DISTRIBUTOR`, `ASLAP` |

### EmployeeResponse

Digunakan sebagai format respons data karyawan.

| Properti | Tipe | Format | Deskripsi | Nilai Enum (Role) |
| :--- | :--- | :--- | :--- | :--- |
| **id** | string | uuid | ID unik Karyawan. | |
| **username** | string | | Nama pengguna. | |
| **firstName** | string | | Nama depan. | |
| **lastName** | string | | Nama belakang. | |
| **role** | string | | Peran/Posisi karyawan. | `CUCI`, `PERSIAPAN`, `SATPAM`, `PEMORSIAN`, `MASAK`, `AKUNTAN`, `GIZI`, `DISTRIBUTOR`, `ASLAP` |
| **createdDate** | string | date-time | Waktu pembuatan data. | |
| **updatedDate** | string | date-time | Waktu pembaruan data terakhir. | |

### AttendanceRequest

Digunakan untuk membuat atau memperbarui data absensi.

| Properti | Tipe | Format | Deskripsi | Nilai Enum (Status) |
| :--- | :--- | :--- | :--- | :--- |
| **employeeId** | array | uuid | Daftar ID karyawan yang terkait dengan status absensi ini. | |
| **attendanceDate** | string | date | Tanggal absensi (format `YYYY-MM-DD`). | |
| **status** | string | | Status absensi yang akan dicatat. | `ALFA`, `IZIN`, `SAKIT`, `ABSEN` |

### AttendanceResponse

Digunakan sebagai format respons data absensi.

| Properti | Tipe | Format | Deskripsi | Nilai Enum (Status) |
| :--- | :--- | :--- | :--- | :--- |
| **id** | string | uuid | ID unik Absensi. | |
| **attendanceDate** | string | date | Tanggal absensi. | |
| **status** | string | | Status absensi yang dicatat. | `ALFA`, `IZIN`, `SAKIT`, `ABSEN` |
| **employees** | EmployeeResponse | | Detail karyawan yang terkait (perhatikan ini bisa jadi hanya satu objek, meskipun Request-nya array). | |
| **createdDate** | string | date-time | Waktu pembuatan data. | |
| **updatedDate** | string | date-time | Waktu pembaruan data terakhir. | |
