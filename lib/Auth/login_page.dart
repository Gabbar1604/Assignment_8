import 'package:assignment_08/Auth/forget_password_page.dart';
import 'package:assignment_08/Auth/signup_page_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  bool offsecureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight:
                  size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 48 : 24,
              vertical: isTablet ? 40 : 20,
            ),
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: isTablet ? 60 : 40),

                  Container(
                    width: isTablet ? 120 : 100,
                    height: isTablet ? 120 : 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: isTablet ? 60 : 50,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: isTablet ? 40 : 32),

                  // Welcome Text
                  Column(
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: isTablet ? 32 : 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      Text(
                        "Sign in to manage your finances",
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: isTablet ? 50 : 40),

                  // Login Form Container
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 400 : double.infinity,
                    ),
                    padding: EdgeInsets.all(isTablet ? 32 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        _buildInputField(
                          controller: emailcontroller,
                          label: 'Email Address',
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            String pattern =
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          isTablet: isTablet,
                        ),

                        SizedBox(height: isTablet ? 24 : 20),

                        // Password Field
                        _buildInputField(
                          controller: passwordcontroller,
                          label: 'Password',
                          hint: 'Enter your password',
                          icon: Icons.lock_outline,
                          obscureText: offsecureText,
                          suffixIcon: IconButton(
                            icon: Icon(
                              offsecureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF64748B),
                            ),
                            onPressed: () {
                              setState(() {
                                offsecureText = !offsecureText;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 24 : 20),
                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: const Color(0xFF6366F1),
                                fontSize: isTablet ? 14 : 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 32 : 24),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: isTablet ? 56 : 52,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                await loginUser();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: const Color(
                                0xFF6366F1,
                              ).withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 32 : 24),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: isTablet ? 14 : 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: const Color(0xFF6366F1),
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isTablet ? 40 : 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    if (emailcontroller.text.isEmpty || passwordcontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Email & password cannot be empty",
        backgroundColor: Colors.red,
      );
      return;
    }

    // Show loading indicator
    Fluttertoast.cancel(); // Cancel any previous toast
    Fluttertoast.showToast(
      msg: "Signing in...",
      backgroundColor: Colors.blue,
      toastLength: Toast.LENGTH_SHORT,
    );

    try {
      final String email = emailcontroller.text.trim();
      final String password = passwordcontroller.text;

      print("Attempting login for: $email");

      // Check if user exists in Firestore
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        Fluttertoast.showToast(
          msg: "User does not exist. Please sign up first.",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }

      // Proceed with Firebase Auth login
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          Fluttertoast.showToast(
            msg: "Session expired. Please try again.",
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
          );
          return;
        }

        print("Login successful for: ${user.email}");
        print("Email verified: ${user.emailVerified}");

        // Check if email is verified
        print("✅ User login successful: ${user.email}");
        // User will be automatically navigated by AuthGate
        Fluttertoast.showToast(
          msg: "Welcome back!",
          backgroundColor: Colors.green,
        );
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth error: ${e.code} - ${e.message}");
      String errorMessage = "Login failed";

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "User does not exist. Please sign up first.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format";
          break;
        case 'user-disabled':
          errorMessage = "This account has been disabled";
          break;
        case 'too-many-requests':
          errorMessage = "Too many login attempts. Please try again later.";
          break;
        case 'network-request-failed':
          errorMessage = "Network error. Please check your connection.";
          break;
        case 'operation-not-allowed':
          errorMessage = "Email/password sign-in is disabled.";
          break;
        case 'invalid-credential':
          errorMessage = "Invalid email or password.";
          break;
        default:
          errorMessage = "Login failed: ${e.message}";
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      print("General login error: $e");
      String errorMessage = "Login failed: An unexpected error occurred.";

      if (e.toString().contains('User not found in database')) {
        errorMessage = "User does not exist. Please sign up first.";
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: isTablet ? 8 : 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: const Color(0xFF1F2937),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF6B7280),
              size: isTablet ? 22 : 20,
            ),
            suffixIcon: suffixIcon,
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: isTablet ? 14 : 13,
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 14,
              vertical: isTablet ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }
}
