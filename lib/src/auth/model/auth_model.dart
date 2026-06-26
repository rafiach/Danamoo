class AuthModel {
  final String id;
  final String userId;
  final String passwordHash;
  final String? pinHash;
  final bool isBiometricEnabled;
  final bool isLoggedIn;
  final DateTime? lastLoginAt;
  final int failedAttempts;
  final DateTime? lockedUntil;
  final String? firebaseUid;
  final String? firebaseToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  AuthModel({
    required this.id,
    required this.userId,
    required this.passwordHash,
    this.pinHash,
    this.isBiometricEnabled = false,
    this.isLoggedIn = false,
    this.lastLoginAt,
    this.failedAttempts = 0,
    this.lockedUntil,
    this.firebaseUid,
    this.firebaseToken,
    required this.createdAt,
    required this.updatedAt,
  });

  // ================= FROM JSON =================
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      pinHash: json['pin_hash'],
      isBiometricEnabled: json['is_biometric_enabled'] ?? false,
      isLoggedIn: json['is_logged_in'] ?? false,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,
      failedAttempts: json['failed_attempts'] ?? 0,
      lockedUntil: json['locked_until'] != null
          ? DateTime.parse(json['locked_until'])
          : null,
      firebaseUid: json['firebase_uid'],
      firebaseToken: json['firebase_token'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'password_hash': passwordHash,
      'pin_hash': pinHash,
      'is_biometric_enabled': isBiometricEnabled,
      'is_logged_in': isLoggedIn,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'failed_attempts': failedAttempts,
      'locked_until': lockedUntil?.toIso8601String(),
      'firebase_uid': firebaseUid,
      'firebase_token': firebaseToken,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // ================= COPY WITH =================
  AuthModel copyWith({
    String? id,
    String? userId,
    String? passwordHash,
    String? pinHash,
    bool? isBiometricEnabled,
    bool? isLoggedIn,
    DateTime? lastLoginAt,
    int? failedAttempts,
    DateTime? lockedUntil,
    String? firebaseUid,
    String? firebaseToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      passwordHash: passwordHash ?? this.passwordHash,
      pinHash: pinHash ?? this.pinHash,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      firebaseToken: firebaseToken ?? this.firebaseToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ================= HELPERS =================
  bool get isLocked =>
      lockedUntil != null && DateTime.now().isBefore(lockedUntil!);

  @override
  String toString() =>
      'AuthModel(id: $id, userId: $userId, isLoggedIn: $isLoggedIn)';
}
