import 'dart:async';


import 'package:bookstore_app_web/route_generator.dart';
import 'package:bookstore_app_web/src/pages/splash_screen.dart';
import 'package:bookstore_app_web/src/repository/user_repository.dart';
import 'package:flutter/material.dart';


import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import '../config/app_config.dart' as config;

import 'package:responsive_framework/responsive_framework.dart';
import '../src/models/user.dart' as modelUser;

import 'generated/i18n.dart';

bool isInChatScreen = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");

  modelUser.User? _user = await getCurrentUser();


  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// This widget is the root of your application.
// Supply 'the Controller' for this application.
// MyApp({Key key}) : super(con: Controller(), key: key);
  // Controller _controller;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(widget,
          //maxWidth: 500,
          minWidth: 440,
          // mediaQueryData: MediaQueryData(
          //     size: Size(440, MediaQuery.of(context).size.height)),
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(430, name: MOBILE),
            const ResponsiveBreakpoint.resize(600, name: TABLET),
            const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
          background:
          Container(color: Theme.of(context).colorScheme.secondary)),
      title: 'BookStore',
      home: SplashScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      //locale: value,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeListResolutionCallback:
      S.delegate.listResolution(fallback: const Locale('en', '')),
      /*  navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ], */
      theme: ThemeData(
        scaffoldBackgroundColor: config.Colors().scaffoldColor(1),
        fontFamily: 'Poppins',
        primaryColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        focusColor: config.Colors().accentColor(1),
        hintColor: config.Colors().secondColor(1),
        textTheme: TextTheme(
          titleSmall: TextStyle(
              fontSize: 20.0, color: config.Colors().secondColor(1)),
          displayMedium: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondColor(1)),
          displaySmall: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().secondColor(1)),
          headlineMedium: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: config.Colors().mainColor(1)),
          headlineSmall: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w300,
              color: config.Colors().secondColor(1)),
          titleMedium: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: config.Colors().secondColor(1)),
          displayLarge: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: config.Colors().mainColor(1)),
          bodyLarge: TextStyle(
              fontSize: 12.0, color: config.Colors().secondColor(1)),
          bodyMedium: TextStyle(
              fontSize: 14.0, color: config.Colors().secondColor(1)),
          bodySmall: TextStyle(
              fontSize: 12.0, color: config.Colors().accentColor(1)),
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: config.Colors().mainColor(1)),
      ),
    );

    // DynamicTheme(
    //     defaultBrightness: Brightness.light,
    //     data: (brightness) {
    //       if (brightness == Brightness.light) {
    //         return ThemeData(
    //           fontFamily: 'Poppins',
    //           primaryColor: Colors.white,
    //           brightness: brightness,
    //           iconTheme: IconThemeData(color: Colors.black),
    //           accentColor: config.Colors().mainColor(1),
    //           focusColor: config.Colors().accentColor(1),
    //           hintColor: config.Colors().secondColor(1),
    //           textTheme: TextTheme(
    //             subtitle2: TextStyle(
    //                 fontSize: 20.0, color: config.Colors().secondColor(1)),
    //             headline2: TextStyle(
    //                 fontSize: 18.0,
    //                 fontWeight: FontWeight.w600,
    //                 color: config.Colors().secondColor(1)),
    //             headline3: TextStyle(
    //                 fontSize: 20.0,
    //                 fontWeight: FontWeight.w600,
    //                 color: config.Colors().secondColor(1)),
    //             headline4: TextStyle(
    //                 fontSize: 22.0,
    //                 fontWeight: FontWeight.w700,
    //                 color: config.Colors().mainColor(1)),
    //             headline5: TextStyle(
    //                 fontSize: 22.0,
    //                 fontWeight: FontWeight.w300,
    //                 color: config.Colors().secondColor(1)),
    //             subtitle1: TextStyle(
    //                 fontSize: 15.0,
    //                 fontWeight: FontWeight.w500,
    //                 color: config.Colors().secondColor(1)),
    //             headline1: TextStyle(
    //                 fontSize: 16.0,
    //                 fontWeight: FontWeight.w600,
    //                 color: config.Colors().mainColor(1)),
    //             bodyText1: TextStyle(
    //                 fontSize: 12.0, color: config.Colors().secondColor(1)),
    //             bodyText2: TextStyle(
    //                 fontSize: 14.0, color: config.Colors().secondColor(1)),
    //             caption: TextStyle(
    //                 fontSize: 12.0, color: config.Colors().accentColor(1)),
    //           ),
    //         );
    //       } else {
    //         return ThemeData(
    //           fontFamily: 'Poppins',
    //           primaryColor: Color(0xFF252525),
    //           brightness: Brightness.dark,
    //           iconTheme: IconThemeData(color: Colors.white),
    //           scaffoldBackgroundColor: Color(0xFF2C2C2C),
    //           accentColor: config.Colors().mainDarkColor(1),
    //           hintColor: config.Colors().secondDarkColor(1),
    //           focusColor: config.Colors().accentDarkColor(1),
    //           textTheme: TextTheme(
    //             subtitle2: TextStyle(
    //                 fontSize: 20.0, color: config.Colors().secondDarkColor(1)),
    //             headline2: TextStyle(
    //                 fontSize: 18.0,
    //                 fontWeight: FontWeight.w600,
    //                 color: config.Colors().secondDarkColor(1)),
    //             headline3: TextStyle(
    //                 fontSize: 20.0,
    //                 fontWeight: FontWeight.w600,
    //                 color: config.Colors().secondDarkColor(1)),
    //             headline4: TextStyle(
    //                 fontSize: 22.0,
    //                 fontWeight: FontWeight.w700,
    //                 color: config.Colors().mainDarkColor(1)),
    //             headline5: TextStyle(
    //                 fontSize: 22.0,
    //                 fontWeight: FontWeight.w300,
    //                 color: config.Colors().secondDarkColor(1)),
    //             subtitle1: TextStyle(
    //                 fontSize: 15.0,
    //                 fontWeight: FontWeight.w500,
    //                 color: config.Colors().secondDarkColor(1)),
    //             headline1: TextStyle(
    //                 fontSize: 16.0,
    //                 fontWeight: FontWeight.w600,
    //                 color: config.Colors().mainDarkColor(1)),
    //             bodyText1: TextStyle(
    //                 fontSize: 12.0, color: config.Colors().secondDarkColor(1)),
    //             bodyText2: TextStyle(
    //                 fontSize: 14.0, color: config.Colors().secondDarkColor(1)),
    //             caption: TextStyle(
    //                 fontSize: 12.0,
    //                 color: config.Colors().secondDarkColor(0.6)),
    //           ),
    //         );
    //       }
    //     },
    //     themedWidgetBuilder: (context, theme) {
    //       return ValueListenableBuilder(
    //           valueListenable: settingRepo.locale,
    //           builder: (context, Locale value, _) {
    //             return MaterialApp(
    //               home: SplashScreen(),
    //               title: 'Beez',
    //               onGenerateRoute: RouteGenerator.generateRoute,
    //               debugShowCheckedModeBanner: false,
    //               locale: value,
    //               localizationsDelegates: [
    //                 S.delegate,
    //                 GlobalMaterialLocalizations.delegate,
    //                 GlobalWidgetsLocalizations.delegate,
    //                 GlobalCupertinoLocalizations.delegate,
    //               ],
    //               supportedLocales: S.delegate.supportedLocales,
    //               localeListResolutionCallback: S.delegate
    //                   .listResolution(fallback: const Locale('en', '')),
    //               theme: theme,
    //             );
    //           });
    //     });
  }
}
