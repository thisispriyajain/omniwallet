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
        title: const Text(
          'OmniWallet',
          style: TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
        titleSpacing: 0,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: Color(0xFF0093FF),
        //   ),
        //   iconSize: 40,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "We'll send your password reset info to the email address linked to your account.",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email address"),
                  onSaved: (newValue) {
                    email = emailController.text;
                  },
                  validator: (value) => null,
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
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
                                    title: Text("Password Reset"),
                                    content: Text(
                                      "Please check your email for a password reseet link."
                                      " Once you set a new password, you can login in.",
                                    ),
                                    actions: [
                                      FilledButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Color(0xFF0093FF),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Password Reset")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Found your password?"),
                    TextButton(
                      child: Text("Cancel",
                          style: TextStyle(
                            color: Color(0xFF0093FF),
                          )),
                      onPressed: widget.cancelRequestCallback,
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
}
