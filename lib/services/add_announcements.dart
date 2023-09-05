import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_notif.dart';

Future addAnnouncement(
  imageUrl,
  name,
  description,
) async {
  final docUser = FirebaseFirestore.instance.collection('Announcements').doc();

  final json = {
    'imageUrl': imageUrl,
    'name': name,
    'description': description,
    'dateTime': DateTime.now(),
    'id': docUser.id,
    'userId': FirebaseAuth.instance.currentUser!.uid,
  };

  addNotif('New Announcement is posted: $name');

  await docUser.set(json);
}
