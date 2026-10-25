import 'package:flutter/material.dart';

import '../features/menu/data/menu_repository.dart';
import '../features/menu/screens/menu_home_screen.dart';
import '../features/search/screens/search_screen.dart';

class DigitalMenuApp extends StatelessWidget {
  const DigitalMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Menu POC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D3764)),
        scaffoldBackgroundColor: const Color(0xFFF7F3EA),
        useMaterial3: true,
      ),
      home: const MenuShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuShell extends StatefulWidget {
  const MenuShell({super.key});

  @override
  State<MenuShell> createState() => _MenuShellState();
}

class _MenuShellState extends State<MenuShell> {
  int _selectedIndex = 0;
  final MenuRepository _repository = const MenuRepository();

  @override
  Widget build(BuildContext context) {
    final screens = [
      MenuHomeScreen(repository: _repository),
      SearchScreen(repository: _repository),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}
