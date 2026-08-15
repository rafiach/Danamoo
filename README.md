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

## 📱 Screenshots

| 🏠 Home | 📊 Insight Chart | 📤 Export |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/0cfb498f-103b-4633-83b0-84c2b5210a31" width="250"> | <img src="https://github.com/user-attachments/assets/2a9cea1b-16a3-4bf1-81e4-d3e1a67242a0" width="250"> | <img src="https://github.com/user-attachments/assets/93a84dda-f32e-40f0-82ed-7f2c187b14cb" width="250"> |

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

## 👤 Author

**Rafi** — Mobile Developer (Flutter & Kotlin)
GitHub: [@rafiach](https://github.com/rafiach)

<!-- TODO opsional: tambahin link LinkedIn / Instagram Mas Mobi / kontak lain -->
