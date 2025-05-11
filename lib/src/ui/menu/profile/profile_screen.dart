import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text16h500w(title: translate("profile.my_profile")),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 22,
          bottom: 92,
          left: 16,
          right: 16,
        ),
        children: [

        ],
      ),
    );
  }
}
