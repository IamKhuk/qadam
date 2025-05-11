import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qadam/src/ui/menu/history/history.dart';
import 'package:qadam/src/ui/menu/new_qadam/new_qadam.dart';
import 'package:qadam/src/ui/menu/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import '../../theme/app_theme.dart';
import 'home/home_screen.dart';

int selectedIndex = 0;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> menus = [
    const HomeScreen(),
    const NewQadam(),
    const History(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          menus[selectedIndex],
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: 82,
              width: size.width,
              decoration: BoxDecoration(
                color: AppTheme.black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    blurRadius: 25,
                    spreadRadius: 0,
                    color: AppTheme.dark.withOpacity(0.2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          selectedIndex == 0
                              ? SvgPicture.asset(
                                  'assets/icons/home_full.svg',
                                  colorFilter: const ColorFilter.mode(
                                    AppTheme.purple,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : SvgPicture.asset(
                                  'assets/icons/home.svg',
                                  colorFilter: const ColorFilter.mode(
                                    AppTheme.gray,
                                    BlendMode.srcIn,
                                  ),
                                ),
                          Text(
                            "Home",
                            style: TextStyle(
                              fontSize: 12,
                              color: selectedIndex == 0
                                  ? AppTheme.bg
                                  : AppTheme.gray,
                              fontFamily: AppTheme.fontFamily,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          selectedIndex == 1
                              ? const Icon(
                                  CupertinoIcons
                                      .arrow_right_arrow_left_circle_fill,
                                  color: AppTheme.purple,
                                  size: 24,
                                )
                              : const Icon(
                                  CupertinoIcons.arrow_right_arrow_left_circle,
                                  color: AppTheme.gray,
                                  size: 24,
                                ),
                          const SizedBox(height: 4),
                          Text(
                            "New Qadam",
                            style: TextStyle(
                              fontSize: 12,
                              color: selectedIndex == 1
                                  ? AppTheme.bg
                                  : AppTheme.gray,
                              fontFamily: AppTheme.fontFamily,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          selectedIndex == 2
                              ? const Icon(
                                  Icons.library_books_rounded,
                                  color: AppTheme.purple,
                                  size: 24,
                                )
                              : const Icon(
                                  Icons.library_books_outlined,
                                  color: AppTheme.gray,
                                  size: 24,
                                ),
                          const SizedBox(height: 4),
                          Text(
                            "History",
                            style: TextStyle(
                              fontSize: 12,
                              color: selectedIndex == 2
                                  ? AppTheme.bg
                                  : AppTheme.gray,
                              fontFamily: AppTheme.fontFamily,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          selectedIndex == 3
                              ? SvgPicture.asset(
                                  'assets/icons/profile_full.svg',
                                  colorFilter: const ColorFilter.mode(
                                    AppTheme.purple,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : SvgPicture.asset(
                                  'assets/icons/profile.svg',
                                  colorFilter: const ColorFilter.mode(
                                    AppTheme.gray,
                                    BlendMode.srcIn,
                                  ),
                                ),
                          Text(
                            "Profile",
                            style: TextStyle(
                              fontSize: 12,
                              color: selectedIndex == 3
                                  ? AppTheme.bg
                                  : AppTheme.gray,
                              fontFamily: AppTheme.fontFamily,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
