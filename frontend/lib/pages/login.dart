import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:frontend/config/environment.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../constants/constants.dart';
import '../controllers/simple_ui_controller.dart';

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

  Future<void> _loadTokenFromStorage() async {
    _accessToken = html.window.localStorage['access_token'];
    if (_accessToken == null) {
      return;
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(_accessToken!);
    int _expiry = decodedToken['exp'];
    if (DateTime.now().millisecondsSinceEpoch < _expiry * 1000) {
      context.go('/dashboard');
    } else {
      html.window.localStorage.remove('access_token');
    }
  }

  Future<void> _googleLogin() async {
    String clientId = 'bloc360google';
    String redirectUri = '${EnvironmentConfig.BASE_URL}/auth.html';

    final authUrl =
        '${EnvironmentConfig.KEYCLOAK_BASE_URL}/protocol/openid-connect/auth'
        '?client_id=$clientId'
        '&response_type=code'
        '&scope=openid%20profile%20email'
        '&redirect_uri=$redirectUri';

    // Start the authentication flow
    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: Uri.parse(redirectUri).scheme,
    );

    // Extract the authorization code from the result
    final code = Uri.parse(result).queryParameters['code'];
    final token = Uri.parse(result).queryParameters['token'];

    // Exchange the authorization code for tokens
    const tokenUrl =EnvironmentConfig.KEYCLOAK_LOGIN_URL;
    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'authorization_code',
        'code': code ?? '',
        'client_id': 'bloc360google',
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final tokenResponse = json.decode(response.body);
      final accessToken = tokenResponse['access_token'];
      final refreshToken = tokenResponse['refresh_token'];
      // final idToken = tokenResponse['id_token'];
      html.window.localStorage['access_token'] = accessToken;
      html.window.localStorage['refresh_token'] = refreshToken;
      context.go('/dashboard');
    } else {
      print('Failed to retrieve token: ${response.statusCode}');
      print(response.body);
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

      context.go('/redirect');
    } else {
      print('Failed to login: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double paddingValue = size.width * 0.04;

    SimpleUIController simpleUIController = Get.find<SimpleUIController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Container(
                width: size.width * 0.8,
                height: size.height * 0.9,
                padding: EdgeInsets.all(paddingValue),
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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: kLoginTermsAndPrivacyStyle(size),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'Creating an account means you\'re okay with our ',
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
                            context.go('/privacy');
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
    );
  }

  Widget _buildLargeScreen(Size size, SimpleUIController simpleUIController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            top: 10,
            child: Image.asset(
              'assets/images/logo-bloc360.png',
              width: size.width * 0.2,
              height: size.height * 0.2,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: _buildMainBodyLarge(size, simpleUIController),
              ),
              _buildImage(size),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallScreen(Size size, SimpleUIController simpleUIController) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: size.height * 0.03),
            Image.asset(
              'assets/images/logo-bloc360.png',
              height: size.height * 0.1,
              width: size.width * 0.4,
              fit: BoxFit.cover,
            ),
            _buildMainBodySmall(size, simpleUIController),
          ],
        ),
      ),
    );
  }

  Widget _buildMainBodyLarge(Size size, SimpleUIController simpleUIController) {
    double horizontalPadding = size.width * 0.04;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
              googleButton(size),
              SizedBox(width: 5),
              facebookButton(size),
            ],
          ),
        ),
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              SizedBox(
                width: 115,
                child: Divider(thickness: 1),
              ),
              SizedBox(width: 8),
              Text(
                'sau foloseste email-ul',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Color(0xFF616161),
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 115,
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
                    key: Key('email'),
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
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
                SizedBox(height: size.height * 0.03),
                Container(
                  width: 390,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFECF4FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      _login();
                    },
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
                      padding: EdgeInsets.only(left: 175),
                      // Ajustează padding-ul cum dorești
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
                loginButton(size),
                SizedBox(height: size.height * 0.03),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    simpleUIController.isObscure.value = true;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Nu ai un cont?',
                        style: kHaveAnAccountStyle(size).copyWith(
                          fontSize: 14.0,
                        ),
                        children: [
                          TextSpan(
                            text: " Creeaza cont nou",
                            style: kLoginOrSignUpTextStyle(size).copyWith(
                              fontSize: 14.0,
                              color: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/register');
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
    );
  }

  Widget _buildMainBodySmall(Size size, SimpleUIController simpleUIController) {
    double horizontalPadding = size.width * 0.04;
    double fontSizeTitle = 24;
    double fontSizeSubtitle = 14;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.03),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0),
          child: Text(
            'Intra in cont',
            style: TextStyle(
              fontSize: fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0),
          child: Text(
            'Bine ai venit! Alege o metoda de log in:',
            style: TextStyle(
              fontSize: fontSizeSubtitle,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              googleButton(size),
              facebookButton(size),
            ],
          ),
        ),
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              Expanded(
                child: Divider(thickness: 1),
              ),
              SizedBox(width: 8),
              Text(
                'sau foloseste email-ul',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF616161),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
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
                  width: size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFECF4FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
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
                SizedBox(height: size.height * 0.03),
                Container(
                  width: size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFECF4FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    key: Key('password'),
                    onFieldSubmitted: (value) {
                      _login();
                    },
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
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        print("Forgot Password");
                      },
                      child: Text(
                        'Am uitat parola',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                loginButton(size),
                SizedBox(height: size.height * 0.03),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    simpleUIController.isObscure.value = true;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Nu ai un cont?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: " Creeaza cont nou",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/register');
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
    );
  }

  Widget googleButton(Size size) {
    double buttonFontSize = size.width < 600 ? 14 : 16;
    double buttonHeight = size.width < 600 ? 45 : 60;
    double buttonWidth = size.width < 600 ? 50 : 200;

    return ElevatedButton.icon(
      icon: Image.asset(
        'assets/images/google.png',
        height: 18,
      ),
      label: Text(
        'Google',
        style: TextStyle(
          fontSize: buttonFontSize,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        _googleLogin();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: Size(buttonWidth, buttonHeight),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Color(0xFFCDCDCD),
            width: 2,
          ),
        ),
        elevation: 0,
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey[200]!;
            }
            return Colors.white;
          },
        ),
      ),
    );
  }

  Widget facebookButton(Size size) {
    double buttonFontSize = size.width < 600 ? 14 : 16;
    double buttonHeight = size.width < 600 ? 45 : 60;
    double buttonWidth = size.width < 600 ? 50 : 200;

    return ElevatedButton.icon(
      icon: Image.asset(
        'assets/images/facebook.png',
        height: 18,
      ),
      label: Text(
        'Facebook',
        style: TextStyle(
          fontSize: buttonFontSize,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        // Logica pentru Facebook login
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: Size(buttonWidth, buttonHeight),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Color(0xFFCDCDCD),
            width: 2,
          ),
        ),
        elevation: 0,
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey[200]!;
            }
            return Colors.white;
          },
        ),
      ),
    );
  }

  Widget loginButton(Size size) {
    double buttonFontSize = size.width < 600 ? 14 : 16;
    double buttonHeight = 45;
    double buttonWidth = size.width < 600 ? size.width * 0.8 : 390;

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        key: Key('loginButton'),
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
            fontSize: buttonFontSize,
            color: Color(0xFFE3E9F1),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(Size size) {
    return Flexible(
      flex: size.width > 1409 ? 5 : 3,
      child: Padding(
        padding: EdgeInsets.only(left: size.width * 0.01),
        child: RotatedBox(
          quarterTurns: 4,
          child: Image.asset(
            'assets/images/people.png',
            height: size.height * (size.width > 1409 ? 0.4 : 0.3),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
