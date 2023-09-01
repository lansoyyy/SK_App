import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addSurvey(name, description, link) async {
  final docUser = FirebaseFirestore.instance.collection('Surveys').doc();

  final json = {
    'link': link,
    'name': name,
    'description': description,
    'dateTime': DateTime.now(),
    'id': docUser.id,
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'response': []
  };

  await docUser.set(json);
}
