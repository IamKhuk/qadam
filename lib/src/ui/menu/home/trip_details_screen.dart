import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/ui/widgets/containers/leading_back.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';

import '../../../theme/app_theme.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const LeadingBack(),
                      Text16h500w(
                        title: translate("trip_details.trip_details"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
