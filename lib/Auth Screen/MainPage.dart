import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/HomePage/HomePage.dart';
import 'Login or Register page.dart';

class MainHomePage extends StatelessWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ( context,  snapshot) {
          if(snapshot.hasData){
            return HomePage();
          } else {
            return const LoginOrRegister();
          }
        }
        ,),
    );
  }
}