import 'package:flutter/material.dart';
import 'package:sk_app/widgets/text_widget.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: 'Activities',
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
