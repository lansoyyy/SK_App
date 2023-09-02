import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sk_app/services/add_services.dart';
import 'package:sk_app/widgets/text_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import '../../widgets/textfield_widget.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final box = GetStorage();

  late String idFileName = '';

  late File idImageFile;

  late String idImageURL = '';

  Future<void> uploadImage(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      idFileName = path.basename(pickedImage.path);
      idImageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Document/$idFileName')
            .putFile(idImageFile);
        idImageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Document/$idFileName')
            .getDownloadURL();

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        addServicesDialog(context);
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: box.read('role') == 'Admin'
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                addServicesDialog(context);
              })
          : null,
      appBar: AppBar(
        title: TextWidget(
          text: 'Services',
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Services').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              );
            }

            final data = snapshot.requireData;
            return Center(
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (int i = 0; i < data.docs.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 175,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        data.docs[i]['imageUrl'],
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 175,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: data.docs[i]['name'],
                                        fontSize: 14,
                                        fontFamily: 'Bold',
                                      ),
                                      TextWidget(
                                        text: data.docs[i]['description'],
                                        fontSize: 12,
                                        fontFamily: 'Regular',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  final nameController = TextEditingController();
  final descController = TextEditingController();

  addServicesDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            text: 'Posting Services',
            fontSize: 18,
            fontFamily: 'Bold',
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      uploadImage('gallery');
                    },
                    child: Container(
                      height: 150,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: idFileName == ''
                            ? null
                            : DecorationImage(
                                image: NetworkImage(
                                  idImageURL,
                                ),
                                fit: BoxFit.cover),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                      label: 'Name of Service', controller: nameController),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                      label: 'Description of Service',
                      controller: descController),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: TextWidget(
                text: 'Close',
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: () {
                addServices(
                    idImageURL, nameController.text, descController.text);
                Navigator.pop(context);
              },
              child: TextWidget(
                text: 'Post',
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}
