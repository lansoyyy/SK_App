import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_notif.dart';

Future addHelpdesk(address, name, description, email) async {
  final docUser = FirebaseFirestore.instance.collection('Helpdesk').doc();

  final json = {
    'email': email,
    'address': address,
    'name': name,
    'description': description,
    'dateTime': DateTime.now(),
    'id': docUser.id,
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'solved': false
  };

  addNotif('New Helpdesk: $description');

  await docUser.set(json);
}
