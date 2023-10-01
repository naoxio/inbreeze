import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/providers/user_provider.dart';

class TitleScreen extends StatefulWidget {
  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  void _navigateToExercise() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.startNewSession();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step1');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
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
      bottomNavigationBar: BreezeBottomNav()
    );
  }
}
