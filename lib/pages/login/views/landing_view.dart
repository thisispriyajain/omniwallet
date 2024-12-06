import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LandingView extends StatefulWidget {
  const LandingView({
    super.key,
    required this.emailSignInCallback,
    required this.resetPasswordRequestCallback,
    required this.signUpRequestCallback,
    required this.googleSignInCallback,
    required this.appleSignInCallback,
  });
  final Future<String?> Function(
      {required String email, required String password}) emailSignInCallback;
  final void Function() resetPasswordRequestCallback;
  final void Function() signUpRequestCallback;
  final Future<String?> Function() googleSignInCallback;
  final Future<String?> Function() appleSignInCallback;

  @override
  State<LandingView> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingView> {
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? email;
  String? name;
  String? password;
  String? errorMessage;
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    emailController.text = "";
    passwordController.text = "";
    super.initState();
  }

  Future<String?> googleSignInCallback() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return 'Sign in aborted';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print(
          'Google User: ${googleUser.displayName}, Email: ${googleUser.email}');

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print('Name: ${user.displayName}, Email: ${user.email}');
        //check if the user already exists in Firestore
        final firestore = FirebaseFirestore.instance;
        final userDocRef = firestore.collection('users').doc(user.uid);

        //check if the user document exists
        await userDocRef.set({
          'name': user.email ?? 'No name provided',
          'email': user.email ?? 'No email provided',
        }, SetOptions(merge: true));
        setState(() {
          name = user.email;
          email = user.email;
        });
        print(
            'Firebase User: Name = ${user.displayName!}, Email = ${user.email!}');
        return null;
      } else {
        return 'User not found';
      }
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'OmniWallet',
          style: TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 45, // Increase text size
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100, // Increase the height of the AppBar
        titleSpacing: 0,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/app_icon.png',
                width: 150,
                height: 150,
              ),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF0093FF),
                ),
              ),
              AnimatedCrossFade(
                  firstChild: Container(),
                  secondChild: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(errorMessage ?? "Error",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onErrorContainer)),
                  ),
                  crossFadeState: crossFadeState,
                  duration: Duration(milliseconds: 300)),
              Container(
                // Blue rectangle
                margin: EdgeInsets.all(20),
                //padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Color(0xFF0093FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // First TextField with user icon and "User ID"
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .white), // White underline when not focused
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.white), // White underline when focused
                        ),
                      ),
                      onSaved: (newValue) {
                        email = emailController.text;
                      },
                      validator: (value) => null,
                    ),
                    // Second TextField for password with visibility toggle
                    _buildPasswordField(
                      controller: passwordController,
                      labelText: "Password",
                      isVisible: _isPasswordVisible,
                      onToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                width: double.maxFinite,
                //padding: EdgeInsets.only(top: 20, bottom: 0),
                child: FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        errorMessage = await widget.emailSignInCallback(
                            email: email!, password: password!);
                        if (errorMessage != null) {
                          setState(() {
                            emailController.clear();
                            passwordController.clear();
                            crossFadeState = CrossFadeState.showSecond;
                          });
                        }
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Color(0xFF0093FF),
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Log in")),
              ),
              SizedBox(height: 10),
              // Row for "Forgot Password" and "Sign Up" texts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TextButton(
                    //   child: Text("Forgot password"),
                    //   onPressed: widget.resetPassworReqestCallback,
                    // ),
                    TextButton(
                      child: Text("Forgot Password",
                          style: TextStyle(
                            color: Color(0xFF0093FF),
                            fontSize: 20,
                          )),
                      onPressed: widget.resetPasswordRequestCallback,
                    ),
                    TextButton(
                      child: Text("Sign up",
                          style: TextStyle(
                            color: Color(0xFF0093FF),
                            fontSize: 20,
                          )),
                      onPressed: widget.signUpRequestCallback,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: SignInButton(
                        Buttons.google,
                        onPressed: () async {
                          print('Google sign-in button pressed');
                          errorMessage = await widget.googleSignInCallback();
                          if (errorMessage != null) {
                            setState(() {});
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    // Container(
                    //     width: double.maxFinite,
                    //     child: SignInButton(
                    //       Buttons.apple,
                    //       onPressed: () async {
                    //         errorMessage = await widget.appleSignInCallback();
                    //         if (errorMessage != null) {
                    //           setState(() {});
                    //         }
                    //       },
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(100)),
                    //     )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    //SizedBox
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.white,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: onToggle,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white), // White underline when not focused
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white), // White underline when focused
        ),
      ),
      onSaved: (newValue) {
        if (labelText == "Password") {
          password = controller.text;
        }
      },
      validator: (value) => null,
    );
  }
}
