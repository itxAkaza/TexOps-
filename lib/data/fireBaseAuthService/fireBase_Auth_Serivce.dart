import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:texops/Utiles/utiles.dart';

class FirebaseAuthService {
  Future<UserCredential?> registerUserWithEmailAndPass({
    required String email,
    required String password,
  }) async {
    FirebaseApp? tempApp;

    try {
      tempApp = await Firebase.initializeApp(
        name: "temporaryApp",
        options: Firebase.app().options,
      );

      final FirebaseAuth tempAuth = FirebaseAuth.instanceFor(app: tempApp);

      final UserCredential userCredential = await tempAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    } on FirebaseException catch (e) {
      Utils.ShowSnackbar("Firebase error: ${e.message ?? 'Unknown error'}");
      return null;
    } catch (e) {
      Utils.ShowSnackbar("Unexpected error occurred. Try again.");
      return null;
    } finally {
      if (tempApp != null) {
        await tempApp.delete();
      }
    }
  }

  Future<UserCredential?> signIn({
    required String email,
    required String pass,
  }) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email.trim(), password: pass);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleSignInException(e);
      return null;
    } on FirebaseException catch (e) {
      Utils.ShowSnackbar("Firebase error: ${e.message ?? 'Unknown error'}");
      return null;
    } catch (e) {
      Utils.ShowSnackbar("Unexpected error occurred. Try again.");
      return null;
    }
  }

  Future<void> signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
  }

  void _handleAuthException(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'email-already-in-use':
        message = "This email is already registered.";
        break;
      case 'invalid-email':
        message = "Invalid email format.";
        break;
      case 'weak-password':
        message = "Password is too weak. Use at least 6 characters.";
        break;
      case 'operation-not-allowed':
        message = "Email/password signup is disabled.";
        break;
      case 'network-request-failed':
        message = "No internet connection. Try again.";
        break;
      case 'too-many-requests':
        message = "Too many attempts. Please wait and try again.";
        break;
      default:
        message = e.message ?? "Authentication failed.";
    }

    Utils.ShowSnackbar(message);
  }
}

void _handleSignInException(FirebaseAuthException e) {
  String message;

  switch (e.code) {
    case 'user-not-found':
      message = "No user found with this email.";
      break;
    case 'wrong-password':
      message = "Incorrect password. Try again.";
      break;
    case 'invalid-email':
      message = "Invalid email format.";
      break;
    case 'user-disabled':
      message = "This account has been disabled.";
      break;
    case 'too-many-requests':
      message = "Too many attempts. Please try later.";
      break;
    case 'network-request-failed':
      message = "No internet connection. Try again.";
      break;
    default:
      message = e.message ?? "Login failed.";
  }

  Utils.ShowSnackbar(message);
}
