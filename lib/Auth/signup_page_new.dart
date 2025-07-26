import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool offsecureText = true;

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
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
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
            letterSpacing: 0.3,
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
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: isTablet ? 15 : 13,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF6B7280),
              size: isTablet ? 22 : 20,
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFF87171),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF87171), width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 14,
              vertical: isTablet ? 16 : 14,
            ),
          ),
        ),
      ],
    );
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
                  SizedBox(height: isTablet ? 40 : 20),

                  // Logo/Icon Section
                  Container(
                    width: isTablet ? 100 : 80,
                    height: isTablet ? 100 : 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.3),
                          blurRadius: 25,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_add_rounded,
                      size: isTablet ? 45 : 40,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: isTablet ? 32 : 24),

                  // Welcome Text
                  Column(
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      Text(
                        "Join us to manage your finances better",
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 13,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: isTablet ? 40 : 32),

                  // Signup Form Container
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
                        // Name Field
                        _buildInputField(
                          controller: namecontroller,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          isTablet: isTablet,
                        ),

                        SizedBox(height: isTablet ? 20 : 16),

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

                        SizedBox(height: isTablet ? 20 : 16),

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

                        SizedBox(height: isTablet ? 28 : 24),

                        // Create Account Button
                        SizedBox(
                          width: double.infinity,
                          height: isTablet ? 56 : 52,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                await RegistorUser();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: const Color(
                                0xFF10B981,
                              ).withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 16 : 12),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 24 : 20),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: isTablet ? 14 : 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: const Color(0xFF10B981),
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isTablet ? 32 : 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> RegistorUser() async {
    if (!formkey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Please fill all fields correctly",
        backgroundColor: Colors.red,
      );
      return;
    }

    if (passwordcontroller.text.length < 6) {
      Fluttertoast.showToast(
        msg: "Password must be at least 6 characters",
        backgroundColor: Colors.red,
      );
      return;
    }

    // Pehle email verification bhejte hain
    await _sendEmailVerificationBeforeSignup();
  }

  // Pehle email verification bhejne ka function
  Future<void> _sendEmailVerificationBeforeSignup() async {
    try {
      String email = emailcontroller.text.trim();
      String password = passwordcontroller.text;
      String name = namecontroller.text.trim();

      print("🚀 Step 1: Pehle email verification bhej rahe hain to: $email");

      Fluttertoast.showToast(
        msg: "📧 Email verification sending....",
        backgroundColor: Colors.blue,
        toastLength: Toast.LENGTH_SHORT,
      );

      // Temporary account banate hain sirf email verification ke liye
      UserCredential tempUserCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? tempUser = tempUserCredential.user;
      if (tempUser != null) {
        print("✅ Temporary account bana: ${tempUser.uid}");

        // Display name set kar dete hain
        await tempUser.updateDisplayName(name);

        // Email verification bhejte hain
        try {
          await tempUser.sendEmailVerification();
          print("✅ Email verification sent: ${tempUser.email}");

          Fluttertoast.showToast(
            msg: "📧 Verification email is sent to your Email's spam folder.",
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
          );

          // Verification dialog show karte hain
          _showPreSignupVerificationDialog(email, password, name);
        } catch (emailError) {
          print("❌ Email verification failed: $emailError");

          // Account delete kar dete hain agar email nahi bhej saka
          await tempUser.delete();

          Fluttertoast.showToast(
            msg: "❌ Email verification not sent. Try again later.",
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      }
    } catch (e) {
      print("❌ Pre-signup verification mein error: $e");
      String errorMessage = "❌ Email verification failed.";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "❌ Email already registered, please login.";
            break;
          case 'invalid-email':
            errorMessage = "❌ Invalid email address.";
            break;
          case 'weak-password':
            errorMessage =
                "❌ Password is too weak, please choose a stronger password.";
            break;
          default:
            errorMessage = "❌ Signup error: ${e.message}";
        }
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // Email verification ke baad signup dialog
  void _showPreSignupVerificationDialog(
    String email,
    String password,
    String name,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '📧 Email Verify ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mark_email_unread, size: 60, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'Verification email is sent to your Email\'s spam folder:\n$email',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Check your email and click the verification link. After verifying, press the "I Verified" button.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '💡 Your account will only be created after you verify your real email!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Resend email verification
              try {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.sendEmailVerification();
                  Fluttertoast.showToast(
                    msg:
                        "📧 Verification email is sent again to your Email's spam folder.",
                    backgroundColor: Colors.blue,
                  );
                }
              } catch (e) {
                Fluttertoast.showToast(
                  msg: "Problem in resending verification email.",
                  backgroundColor: Colors.red,
                );
              }
            },
            child: const Text('📧 Resend'),
          ),
          TextButton(
            onPressed: () async {
              // Check if email is verified
              try {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.reload();
                  user = FirebaseAuth.instance.currentUser;

                  if (user != null && user.emailVerified) {
                    // Email verified, ab database mein save karo
                    try {
                      await addUserData(user.uid, name, email);

                      Fluttertoast.showToast(
                        msg: "✅ Email verified! Account is ready.",
                        backgroundColor: Colors.green,
                        toastLength: Toast.LENGTH_LONG,
                      );

                      Navigator.of(context).pop(); // Close dialog
                      Navigator.pop(context); // Go to login
                    } catch (dbError) {
                      print("Database save error: $dbError");
                      Fluttertoast.showToast(
                        msg:
                            "Account verified but there was a problem saving to the database.",
                        backgroundColor: Colors.orange,
                      );
                    }
                  } else {
                    Fluttertoast.showToast(
                      msg:
                          "❌ Email is not verified yet. Please check your inbox and spam folder.",
                      backgroundColor: Colors.orange,
                    );
                  }
                }
              } catch (e) {
                Fluttertoast.showToast(
                  msg: "❌ Verification failed.",
                  backgroundColor: Colors.red,
                );
              }
            },
            child: const Text('Verified !'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Cancel and delete account
              try {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.delete();
                  print("Temporary account delete kar diya");
                }
              } catch (e) {
                print("Delete mein error: $e");
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> addUserData(String uid, String name, String email) async {
    try {
      print("Starting to add user data for UID: $uid");

      Map<String, dynamic> userData = {
        'name': name,
        'email': email,
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': false,
      };

      // Add user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData);

      print("User document created successfully");

      // Initialize user data with 'init' document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc('init')
          .set({
            'initialized': true,
            'createdAt': FieldValue.serverTimestamp(),
          });

      print("User data added successfully to Firestore");
    } catch (e) {
      print("Error adding user data to Firestore: $e");
      // Handle error appropriately
      rethrow; // Re-throw to be handled by caller
    }
  }
}
