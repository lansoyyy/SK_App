import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_notif.dart';

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

  addNotif('New Survey: $name');

  await docUser.set(json);
}
