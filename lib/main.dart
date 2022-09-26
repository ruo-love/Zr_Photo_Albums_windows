import 'dart:io';
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_pc/config/state.dart';
import 'package:test_pc/layout.dart';
import 'package:test_pc/request/request.dart';

// import 'package:test_pc/pages/home_page.dart';

void main() async {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeChangeNotifier()),
  ], child: MyApp()));
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown

        // etc.
      };
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor:
              Provider.of<ThemeChangeNotifier>(context, listen: true).primary),
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Zr Photo Album',
      debugShowCheckedModeBanner: false,
      home: LayoutPage(),
    ); //
  }
}
