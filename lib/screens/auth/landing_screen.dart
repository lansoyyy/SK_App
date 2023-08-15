import 'package:flutter/material.dart';
import 'package:sk_app/widgets/button_widget.dart';
import 'package:sk_app/widgets/text_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Row(
                children: [
                  Container(
                    height: 225,
                    width: medQuery.width * 0.5,
                    decoration: const BoxDecoration(color: Colors.blue),
                  ),
                  Container(
                    height: 225,
                    width: medQuery.width * 0.5,
                    decoration: const BoxDecoration(color: Colors.red),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Container(
                    height: 300,
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/sample.jpg'),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: TextWidget(
              text: 'Service',
              fontSize: 24,
              fontFamily: 'Bold',
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: TextWidget(
                  text:
                      'The Sangguniang Kabataan (SK) is a youth organizations in the Philippines that serves the community by implementing programs and projects to meet the needs of young people.',
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          ButtonWidget(
            label: 'Continue',
            onPressed: () {},
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
