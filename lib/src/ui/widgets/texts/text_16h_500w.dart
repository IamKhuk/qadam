import 'package:flutter/cupertino.dart';

import '../../../theme/app_theme.dart';

class Text16h500w extends StatelessWidget {
  const Text16h500w(
      {super.key, required this.title, this.color = AppTheme.black,});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: color,
      ),
    );
  }
}
