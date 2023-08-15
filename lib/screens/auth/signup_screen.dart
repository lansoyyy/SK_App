import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sk_app/screens/auth/login_screen.dart';
import 'package:sk_app/screens/home_screen.dart';
import 'package:sk_app/services/signup.dart';
import 'package:sk_app/widgets/button_widget.dart';
import 'package:sk_app/widgets/text_widget.dart';
import 'package:sk_app/widgets/textfield_widget.dart';

import '../../widgets/toast_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  final addressController = TextEditingController();

  final contactNumberController = TextEditingController();

  String selectedPurok = 'Purok 1';
  // Store the selected purok
  List<String> purokOptions = [
    'Purok 1',
    'Purok 2',
    'Purok 3',
    'Purok 4',
    'Purok 5',
    'Purok 6',
    'Purok 7',
    'Purok 8',
    'Purok 9',
    'Purok 10',
  ];

  @override
  Widget build(BuildContext context) {
    final medQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    Container(
                      height: 150,
                      width: medQuery.width * 0.5,
                      decoration: const BoxDecoration(color: Colors.blue),
                    ),
                    Container(
                      height: 150,
                      width: medQuery.width * 0.5,
                      decoration: const BoxDecoration(color: Colors.red),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.fitWidth)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: TextWidget(
                text: 'Sign Up',
                fontSize: 24,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(label: 'Name', controller: nameController),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(label: 'Email', controller: emailController),
            const SizedBox(
              height: 5,
            ),
            TextFieldWidget(
                showEye: true,
                isObscure: true,
                label: 'Password',
                controller: passwordController),
            const SizedBox(
              height: 5,
            ),
            TextFieldWidget(
                inputType: TextInputType.number,
                label: 'Contact Number',
                controller: contactNumberController),
            const SizedBox(
              height: 5,
            ),
            TextFieldWidget(label: 'Address', controller: addressController),
            const SizedBox(
              height: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Purok',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Bold',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Bold',
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 325,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String>(
                    underline: const SizedBox(),
                    value: selectedPurok,
                    onChanged: (newValue) {
                      setState(() {
                        selectedPurok = newValue!;
                      });
                    },
                    items: purokOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextWidget(
                            text: value,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              label: 'Sign Up',
              onPressed: () {
                register(context);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                    text: "Already had an account?",
                    fontSize: 12,
                    color: Colors.black),
                TextButton(
                  onPressed: (() {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }),
                  child: TextWidget(
                      fontFamily: 'Bold',
                      text: "Login Now",
                      fontSize: 14,
                      color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  register(context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      signup(nameController.text, emailController.text,
          contactNumberController.text, addressController.text, selectedPurok);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      showToast("Registered Successfully!");

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showToast('The email address is not valid.');
      } else {
        showToast(e.toString());
      }
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
