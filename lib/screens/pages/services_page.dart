import 'package:flutter/material.dart';
import 'package:sk_app/widgets/text_widget.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: 'Services',
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              for (int i = 0; i < 100; i++)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 175,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 175,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'Name of the Service',
                                  fontSize: 14,
                                  fontFamily: 'Bold',
                                ),
                                TextWidget(
                                  text: 'Description of the Service',
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
