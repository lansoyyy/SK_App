import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_notif.dart';

Future addActivities(imageUrl, name, description, date) async {
  final docUser = FirebaseFirestore.instance.collection('Activities').doc();

  final json = {
    'date': date,
    'imageUrl': imageUrl,
    'name': name,
    'description': description,
    'dateTime': DateTime.now(),
    'id': docUser.id,
    'userId': FirebaseAuth.instance.currentUser!.uid,
  };

  addNotif('New Activity: $name');

  await docUser.set(json);
}
