import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF0093FF),
          ),
          iconSize: 40,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 40,
                  color: Color(0xFF0093FF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 65),
              _buildTextField(
                hintText: 'Full name',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                hintText: 'Email address',
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                hintText: 'Password',
                isVisible: _isPasswordVisible,
                onToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                hintText: 'Confirm password',
                isVisible: _isConfirmPasswordVisible,
                onToggle: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0093FF),
                  minimumSize: const Size(200, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText}) {
    return SizedBox(
      width: 350,
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF0093FF), width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF0093FF), width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return SizedBox(
      width: 350,
      child: TextField(
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF0093FF),
            ),
            onPressed: onToggle,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF0093FF), width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF0093FF), width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
