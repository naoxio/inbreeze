import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/providers/user_provider.dart';

class TitleScreen extends StatefulWidget {
  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  int _selectedIndex = 1; // Default index for the sun icon

  void _navigateToExercise() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.startNewSession();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step1');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/progress');
        break;
      case 1:
        // We are already on the title screen
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              SizedBox(
                width: 256,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'Inner Breeze',
                style: BreezeStyle.header,
              ),
              SizedBox(height: 32),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(180, 60),
                ),
                child: Text(
                  "Start",
                  style: BreezeStyle.bodyBig,
                ),
                onPressed: () {
                  _navigateToExercise();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
