import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sk_app/widgets/text_widget.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: box.read('role') == 'Admin'
          ? FloatingActionButton(child: const Icon(Icons.add), onPressed: () {})
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
}
