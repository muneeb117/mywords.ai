import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, OAuthProvider, User, UserCredential;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mywords/core/exceptions/apple_failure.dart';
import 'package:mywords/core/exceptions/google_failure.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthRepository {
  SocialAuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// =================================== Google ===================================

  Future<({String name, String email})> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Google sign-in was cancelled by user.';
      }

      await googleUser.authentication;
      return (name: googleUser.displayName ?? '', email: googleUser.email);
    } catch (e) {
      throw LogInWithGoogleFailure(e.toString());
    }
  }

  /// =================================== Apple ===================================

  Future<({String name, String email})> loginWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;
      String userName = '';
      if (appleCredential.givenName != null && appleCredential.familyName != null) {
        userName = '${appleCredential.givenName} ${appleCredential.familyName}';
      } else if (appleCredential.givenName != null) {
        userName = appleCredential.givenName!;
      }

      if (userName.isNotEmpty) {
        await user?.updateDisplayName(userName);
      }
      String displayName;
      if (user?.displayName != null && user!.displayName!.isNotEmpty) {
        displayName = user.displayName!;
      } else if (userName.isNotEmpty) {
        displayName = userName;
      } else {
        displayName = 'Username';
      }
      print('final display name :: $displayName');
      final email = user?.email ?? 'user@gmail.com';
      return (name: displayName, email: email);
    } on FirebaseAuthException catch (e) {
      print('Apple error fb:: ${e.toString()}');
      throw LogInWithAppleFailure.fromCode(e.code);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const LogInWithAppleFailure('cancelled by user');
      } else {
        throw LogInWithAppleFailure(e.message);
      }
    } catch (e) {
      print('Apple error nm :: ${e.toString()}');
      throw const LogInWithAppleFailure();
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
