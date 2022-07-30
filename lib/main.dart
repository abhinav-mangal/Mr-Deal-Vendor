import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mr_deal_app/splash_screen.dart';

import 'common_widgets/auth_utls.dart';
import 'home_module/home_pg.dart';
import 'login_module/login.dart';

Future<void> main() async {
  runZoned<Future<dynamic>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    runApp(const MyApp());
  }, onError: (error, stackTrace) async {
    print(error);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MR DEAL VENDOR',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/SplashScreen': (BuildContext context) => const SplashScreen(),
          '/LoginPage': (BuildContext context) => const LoginPage(),
          // '/RegisterPage': (BuildContext context) => const RegisterPage(),
          // '/HomePage': (BuildContext context) => const HomePage(),
          '/TabbarPage': (BuildContext context) => const TabbarPage(
                initialIndex: 0,
              ),
        });
  }
}
