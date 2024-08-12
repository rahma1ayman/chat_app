import 'package:chat_app/Widget/CustomButton.dart';
import 'package:chat_app/Widget/CustomTextField.dart';
import 'package:chat_app/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;

  String? password;

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
                  'Create Your Account',
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
                  title: 'Username',
                  icon: Icons.person,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
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
                  obsecure: true,
                  onChanged: (data) {
                    password = data;
                  },
                  title: 'Password',
                  icon: Icons.password,
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
                        await registerUser();
                        showSnackBar(context, 'Signed Up Successfully');
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showSnackBar(context, 'Weak Password');
                        } else if (e.code == 'email-already-in-use') {
                          showSnackBar(context, 'Email Already Used');
                        }
                      } catch (e) {
                        showSnackBar(context, 'There Was An Error');
                      }
                      isLoading = false;
                      setState(() {});
                    }
                  },
                  title: 'Sign Up',
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account ?',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        ' Sign In ',
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

  Future<void> registerUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
