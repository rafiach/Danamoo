import 'package:danamoo/src/profile/model/profile_model.dart';
import 'package:flutter/material.dart';

import '../../../database/entity/category_entity.dart';
import '../../../database/entity/transaction_entity.dart';
import '../../../database/entity/user_entity.dart';
import '../../../database/service/user_service.dart';
import '../../../../data/sync_service.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// ...

enum ProfileStatus { initial, loading, loaded, saving, error }

class ProfileProvider extends ChangeNotifier {
  final UserService _userService;
  final SyncService _syncService;

  ProfileStatus _status = ProfileStatus.initial;
  ProfileModel? _profileModel;
  String? _errorMessage;

  ProfileProvider({
    required UserService userService,
    required SyncService syncService,
  }) : _userService = userService,
       _syncService = syncService;

  ProfileStatus get status => _status;
  ProfileModel? get profileModel => _profileModel;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ProfileStatus.loading;
  bool get isSaving => _status == ProfileStatus.saving;

  // ================= LOAD =================
  void load() {
    final entity = _userService.getCurrentUser();
    if (entity == null) return;

    _profileModel = _toProfileModel(entity);
    _status = ProfileStatus.loaded;
    notifyListeners();
  }

  // ================= UPDATE PROFILE =================
  Future<bool> updateProfile({
    String? name,
    String? currency,
    String? avatarPath,
    String? themeMode,
    bool? notifEnabled,
    String? notifTime,
  }) async {
    if (_profileModel == null) return false;
    _status = ProfileStatus.saving;
    notifyListeners();

    final entity = _userService.getCurrentUser();
    if (entity == null) {
      _status = ProfileStatus.error;
      _errorMessage = 'User tidak ditemukan';
      notifyListeners();
      return false;
    }

    final updated = entity.copyWith(
      name: name,
      currency: currency,
      avatarPath: avatarPath,
      themeMode: themeMode,
      notifEnabled: notifEnabled,
      notifTime: notifTime,
      updatedAt: DateTime.now(),
    );

    final success = await _userService.update(updated);

    if (success) {
      _profileModel = _toProfileModel(updated);
      _status = ProfileStatus.loaded;
      _errorMessage = null;
    } else {
      _status = ProfileStatus.error;
      _errorMessage = 'Gagal menyimpan perubahan';
    }

    notifyListeners();
    return success;
  }

  // ================= UPDATE INITIAL BALANCE =================
  Future<bool> updateInitialBalance(double amount) async {
    if (_profileModel == null) return false;
    _status = ProfileStatus.saving;
    notifyListeners();

    final success = await _userService.updateInitialBalance(
      _profileModel!.id,
      amount,
    );

    if (success) {
      _profileModel = ProfileModel(
        id: _profileModel!.id,
        name: _profileModel!.name,
        email: _profileModel!.email,
        currency: _profileModel!.currency,
        avatarPath: _profileModel!.avatarPath,
        themeMode: _profileModel!.themeMode,
        notifEnabled: _profileModel!.notifEnabled,
        notifTime: _profileModel!.notifTime,
        initialBalance: amount,
        lastBackupAt: _profileModel!.lastBackupAt,
        createdAt: _profileModel!.createdAt,
      );
      _status = ProfileStatus.loaded;
    } else {
      _status = ProfileStatus.error;
      _errorMessage = 'Gagal update saldo awal';
    }

    notifyListeners();
    return success;
  }

  Future<void> exportDataToExcel(
    List<TransactionEntity> transactions, {
    bool isShare = false,
  }) async {
    // 1. Buat instance Excel baru
    var excel = Excel.createExcel();

    // Ambil semua kategori untuk memetakan ID ke nama
    final allCategories = CategoryEntity.all;
    final categoryMap = {for (var cat in allCategories) cat.id: cat.name};
    // 2. Buat/pilih sheet
    Sheet sheetObject = excel['Transactions'];
    excel.setDefaultSheet('Transactions');

    // 3. Tambahkan Header (Baris Pertama)
    sheetObject.appendRow([
      TextCellValue('Tanggal'),
      TextCellValue('Tipe'),
      TextCellValue('Kategori'),
      TextCellValue('Deskripsi'),
      TextCellValue('Nominal'),
    ]);

    // 4. Masukkan data transaksi dari database menggunakan looping
    for (var tx in transactions) {
      sheetObject.appendRow([
        TextCellValue(tx.date.toIso8601String()),
        TextCellValue(tx.type.name),
        TextCellValue(
          categoryMap[tx.categoryId] ?? 'Tidak Diketahui',
        ), // Tampilkan nama kategori
        TextCellValue(tx.note ?? '-'),
        DoubleCellValue(tx.amount),
      ]);
    }

    // 5. Simpan file ke dalam bentuk bytes
    var fileBytes = excel.save();

    if (fileBytes != null) {
      if (isShare) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/Laporan_Transaksi.xlsx';
        File file = File(filePath);
        await file.writeAsBytes(fileBytes);

        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(filePath)],
            text: 'Berikut adalah laporan transaksi Anda.',
          ),
        );
      } else {
        // Opsi 2: Simpan ke penyimpanan perangkat (File Picker)
        await FileSaver.instance.saveAs(
          name: 'Laporan_Transaksi',
          bytes: Uint8List.fromList(fileBytes),
          fileExtension:
              'xlsx', // Gunakan 'ext' sesuai dokumentasi package file_saver
          mimeType: MimeType.microsoftExcel,
        );
      }
    }
  }

  // ================= CLOUD SYNC =================
  Future<bool> backupData() async {
    final entity = _userService.getCurrentUser();
    if (entity == null) return false;

    _status = ProfileStatus.saving;
    notifyListeners();

    final success = await _syncService.backupData(entity.id);

    if (success) {
      // Muat ulang untuk memperbarui lastBackupAt pada UI
      load();
    } else {
      _status = ProfileStatus.error;
      _errorMessage = 'Gagal melakukan backup data';
      notifyListeners();
    }
    return success;
  }

  Future<bool> restoreData() async {
    final entity = _userService.getCurrentUser();
    if (entity == null) return false;

    _status = ProfileStatus.saving;
    notifyListeners();

    final success = await _syncService.restoreData(entity.id);

    // Jika berhasil restore, muat ulang state profil
    load();
    return success;
  }

  // ================= HELPER =================
  ProfileModel _toProfileModel(UserEntity entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      currency: entity.currency,
      avatarPath: entity.avatarPath,
      themeMode: entity.themeMode,
      notifEnabled: entity.notifEnabled,
      notifTime: entity.notifTime,
      initialBalance: entity.initialBalance,
      lastBackupAt: entity.lastBackupAt,
      createdAt: entity.createdAt,
    );
  }

  void clear() {
    _profileModel = null;
    _status = ProfileStatus.initial;
    notifyListeners();
  }
}
