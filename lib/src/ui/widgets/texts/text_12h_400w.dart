import 'package:flutter/cupertino.dart';

import '../../../theme/app_theme.dart';

class Text12h400w extends StatelessWidget {
  const Text12h400w(
      {super.key, required this.title, this.color = AppTheme.black,});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: color,
      ),
    );
  }
}
