import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword(
      {super.key,
      required this.emailForgotPasswordCallback,
      required this.cancelRequestCallback});

  final Future<String?> Function({required String email})
      emailForgotPasswordCallback;
  final void Function() cancelRequestCallback;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();

  String? email;
  String? errorMessage;
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    emailController.text = "";
    super.initState();
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "We'll send your password reset info to the email address linked to your account.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                const SizedBox(height: 30),
                AnimatedCrossFade(
                    firstChild: Container(),
                    secondChild: Text(errorMessage ?? "Error",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error)),
                    crossFadeState: crossFadeState,
                    duration: const Duration(milliseconds: 300)),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email address"),
                  onSaved: (newValue) {
                    email = emailController.text;
                  },
                  validator: (value) => null,
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          errorMessage = await widget
                              .emailForgotPasswordCallback(email: email!);
                          if (errorMessage != null) {
                            setState(() {
                              emailController.clear();
                              crossFadeState = CrossFadeState.showSecond;
                            });
                          } else {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Password Reset"),
                                    content: const Text(
                                      "Please check your email for a password reseet link."
                                      " Once you set a new password, you can login in.",
                                    ),
                                    actions: [
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                            backgroundColor: const Color(0xFF0093FF)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0093FF),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Password Reset")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Got your password?"),
                    TextButton(
                      onPressed: widget.cancelRequestCallback,
                      child: Text("Log in",
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

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
