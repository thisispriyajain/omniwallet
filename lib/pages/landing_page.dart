import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
                    // First small white rectangle with user icon and "user ID"
                    Container(
                      width: 350,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(4), // 4-point radius
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.account_circle, // User icon
                              color: Color(0xFF0093FF),
                              size: 30,
                            ),
                          ),
                          const Text(
                            'User ID',
                            style: TextStyle(
                              color: Color(0xFF0093FF),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height:
                            30), // Adds space between the two white rectangles
                    Container(
                      width: 350,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Icon(
                              Icons.lock, // Lock icon
                              color: Color(0xFF0093FF),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: const Text(
                              'Password',
                              style: TextStyle(
                                color: Color(0xFF0093FF),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const Spacer(), // Adds space between text and eye icon
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.remove_red_eye,
                              color: Color(0xFF0093FF),
                            ),
                          ),
                        ],
                      ),
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
}
