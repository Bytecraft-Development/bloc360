import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'HelloWorld.dart';
import 'config/environment_config.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import 'package:frontend/controller/simple_ui_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

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
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; // Obținerea dimensiunilor ecranului
    double paddingValue = size.width * 0.04; // Calcularea padding-ului ca 5% din lățimea ecranului

    SimpleUIController simpleUIController = Get.find<SimpleUIController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                Container(
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
                // Adăugarea RichText aici:
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
                            fontSize:10,
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
                            fontSize: 10,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL('https://bloc360.live/privacy');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    double horizontalPadding = size.width * 0.04;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : Lottie.asset(
                'assets/json/wave.json',
                height: size.height * 0.2,
                width: size.width,
                fit: BoxFit.fill,
              ),
        SizedBox(height: size.height * 0.03),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0),
          child: Text(
            'Intra in cont',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0),
          child: Text(
            'Bine ai venit! Alege o metoda de log in:',
            style: kLoginSubtitleStyle(size).copyWith(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              googleButton(),
              SizedBox(width: 10),
              facebookButton(),
            ],
          ),
        ),
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  horizontalPadding), // Ajustează padding-ul cum consideri
          child: Row(
            children: [
              SizedBox(
                width: 115, // Ajustează lățimea cum consideri
                child: Divider(thickness: 1),
              ),
              SizedBox(width: 8), // Adaugă spațiu între divizor și text
              Text(
                'sau foloseste email-ul',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Color(0xFF616161),
                ),
              ),
              SizedBox(width: 8), // Adaugă spațiu între text și divizor
              SizedBox(
                width: 115, // Ajustează lățimea cum consideri
                child: Divider(thickness: 1),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Form(
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
                    style: TextStyle(),
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'E-mail',
                      fillColor: Color(0xFFECF4FF),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0), // Stilul outline-ului
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
                SizedBox(height: size.height * 0.03),
                Container(
                  width: 390,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFECF4FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    style: TextStyle(), // Poți specifica un stil dacă e necesar
                    controller: _passwordController,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Password',
                      fillColor: Color(0xFFECF4FF),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
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
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Obx(() => Checkbox(
                          value: simpleUIController.isRememberMe.value,
                          onChanged: (value) {
                            simpleUIController.isRememberMe.value = value!;
                          },
                          activeColor: Colors.blue,
                        )),
                        Text(
                          'Ține minte',
                          style: TextStyle(
                            color: Color(0xFF616161),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:175), // Ajustează padding-ul cum dorești
                      child: TextButton(
                        onPressed: () {
                          print("Forgot Password");
                        },
                        child: Text(
                          'Am uitat parola',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                loginButton(),
                SizedBox(height: size.height * 0.03),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    simpleUIController.isObscure.value = true;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 8.0), // Ajustează valorile padding-ului după cum dorești
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Nu ai un cont?',
                        style: kHaveAnAccountStyle(size).copyWith(
                          fontSize: 14.0, // Ajustează dimensiunea textului
                        ),
                        children: [
                          TextSpan(
                            text: " Creeaza cont nou",
                            style: kLoginOrSignUpTextStyle(size).copyWith(
                              fontSize: 14.0, // Ajustează dimensiunea textului
                            ),
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
    );
  }

  Widget googleButton() {
    return ElevatedButton.icon(
      icon: Image.asset(
        'assets/images/google.png',
        height: 18, // Înlocuiește cu calea corectă a imaginii
      ),
      label: Text(
        'Google',
        style: TextStyle(
          color: Colors.black, // Setează culoarea textului la negru
        ),
      ),
      onPressed: () {
        // Logica pentru Google login
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Setează culoarea de fundal la alb
        foregroundColor:
            Colors.black, // Setează culoarea textului/iconițelor la negru
        minimumSize: Size(200, 60),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: Color(0xFFCDCDCD),
              width: 2), // Grosimea bordurii ajustată la 2
        ),
        elevation: 0, // Elimină orice umbrire sub buton
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey[200]!; // Culoarea pentru starea 'pressed'
            }
            return Colors.white; // Culoarea implicită
          },
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
        backgroundColor: Colors.white, // Setează culoarea de fundal la alb
        foregroundColor:
            Colors.black, // Setează culoarea textului/iconițelor la negru
        minimumSize: Size(200, 60),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xFFCDCDCD), width: 2),
        ),
        elevation: 0, // Elimină orice umbrire sub buton
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey[200]!; // Culoarea pentru starea 'pressed'
            }
            return Colors.white; // Culoarea implicită
          },
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
        onPressed: _login,
        child: Text(
          'Login',
          style: TextStyle(
              color: Color(
                  0xFFE3E9F1)), // Aici setezi culoarea textului ca fiind albă
        ),
      ),
    );
  }
}
