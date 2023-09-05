import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class BreezeBottomNav extends StatefulWidget {
  BreezeBottomNav();

  @override
  State<BreezeBottomNav> createState() => _BreezeBottomNavState();
}

class _BreezeBottomNavState extends State<BreezeBottomNav> {
  int _selectedIndex = 1; 

  final _routeToIndexMap = {
    '/progress': 0,
    '/home': 1,
    '/settings': 2,
  };

  @override
  void initState() {
    super.initState();
  }


  void _onItemTapped(int index) {
    final route = _routeToIndexMap.entries.firstWhere((entry) => entry.value == index).key;
    context.go(route);
  }
  @override
  Widget build(BuildContext context) {
    _selectedIndex = _routeToIndexMap[GoRouterState.of(context).uri.toString()] ?? 1;
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wb_sunny),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.teal,
      onTap: _onItemTapped,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
