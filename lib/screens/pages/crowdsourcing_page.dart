import 'package:flutter/material.dart';

import '../../widgets/text_widget.dart';

class CroudsourcingPage extends StatelessWidget {
  const CroudsourcingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: 'Crowdsourcing',
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        centerTitle: true,
      ),
    );
  }
}
