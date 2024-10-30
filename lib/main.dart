import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/dock_item.dart';
import 'widgets/dock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mac Dock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Dock(
                  items: [
                    DockItem(
                      icon: Icons.person,
                      color: Colors.blue,
                      onTap: () => _handleItemTap(context, 'Profile'),
                    ),
                    DockItem(
                      icon: Icons.message,
                      color: Colors.green,
                      onTap: () => _handleItemTap(context, 'Messages'),
                    ),
                    DockItem(
                      icon: Icons.call,
                      color: Colors.orange,
                      onTap: () => _handleItemTap(context, 'Calls'),
                    ),
                    DockItem(
                      icon: Icons.camera,
                      color: Colors.purple,
                      onTap: () => _handleItemTap(context, 'Camera'),
                    ),
                    DockItem(
                      icon: Icons.photo,
                      color: Colors.red,
                      onTap: () => _handleItemTap(context, 'Photos'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _handleItemTap(BuildContext context, String itemName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on $itemName'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
