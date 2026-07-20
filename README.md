# 🐄 DanaMoo

> Catat pemasukan-pengeluaran, lihat insight lewat grafik, data aman tersimpan offline maupun cloud.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Status](https://img.shields.io/badge/status-in%20development-orange)]()

DanaMoo adalah aplikasi pencatatan keuangan pribadi yang dikembangkan **end-to-end sendiri** (frontend sampai backend/cloud). Dibuat buat siapa pun yang butuh cara sederhana mencatat pemasukan & pengeluaran harian dan memahami pola keuangannya — tanpa harus connect langsung ke rekening bank/e-wallet.

---

## ✨ Fitur Utama

- 📝 **CRUD pencatatan** pemasukan & pengeluaran
- 📊 **Visualisasi grafik** (chart insight) untuk melihat pola pengeluaran
- 🔐 **Login/autentikasi akun** (Firebase Auth)
- ☁️ **Penyimpanan ganda** — lokal (offline) + Cloud Firestore, tetap bisa diakses tanpa internet
- 💾 **Backup & restore data**
- 📤 **Export laporan ke Excel** — siap dibagikan atau dicetak
- 🔔 **Notifikasi lokal** — pengingat mencatat transaksi

---

## 🛠️ Tech Stack

| Layer | Tools |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Provider (`ChangeNotifier`) |
| Local Storage | SharedPreferences |
| Cloud Storage | Cloud Firestore |
| Authentication | Firebase Auth |
| Chart / Visualisasi | fl_chart |
| Export Data | excel, file_saver, share_plus |
| Notifikasi | flutter_local_notifications |
| Utilities | uuid, intl, crypto |

---

## 📱 Screenshot

<!-- TODO: tempel screenshot aplikasi di sini, contoh:
| Home | Insight Chart | Export |
|---|---|---|
| ![home](assets/screenshots/home.png) | ![chart](assets/screenshots/chart.png) | ![export](assets/screenshots/export.png) |
-->

---

## 🚀 Instalasi & Menjalankan

```bash
# 1. Clone repo
git clone https://github.com/rafiach/Danamoo.git
cd Danamoo

# 2. Install dependencies
flutter pub get

# 3. Setup Firebase
# Tambahkan file konfigurasi Firebase kamu sendiri:
# - android/app/google-services.json
# - ios/Runner/GoogleService-Info.plist
# (project ini pakai firebase_core, cloud_firestore, dan firebase_auth)

# 4. Jalankan aplikasi
flutter run
```

---

## 🧭 Roadmap

- [ ] <!-- TODO: contoh — sinkronisasi otomatis e-wallet/m-banking -->
- [ ] <!-- TODO: kategori pengeluaran custom -->
- [ ] <!-- TODO: tambahin rencana lain di sini -->

---

## 👤 Author

**Rafi** — Mobile Developer (Flutter & Kotlin)
GitHub: [@rafiach](https://github.com/rafiach)

<!-- TODO opsional: tambahin link LinkedIn / Instagram Mas Mobi / kontak lain -->