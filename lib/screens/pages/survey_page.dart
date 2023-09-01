import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sk_app/services/add_survey.dart';
import 'package:sk_app/widgets/toast_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/text_widget.dart';
import '../../widgets/textfield_widget.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  Map<String, String> surveyAnswers = {};

  void _handleRadioValueChange(String question, String answer) {
    setState(() {
      surveyAnswers[question] = answer;
    });
  }

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: box.read('role') == 'Admin'
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                addSourveyDialog();
              })
          : null,
      appBar: AppBar(
        title: TextWidget(
          text: 'Survey',
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Surveys').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              );
            }

            final data = snapshot.requireData;
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: SizedBox(
                      height: 75,
                      child: ListTile(
                        onTap: () async {
                          if (await canLaunchUrl(
                              Uri.parse(data.docs[index]['link']))) {
                            await launchUrl(
                                Uri.parse(data.docs[index]['link']));
                          } else {
                            showToast('Invalid google form link');
                          }
                        },
                        title: TextWidget(
                          text: data.docs[index]['name'],
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        subtitle: TextWidget(
                          text: data.docs[index]['description'],
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        trailing: const Icon(
                          Icons.open_in_browser,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final linkController = TextEditingController();

  addSourveyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            text: 'Posting Survey',
            fontSize: 18,
            fontFamily: 'Bold',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  label: 'Name of Survey', controller: nameController),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  label: 'Description of Survey', controller: descController),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  label: 'Google Form Link', controller: linkController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: TextWidget(
                text: 'Close',
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: () {
                addSurvey(nameController.text, descController.text,
                    linkController.text);
                Navigator.pop(context);
              },
              child: TextWidget(
                text: 'Post',
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestion(String questionText) {
    return Text(
      questionText,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildRadioOption(String question, String option) {
    return ListTile(
      title: Text(option),
      leading: Radio<String>(
        value: option,
        groupValue: surveyAnswers[question],
        onChanged: (value) {
          _handleRadioValueChange(question, value!);
        },
      ),
    );
  }
}
