import 'package:flutter/material.dart';
import 'package:sk_app/screens/auth/forgot_password_screen.dart';
import 'package:sk_app/screens/auth/signup_screen.dart';
import 'package:sk_app/screens/home_screen.dart';
import 'package:sk_app/widgets/button_widget.dart';
import 'package:sk_app/widgets/text_widget.dart';
import 'package:sk_app/widgets/textfield_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                      height: 225,
                      width: medQuery.width * 0.5,
                      decoration: const BoxDecoration(color: Colors.blue),
                    ),
                    Container(
                      height: 225,
                      width: medQuery.width * 0.5,
                      decoration: const BoxDecoration(color: Colors.red),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                    child: Container(
                      height: 300,
                      width: 250,
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
            Center(
              child: TextWidget(
                text: 'Sign In',
                fontSize: 24,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(label: 'Email', controller: emailController),
            const SizedBox(
              height: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFieldWidget(
                    showEye: true,
                    isObscure: true,
                    label: 'Password',
                    controller: passwordController),
                TextButton(
                  onPressed: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()));
                  }),
                  child: TextWidget(
                      fontFamily: 'Bold',
                      text: "Forgot Password?",
                      fontSize: 12,
                      color: Colors.red),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ButtonWidget(
              label: 'Sign In',
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                    text: "No Account?", fontSize: 12, color: Colors.black),
                TextButton(
                  onPressed: (() {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SignupScreen()));
                  }),
                  child: TextWidget(
                      fontFamily: 'Bold',
                      text: "Signup Now",
                      fontSize: 14,
                      color: Colors.black),
                ),
              ],
            ),
            TextButton(
              onPressed: (() {
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(
                //         builder: (context) => SignupScreen()));
              }),
              child: TextWidget(
                  fontFamily: 'Bold',
                  text: "Continue as Admin",
                  fontSize: 14,
                  color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
