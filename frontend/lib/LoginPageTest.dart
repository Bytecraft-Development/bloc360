import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'HelloWorld.dart';
import 'RegistrationPage.dart';
import 'config/environment_config.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import 'package:frontend/controller/simple_ui_controller.dart';

import 'config/environment_config.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _loadTokenFromStorage();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _loadTokenFromStorage() async {
    _accessToken = html.window.localStorage['access_token'];
    if (_accessToken == null) {
      return;
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(_accessToken!);
    int _expiry = decodedToken['exp'];
    if (DateTime.now().millisecondsSinceEpoch < _expiry * 1000) {
      _navigateToHelloWorldPage();
    } else {
      html.window.localStorage.remove('access_token');
    }
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await http.post(
      Uri.parse(EnvironmentConfig.KEYCLOAK_LOGIN_URL),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'client_id': EnvironmentConfig.KEYCLOAK_CLIENT_ID,
        'username': username,
        'password': password,
        'grant_type': 'password',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      _accessToken = jsonResponse['access_token'];
      html.window.localStorage['access_token'] = _accessToken!;

      _navigateToHelloWorldPage();
    } else {
      print('Failed to login: ${response.statusCode}');
    }
  }

  Future<void> _navigateToHelloWorldPage() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HelloWorldPage(accessToken: _accessToken),
      ),
    );
  }

  void _navigateToRegistrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; // Obținerea dimensiunilor ecranului
    double paddingValue = size.width *
        0.04; // Calcularea padding-ului ca 5% din lățimea ecranului

    SimpleUIController simpleUIController = Get.find<SimpleUIController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.9,
              padding: EdgeInsets.all(
                  paddingValue), // Aplicarea padding-ului bazat pe procent
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return _buildLargeScreen(size, simpleUIController);
                  } else {
                    return _buildSmallScreen(size, simpleUIController);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10, // Poziționarea logo-ului
            top: 10,
            child: Image.asset(
              'assets/images/logo-bloc360.png',
              width: size.width * 0.2,
              height: size.height * 0.2,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            // Asigură-te că Row este adăugat după Positioned, pentru ca imaginea din Row să vină deasupra logo-ului
            children: [
              Expanded(
                flex: 5,
                child: _buildMainBody(size, simpleUIController),
              ),
              _buildImage(size), // Imaginea care va acoperi logo-ul
            ],
          ),
        ],
      ),
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    double horizontalPadding =
        size.width * 0.04; // 4% din lățimea ecranului pentru padding lateral

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : Lottie.asset(
                'assets/wave.json',
                height: size.height * 0.2,
                width: size.width,
                fit: BoxFit.fill,
              ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            'Intra in cont',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            'Bine ai venit! Alege o metoda de log-in:',
            style: kLoginSubtitleStyle(size).copyWith(fontSize: 18),
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Row(
            children: [
              googleButton(),
              SizedBox(width: 30),
              facebookButton(),
            ],
          ),
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      horizontalPadding), // Ajustează padding-ul cum consideri
              child: SizedBox(
                width: size.width * 0.03, // Ajustează lățimea cum consideri
                child: Divider(thickness: 2),
              ),
            ),
            Text('sau foloseste email-ul'),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      horizontalPadding), // Ajustează padding-ul cum consideri
              child: SizedBox(
                width: size.width * 0.03, // Ajustează lățimea cum consideri
                child: Divider(thickness: 2),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Form(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_rounded),
                    hintText: 'email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (!value.endsWith('@gmail.com')) {
                      return 'please enter valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                Obx(
                  () => TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: _passwordController,
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
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
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
                SizedBox(
                  height: size.height * 0.01,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: kLoginTermsAndPrivacyStyle(
                        size), // Acesta trebuie să fie stilul general al textului
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              'Creating an account means you\'re okay with our '),
                      TextSpan(
                        text: 'Terms of Services',
                        style: TextStyle(
                          color: Colors
                              .blue, // S-ar putea să vrei să adaugi subliniere dacă dorești
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchURL('https://bloc360.live/tos');
                          },
                      ),
                      TextSpan(text: ' and our '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchURL(
                                'https://bloc360.live/tos'); // Presupunem că există un link diferit pentru Politica de Confidențialitate
                          },
                      ),
                    ],
                  ),
                ),

                /// Login Button
                SizedBox(
                  height: size.height * 0.03,
                ),
                loginButton(),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Nu ai un cont?',
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                          text: " Inregistreaza-te",
                          style: kLoginOrSignUpTextStyle(
                            size,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget googleButton() {
    return ElevatedButton.icon(
      icon: Image.asset('assets/images/google.png',
          height: 18), // Înlocuiește cu calea corectă a imaginii
      label: Text(
        'Google',
        style: TextStyle(
            color: Colors.black), // Setează culoarea textului la negru
      ),
      onPressed: () {
        // Logica pentru Google login
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        minimumSize: Size(190, 60),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget facebookButton() {
    return ElevatedButton.icon(
      icon: Image.asset('assets/images/facebook.png',
          height: 18), // Asigură-te că ai acces la această imagine
      label: Text(
        'Facebook',
        style: TextStyle(
            color: Colors.black), // Setează culoarea textului la negru
      ),
      onPressed: () {
        // Logica pentru Facebook login
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        minimumSize: Size(190, 60),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: Colors
                  .grey), // Adaugă un border albastru pentru a menține recunoașterea vizuală a Facebook
        ),
      ),
    );
  }

  Widget _buildImage(Size size) {
    return Flexible(
      flex: size.width > 1409
          ? 5
          : 3, // Ajustează proporția flexibilă în funcție de dimensiunea ecranului
      child: Padding(
        padding: EdgeInsets.only(left: size.width * 0.01),
        child: RotatedBox(
          quarterTurns: 4,
          child: Image.asset(
            'assets/images/people.png',
            height: size.height *
                (size.width > 1409 ? 0.4 : 0.3), // Ajustează înălțimea imaginii
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Login Button
  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.indigo),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
        onPressed: _login,
        child: Text(
          'Login',
          style: TextStyle(
              color:
                  Colors.white), // Aici setezi culoarea textului ca fiind albă
        ),
      ),
    );
  }
}
