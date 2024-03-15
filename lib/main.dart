import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'grid_input_screen.dart';
import 'grid_display_screen.dart';
import 'search_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.
    // Remove the following example because delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/grid_input',
      routes: {
        '/grid_input': (context) => GridInputScreen(),
        '/grid_display': (context) => GridDisplayScreen(
            m: 0, n: 0), // Initial values; you can change them if needed
        '/search': (context) => SearchScreen(
              grid: [],
            ),
      },
    );
  }
}
