// Model khusus untuk ProfileView — sama konsepnya dengan HomeData
class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String currency;
  final String? avatarPath;
  final String themeMode;
  final bool notifEnabled;
  final String notifTime;
  final double initialBalance;
  final DateTime? lastBackupAt;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.currency,
    this.avatarPath,
    required this.themeMode,
    required this.notifEnabled,
    required this.notifTime,
    required this.initialBalance,
    this.lastBackupAt,
    required this.createdAt,
  });
}
