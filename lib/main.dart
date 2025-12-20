import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/resources/app_provider.dart';
import 'package:qadam/src/ui/splash/splash_screen.dart';

String language = 'en';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = AppHttpOverrides();
  var delegate = await LocalizationDelegate.create(
    basePath: 'assets/i18n',
    fallbackLocale: 'en',
    supportedLocales: ['en', 'ru', 'uz'],
  );
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    localizationDelegate.changeLocale(Locale(language));
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: ThemeData(
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          platform: TargetPlatform.iOS,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xFF818C99),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final allowedHost = Uri.parse(ApiProvider.baseUrl).host;
    return super.createHttpClient(context)
      ..badCertificateCallback = (
        X509Certificate cert,
        String host,
        int port,
      ) {
        return host == allowedHost;
      };
  }
}
