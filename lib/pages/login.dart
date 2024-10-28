import 'dart:ui';
import 'package:diplomski_rad/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/components/sign_button.dart';
import 'package:diplomski_rad/components/square_image.dart';
import 'package:diplomski_rad/components/textfield.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.blue,
    ),
      body: SafeArea(
        child: Stack(
          children: [
            // Pozadinska slika s efektom zamagljivanja
            Positioned.fill(
              child: Image.asset(
                'lib/images/fink1.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Efekt zamagljivanja
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.white.withOpacity(0),
                ),
              ),
            ),
            // Sadržaj stranice
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // logo
                    Center(
                      child: Container(
                        width: 122,
                        height: 161,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/images/fink_grb.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Text(
                    //   'Dobro došli!',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 18,
                    //   ),
                    // ),
                    const SizedBox(height: 30),
                    // email
                    MyTextField(
                      controller: emailController,
                      hintText: 'E-adresa',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    // password
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Lozinka',
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    // sign in button
                    MyButton(
                      onTap: signUserIn,
                    ),
                    const SizedBox(height: 30),
                    // continue with
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Divider(
                    //           thickness: 0.5,
                    //           color: Colors.grey[400],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding:
                    //         const EdgeInsets.symmetric(horizontal: 10.0),
                    //         child: Text(
                    //           'ili nastavite pomoću',
                    //           style: TextStyle(
                    //             color: Colors.grey[600],
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Divider(
                    //           thickness: 0.5,
                    //           color: Colors.grey[400],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // google
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/images/google.png',
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
