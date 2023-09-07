import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('InnerBreeze Privacy Policy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _buildSectionTitle('1. Introduction'),
            _buildSectionContent('Welcome to InnerBreeze. We prioritize the privacy of all users of our application. This Privacy Policy outlines our commitment to safeguarding your data and ensuring that you have control over any personal information you provide.'),
            SizedBox(height: 20),
            _buildSectionTitle('2. No Collection or Sharing of Information'),
            _buildSectionContent('We do not collect, store, or share any personal data of our users. InnerBreeze is designed to respect your privacy and the confidentiality of your information.'),
            SizedBox(height: 20),
            _buildSectionTitle('3. Local Data Storage'),
            _buildSectionContent('For the purpose of enhancing user experience, InnerBreeze may store some data locally on your device. This data remains on your device and is not sent to us or any third parties. You have full control over this locally stored data and can remove or manage it through the application\'s settings.'),
            SizedBox(height: 20),
            _buildSectionTitle('4. Security'),
            _buildSectionContent('We value the trust you place in InnerBreeze by using the application. While the app does not send or receive any personal data, we use best practices to ensure that any local data is stored securely on your device.'),
            SizedBox(height: 20),
            _buildSectionTitle('5. Children\'s Privacy'),
            _buildSectionContent('InnerBreeze is suitable for users of all ages, but we do not knowingly engage with or target children under the age of 13.'),
            SizedBox(height: 20),
            _buildSectionTitle('6. Changes to This Privacy Policy'),
            _buildSectionContent('We may occasionally update this Privacy Policy. We recommend checking this section regularly to stay informed about any changes. Continued use of InnerBreeze after an update signifies your acceptance of the revised policy.'),
            SizedBox(height: 20),
            _buildSectionTitle('7. Contact Us'),
            _buildSectionContent('If you have questions or concerns about our Privacy Policy, please reach out to us at [your_contact_email@email.com].'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _buildSectionContent(String content) {
    return Text(content, style: TextStyle(fontSize: 16));
  }
}
