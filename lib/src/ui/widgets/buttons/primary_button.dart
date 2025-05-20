import 'package:flutter/material.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';

import '../../../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.dark.withOpacity(0.1),
            spreadRadius: 15,
            blurRadius: 25,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text16h500w(title: title, color: Colors.white),
      ),
    );
  }
}
