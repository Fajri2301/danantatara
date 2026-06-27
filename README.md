# Danantara (Dom) - Flutter App

Aplikasi *e-money* premium berbasis **Flutter** untuk Frontend, didukung oleh backend tangguh menggunakan **Golang (Gin + PostgreSQL)**, serta dilengkapi keamanan ekstra seperti Autentikasi Biometrik, 2FA (SMTP/TOTP), dan integrasi **Firebase Cloud Messaging (FCM)** untuk notifikasi _real-time_.

## 🔗 Repositori Terkait
- **Frontend E-Money (Flutter):** [https://github.com/Fajri2301/danantatara.git](https://github.com/Fajri2301/danantatara.git)
- **Backend E-Money (Golang API):** [https://github.com/Fajri2301/be-emoney.git](https://github.com/Fajri2301/be-emoney.git)
- **Toko Emas Digital (App):** [https://github.com/Fajri2301/uts_1123150166_tokoemasdigital.git](https://github.com/Fajri2301/uts_1123150166_tokoemasdigital.git)

## 📱 Fitur Utama

### 👤 User Features
- ✅ **Authentication Terpusat & Aman:**
  - Login & Register via JWT Token
  - Autentikasi 2FA via Email SMTP (OTP) & TOTP (Google Authenticator)
  - Fitur Login cepat dengan Biometrik (Fingerprint/FaceID)
- ✅ **Home & Dashboard:** 
  - Tampilan saldo secara *real-time*
  - Pintasan menu utama (Top Up, Transfer, QRIS/Scan)
- ✅ **Transaksi & Keuangan:**
  - P2P Transfer (Kirim saldo antar pengguna)
  - Top Up Saldo
  - Riwayat Transaksi terperinci
- ✅ **Pembayaran QR & Deep Linking:**
  - Pindai QR Code untuk pembayaran instan (*Mobile Scanner*)
  - *Deep Linking* (App Links) untuk menerima *request* transfer dari *link* URL
- ✅ **Notifikasi *Real-Time*:**
  - Menerima pesan instan melalui Push Notification (FCM) setiap transaksi sukses

### 🔧 Pengaturan Akun
- ✅ Profil dan Data Pengguna terintegrasi
- ✅ *Saved Cards* (Kartu Tersimpan) untuk mempermudah alur pendanaan

## 🛠️ Teknologi & Stack

| Teknologi | Fungsi |
|-----------|--------|
| **Flutter (Dart)** | Mobile Frontend (Android/iOS) |
| **BLoC / Cubit** | State Management Reaktif yang dapat diprediksi |
| **GetIt** | Dependency Injection (Penerapan Clean Architecture) |
| **Dio + Logger** | HTTP Client & REST API Integration |
| **Go Router** | Routing Dinamis & Deep Linking Navigasi |
| **Firebase FCM** | Layanan Push Notification Transaksional |
| **LocalAuth** | Biometric Authentication & Keamanan Perangkat |

## 🔄 Arsitektur & Pola Desain (Clean Architecture)
Aplikasi ini diimplementasikan dengan sangat ketat mengikuti kaidah **Clean Architecture** untuk standarisasi level-produksi:
- **Presentation Layer:** Berisi Widget, Screen, dan BLoC.
- **Domain Layer:** Berisi Entity murni, Repository Interfaces, dan UseCases.
- **Data Layer:** Berisi Implementation Repository, Data Sources (Remote/Local), dan mapping API (seharusnya DTO/Model).
- **Core Layer:** *Dependency Injection*, *Error Handling*, Konfigurasi Network (Dio Interceptors), dan *Constants*.

## 📂 Struktur Folder (Frontend - Flutter)

```
lib/
├── core/                   # Utilitas, Error, Constants, ApiClient, AppTheme
├── data/                   # Data sources (Remote/Local) & Repository Implementation
├── domain/                 # Entities, Repository Interface, Use Cases
├── injection/              # Dependency Injection (GetIt locator)
├── presentation/           # Pages, Widgets, BLoC
│   ├── blocs/              # Manajemen state tiap fitur (Auth, Account, Payment, Otp)
│   ├── pages/              # UI Pages (Auth, Home, Payment, Account, dll.)
│   └── widgets/            # Reusable UI components
└── main.dart
```

## 🚀 Setup & Installasi

### 1. Persiapan Backend
Silakan operasikan API Backend Golang dari folder `be-emoney/be-emoney` terlebih dahulu dan sesuaikan alamat API (seperti `http://192.168.x.x:8080`) di `lib/core/constants/app_constants.dart`.

### 2. Setup Frontend Flutter

```bash
cd danantara
flutter clean
flutter pub get
```

### 3. Setup Firebase Cloud Messaging (FCM)
1. Dapatkan file `google-services.json` dari Firebase Console.
2. Letakkan file tersebut di dalam `android/app/google-services.json`.

### 4. Build & Jalankan Aplikasi

```bash
flutter run
```

## 🎨 UI Design (Fintech Premium Theme)
Aplikasi dirancang untuk menampilkan kesan aplikasi *fintech* level-produksi (seperti Bank Digital atau dompet digital premium) yang intuitif, aman, dan responsif. Tema warna dan *styling* dipusatkan pada `core/theme/app_theme.dart`.

## 👥 Developer

**Fajri Khaerullah**
- NIM: 1123150166
- GitHub: [@Fajri2301](https://github.com/Fajri2301)
