import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../controller/simple_ui_controller.dart';
import 'LoginPageTest.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _registerUser() async {
    String _message = '';
    final String url = 'https://bloc360.live:8080/createUser';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'email': emailController.text,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      _message = "UserCreated";
    } else {
      _message = "Error creating User";
    }

    // Afișarea unui mesaj de confirmare sau eroare
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_message),
      ),
    );
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    SimpleUIController simpleUIController = Get.find<SimpleUIController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black12,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size, simpleUIController, theme);
            } else {
              return _buildSmallScreen(size, simpleUIController, theme);
            }
          },
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width * 0.8,
              height: size.height * 0.9,
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildMainBody(size, simpleUIController, theme),
                  ),
                  _buildImage(size),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: kLoginTermsAndPrivacyStyle(size),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Creating an account means you\'re okay with our ',
                    ),
                    TextSpan(
                      text: 'Terms of Services',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 10,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.go(
                              '/tos'); // Folosește context.go pentru a naviga la Terms of Services
                        },
                    ),
                    TextSpan(text: ' and our '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 10,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.go(
                              '/privacy'); // Folosește context.go pentru a naviga la Privacy Policy
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: Container(
        width: size.width * 0.9,
        padding: EdgeInsets.all(size.width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: _buildMainBody(size, simpleUIController, theme),
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    double horizontalPadding = size.width * 0.04;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: size.width > 600
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              'Inregistreaza-te',
              style: kLoginTitleStyle(size).copyWith(
                fontSize: 45,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              'Creeaza un cont:',
              style: kLoginSubtitleStyle(size).copyWith(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
                  Container(
                    width: 390,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFFECF4FF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      style: kTextFormFieldStyle(),
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_rounded),
                        hintText: 'E-mail',
                        fillColor: Color(0xFFECF4FF),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        } else if (!value.endsWith('@gmail.com')) {
                          return 'please enter valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    width: 390,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFFECF4FF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      style: kTextFormFieldStyle(),
                      controller: firstNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'First Name',
                        fillColor: Color(0xFFECF4FF),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    width: 390,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFFECF4FF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      style: kTextFormFieldStyle(),
                      controller: lastNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Last Name',
                        fillColor: Color(0xFFECF4FF),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Obx(
                    () => Container(
                      width: 390,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFECF4FF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        style: kTextFormFieldStyle(),
                        controller: passwordController,
                        obscureText: simpleUIController.isObscure.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_open),
                          suffixIcon: IconButton(
                            icon: Icon(
                              simpleUIController.isObscure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              simpleUIController.isObscureActive();
                            },
                          ),
                          hintText: 'Password',
                          fillColor: Color(0xFFECF4FF),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (value.length < 7) {
                            return 'at least enter 6 characters';
                          } else if (value.length > 13) {
                            return 'maximum character is 13';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  signUpButton(theme),
                  SizedBox(height: size.height * 0.03),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (ctx) => const LoginView()));
                      emailController.clear();
                      firstNameController.clear();
                      lastNameController.clear();
                      passwordController.clear();
                      _formKey.currentState?.reset();
                      simpleUIController.isObscure.value = true;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 90, vertical: 8.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Ai deja un cont?',
                          style: kHaveAnAccountStyle(size).copyWith(
                            fontSize: 14.0,
                          ),
                          children: [
                            TextSpan(
                              text: " Mergi catre Login",
                              style: kLoginOrSignUpTextStyle(size).copyWith(
                                fontSize: 14.0,
                                color: Colors
                                    .blue, // Adaugă o culoare pentru a indica faptul că este un link
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.go(
                                      '/login-page'); // Folosește context.go pentru a naviga la ruta de login
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Image on the right side for large screens
  Widget _buildImage(Size size) {
    return Flexible(
      flex:
          size.width > 1409 ? 5 : 3, // Adjust flex value based on screen width
      child: Padding(
        padding: EdgeInsets.only(left: size.width * 0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 3,
              child: Image.asset(
                'assets/images/logo-bloc360.png',
                width: size.width * 0.3,
                height: size.height * 0.3,
                fit: BoxFit.contain,
              ),
            ),
            Flexible(
              flex: 7,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  'assets/images/register.png',
                  height: size.height *
                      (size.width > 1409 ? 0.6 : 0.4), // Adjust image height
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: 390,
      height: 45,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF275DAD)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
        onPressed: _registerUser,
        child: Text(
          'Inregistreaza-te',
          style: TextStyle(
              color: Color(
                  0xFFE3E9F1)), // Aici setezi culoarea textului ca fiind albă
        ),
      ),
    );
  }
}
