part of 'user_repository.dart';

class ProviderUserRepository extends UserRepository {
  LaravelApiClient? _laravelApiClient;
  FirebaseProvider? _firebaseProvider;

  Future<User> login(User user) {
    try {
      _laravelApiClient = Get.find<ProviderApiClient>();
      return _laravelApiClient!.login(user);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<User> get(User user) {
    try {
      _laravelApiClient = Get.find<ProviderApiClient>();
      return _laravelApiClient!.getUser(user);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<User> update(User user) {
    try {
      _laravelApiClient = Get.find<ProviderApiClient>();
      return _laravelApiClient!.updateUser(user);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<bool> sendResetLinkEmail(User user) {
    try {
      _laravelApiClient = Get.find<ProviderApiClient>();
      return _laravelApiClient!.sendResetLinkEmail(user);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<User> getCurrentUser() {
    return this.get(Get.find<AuthService>().user.value);
  }

  Future<User> register(User user) {
    try {
      _laravelApiClient = Get.find<ProviderApiClient>();
      return _laravelApiClient!.register(user);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _firebaseProvider = Get.find<FirebaseProvider>();
      return _firebaseProvider!.signInWithEmailAndPassword(email, password);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    try {
      _firebaseProvider = Get.find<FirebaseProvider>();
      return _firebaseProvider!.signUpWithEmailAndPassword(email, password);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<void> verifyPhone(String smsCode) async {
    try {
      _firebaseProvider = Get.find<FirebaseProvider>();
      return _firebaseProvider!.verifyPhone(smsCode);
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future<void> sendCodeToPhone() async {
    try {
      _firebaseProvider = Get.find<FirebaseProvider>();

      return _firebaseProvider!.sendCodeToPhone();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  Future signOut() async {
    try {
      _firebaseProvider = Get.find<FirebaseProvider>();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      return await _firebaseProvider!.signOut();
    } on ApiException catch (e) {
      throw e.message;
    }
  }

  @override
  Future<UserCredential> signInWithApple() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return _firebaseProvider!.signInWithCredential(oauthCredential);
  }

  @override
  Future<UserCredential> signInWithFacebook() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return _firebaseProvider!.signInWithCredential(facebookAuthCredential);
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _firebaseProvider!.signInWithCredential(credential);
  }
}
