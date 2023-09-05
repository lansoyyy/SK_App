import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sk_app/screens/auth/login_screen.dart';
import 'package:sk_app/screens/pages/activities_page.dart';
import 'package:sk_app/screens/pages/announcements_page.dart';
import 'package:sk_app/screens/pages/crowdsourcing_page.dart';
import 'package:sk_app/screens/pages/helpdesk/main_helpdesk_page.dart';
import 'package:sk_app/screens/pages/notif_page.dart';
import 'package:sk_app/screens/pages/registration_page.dart';
import 'package:sk_app/screens/pages/services_page.dart';
import 'package:sk_app/screens/pages/survey_page.dart';
import 'package:sk_app/widgets/text_widget.dart';

import '../widgets/instruction_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  final box = GetStorage();

  bool hasLoaded = false;

  getUserData() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        box.write('role', doc['role']);
      }

      setState(() {
        hasLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hasLoaded
          ? Padding(
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
                          TextWidget(
                            text: 'HOME',
                            fontSize: 24,
                            color: Colors.black,
                            fontFamily: 'Bold',
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const InstructionsDialog();
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.info,
                                    color: Colors.blue,
                                    size: 32,
                                  )),
                              box.read('role') != 'Admin'
                                  ? IconButton(
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NotifPage()));
                                      },
                                      icon: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Notif')
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return const Center(
                                                  child: Text('Error'));
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 50),
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.black,
                                                )),
                                              );
                                            }

                                            final data = snapshot.requireData;
                                            return Badge(
                                              label: TextWidget(
                                                  text: data.docs.length
                                                      .toString(),
                                                  color: Colors.white,
                                                  fontSize: 12),
                                              child: const Icon(
                                                Icons.notifications,
                                                color: Colors.blue,
                                              ),
                                            );
                                          }),
                                    )
                                  : const SizedBox(),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text(
                                                'Logout Confirmation',
                                                style: TextStyle(
                                                    fontFamily: 'QBold',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                'Are you sure you want to Logout?',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular'),
                                              ),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text(
                                                    'Close',
                                                    style: TextStyle(
                                                        fontFamily: 'QRegular',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  onPressed: () async {
                                                    await FirebaseAuth.instance
                                                        .signOut();
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LoginScreen()));
                                                  },
                                                  child: const Text(
                                                    'Continue',
                                                    style: TextStyle(
                                                        fontFamily: 'QRegular',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.blue,
                                    size: 32,
                                  )),
                            ],
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
                                builder: (context) =>
                                    const AnnouncementsPage()));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.blue,
                          title: TextWidget(
                            text: 'Announcements',
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
                                builder: (context) => const ServicesPage()));
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
                                builder: (context) => const ActivitiesPage()));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.blue,
                          title: TextWidget(
                            text: 'Activities',
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
                                builder: (context) => const SurveyPage()));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.blue,
                          title: TextWidget(
                            text: 'Surveys',
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
                                builder: (context) =>
                                    const CroudsourcingPage()));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          tileColor: Colors.blue,
                          title: TextWidget(
                            text: 'Crowdsourcing',
                            fontSize: 22,
                            color: Colors.white,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      box.read('role') == 'User'
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const MainHelpdeskScreen()));
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                tileColor: Colors.blue,
                                title: TextWidget(
                                  text: 'Help Desk',
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      box.read('role') == 'User'
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationPage()));
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                tileColor: Colors.blue,
                                title: TextWidget(
                                  text: 'Registrations',
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
