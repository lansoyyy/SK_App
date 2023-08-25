import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../widgets/text_widget.dart';

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
          ? FloatingActionButton(child: const Icon(Icons.add), onPressed: () {})
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Please take a moment to complete our survey:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              _buildQuestion('Q1. How satisfied are you with our service?'),
              _buildRadioOption('Q1', 'Very Satisfied'),
              _buildRadioOption('Q1', 'Satisfied'),
              _buildRadioOption('Q1', 'Neutral'),
              _buildRadioOption('Q1', 'Dissatisfied'),
              _buildRadioOption('Q1', 'Very Dissatisfied'),
              const SizedBox(height: 20),
              _buildQuestion('Q2. Would you recommend our app to others?'),
              _buildRadioOption('Q2', 'Definitely'),
              _buildRadioOption('Q2', 'Probably'),
              _buildRadioOption('Q2', 'Not Sure'),
              _buildRadioOption('Q2', 'Probably Not'),
              _buildRadioOption('Q2', 'Definitely Not'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle survey submission here (e.g., send to server).
                  // surveyAnswers contains the user's responses.
                  print(surveyAnswers);
                },
                child: const Text('Submit Survey'),
              ),
            ],
          ),
        ),
      ),
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
