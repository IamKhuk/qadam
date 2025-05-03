import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_theme.dart';

class LeadingBack extends StatelessWidget {
  const LeadingBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12),
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(8),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/arrow_left.svg',
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(
                  AppTheme.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
