import 'package:flutter/material.dart';
import 'package:sk_app/screens/pages/helpdesk/add_helpdesk_page.dart';
import 'package:sk_app/widgets/text_widget.dart';

class MainHelpdeskScreen extends StatelessWidget {
  const MainHelpdeskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                    TextWidget(
                      text: 'Help Desk',
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: 'Bold',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddHelpdeskPage()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    tileColor: Colors.blue,
                    title: TextWidget(
                      text: 'Sports',
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddHelpdeskPage()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    tileColor: Colors.blue,
                    title: TextWidget(
                      text: 'Environmental',
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddHelpdeskPage()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    tileColor: Colors.blue,
                    title: TextWidget(
                      text: 'Esports',
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddHelpdeskPage()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    tileColor: Colors.blue,
                    title: TextWidget(
                      text: 'Cultural',
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddHelpdeskPage()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    tileColor: Colors.blue,
                    title: TextWidget(
                      text: 'Services',
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddHelpdeskPage()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    tileColor: Colors.blue,
                    title: TextWidget(
                      text: 'Livelihood',
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddHelpdeskPage()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    tileColor: Colors.blue,
                    title: TextWidget(
                      text: 'Compliants',
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
