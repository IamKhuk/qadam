import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/ui/auth/login_screen.dart';
import 'package:qadam/src/ui/menu/main_screen.dart';
import 'package:qadam/src/ui/menu/profile/edit_profile_screen.dart';
import 'package:qadam/src/ui/menu/profile/top_up_screen.dart';
import 'package:qadam/src/ui/widgets/texts/text_12h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../bloc/profile_bloc.dart';
import '../../../model/settings_model.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/utils.dart';
import '../../widgets/containers/settings_container.dart';
import '../../widgets/texts/text_14h_400w.dart';
import '../../widgets/texts/text_18h_500w.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String balance = "";
  String _myImage = '';
  String _myName = '';
  String _myPhone = '';

  @override
  void initState() {
    blocProfile.fetchMe();
    getBalance();
    _getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text16h500w(title: translate("profile.my_profile")),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 22,
          bottom: 92,
          left: 16,
          right: 16,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.purple),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 100,
                  spreadRadius: 0,
                  color: AppTheme.black.withOpacity(0.05),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CachedNetworkImage(
                    imageUrl: _myImage,
                    placeholder: (context, url) => Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: AppTheme.gray,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: AppTheme.light,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.error,
                          color: AppTheme.purple,
                          size: 24,
                        ),
                      ),
                    ),
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text18h500w(
                        title: _myName,
                      ),
                      const SizedBox(height: 4),
                      Text12h400w(
                        title: _myPhone,
                        color: AppTheme.gray,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.light,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Text14h400w(title: translate("profile.edit_profile")),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.black,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 100,
                  spreadRadius: 0,
                  color: AppTheme.black.withOpacity(0.05),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text16h500w(
                          title: translate("profile.my_balance"),color: AppTheme.light,),
                      const SizedBox(height: 16),
                      Text18h500w(
                          title:
                          "${Utils.priceFormat(balance)} ${translate(
                              "currency")}", color: Colors.white,)
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TopUpScreen(),
                      ),
                    ).then((_) {
                      setState(() {
                        blocProfile.fetchMe();
                        getBalance();
                      });
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text14h400w(
                          title: translate("profile.top_up"),
                          color: AppTheme.purple,
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.monetization_on_outlined,
                          color: AppTheme.purple,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text16h500w(
            title: translate("profile.settings"),
          ),
          SettingsContainer(
              settingsModel: SettingsModel(
            icon: Icons.lock_clock,
            title: translate("profile.change_password"),
          )),
          SettingsContainer(
              settingsModel: SettingsModel(
            icon: Icons.language,
            title: translate("profile.language"),
          )),
          SettingsContainer(
              settingsModel: SettingsModel(
            icon: Icons.notifications,
            title: translate("profile.notifications"),
          )),
          const SizedBox(height: 16),
          Text16h500w(
            title: translate("profile.about_us"),
          ),
          SettingsContainer(
              settingsModel: SettingsModel(
            icon: Icons.info,
            title: translate("profile.info"),
          )),
          SettingsContainer(
              settingsModel: SettingsModel(
            icon: Icons.privacy_tip,
            title: translate("profile.privacy_security"),
          )),
          SettingsContainer(
              settingsModel: SettingsModel(
            icon: Icons.contact_support,
            title: translate("profile.contact_us"),
          )),
          const SizedBox(height: 16),
          Text16h500w(
            title: translate("profile.other"),
          ),
          SettingsContainer(
              settingsModel: SettingsModel(
            icon: Icons.share,
            title: translate("profile.share"),
          )),
          GestureDetector(
            onTap: () async {
              await wipeSharedPreferences();
              setState(() {
                selectedIndex = 0;
              });
              Navigator.of(context).popUntil(
                    (route) => route.isFirst,
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            child: SettingsContainer(
                settingsModel: SettingsModel(
                  icon: Icons.logout_outlined,
                  title: translate("profile.logout"),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> getBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      balance = prefs.getString('balance') ?? "0";
    });
  }

  Future<void> _getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String firstName = prefs.getString('first_name') ?? '';
    String lastName = prefs.getString('last_name') ?? '';
    setState(() {
      _myImage = prefs.getString('avatar') ?? '';
      _myName = '$firstName $lastName';
      _myPhone = prefs.getString('phone') ?? '+48123456789';
    });
  }

  Future<void> wipeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
