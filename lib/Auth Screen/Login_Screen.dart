import 'package:blood_donating/Auth%20Screen/ForgotPassword_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Screens/HomePage/HomePage.dart';

class LoginPage extends StatefulWidget {
  final Function() onTap;
  const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  Future<void> signIn(BuildContext context) async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both email and password"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pop(context); // Close the progress dialog on success

      // Navigate to the next screen or perform other actions on successful login
      // For example: Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the progress dialog on error

      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email not found"),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong password"),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Check Your Email and Password. Make sure Password is Correct"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close the progress dialog on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }



  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              // Image in the center
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'Assets/blood_donating_logo.png'
                    ,height: 150,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Welcome Text
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                "Please enter your Email or Phone number to continue",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your email';
                          } return null;

                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            hintText: "Enter your Email or Phone number",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.grey
                                )
                            ),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent
                                ),
                                borderRadius: BorderRadius.circular(5)
                            )
                        ),
                      ),
                    ),
                    //password
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        obscureText: _obscureText,

                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return "Enter password";
                          }
                          return null;
                        },
                        controller: _passwordController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.only(left: 10),
                            hintText: "password",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.grey
                                )
                            ),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent
                                ),
                                borderRadius: BorderRadius.circular(5)
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(ForgetPasswordPage());
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Text("Forgot password?"),
                    ),
                  )
                ],
              ),

              // Continue Button
              GestureDetector(
                onTap: () {
                  if(_formKey.currentState!.validate());
                  signIn(context);
                  },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: widget.onTap,
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account?"),
                      SizedBox(width: 5,),
                      Text("Create new account?",style: TextStyle(
                          color: Colors.red,
                          fontSize: 16
                      ),)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
