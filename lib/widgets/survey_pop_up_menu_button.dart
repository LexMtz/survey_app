import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/view_models/survey_VM.dart';
import 'package:survey_app/view_models/survey_list_VM.dart';

class SurveyPopUpMenuButton extends StatelessWidget {
  BuildContext context;
  final SurveyVM survey;
  SurveyListVM _surveyListVM;

  SurveyPopUpMenuButton({@required this.survey});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _surveyListVM = Provider.of<SurveyListVM>(context);

    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'report') {
          _actionAlertDialog(0);
          FocusScope.of(context).unfocus();
        } else if (value == 'delete') {
          _actionAlertDialog(1);
        }
      },
      itemBuilder: (context) => [
        if (!survey.ownSurvey())
          PopupMenuItem(
            value: 'report',
            child: Text("Report"),
          ),
        if (survey.ownSurvey())
          PopupMenuItem(
            value: 'delete',
            child: Text("Delete"),
          ),
      ],
    );
  }

  Future<void> _actionAlertDialog(int dialogType) async {
    var titles = [
      'Report survey',
      'Delete survey',
    ];

    var questions = [
      'Would you like to report this survey?',
      'Would you like to delete this survey?',
    ];

    Function reportSurvey = () {
      _surveyListVM.reportSurvey(survey);
      showThankYouMessage();
      Navigator.of(context).pop();
    };

    Function deleteSurvey = () {
      _surveyListVM.deleteSurvey(survey);
      Navigator.of(context).pop();
    };

    var functions = [reportSurvey, deleteSurvey];

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titles[dialogType]),
          content: Text(questions[dialogType]),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: functions[dialogType],
            ),
          ],
        );
      },
    );
  }

  void showThankYouMessage() {
    Fluttertoast.showToast(
        msg: "Thank you for your report",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
