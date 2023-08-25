import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sk_app/widgets/text_widget.dart';

class ActivitiesPage extends StatelessWidget {
  final box = GetStorage();

  ActivitiesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: box.read('role') == 'Admin'
          ? FloatingActionButton(child: const Icon(Icons.add), onPressed: () {})
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
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: SizedBox(
                height: 75,
                child: ListTile(
                  title: TextWidget(
                    text: 'Name of the\nActivity',
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Bold',
                  ),
                  subtitle: TextWidget(
                    text: 'Details of the Activity',
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
