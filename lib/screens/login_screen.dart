import 'package:chat_app/Widget/CustomButton.dart';
import 'package:chat_app/Widget/CustomTextField.dart';
import 'package:chat_app/models.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;

  String? password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Image(
                  image: AssetImage(
                      'images/Premium Vector _ Online registration and sign up with man sitting near smartphone.jpeg'),
                  height: 300,
                  width: 100,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.aBeeZee(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  controller: emailController,
                  onChanged: (data) {
                    email = data;
                  },
                  title: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  onChanged: (data) {
                    password = data;
                  },
                  controller: passwordController,
                  obsecure: isObsecure,
                  title: 'Password',
                  icon: Icons.password,
                  suffixIcon:
                      isObsecure ? Icons.visibility_off : Icons.visibility,
                  onTap: () {
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await loginUser();
                        showSnackBar(context, 'Signed in Successfully');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(email: email),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnackBar(
                              context, 'No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          showSnackBar(context,
                              'Wrong password provided for that user.');
                        }
                      } catch (e) {
                        showSnackBar(context, 'There Was An Error');
                      }
                      isLoading = false;
                      setState(() {
                        emailController.clear();
                        passwordController.clear();
                      });
                    }
                  },
                  title: 'Sign In',
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Dont have an account ?',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        ' Sign Up ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password!,
    );
  }
}
