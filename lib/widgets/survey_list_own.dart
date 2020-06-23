import 'package:flutter/material.dart';
import 'package:survey_app/view_models/survey_VM.dart';
import 'package:survey_app/view_models/survey_list_VM.dart';
import 'package:survey_app/widgets/search_field.dart';
import 'package:survey_app/widgets/survey_output.dart';

class SurveyListOwn extends StatelessWidget {
 SurveyListVM surveyListVM;

  SurveyListOwn({@required this.surveyListVM});

  @override
  Widget build(BuildContext context) {
    
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          titleSpacing: 0,
          title: SearchField(),
          floating: true,
          elevation: 10,
          forceElevated: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        SliverList(delegate: SliverChildListDelegate(_buildList())),
      ],
    );
  }

  List _buildList() {
    List<Widget> listItems = List();
    for (int i = 0; i < surveyListVM.surveysOwn.length; i++) {
      SurveyVM survey = surveyListVM.surveysOwn[i];
      listItems.add(Padding(
          padding: EdgeInsets.all(20.0),
          child: SurveyOutput(survey: survey)));
      listItems.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 1.0,
            width: 130.0,
            color: Colors.grey,
          ),
        ),
      );
    }
    return listItems;
  }
}