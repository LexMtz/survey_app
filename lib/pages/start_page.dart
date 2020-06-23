import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/states/authentication_state.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationState authenticationState = Provider.of<AuthenticationState>(context);
    loginListener(context, authenticationState);

    return Container(
        child: Center(
            child: RaisedButton(
      child: Text('START'),
      onPressed: () {
        authenticationState.login();
      },
    )));
  }

  void loginListener(
      BuildContext context, AuthenticationState authenticatioinState) {
    Future.microtask(() {
      if (authenticatioinState.authStatus == kAuthSuccess) {
        Navigator.pushReplacementNamed(context, '/survey_list_page');
      }
    });
  }
}
