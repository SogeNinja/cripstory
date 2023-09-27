import 'package:cripstory/models/asset_model.dart';
import 'package:cripstory/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(
    MultiProvider(
      providers:[
        ChangeNotifierProvider(
          create: (context) => AssetCollection(),
          child: const MainApp(),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectedAsset(),
          child: const MainApp(),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectedCurrency(),
          child: const MainApp(),
        ),
      ],
      child: const MainApp(),
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      routerConfig: appRouterConfig
    );
  }
}
