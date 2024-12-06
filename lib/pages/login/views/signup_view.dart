import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupView extends StatefulWidget {
  const SignupView(
      {super.key,
      required this.emailSignUpCallback,
      required this.signInRequestCallback});
  final Future<String?> Function(
      {required String email,
      required String password,
      required String name,
      required String confirmPassword}) emailSignUpCallback;
  final void Function() signInRequestCallback;

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? email;
  String? password;
  String? name;
  String? confirmPassword;
  String? errorMessage;
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    emailController.text = "";
    passwordController.text = "";
    super.initState();
  }

  Future<void> _storeUserInFirestore(
      User user, String name, String email) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'OmniWallet',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Color(0xFF0093FF),
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
        titleSpacing: 0,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20.0),
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 45),
                Text(
                  "Sign up",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Color(0xFF0093FF),
                      ),
                  textAlign: TextAlign.center,
                ),
                //SizedBox(height: 65),
                AnimatedCrossFade(
                    firstChild: Container(),
                    secondChild: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(errorMessage ?? "Error",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer)),
                    ),
                    crossFadeState: crossFadeState,
                    duration: const Duration(milliseconds: 300)),
                TextFormField(
                  controller: fullnameController,
                  decoration: const InputDecoration(labelText: "Name"),
                  onSaved: (newValue) {
                    name = fullnameController.text;
                  },
                  validator: (value) => null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email address"),
                  onSaved: (newValue) {
                    email = emailController.text;
                  },
                  validator: (value) => null,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                _buildPasswordField(
                    controller: confirmPasswordController,
                    labelText: "Confirm password",
                    isVisible: _isConfirmPasswordVisible,
                    onToggle: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    }),
                const SizedBox(height: 30),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          errorMessage = await widget.emailSignUpCallback(
                              email: email!,
                              password: password!,
                              name: name!,
                              confirmPassword: confirmPassword!);
                          if (errorMessage != null) {
                            setState(() {
                              emailController.clear();
                              passwordController.clear();
                              crossFadeState = CrossFadeState.showSecond;
                            });
                          } else {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await _storeUserInFirestore(user, name!, email!);
                            }
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title: Text("Thank you for signing up!"),
                                    content: Text(
                                        "Please check your email for verifying your email address."),
                                  );
                                });
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0093FF),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Sign up")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    TextButton(
                      onPressed: widget.signInRequestCallback,
                      child: Text("Sign in",
                          style: TextStyle(
                            color: Color(0xFF0093FF),
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
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
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: onToggle,
        ),
      ),
      onSaved: (newValue) {
        if (labelText == "Password") {
          password = controller.text;
        } else {
          confirmPassword = controller.text;
        }
      },
      validator: (value) => null,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
