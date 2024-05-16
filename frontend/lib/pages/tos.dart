import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc360 Terms of Service'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Acceptance of Terms',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'These Terms of Service ("Terms") govern your access to and use of the Bloc360 web application (the "App") developed and operated by Bytecraft Development SRL ("Bytecraft," "we," "us," or "our"). By accessing or using the App, you agree to be bound by these Terms. If you disagree with any part of these Terms, you may not access or use the App.',
            ),
            SizedBox(height: 16.0),
            Text(
              '2. Disclaimer of Warranties',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'THE APP IS PROVIDED "AS IS" AND WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED. BYTECRAFT DISCLAIMS ALL WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. BYTECRAFT DOES NOT WARRANT THAT THE APP WILL FUNCTION UNINTERRUPTED, ERROR-FREE, OR VIRUS-FREE. BYTECRAFT DOES NOT WARRANT THAT THE APP WILL MEET YOUR REQUIREMENTS.',
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Limitation of Liability',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'BYTECRAFT SHALL NOT BE LIABLE FOR ANY DAMAGES ARISING OUT OF OR RELATED TO YOUR USE OF THE APP, INCLUDING, BUT NOT LIMITED TO, DIRECT, INDIRECT, INCIDENTAL, CONSEQUENTIAL, OR SPECIAL DAMAGES.',
            ),
            SizedBox(height: 16.0),
            Text(
              '4. Data Ownership and Use',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'By using the App, you grant Bytecraft a non-exclusive, irrevocable, royalty-free worldwide license to use, reproduce, modify, publish, distribute, and create derivative works of any data you submit to the App. Bytecraft reserves the right to use this data for any purpose, including, but not limited to, improving the App, developing new products or services, and for marketing purposes.',
            ),
            SizedBox(height: 16.0),
            Text(
              '5. Intellectual Property',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'The App and all intellectual property rights associated therewith, including copyrights, trademarks, and patents, are the sole property of Bytecraft or its licensors. You are granted a non-exclusive, non-transferable license to use the App in accordance with these Terms.',
            ),
            SizedBox(height: 16.0),
            Text(
              '6. Termination',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Bytecraft may terminate your access to the App at any time for any reason, with or without notice.',
            ),
            SizedBox(height: 16.0),
            Text(
              '7. Governing Law',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'These Terms shall be governed by and construed in accordance with the laws of Romania.',
            ),
            SizedBox(height: 16.0),
            Text(
              '8. Entire Agreement',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'These Terms constitute the entire agreement between you and Bytecraft regarding your use of the App.',
            ),
            SizedBox(height: 16.0),
            Text(
              '9. Severability',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'If any provision of these Terms is held to be invalid or unenforceable, such provision shall be struck and the remaining provisions shall remain in full force and effect.',
            ),
            SizedBox(height: 16.0),
            Text(
              '10. Waiver',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'No waiver by Bytecraft of any breach of these Terms shall constitute a waiver of any other breach.',
            ),
            SizedBox(height: 16.0),
            Text(
              '11. Updates to Terms',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Bytecraft may update these Terms from time to time. By continuing to access or use the App after such updates, you agree to be bound by the revised Terms.',
            ),
            SizedBox(height: 16.0),
            Text(
              '12. Contact Us',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'If you have any questions about these Terms, please contact us at [your email address].',
            ),
          ],
        ),
      ),
    );
  }
}
