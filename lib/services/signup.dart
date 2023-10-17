import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future signup(name, email, number, address, purok, profile, residency) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'name': name,
    'email': email,
    'number': number,
    'address': address,
    'purok': purok,
    'isActive': false,
    'role': 'User',
    'id': docUser.id,
    'profile': profile,
    'residency': residency,
  };

  await docUser.set(json);
}
