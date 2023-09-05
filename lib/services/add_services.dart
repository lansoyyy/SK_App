import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sk_app/services/add_notif.dart';

Future addServices(
  imageUrl,
  name,
  description,
) async {
  final docUser = FirebaseFirestore.instance.collection('Services').doc();

  final json = {
    'imageUrl': imageUrl,
    'name': name,
    'description': description,
    'dateTime': DateTime.now(),
    'id': docUser.id,
    'userId': FirebaseAuth.instance.currentUser!.uid,
  };
  addNotif('Added a service: $name');

  await docUser.set(json);
}
