import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/pages/login.dart';

import 'routes.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // logged
          if (snapshot.hasData) {
            return RoutesPage();
          }
          // not logged
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
