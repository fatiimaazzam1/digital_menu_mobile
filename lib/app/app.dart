import 'package:flutter/material.dart';

import 'design_tokens.dart';
import '../features/menu/data/menu_repository.dart';
import '../features/menu/screens/menu_home_screen.dart';
import '../features/qr_scanner/screens/qr_scanner_screen.dart';
import '../features/search/screens/search_screen.dart';

class DigitalMenuApp extends StatelessWidget {
  const DigitalMenuApp({this.scannerPreviewBuilder, super.key});

  final QrScannerPreviewBuilder? scannerPreviewBuilder;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARDO Menu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D3764))
            .copyWith(
              primary: const Color(0xFF101D36),
              secondary: const Color(0xFFC9A75C),
              surface: const Color(0xFFFFFDF8),
            ),
        scaffoldBackgroundColor: const Color(0xFFF7F3EA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101D36),
          foregroundColor: Color(0xFFFFFDF8),
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFDF8),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.surface),
            side: const BorderSide(color: Color(0xFFE6E0D5)),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFFFFFDF8),
          indicatorColor: const Color(0xFFE5CF9D),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF101D36)
                  : const Color(0xFF73788A),
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.w400,
            );
          }),
        ),
        useMaterial3: true,
      ),
      home: MenuShell(scannerPreviewBuilder: scannerPreviewBuilder),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuShell extends StatefulWidget {
  const MenuShell({this.scannerPreviewBuilder, super.key});

  final QrScannerPreviewBuilder? scannerPreviewBuilder;

  @override
  State<MenuShell> createState() => _MenuShellState();
}

class _MenuShellState extends State<MenuShell> {
  int _selectedIndex = 0;
  final MenuRepository _repository = const MenuRepository();

  @override
  Widget build(BuildContext context) {
    final screens = [
      MenuHomeScreen(
        repository: _repository,
        onSearchTap: () => setState(() => _selectedIndex = 1),
        scannerPreviewBuilder: widget.scannerPreviewBuilder,
      ),
      SearchScreen(repository: _repository),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (index < 2) {
            setState(() => _selectedIndex = index);
            return;
          }

          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              content: const Text('Not included in this version'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
