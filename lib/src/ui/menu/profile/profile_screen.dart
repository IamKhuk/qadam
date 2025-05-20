import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/ui/menu/profile/edit_profile_screen.dart';
import 'package:qadam/src/ui/widgets/texts/text_12h_400w.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';

import '../../../model/settings_model.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/containers/settings_container.dart';
import '../../widgets/texts/text_14h_400w.dart';
import '../../widgets/texts/text_18h_500w.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    "assets/images/intersect.png",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text18h500w(
                        title: translate("Erali Choriev"),
                      ),
                      const SizedBox(height: 4),
                      const Text12h400w(
                        title: "+48 123 456 789",
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
        ],
      ),
    );
  }
}
