import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/view_models/survey_VM.dart';
import 'package:survey_app/view_models/survey_list_VM.dart';

class SurveyFooter extends StatelessWidget {
  final SurveyVM survey;
  SurveyListVM _surveyListVM;

  SurveyFooter({@required this.survey});

  @override
  Widget build(BuildContext context) {
    _surveyListVM = Provider.of<SurveyListVM>(context);

    var textStyle = TextStyle(color: Colors.grey);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        !survey.expired()
        ? Text('${survey.daysToExpireDate()} days left', style: textStyle)
        : Text('expired', style: textStyle,),
        Spacer(),
        IconButton(
          icon: Icon(Icons.thumb_up),
          onPressed: () {
            _surveyListVM.likeSurvey(survey);
          },
        ),
        Text(survey.likes.toString()),
        IconButton(
          onPressed: null,
          icon: Icon(Icons.warning),
        ),
        Text(survey.reports.toString()),
      ],
    );
  }
}
