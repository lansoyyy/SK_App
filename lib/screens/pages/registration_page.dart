import 'package:flutter/material.dart';
import 'package:sk_app/widgets/text_widget.dart';
import 'package:sk_app/widgets/textfield_widget.dart';

class RegistrationPage extends StatelessWidget {
  final leaderController = TextEditingController();
  final teamnameController = TextEditingController();
  final emailController = TextEditingController();
  final commentController = TextEditingController();

  RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: TextWidget(
            text: 'Save',
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'Medium',
          ),
        ),
        appBar: AppBar(
          title: TextWidget(
            text: 'Registration',
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'Bold',
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Fill up the form below',
                  fontSize: 18,
                  fontFamily: 'Bold',
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                    label: 'Team Leader', controller: leaderController),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                    label: 'Team Name', controller: teamnameController),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                    label: 'Input your Email', controller: emailController),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                    height: 300,
                    maxLine: 10,
                    label: 'Other document/comments',
                    controller: commentController),
              ],
            ),
          ),
        ));
  }
}
