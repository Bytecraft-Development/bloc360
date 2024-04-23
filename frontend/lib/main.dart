import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

// initialize GoogleSignIn with scopes
const List<String> scopes = <String>[
  'email',
  'profile',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    // listen onCurrentUserChanged  and call keyycloak login

    _googleSignIn.onCurrentUserChanged.listen((event) {
      event?.authentication.then((value) {
        String accessToken = value.accessToken!;

        print('Access Token $accessToken');

        _login('google', accessToken);
      });
    }).onError((error) {
      print(error);
    });
  }

  void _login(String provider, String token) async {
    //Dio to call keycloak login endpoint
    Dio dio = Dio();
    Map<String, String> data = {};

    data['grant_type'] = 'urn:ietf:params:oauth:grant-type:token-exchange';
    data['subject_token_type'] =
    'urn:ietf:params:oauth:token-type:access_token';
    data['client_id'] = 'authenticationClientId';
    data['subject_token'] = token;
    data['subject_issuer'] = provider;

    final response = await dio.post(
        'https://bloc360.live:8443/realms/bloc360/protocol/openid-connect/token',
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType));

    print('Status ${response.statusCode}');
    print(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Social Login Example"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: const NetworkImage(
                "https://www.xda-developers.com/files/2018/02/Flutter-Framework-Feature-Image-Red.png"),
            minRadius: MediaQuery.of(context).size.width / 4,
          ),
          const SizedBox(
            height: 280,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              padding: const EdgeInsets.all(10.0),
              onPressed: () => _googleSignIn.signIn(),
              color: Colors.white,
              elevation: 5,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://storage.googleapis.com/gd-wagtail-prod-assets/original_images/evolving_google_identity_videoposter_006.jpg"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Login with Google    "),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
