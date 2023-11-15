// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutriscan/firebase_options.dart';
import 'package:nutriscan/screens/history.dart';
import 'package:provider/provider.dart';
import 'package:nutriscan/components/constants.dart';
import 'package:nutriscan/screens/get_started.dart';
import 'package:nutriscan/screens/home_screen.dart';
import 'package:nutriscan/screens/login_screen.dart';
import 'package:nutriscan/screens/signup_form.dart';
import 'package:nutriscan/screens/your_prefrence.dart';
import 'package:nutriscan/services/firebase_auth_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await SharedPreferences.getInstance(); // Initialize shared preferences
  // final historyProvider = HistoryProvider();
  // await historyProvider.loadHistory();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<FirebaseAuthMethods>(
            create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<FirebaseAuthMethods>().authState,
            initialData: null,
          ),
          ChangeNotifierProvider<ChoiceModel>(
            create: (context) => ChoiceModel(),
            child: Preferences(),
          ),
          // ChangeNotifierProvider(
          //   create: (context) => HistoryProvider(),
          // ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a blue toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Blue1),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            useMaterial3: true,
          ),
          home: const AuthWrapper(),
          routes: {
            SignupForm.routeName: (context) => SignupForm(),
            LoginScreen.routeName: (context) => const LoginScreen(),
          },
          debugShowCheckedModeBanner: false,
        ));
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return HomeScreen();
    }
    return GetStarted();
  }
}
