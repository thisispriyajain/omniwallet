import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isPasswordVisible = false;

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
      body: GestureDetector(
        onTap: () {
          // Handle tap event here if needed
        },
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/app_icon.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF0093FF),
                ),
              ),
              SizedBox(height: 20),
              Container(
                // Blue rectangle
                width: double.infinity,
                height: 200,
                color: Color(0xFF0093FF),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // First TextField with user icon and "User ID"
                    _buildTextField(
                      hintText: 'User ID',
                      icon: Icons.account_circle,
                    ),
                    SizedBox(height: 30), // Space between fields
                    // Second TextField for password with visibility toggle
                    _buildPasswordField(
                      hintText: 'Password',
                      icon: Icons.lock,
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height:
                      30), // Space between the blue rectangle and the button
              ElevatedButton(
                onPressed: () {
                  // Add the action for the button here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0093FF), // Button color
                  minimumSize: Size(125, 50), // Button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Text color
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Row for "Forgot Password" and "Sign Up" texts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle Forgot Password action
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Color(0xFF0093FF),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle Sign Up action
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF0093FF),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
  }) {
    return SizedBox(
      width: 350,
      height: 45,
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 18,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            icon,
            color: Color(0xFF0093FF),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: Color(0xFF0093FF),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hintText,
    required IconData icon,
  }) {
    return SizedBox(
      width: 350,
      height: 45,
      child: TextField(
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 18,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            icon,
            color: Color(0xFF0093FF),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF0093FF),
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: Color(0xFF0093FF),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
