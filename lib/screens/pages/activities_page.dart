import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sk_app/services/add_activities.dart';
import 'package:sk_app/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import '../../utils/colors.dart';
import '../../widgets/textfield_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
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
        addActivityDialog(context);
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

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: box.read('role') == 'Admin'
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                addActivityDialog(context);
              })
          : null,
      appBar: AppBar(
        title: TextWidget(
          text: 'Activities',
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('Activities').snapshots(),
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
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: SizedBox(
                      height: 75,
                      child: ListTile(
                        title: TextWidget(
                          text: data.docs[index]['name'],
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                        subtitle: TextWidget(
                          text: data.docs[index]['description'],
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        trailing: TextWidget(
                          text: data.docs[index]['date'],
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'Bold',
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final dateController = TextEditingController();

  addActivityDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            text: 'Posting Activities',
            fontSize: 18,
            fontFamily: 'Bold',
          ),
          content: Column(
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
                  label: 'Name of Activity', controller: nameController),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  label: 'Description of Activity', controller: descController),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Date',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Bold',
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      dateFromPicker(context);
                    },
                    child: SizedBox(
                      width: 325,
                      height: 50,
                      child: TextFormField(
                        enabled: false,
                        style: const TextStyle(
                          fontFamily: 'Regular',
                          fontSize: 14,
                          color: primary,
                        ),

                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            color: primary,
                          ),
                          hintStyle: const TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          hintText: dateController.text,
                          border: InputBorder.none,
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          errorStyle:
                              const TextStyle(fontFamily: 'Bold', fontSize: 12),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),

                        controller: dateController,
                        // Pass the validator to the TextFormField
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                addActivities(idImageURL, nameController.text,
                    descController.text, dateController.text);
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

  void dateFromPicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: primary,
                onPrimary: Colors.white,
                onSurface: Colors.grey,
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      setState(() {
        dateController.text = formattedDate;
      });
    } else {
      return null;
    }
  }
}
