import 'package:flutter/cupertino.dart';

import '../../../theme/app_theme.dart';

class Text14h400w extends StatelessWidget {
  const Text14h400w(
      {super.key, required this.title, this.color = AppTheme.black,});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: color,
      ),
    );
  }
}
