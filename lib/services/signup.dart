import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future signup(name, email, number, address, purok) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'name': name,
    'email': email,
    'number': number,
    'address': address,
    'purok': purok,
    'isActive': true,
    'role': 'User',
    'id': docUser.id,
  };

  await docUser.set(json);
}
