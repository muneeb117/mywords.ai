import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mywords/core/exceptions/apple_failure.dart';
import 'package:mywords/core/exceptions/google_failure.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthRepository {
  SocialAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// =================================== Google ===================================
  Future<({String name, String email})> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      print('google user :: $googleUser');
      return (name: googleUser.displayName ?? '', email: googleUser.email ?? '');

      // final AuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );
      //
      // UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      // return userCredential;
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (e) {
      throw LogInWithGoogleFailure(e.toString());
    }
  }

  /// =================================== Apple ===================================

  Future<void> loginWithApple() async {
    try {
      // final appleProvider = AppleAuthProvider();
      // await _firebaseAuth.signInWithProvider(appleProvider);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('Apple error :: ${e.toString()}');
      throw LogInWithAppleFailure.fromCode(e.code);
    } catch (e) {
      print('Apple error :: ${e.toString()}');
      throw const LogInWithAppleFailure();
    }
  }
}
