import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/widgets/language_selector.dart';
import 'package:localization/localization.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  LanguageSelectionScreenState createState() => LanguageSelectionScreenState();
}

class LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  bool isLoading = false;

  void handleLanguageChange(String languageCode) async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(seconds: 1)); // Wait for 1 second
    setState(() => isLoading = false);

  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 128.0,
          height: 128.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    return PageLayout(
      titleText: 'language_selection_title'.i18n(),
      forwardButtonText: 'continue_button'.i18n(),
      forwardButtonPressed: () {
        context.go('/guide/welcome');
      },
      column: Column(
        children: [
          LanguageSelector(onLanguageChanged: handleLanguageChange),
          SizedBox(height: 20),
          Text(
            'language_instruction'.i18n(),
            style: BreezeStyle.body,
          ),
        ],
      ),
    );
  }
}
