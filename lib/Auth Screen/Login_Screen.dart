import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../HomePage.dart';

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

  Future signIn() async{

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
              // Phone number field with country code
              // TextField(
              //   keyboardType: TextInputType.phone,
              //   decoration: InputDecoration(
              //     labelText: 'Phone Number',
              //     border: OutlineInputBorder(),
              //     prefixIcon: CountryCodePicker(
              //       onChanged: (countryCode) {
              //         // Handle country code change
              //       },
              //       initialSelection: 'BD',
              //       favorite: ['+88', 'US'],
              //       showCountryOnly: false,
              //       showOnlyCountryWhenClosed: false,
              //       alignLeft: false,
              //     ),
              //   ),
              // ),
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
                    onTap: (){ },
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
                  // if(_formKey.currentState!.validate());
                  // signIn();
                  Get.to(HomePage());
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
