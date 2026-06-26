import '../../../database/entity/user_entity.dart';
import '../model/auth_model.dart';

class AuthResult {
  final bool success;
  final String message;
  final UserEntity? user;
  final AuthModel? auth;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.auth,
  });

  factory AuthResult.ok(UserEntity user, AuthModel auth) =>
      AuthResult(success: true, message: 'Berhasil', user: user, auth: auth);

  factory AuthResult.fail(String message, {AuthModel? auth}) =>
      AuthResult(success: false, message: message, auth: auth);
}
