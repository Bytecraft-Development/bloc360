import 'package:flutter/material.dart';

import '../constants/layout_constants.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Bloc360 Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(50.0),
            child: Container(
              decoration: kStandardBackgroundContainerDecoration,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    children: [
                      TextSpan(text: '\n\n'),
                      TextSpan(
                        text:
                        'Effective Date: 15 May 2024 \n\nBloc360 ("we," "us," or "our") is committed to protecting the privacy of our users ("you" or "your"). This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our Bloc360 application (the "App").\n\n',
                      ),
                      TextSpan(
                        text: 'Information We Collect\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        'We may collect the following information from you when you use the App:\n\n',
                      ),
                      TextSpan(
                        text: '* App-Relevant Data:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        '\n    * Device information: Device type, operating system, unique device identifiers, and network information.\n    * Usage data: Information about how you interact with the App, such as features used, usage statistics, and browsing data within the App.\n    * Location data (with consent): We may collect your location data with your explicit consent to provide specific features or functionality within the App.\n\n',
                      ),
                      TextSpan(
                        text: '* Limited Personal Information:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        '\n    * Full name, payment information, national identification numbers, address, meter reading, personal documents, email: These could be used for contacting support or accessing specific features.\n\n',
                      ),
                      TextSpan(
                        text: 'Legal Basis for Data Collection\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        'We collect and process your information based on the following legal grounds:\n\n    * Consent: You may provide explicit consent for us to collect certain data, such as location data.\n    * Contractual Necessity: Some data collection is necessary for the App to function properly and provide you with the services you request.\n    * Legitimate Interests: We may collect data for our legitimate interests, such as analyzing App usage to improve its functionality and user experience. However, we will always balance our interests with your privacy rights.\n\n',
                      ),
                      TextSpan(
                        text: 'How We Use Your Information\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'We may use the information we collect for the following purposes:\n\n    * To provide and improve the App\n    * To personalize your experience within the App\n    * To respond to your inquiries and requests\n    * To send you important information about the App, such as updates and changes\n    * To analyze how the App is used\n    * To comply with legal and regulatory requirements\n\n',
                      ),
                      TextSpan(
                        text: 'Sharing Your Information\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'We may share your information with third-party service providers who help us operate the App, such as data storage providers and analytics providers. These third-party service providers are obligated to protect your information in accordance with this Privacy Policy.  \n\nWe will not share your personal information with any third-party for marketing or advertising purposes without your consent.\n\n',
                      ),
                      TextSpan(
                        text: 'Data Security\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'We take reasonable precautions to protect your information from unauthorized access, disclosure, alteration, or destruction. However, no website or internet transmission is completely secure. We cannot guarantee the security of your information.\n\n',
                      ),
                      TextSpan(
                        text: 'Your Rights\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'You have certain rights regarding your information, including:\n\n    * The right to access your information\n    * The right to rectify inaccurate information\n    * The right to erasure of your information (subject to legal restrictions)\n    * The right to restrict the processing of your information\n    * The right to object to the processing of your information\n    * The right to data portability (where applicable)\n\nYou can exercise these rights by contacting us at [your email address].\n\n',
                      ),
                      TextSpan(
                        text: 'Children\'s Privacy\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'The App is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and you believe that your child has provided us with personal information, please contact us. We will take steps to delete the information from our systems.\n\n',
                      ),
                      TextSpan(
                        text: 'Compliance with GDPR and Romanian Law\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'We comply with the General Data Protection Regulation (GDPR) and Romanian law regarding data protection. We will take all reasonable steps to protect your information and respect your privacy rights.\n\n',
                      ),
                      TextSpan(
                        text: 'Disclaimer\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'We strive to protect your information; however, we are not responsible for any information you choose to provide to the App. You acknowledge that you provide information at your own risk. We will only collect data that is legally permissible under applicable laws and regulations.\n\n',
                      ),
                      TextSpan(
                        text: 'Changes to this Privacy Policy\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on the App.\n\n',
                      ),
                      TextSpan(
                        text: 'Contact Us\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'If you have any questions about this Privacy Policy, please contact us at suport@bloc360.ro.\n\n',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
