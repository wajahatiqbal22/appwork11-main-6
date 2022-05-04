import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_services/common/api_exception.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../models/user_model.dart';
import '../../providers/firebase_provider.dart';
import '../../providers/laravel_providers/laravel_provider.dart';
import '../../services/auth_service.dart';

part 'customer_user_repository.dart';
part 'provider_user_repository.dart';

abstract class UserRepository {
  Future<User> login(User user);

  Future<User> get(User user);

  Future<User> update(User user);

  Future<bool> sendResetLinkEmail(User user);

  Future<User> getCurrentUser();

  Future<User> register(User user);

  Future<bool> signInWithEmailAndPassword(String email, String password);

  Future<bool> signUpWithEmailAndPassword(String email, String password);

  Future<UserCredential> signInWithGoogle();

  Future<UserCredential> signInWithFacebook();

  Future<UserCredential> signInWithApple();

  Future<void> verifyPhone(String smsCode);

  Future<void> sendCodeToPhone();

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut();
}
