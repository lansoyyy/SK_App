import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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
                addAnnouncementDialog();
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
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: SizedBox(
                height: 100,
                child: ListTile(
                  title: TextWidget(
                    text: 'Name of the\nAnnouncements',
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Bold',
                  ),
                  subtitle: TextWidget(
                    text: 'Details of the Announcements',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  trailing: TextWidget(
                    text: 'Date and Time',
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Bold',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  addAnnouncementDialog() {
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
              Container(
                height: 150,
                width: 300,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
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
              onPressed: () {
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
