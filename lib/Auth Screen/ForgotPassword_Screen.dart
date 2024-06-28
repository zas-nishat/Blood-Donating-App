import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _forgotPassController = TextEditingController();

  @override
  void dispose() {
    _forgotPassController.text.trim();
    super.dispose();
  }
  ///Reset Email Link
  Future resetPassword() async{
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _forgotPassController.text);
      Get.snackbar(
        "Success!",
        "A link has been sent to: ${_forgotPassController.text}",
        duration: const Duration(seconds: 4),
      );
    } on FirebaseAuthException catch(e) {
      Get.snackbar(
        "Error!",
        // "${e.message.toString()}",
        "You forgot to enter your email address",
        duration: const Duration(seconds: 3),

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot password"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
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

                const Text("Enter the email you've used to sign up. We'll send a link to the address",
                  style: TextStyle(
                      fontSize: 19
                  ),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _forgotPassController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        hintText: "Email",
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
                GestureDetector(
                  onTap: resetPassword,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: Text("Reset Password",style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                          ),),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
