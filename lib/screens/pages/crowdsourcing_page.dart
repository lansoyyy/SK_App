import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import '../../services/add_crowdsourcing.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/textfield_widget.dart';
import 'dart:io';

class CroudsourcingPage extends StatefulWidget {
  const CroudsourcingPage({super.key});

  @override
  State<CroudsourcingPage> createState() => _CroudsourcingPageState();
}

class _CroudsourcingPageState extends State<CroudsourcingPage> {
  List<PollOption> pollOptions = [
    PollOption(text: 'Option 1', votes: 0),
    PollOption(text: 'Option 2', votes: 0),
  ];

  void _voteForOption(int index) {
    setState(() {
      pollOptions[index].votes++;
    });
  }

  final nameController = TextEditingController();
  final descController = TextEditingController();

  List<Map<String, dynamic>> options = [];

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
        addCrowdsourcingDialog(context);
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
                addCrowdsourcingDialog(context);
              })
          : null,
      appBar: AppBar(
        title: TextWidget(
          text: 'Crowdsourcing',
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Crowdsourcing')
              .snapshots(),
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
            return ListView.separated(
              itemCount: data.docs.length,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                data.docs[index]['imageUrl'],
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data.docs[index]['name'],
                                style: const TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                data.docs[index]['description'],
                                style: const TextStyle(fontSize: 12.0),
                              ),
                              const SizedBox(height: 20.0),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.docs[index]['options'].length,
                                itemBuilder: (context, index1) {
                                  return PollOptionCard(
                                    hasVoted: data.docs[index]['votes']
                                        .contains(FirebaseAuth
                                            .instance.currentUser!.uid),
                                    pollOption: PollOption(
                                        votes: data.docs[index][data.docs[index]
                                            ['options'][index1]],
                                        text: data.docs[index]['options']
                                            [index1]),
                                    onPressed: () async {
                                      _voteForOption(index);
                                      await FirebaseFirestore.instance
                                          .collection('Crowdsourcing')
                                          .doc(data.docs[index].id)
                                          .update({
                                        data.docs[index]['options'][index1]:
                                            data.docs[index][data.docs[index]
                                                    ['options'][index1]] +
                                                1,
                                        'votes': FieldValue.arrayUnion([
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                        ])
                                      });
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

  addCrowdsourcingDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        // Define a list to hold answer controllers
        List<TextEditingController> answerControllers = [];

        // Function to add a new answer field

        return AlertDialog(
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
                  TextFieldWidget(label: 'Name', controller: nameController),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                      label: 'Description', controller: descController),
                  const SizedBox(
                    height: 20,
                  ),
                  // Display answer input fields
                  if (answerControllers.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Option:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        for (int i = 0; i < answerControllers.length; i++)
                          TextFieldWidget(
                              label: 'Option ${i + 1}',
                              controller: answerControllers[i]),
                      ],
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Button to add new answer field
                  TextButton(
                    onPressed: () {
                      setState(() {
                        answerControllers.add(TextEditingController());
                      });
                    },
                    child: TextWidget(
                      text: 'Add Answer',
                      fontSize: 14,
                    ),
                  ),
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
                // Access the answer values from controllers
                List<String> answers = answerControllers
                    .map((controller) => controller.text)
                    .toList();

                addCrowdsourcing(idImageURL, nameController.text,
                    descController.text, answers);
                Navigator.pop(context);
              },
              child: TextWidget(
                text: 'Add',
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}

class PollOption {
  final String text;
  int votes;

  PollOption({required this.text, this.votes = 0});
}

class PollOptionCard extends StatelessWidget {
  final PollOption pollOption;
  final VoidCallback onPressed;
  final bool? hasVoted;

  const PollOptionCard(
      {super.key,
      required this.pollOption,
      required this.onPressed,
      required this.hasVoted});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ListTile(
        title: Text(pollOption.text),
        subtitle: Text('Votes: ${pollOption.votes}'),
        trailing: hasVoted == true
            ? const SizedBox()
            : ElevatedButton(
                onPressed: onPressed,
                child: const Text('Vote'),
              ),
      ),
    );
  }
}
