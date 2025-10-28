import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int counter = 0;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _loadCounter(); // Load saved value from device upon startup
    _LoadIsSelectedBool();
  }

  _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter =
          prefs.getInt('Counter') ??
          0; // Try to load value, otherwise if it's blank then default it to 0
    });
  }

  void _IncrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter++;
    });
    await prefs.setInt('Counter', counter);
  }

  void _DecreaseCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter--;
    });
    await prefs.setInt('Counter', counter);
  }

  _LoadIsSelectedBool() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSelected = prefs.getBool('Bool') ?? false;
    });
  }

  void _setIsSelectedBool(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSelected = value;
    });

    await prefs.setBool('Bool', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SwitchListTile(
                title: Text('Test Bool Change = ${isSelected}'),
                value: isSelected,
                onChanged: (bool value) {
                  _setIsSelectedBool(value);
                },
              ),
              ListTile(
                title: Text("Value = ${counter}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: _IncrementCounter,
                      child: Text("Increase"),
                    ),
                    TextButton(
                      onPressed: _DecreaseCounter,
                      child: Text("Decrease"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
