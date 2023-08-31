import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addCrowdsourcing(
  imageUrl,
  name,
  description,
  List<String> options,
) async {
  final docUser = FirebaseFirestore.instance.collection('Crowdsourcing').doc();

  final json = {
    'options': options,
    'imageUrl': imageUrl,
    'name': name,
    'description': description,
    'dateTime': DateTime.now(),
    'id': docUser.id,
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'votes': [],
    for (int i = 0; i < options.length; i++) options[i]: 0
  };

  await docUser.set(json);
}
