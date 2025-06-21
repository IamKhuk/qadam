import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:qadam/src/model/trip_model.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/menu/new_qadam/create_new_qadam_screen.dart';
import 'package:qadam/src/ui/widgets/buttons/secondary_button.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/containers/destinations_container.dart';
import 'add_docs_screen.dart';

class NewQadam extends StatefulWidget {
  const NewQadam({super.key});

  @override
  State<NewQadam> createState() => _NewQadamState();
}

class _NewQadamState extends State<NewQadam> {
  bool isDocsAdded = false;
  bool isDocsVerified = false;

  List<TripModel> myTrips = [];

  Future<void> getDriverStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDocsAdded = prefs.getBool('isDocsAdded') ?? false;
      isDocsVerified = prefs.getBool('isDocsVerified') ?? false;
    });
  }

  @override
  void initState() {
    getDriverStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text16h500w(title: "New Qadam"),
        centerTitle: true,
      ),
      body: isDocsAdded == false
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/lottie/add_docs.json",
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24),
                Text16h500w(title: translate("qadam.add_docs_title")),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 32),
                    Expanded(
                      child: Text(
                        translate("qadam.add_docs_msg"),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.gray,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppTheme.fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 32),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SecondaryButton(
                    title: translate("qadam.add_docs_button"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const AddDocsScreen();
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 92),
              ],
            )
          : isDocsVerified == false
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/lottie/waiting.json",
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 24),
                    Text16h500w(
                        title: translate("qadam.verification_in_progress")),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 32),
                        Expanded(
                          child: Text(
                            translate("qadam.verification_in_progress_msg"),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.gray,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTheme.fontFamily,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 32),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SecondaryButton(
                        title: translate("qadam.verify"),
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool('isDocsVerified', true);
                          setState(() {
                            isDocsVerified = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 92),
                  ],
                )
              : myTrips.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/lottie/empty.json",
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 24),
                        Text16h500w(title: translate("qadam.No_trip_found")),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const SizedBox(width: 32),
                            Expanded(
                              child: Text(
                                translate("qadam.No_trip_found_msg"),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.gray,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 32),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: SecondaryButton(
                            title: translate("qadam.create_new_trip"),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateNewQadamScreen(
                                    trip: TripModel(
                                      vehicleId: 0,
                                      startTime: DateTime.now(),
                                      endTime: DateTime.now(),
                                      pricePerSeat: "",
                                      availableSeats: 0,
                                    ),
                                    onCreated: (data) {
                                      myTrips.add(data);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 92),
                      ],
                    )
                  : Stack(
                      children: [
                        Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: myTrips.length,
                              padding: const EdgeInsets.only(bottom: 92),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - 48,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateNewQadamScreen(
                                                trip: myTrips[index],
                                                onCreated: (data) {
                                                  setState(() {
                                                    myTrips.add(data);
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        child: DestinationsContainer(
                                            trip: myTrips[index]),
                                      ),
                                    ),
                                    index == myTrips.length - 1
                                        ? Container()
                                        : const SizedBox(height: 16),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 96,
                                bottom: 96,
                                right: 16,
                              ),
                              child: SecondaryButton(
                                  title: translate("qadam.create_new_trip"),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateNewQadamScreen(
                                          trip: TripModel(
                                            vehicleId: 0,
                                            startTime: DateTime.now(),
                                            endTime: DateTime.now(),
                                            pricePerSeat: "",
                                            availableSeats: 0,
                                          ),
                                          onCreated: (data) {
                                            myTrips.add(data);
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
    );
  }
}
