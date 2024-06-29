


import 'package:flutter/material.dart';

import '../OTP_Screen.dart';
import 'Login_Screen.dart';
import 'Registration_Screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void toggle() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(onTap: toggle);
    } else{
      return RegistrationScreen(onTap:toggle);
    }
  }
}
