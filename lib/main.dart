import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/pages/start_page.dart';
import 'package:survey_app/pages/survey_create_page.dart';
import 'package:survey_app/pages/survey_list_page.dart';
import 'package:survey_app/states/authentication_state.dart';
import 'package:survey_app/view_models/survey_list_VM.dart';

void main() {
  runApp(MultiProvider(
    providers: [
    ChangeNotifierProvider(create: (context) => AuthenticationState()),
    ChangeNotifierProvider(create: (context) => SurveyListVM()),
    ],
    child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFDA7B00),

        accentColor: Colors.blueAccent,
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
        primaryIconTheme: IconThemeData(color: Colors.white),
        accentIconTheme: IconThemeData(color: Colors.white),
      ),
      initialRoute: "/",
      routes: {"/": (context) => StartPage(),
      "/survey_list_page": (context) => SurveyListPage(),
      "/survey_create_page": (context) => SurveyCreatePage()}
    );
  }
}
