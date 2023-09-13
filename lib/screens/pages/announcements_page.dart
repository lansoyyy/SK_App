import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sk_app/services/add_announcements.dart';
import 'package:sk_app/widgets/text_widget.dart';
import 'package:sk_app/widgets/textfield_widget.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final box = GetStorage();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: box.read('role') == 'Admin'
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                addAnnouncementDialog(false, '');
              })
          : null,
      appBar: AppBar(
        title: TextWidget(
          text: 'Announcements',
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Announcements')
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
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: SizedBox(
                      height: 100,
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            nameController.text = data.docs[index]['name'];
                            descController.text =
                                data.docs[index]['description'];
                          });
                          addAnnouncementDialog(true, data.docs[index].id);
                        },
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
                          text: DateFormat.yMMMd()
                              .add_jm()
                              .format(data.docs[index]['dateTime'].toDate()),
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

  addAnnouncementDialog(bool inEdit, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            text: 'Posting Announcement',
            fontSize: 18,
            fontFamily: 'Bold',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  label: 'Name of Announcement', controller: nameController),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  label: 'Description of Announcement',
                  controller: descController),
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
              onPressed: () async {
                if (inEdit) {
                  FirebaseFirestore.instance
                      .collection('Announcements')
                      .doc(id)
                      .update({
                    'name': nameController.text,
                    'description': descController.text
                  });
                } else {
                  addAnnouncement('', nameController.text, descController.text);
                }
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
