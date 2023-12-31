import 'package:flutter/material.dart';
import 'package:inner_breeze/widgets/breeze_app_bar.dart';

class PageLayout extends StatelessWidget {
  final String titleText;
  final String forwardButtonText;
  final String? backButtonText;
  final VoidCallback forwardButtonPressed;
  final VoidCallback? backButtonPressed;
  final Widget column;

  PageLayout({
    required this.titleText,
    required this.column,
    required this.forwardButtonText,
    this.backButtonText,
    this.backButtonPressed, required this.forwardButtonPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BreezeAppBar(title: titleText),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 420,
              child: column
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (backButtonText != null && backButtonPressed != null)
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: TextButton(
                    onPressed: backButtonPressed,
                    child: Text(
                      backButtonText!,
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: SizedBox(
                height: 52,
                child: TextButton(
                  onPressed: forwardButtonPressed,
                  child: Text(
                    forwardButtonText,
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
