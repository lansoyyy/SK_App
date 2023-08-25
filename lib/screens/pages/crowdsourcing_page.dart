import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../widgets/text_widget.dart';

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

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: box.read('role') == 'Admin'
          ? FloatingActionButton(child: const Icon(Icons.add), onPressed: () {})
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
      body: ListView.separated(
        itemCount: 100,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      minRadius: 25,
                      maxRadius: 25,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: 'John Doe',
                          fontSize: 18,
                          fontFamily: 'Bold',
                        ),
                        TextWidget(
                          text: 'Youth Participant',
                          fontSize: 12,
                          fontFamily: 'Regular',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'What is your favorite option?',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 20.0),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: pollOptions.length,
                        itemBuilder: (context, index) {
                          return PollOptionCard(
                            pollOption: pollOptions[index],
                            onPressed: () {
                              _voteForOption(index);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

  const PollOptionCard(
      {super.key, required this.pollOption, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ListTile(
        title: Text(pollOption.text),
        subtitle: Text('Votes: ${pollOption.votes}'),
        trailing: ElevatedButton(
          onPressed: onPressed,
          child: const Text('Vote'),
        ),
      ),
    );
  }
}
