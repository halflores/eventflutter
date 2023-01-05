import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventflutter/bloc/auth/auth_bloc.dart';
import 'package:eventflutter/bloc/date_time/date_time_bloc.dart';
import 'package:eventflutter/bloc/map/map_bloc.dart';
import 'package:eventflutter/bloc/video/video_bloc.dart';
import 'package:eventflutter/services/auth_fireStore.dart';
import 'package:eventflutter/view/onBoarding/onBoardingScreen.dart';
import 'package:eventflutter/view/root_app.dart';
import 'package:eventflutter/theme/color.dart' as color;
import '../constants.dart' as constants;

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  //final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  //await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  //initializeFlutterFire();
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  //initializeFlutterFire01();
  //runApp(MyApp(settingsController: settingsController));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  const App({
    Key? key,
    // required this.settingsController,
  }) : super(key: key);
  //final SettingsController settingsController;

  Future<void> initializeFlutterFire() async {
    try {
      await Firebase.initializeApp(
              //name: 'eventflutter',
              options: const FirebaseOptions(
                  appId: '1:TU-GOOGLE-APPID',
                  apiKey: 'TU-GOOGLE-APIKEY',
                  messagingSenderId: 'TU-GOOGLE-messagingSenderId',
                  projectId: 'TU-GOOGLE-projectId',
                  storageBucket: 'TU-GOOGLE-storageBucket'))
          .whenComplete(() => {
                for (var app in Firebase.apps)
                  {
                    debugPrint('App name: ${app.name}'),
                  }
              });
/*     setState(() {
      _initialized = true;
      List<FirebaseApp> apps = Firebase.apps;
      for (var app in apps) {
        debugPrint('App name: ${app.name}');
      }
    }); */
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      debugPrint('error firebase:$e');
/*     setState(() {
      _error = true;
    }); */
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: initializeFlutterFire(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Container(
                  color: Colors.white,
                  child: Center(
                      child: Column(
                    children: const [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 25,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Falló al iniciar Firebase!',
                        style: TextStyle(color: Colors.red, fontSize: 25),
                      ),
                    ],
                  )),
                ),
              ));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: color.primary,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(color.inActiveColor),
                        backgroundColor: color.shadowColor),
                  ),
                ),
              ));
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
                create: (_) => AuthBloc(authFireStore: AuthFireStore())),
            BlocProvider<MapBloc>(create: (_) => MapBloc()),
            BlocProvider<DateTimeBloc>(create: (_) => DateTimeBloc()),
            BlocProvider<VideoBloc>(create: (_) => VideoBloc()),
          ],
          child: MaterialApp(
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch()
                      .copyWith(secondary: color.actionColor)),
              debugShowCheckedModeBanner: false,
              color: color.primary,
              home: const OnBoarding()),
        );
      },
    );
  }
}

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State createState() {
    return OnBoardingState();
  }
}

class OnBoardingState extends State<OnBoarding> {
  Future hasFinishedOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool finishedOnBoarding =
        (prefs.getBool(constants.finishedOnBoarding) ?? false);

    if (finishedOnBoarding) {
      //auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
/*       Navigator.of(context).push(MaterialPageRoute(
          settings: const RouteSettings(name: "/Page1"),
          builder: (context) => const RootApp())); */
/*       Navigator.of(context).push(
        MaterialPageRoute(
          settings: const RouteSettings(name: "/RootApp"),
          builder: (context) => const RootApp(),
        ),
      ); */

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              settings: const RouteSettings(name: "/RootApp"),
              builder: (context) => const RootApp()),
          (Route<dynamic> route) => false);

/*       if (firebaseUser != null) {
        Usuario? usuario;
        usuario =
            await FireStoreAuthenticate().getCurrentUser(firebaseUser.uid);

        if (usuario != null) {
          print('currentUser token' + usuario.token!);

          MyAppTuSolucion.currentUser = usuario;
          pushReplacement(
              context,
              new HomeScreen(
                usuario: usuario,
                selectedTab: 0,
              ));
          FireStoreAuthenticate.firestore
              .collection(Constants.USUARIOS)
              .doc(usuario.usuarioID)
              .update({'active': true});
        } else {
          pushReplacement(context, new AuthScreen());
        }
      } else {
        pushReplacement(context, new AuthScreen());
      } */
    } else {
      //pushReplacement(context, new OnBoardingScreen());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
    }
  }

  @override
  void initState() {
    hasFinishedOnBoarding();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //backgroundColor: Color(Constants.COLOR_ACCENT),
        body: Center(
            child: CircularProgressIndicator(
                color: color.primary,
                valueColor: AlwaysStoppedAnimation<Color>(color.inActiveColor),
                backgroundColor: color.shadowColor)),
      ),
    );
  }
}
