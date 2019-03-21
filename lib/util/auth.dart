import "package:flutter_facebook_login/flutter_facebook_login.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:firebase_auth/firebase_auth.dart";

class AuthUtil {
  static final _facebookSignIn = FacebookLogin();
  static final _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  static final _firebaseSignIn = FirebaseAuth.instance;

  /// Signs into firebase with the facebook credential when successful.
  static Future<void> signInFacebook(Function onSignedIn, Function onErrorOrCancel) async {
    try {
      final result = await _facebookSignIn.logInWithReadPermissions(["email"]);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          onSignedIn();
          return await _signInPortalFirebase([result.accessToken.token]);
        case FacebookLoginStatus.cancelledByUser: return onErrorOrCancel();
        case FacebookLoginStatus.error: break;
      }
    } catch (e) {
      print(e);
      onErrorOrCancel();
    }
  }

  /// Signs into firebase with the google credential when successful.
  static Future<void> signInGoogle(Function onSignedIn, Function onErrorOrCancel) async {
    try {
      final account = await _googleSignIn.signIn();

      if (account != null) {
        final auth = await account.authentication;

        onSignedIn();
        return await _signInPortalFirebase([auth.idToken, auth.accessToken]);
      }
    } catch (e) {
      print(e);
    }

    onErrorOrCancel();
  }

  /// To sign into firebase with facebook or google credentials.
  /// Throws and catches when there's an existing firebase account
  /// with the given email, unless you allow otherwise in your firebase
  /// console settings. 
  static Future<void> _signInPortalFirebase(List<String> tokens) async {
    try {
      AuthCredential credential;

      if (tokens.length == 1)
        credential = FacebookAuthProvider.getCredential(accessToken: tokens[0]);
      else
        credential = GoogleAuthProvider.getCredential(idToken: tokens[0], accessToken: tokens[1]);

      await _firebaseSignIn.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }

  /// Credentials: ``[email, password]``
  static Future<void> signInFirebase(List<String> credentials, Function onSignedIn, Function onError) async {
    try {
      await _firebaseSignIn.signInWithEmailAndPassword(
        email: credentials[0].trim(), password: credentials[1]
      );

      return onSignedIn();
    } catch (e) {
      print(e);
      onError();
    }
  }

  static Future<void> signUpFirebase(String email, String password, Function onSignedIn,
    Function onError
  ) async {
    try {
      await _firebaseSignIn.createUserWithEmailAndPassword(email: email, password: password);
      onSignedIn();
    } catch (e) {
      print(e);
      onError();
    }
  }

  static Future<void> resetFirebasePassword(String email, Function onDone, Function onError) async {
    try {
      await _firebaseSignIn.sendPasswordResetEmail(email: email);
      onDone();
    } catch (e) {
      print(e);
      onError();
    }
  }

  static Future<void> signOut() async {
    try {
      await _facebookSignIn.logOut();
      await _googleSignIn.signOut();
      await _firebaseSignIn.signOut();
    } catch (e) {
      print(e);
    }
  }
}