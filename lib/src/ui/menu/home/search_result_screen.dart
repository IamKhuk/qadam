import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/model/trip_model.dart';
import 'package:qadam/src/ui/widgets/containers/destinations_container.dart';
import 'package:qadam/src/ui/widgets/texts/text_12h_400w.dart';
import 'package:qadam/src/utils/utils.dart';
import '../../../defaults/defaults.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/texts/text_16h_500w.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key, required this.trip});

  final TripModel trip;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: Defaults().trips.length,
            padding: const EdgeInsets.only(
              top: 282,
              left: 16,
              right: 16,
              bottom: 32,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  DestinationsContainer(trip: Defaults().trips[index]),
                  index != Defaults().trips.length - 1
                      ? const SizedBox(height: 16)
                      : const SizedBox(),
                ],
              );
            },
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text16h500w(
                            title: translate("home.search_result"),
                            color: Colors.white,
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text12h400w(
                                  title: Defaults()
                                      .regions[widget.trip.startLocation[0] - 1]
                                      .text,
                                  color: AppTheme.light,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  safeSubstring(
                                      Defaults()
                                          .neighborhoods[
                                              widget.trip.startLocation[2] - 1]
                                          .text,
                                      3),
                                  style: const TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text12h400w(
                                  title: Defaults()
                                      .cities[widget.trip.startLocation[1] - 1]
                                      .text,
                                  color: AppTheme.light,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.dark,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  // 3 Vertical Lines (Stacked)
                                  Row(
                                    children: List.generate(
                                      6,
                                      (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: Container(
                                          width: 5,
                                          height: 2,
                                          color: AppTheme.gray,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.light,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/map_pin.svg",
                                      height: 24, // Adjust size as needed
                                      width: 24,
                                      colorFilter: const ColorFilter.mode(
                                        AppTheme.purple,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      6,
                                      (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: Container(
                                          width: 5,
                                          height: 2,
                                          color: AppTheme.gray,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.dark,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text12h400w(
                                title: Utils.scheduleDateFormat(
                                    widget.trip.startTime),
                                color: AppTheme.light,
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text12h400w(
                                  title: Defaults()
                                      .regions[widget.trip.endLocation[0] - 1]
                                      .text,
                                  color: AppTheme.light,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  safeSubstring(
                                      Defaults()
                                          .neighborhoods[
                                              widget.trip.endLocation[2] - 1]
                                          .text,
                                      3),
                                  style: const TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text12h400w(
                                  title: Defaults()
                                      .cities[widget.trip.endLocation[1] - 1]
                                      .text,
                                  color: AppTheme.light,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String safeSubstring(String text, int length) {
    return text.length >= length
        ? text.substring(0, length).toUpperCase()
        : text.toUpperCase();
  }
}
