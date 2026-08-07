import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static final SupabaseClient _client = Supabase.instance.client;

  static User? get currentUser => _client.auth.currentUser;

  static Session? get currentSession => _client.auth.currentSession;

  static bool get isLoggedIn => currentSession != null;

  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  static Future<Map<String, dynamic>?> getProfile() async {
    if (currentUser == null) {
      debugPrint("Current user is null");
      return null;
    }

    debugPrint("Fetching profile for: ${currentUser!.id}");

    try {
      final profile = await _client
          .from('profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();

      debugPrint("PROFILE FOUND: $profile");

      return profile;
    } catch (e, s) {
      debugPrint("GET PROFILE ERROR: $e");
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    debugPrint("========== LOGIN ==========");
    debugPrint("Login User : ${response.user?.id}");
    debugPrint("Login Session : ${response.session != null}");
    debugPrint("Current Session : ${_client.auth.currentSession != null}");

    return response;
  }

  static Future<AuthResponse> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      debugPrint("========== SIGNUP START ==========");
      debugPrint("Email: $email");

      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'phone': phone, 'role': 'vendor'},
      );

      debugPrint("Signup Auth Success");
      debugPrint("User Id : ${response.user?.id}");

      return response;
    } on AuthException catch (e, s) {
      debugPrint("AUTH ERROR : ${e.message}");
      debugPrintStack(stackTrace: s);
      rethrow;
    } on PostgrestException catch (e, s) {
      debugPrint("DATABASE ERROR : ${e.message}");
      debugPrintStack(stackTrace: s);
      rethrow;
    } catch (e, s) {
      debugPrint("UNKNOWN ERROR : $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<void> forgotPassword({required String email}) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  static Future<void> logout() async {
    await _client.auth.signOut();
  }
}
