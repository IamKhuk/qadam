import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/bloc/history_bloc.dart';
import 'package:qadam/src/model/api/book_model.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/widgets/containers/history_container.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    blocHistory.fetchBookingsByStatus(selectedIndex);
  }

  Future<void> _onRefresh() async {
    blocHistory.fetchBookingsByStatus(selectedIndex);
    await Future.delayed(const Duration(milliseconds: 500));
  }

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
          RefreshIndicator(
            color: AppTheme.black,
            onRefresh: _onRefresh,
            child: StreamBuilder<bool>(
              stream: blocHistory.getLoading,
              builder: (context, loadingSnapshot) {
                final isLoading = loadingSnapshot.data ?? false;

                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.black,
                    ),
                  );
                }

                return StreamBuilder<List<BookModel>>(
                  stream: blocHistory.getBookings,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final bookings = snapshot.data!;

                      if (bookings.isEmpty) {
                        return ListView(
                          padding: const EdgeInsets.only(top: 88),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 64,
                                    color: AppTheme.gray.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text14h400w(
                                    title: translate('history.no_trips'),
                                    color: AppTheme.gray,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(
                            top: 88, bottom: 92, left: 16, right: 16),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              HistoryContainer(booking: bookings[index]),
                              index == bookings.length - 1
                                  ? const SizedBox()
                                  : const SizedBox(height: 16),
                            ],
                          );
                        },
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.black,
                      ),
                    );
                  },
                );
              },
            ),
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
                      _buildTab(0, translate('history.in_progress')),
                      _buildTab(1, translate('history.completed')),
                      _buildTab(2, translate('history.canceled')),
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

  Widget _buildTab(int index, String title) {
    return GestureDetector(
      onTap: () {
        if (selectedIndex == index) return;
        setState(() {
          selectedIndex = index;
        });
        blocHistory.fetchBookingsByStatus(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedIndex == index ? AppTheme.black : Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text14h400w(
          title: title,
          color: selectedIndex == index ? Colors.white : AppTheme.dark,
        ),
      ),
    );
  }
}
