import 'package:flutter/material.dart';

void main() {
  runApp(const InertButtonApp());
}

class InertButtonApp extends StatelessWidget {
  const InertButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inert Button',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          // Intentionally inert: pressing this button has no effect.
          onPressed: () {},
          child: const Text('Press me'),
        ),
      ),
    );
  }
}
