import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'injection_container.dart' as di;
import 'shared/localization/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize dependencies
  await di.init();

  runApp(const MugalimApp());
}

class MugalimApp extends StatelessWidget {
  const MugalimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
