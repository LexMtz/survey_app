import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/view_models/survey_list_VM.dart';

class HashTagText extends StatelessWidget {
  final inputText;

  HashTagText({@required this.inputText});

  @override
  Widget build(BuildContext context) {
    SurveyListVM _surveyListVM = Provider.of<SurveyListVM>(context);

    return RichText(
      text: getHashTagTextSpan(
        TextStyle(fontSize: 16, color: Colors.blue),
        TextStyle(fontSize: 16, color: Colors.black),
        inputText,
        (text) {
          _surveyListVM.searchSurveysByKeyword(text);
        },
      ),
    );
  }
}
