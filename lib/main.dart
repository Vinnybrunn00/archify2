import 'package:archify2/core/providers/file_system_provider.dart';
import 'package:archify2/ui/pages/home_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Archify2());
}

class Archify2 extends StatelessWidget {
  const Archify2({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FileSystemProvider())],
      child: MaterialApp(
        title: 'Archify2',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: HomePage(),
      ),
    );
  }
}
