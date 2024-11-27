import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omniwallet/blocs/authentication/bloc/authentication_bloc.dart';

part 'login_state.dart';

class LogInCubit extends Cubit<LogInState> {
  //final AuthenticationBloc authenticationBloc;
  LogInCubit() : super(LogInInitial());

  Future<String?> emailSignIn(
      {required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Please enter both email and password.';
    }
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("logged in succesfully");
      emit(SignInSuccess());
      //authenticationBloc.add(AuthenticationLoginEvent());

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return 'Wrong password provided for that user.';
      } else {
        return e.code;
      }
    } catch (e) {
      return e.toString();
    }
  }

  void resetPasswordRequest() {
    emit(PasswordReset());
  }

  void signUpRequest() {
    emit(SignUpState());
  }

  void signInRequest() {
    emit(SignInInitial());
  }

  Future<String?> googleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        emit(SignInSuccess());
        //authenticationBloc.add(AuthenticationLoginEvent());
        return null;
      } catch (e) {
        return e.toString();
      }
    }
  }

  Future<String?> appleSignIn() async {
    final appleProvider = AppleAuthProvider();
    if (kIsWeb) {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(appleProvider);
    } else {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);
    }
    if (UserCredential != null) {
      emit(SignInSuccess());
      //authenticationBloc.add(AuthenticationLoginEvent());
    }
  }

  Future<String?> forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      emit(SignInInitial());
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.code;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> emailSignUp(
      {required String email,
      required String password,
      required String name,
      required String confirmPassword}) async {
    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        confirmPassword.isEmpty) {
      return 'Please fillout all the field.';
    }
    if (password != confirmPassword) {
      return 'Password and confirm password do not match.';
    }
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
        // name: name,
        //confirmPassword: confirmPassword
      );
      User? user = credential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      //emit(SignInSuccess());
      emit(SignInInitial());

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.code;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
