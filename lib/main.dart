import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/Screen/Home_Screen.dart';

import 'Provider/cal_provider.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalculatorProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),

      ),
    );

  }
}