import 'package:flutter/material.dart';

class NewQadam extends StatefulWidget {
  const NewQadam({super.key});

  @override
  State<NewQadam> createState() => _NewQadamState();
}

class _NewQadamState extends State<NewQadam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("New Qadam"),
      ),
    );
  }
}
