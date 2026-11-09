import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const Archify2());
}

class Archify2 extends StatelessWidget {
  const Archify2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archify2',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: null,
    );
  }
}
