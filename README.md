# 📝 Aplikasi Todo List

Aplikasi **ToDo List** ini dibuat menggunakan **Flutter** sebagai frontend, serta terhubung dengan **API Laravel** dan **MySQL Database** untuk menyimpan data todo pengguna.

Fitur utama:
- Login & Registrasi pengguna
- Menambah tugas
- Menghapus tugas
- Menandai tugas sebagai selesai

---

## 📱 Halaman-Halaman Aplikasi

1. **Splash Screen** – Tampilan awal saat loading  
2. **Login Screen** – Form login pengguna  
3. **Register Screen** – Form registrasi pengguna baru  
4. **Todo List Screen** – Menampilkan daftar tugas pengguna  
5. **Add/Edit Task** – Menambah atau mengedit tugas  

---

## 🗄️ Database

- **Jenis:** MySQL  
- **Nama Database:** `todoflutter`  
- **Tabel:**  
  - `users`  
  - `todos`  

---

## 🌐 API (Laravel)

| Method | Endpoint        | Deskripsi                    |
|--------|------------------|------------------------------|
| POST   | `/register`      | Registrasi pengguna baru     |
| POST   | `/login`         | Login pengguna               |
| GET    | `/todos`         | Ambil semua todo milik user  |
| POST   | `/todos`         | Tambah todo baru             |
| PUT    | `/todos/:id`     | Update status todo           |
| DELETE | `/todos/:id`     | Hapus todo                   |

---

## 🧰 Software yang Digunakan

- Flutter SDK (^3.6.1)  
- Dart  
- Visual Studio Code  
- Laragon (MySQL)  
- Laravel 11 (Backend API)  

---

## ⚙️ Cara Instalasi

### 🔹 Frontend (Flutter)

```bash
git clone https://github.com/vinaxixie/todolist_app.git
cd todolist_app
flutter pub get
flutter run
```

### 🔹 Backend (Laravel)

```bash
cd todoflutter
composer install
cp .env.example .env
php artisan key:generate
```

Edit file `.env`:

```env
DB_DATABASE=todoflutter
DB_USERNAME=root
DB_PASSWORD=
```

**Import Database:**
1. Buka phpMyAdmin  
2. Buat database baru dengan nama `todoflutter`  
3. Import file `todoflutter.sql` dari folder `database/`  

**Jalankan Migrasi dan Server Laravel:**

```bash
php artisan migrate
php artisan serve
```

---

## ▶️ Cara Menjalankan Aplikasi

1. Jalankan Laravel backend:
   ```bash
   php artisan serve
   ```
   *(atau gunakan `php artisan serve --host=0.0.0.0 --port=8000` jika diperlukan)*

2. Jalankan Flutter frontend:
   ```bash
   flutter run
   ```

3. Aplikasi akan menampilkan halaman Login/Register  
4. Setelah login, pengguna dapat mengelola daftar tugas  
5. **Catatan:** Pastikan base URL di Flutter mengarah ke alamat backend:
   - `http://10.0.2.2:8000/api` (Android emulator)
   - `http://127.0.0.1:8000/api` (langsung di lokal)

---

## 🎥 Demo Aplikasi

📹 [Klik di sini untuk melihat demo aplikasi (Google Drive)](https://drive.google.com/drive/folders/13Bx0N3rDP4fGVgpzxJhnIg4PpX1tk8bE?usp=sharing)

---

## 👩‍💻 Identitas Pembuat

- **Nama:** Levina Devi Azaria  
- **Kelas:** XI RPL 1  
- **Mapel:** Pemrograman Perangkat Bergerak  

---

> 💡 Terima kasih telah menggunakan aplikasi ini! Semoga bermanfaat.
