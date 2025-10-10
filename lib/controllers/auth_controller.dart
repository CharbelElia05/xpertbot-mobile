import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _authService.currentUser;

  AuthController() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      notifyListeners();
    });
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();

      return user != null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getUserFriendlyError(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(email: email, password: password);

      _isLoading = false;
      notifyListeners();

      return user != null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getUserFriendlyError(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getUserFriendlyError(e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Helper method for user-friendly error messages
  String _getUserFriendlyError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already registered. Please login instead.';
    } else if (error.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (error.contains('wrong-password')) {
      return 'Invalid password. Please try again.';
    } else if (error.contains('user-not-found')) {
      return 'No account found with this email. Please register first.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak. Please choose a stronger password.';
    } else if (error.contains('user-disabled')) {
      return 'This account has been disabled. Please contact support.';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  // Utility getters
  bool get isLoggedIn => currentUser != null;
  String? get userEmail => currentUser?.email;
  String? get userName => currentUser?.displayName;

  Stream<User?> get authStateChanges => _authService.authStateChanges;
}
