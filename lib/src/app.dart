import 'package:flutter/material.dart';
import 'package:Albatross/src/providers/hospital_user_provider.dart';
import 'package:Albatross/src/screens/hospital_home_screen.dart';
import 'package:Albatross/src/screens/hospital_info_screen.dart';
import 'package:Albatross/src/providers/hospital_list_provider.dart';
import 'package:Albatross/src/providers/user_profile_provider.dart';
import 'package:Albatross/src/screens/auth_screen.dart';
import 'package:Albatross/src/screens/hospital_profile_edit_screen.dart';
import 'package:Albatross/src/screens/signup_screen.dart';
import 'package:Albatross/src/screens/user_home_screen.dart';
import 'package:Albatross/src/screens/splash_screen.dart';
import 'package:Albatross/src/screens/map_screen.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => HospitalListProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HospitalUserProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xff0079f5),
          accentColor: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (BuildContext context) => SplashPage(),
          '/info': (BuildContext context) => HospitalInfo(),
          '/user-home': (BuildContext context) => UserHomeScreen(),
          '/auth': (BuildContext context) => AuthScreen(),
          '/map': (BuildContext context) => MapView(),
          '/signup': (BuildContext context) => SignUpScreen(),
          "/hospital-profile-edit": (BuildContext context) => HospitalProfileEditScreen(),
          "/hospital-info": (BuildContext context) => HospitalInfo(),
          "/hospital-home":(BuildContext context) => HospitalDashboard(),
        },
      ),
    );
  }
}
