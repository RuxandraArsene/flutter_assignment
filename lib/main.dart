import 'package:flutter/material.dart';
import 'package:flutter_assignment/view/page/art_collection_page.dart';

import 'common/injection.dart';

void main() async {
  await configureDependencies();
  await getIt.allReady();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Assignment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const ArtCollectionPage(),
    );
  }
}
