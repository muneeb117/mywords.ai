import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/storage/storage_service.dart';
import 'package:mywords/utils/logger/logger.dart';

/// Handles session-related data such as login state and token management.
class SessionRepository {
  final StorageService _storageService;

  SessionRepository({required StorageService storageService}) : _storageService = storageService;

  final _log = logger(SessionRepository);

  // ------------------------
  // Login State
  // ------------------------

  Future<void> setLoggedIn(bool value) async {
    await _storageService.setBool(AppKeys.isLoggedIn, value);
    _log.i('setLoggedIn: $value');
  }

  bool isUserLoggedIn() {
    final isLoggedIn = _storageService.getBool(AppKeys.isLoggedIn) ?? false;
    _log.i('isUserLoggedIn: $isLoggedIn');
    return isLoggedIn;
  }

  // ------------------------
  // Onboarding
  // ------------------------
  /// Returns true if the user is using the app for the first time.
  bool checkIfNewUser() {
    return _storageService.getBool(AppKeys.isNewUser) ?? true;
  }

  void completeOnboarding() {
    _storageService.setBool(AppKeys.isNewUser, false);
  }

  // ------------------------
  // Token Management
  // ------------------------

  Future<void> setToken(String token) async {
    await _storageService.setString(AppKeys.token, token);
    _log.i('setToken: token set');
  }

  String? getToken() {
    final token = _storageService.getString(AppKeys.token);
    _log.i('getToken: ${token != null ? 'token retrieved' : 'no token found'}');
    return token;
  }

  Future<void> removeToken() async {
    await _storageService.remove(AppKeys.token);
    _log.i('removeToken: token removed');
  }

  // ------------------------
  // Helper
  // ------------------------

  /// Clears all session-related data (login + token).
  Future<void> clearSession() async {
    await _storageService.remove(AppKeys.isLoggedIn);
    await _storageService.remove(AppKeys.token);
    _log.i('clearSession: login state and token cleared');
  }
}
