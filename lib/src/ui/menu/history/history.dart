import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/defaults/defaults.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/widgets/containers/destinations_container.dart';
import 'package:qadam/src/ui/widgets/texts/text_12h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_500w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text16h500w(title: translate('history.history')),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding:
                const EdgeInsets.only(top: 88, bottom: 92, left: 16, right: 16),
            itemCount: Defaults().trips.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  DestinationsContainer(trip: Defaults().trips[index]),
                  index == Defaults().trips.length - 1
                      ? const SizedBox()
                      : const SizedBox(height: 16),
                ],
              );
            },
          ),
          Column(
            children: [
              const SizedBox(height: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 270),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 5),
                        blurRadius: 100,
                        spreadRadius: 0,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (selectedIndex == 0) {
                            return;
                          }
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedIndex == 0
                                ? AppTheme.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text14h400w(
                            title: translate('history.in_progress'),
                            color: selectedIndex == 0
                                ? Colors.white
                                : AppTheme.dark,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (selectedIndex == 1) {
                            return;
                          }
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedIndex == 1
                                ? AppTheme.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text14h400w(
                            title: translate('history.completed'),
                            color: selectedIndex == 1
                                ? Colors.white
                                : AppTheme.dark,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (selectedIndex == 2) {
                            return;
                          }
                          setState(() {
                            selectedIndex = 2;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedIndex == 2
                                ? AppTheme.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text14h400w(
                            title: translate('history.canceled'),
                            color: selectedIndex == 2
                                ? Colors.white
                                : AppTheme.dark,
                          ),
                        ),
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
}
