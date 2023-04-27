import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> registerUser(
      {required String email, required String password}) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return 'please enter all the fields';
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        return 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return e.runtimeType.toString();
    }

    return 'Unexpected error happened, please try again later';
  }

  //login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Please enter all the fields';
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return 'success';
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException with specific error messages
      if (e.code == 'user-not-found') {
        return 'User not found. Please check your email or sign up';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password. Please try again';
      } else {
        return 'Error: ${e.code}. Please try again later';
      }
    } catch (e) {
      // Handle other exceptions with a generic error message
      return 'Error occurred. Please try again later';
    }

    // Return a default error message if none of the above conditions are met
    return 'Unexpected error occurred. Please try again later';
  }

  //method to logout user

  Future<void> logoutUser() async {
    await _auth.signOut();
  }
}//end class



