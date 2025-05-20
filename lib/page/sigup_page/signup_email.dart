import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trademine/bloc/loading_cubit.dart';
import 'package:trademine/page/sigup_page/signup_otp.dart';
import 'package:lottie/lottie.dart';

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({super.key});

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _email = TextEditingController();
  final _url = Uri.parse('http://localhost:3000/api/register/email');
  bool isChecked = false;
  bool isPolicyAgree = false;

  void PolicyAgree() {
    setState(() {
      isPolicyAgree = !isPolicyAgree;
      Navigator.pop(context);
      isChecked = true;
    });
  }

  Future<void> ApiConnect() async {
    try {
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'auth_token');
      print(_email.text);
      final response = await http.post(_url, body: {"email": _email.text});

      if (response.statusCode == 200) {
        await storage.write(key: 'email', value: _email.text);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => SignUpOtp(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERROR: $e', style: TextStyle(color: Colors.red)),
        ),
      );
    }
  }

  final policy = '''Introduction
Welcome to Trademine – a platform for viewing stock charts, analyzing market trends, and predicting stock prices using Artificial Intelligence (AI). By using the services of Trademine, you agree to fully comply with the terms and policies outlined in this document. If you do not agree with any part of these terms, please discontinue use of our services immediately.
1. Purpose of the App
Trademine is designed to provide analytical insights into the stock market through chart visualization, data analysis, and AI-based stock price prediction. The information presented in the app is intended as a decision-support tool only and does not constitute direct investment advice.
2. Scope of Services
Trademine provides stock data display and analysis services only. It does not facilitate stock trading.
Users must be at least 18 years old or have parental/guardian consent.
Users agree to use the service in accordance with applicable laws and ethical standards.
3. App Usage
Users must not use the app for any malicious, unlawful, or rights-infringing purposes.
Reverse engineering, duplicating, modifying, or distributing any part of Trademine’s system or content without explicit permission is strictly prohibited.
Trademine reserves the right to suspend or terminate accounts that violate these terms without prior notice.
4. Information and Recommendations
While Trademine continuously improves its AI models for stock prediction, accuracy or reliability of the information is not guaranteed.
All investment decisions are solely the responsibility of the user. Trademine is not liable for any losses or damages resulting from the use of the app.
5. Service Fees
The app may offer free services or implement premium subscription options in the future.
Any charges or fees will be communicated in advance via the app interface or official communication channels.
6. Privacy Policy
Trademine prioritizes user privacy and handles personal data in compliance with data protection laws such as PDPA and GDPR.
Data We Collect
Basic personal data: Name, email, phone number (if provided)
Usage data: Stock viewing behavior, feature usage, button interactions
Device data: Device model, operating system, IP address
Purposes of Data Use
To enhance user experience
To improve AI models and provide personalized stock recommendations
To deliver news, updates, and relevant promotions
Data Storage and Disclosure
All data is securely stored and kept confidential
Personal data will not be shared with third parties unless legally required or requested by authorized government agencies
User Rights
Users have the right to access, correct, or delete their personal data
Users may withdraw consent at any time, which may affect the availability of some app features
7. Intellectual Property
All software, AI models, charts, images, content, and components of Trademine are the intellectual property of the company. Reproduction, distribution, or commercial use of any content without written permission is strictly prohibited.
8. Policy Updates
Trademine reserves the right to amend or update this policy at any time. Any changes will take effect immediately upon being published in the app or on the official website.
9. Contact Information
If you have any questions, feedback, or concerns regarding our terms or privacy practices, please contact us at:
Customer Support Email: support@trademine.appWebsite: www.trademine.appCompany Address: [Insert Address, if applicable]
By using the Trademine app, you acknowledge that you have read and agreed to all terms and conditions outlined in this document.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Sign Up For An Account',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto', // ตั้งชื่อฟอนต์
                    letterSpacing: -1, // ระยะห่างระหว่างตัวอักษร
                  ),
                ),

                Text(
                  'Enter your email to receive an OTP.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: 30),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Color(0xffE5E5E5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isChecked = newValue!;
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                        ),
                        Text("I agree to the", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Terms of Service',
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          color: Color(0xffFCA311),
                          decorationColor: Color(0xffFCA311),
                        ),
                      ),
                    ),
                    Text("and", style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Scrollbar(
                              thumbVisibility: true, // แสดง scrollbar ตลอด
                              controller: _scrollController, // ต้องใช้ร่วมกัน
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Container(
                                  width: double.infinity,
                                  child: SafeArea(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 60,
                                        left: 20,
                                        right: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Terms of Use and Privacy Policy For Trademine Application',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -1,
                                            ),
                                          ),
                                          Text('Last Updated: 5/4/2025'),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  policy,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          const Divider(),
                                          ElevatedButton(
                                            onPressed: () {
                                              PolicyAgree();
                                            },
                                            child: Text(
                                              'Accept',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(
                                                MediaQuery.of(
                                                  context,
                                                ).size.width,
                                                50,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor: Color(
                                                0xffFCA311,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          color: Color(0xffFCA311),
                          decorationColor: Color(0xffFCA311),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed:
                      isChecked
                          ? () {
                            ApiConnect();
                          }
                          : null,

                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Color(0xffFCA311),
                  ),
                  child: Text(
                    'GET OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xffEB5757),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xffEB5757),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
