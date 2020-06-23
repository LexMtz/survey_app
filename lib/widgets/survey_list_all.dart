import 'package:flutter/material.dart';
import 'package:survey_app/view_models/survey_VM.dart';
import 'package:survey_app/view_models/survey_list_VM.dart';
import 'package:survey_app/widgets/search_field.dart';
import 'package:survey_app/widgets/survey_input.dart';
import 'package:survey_app/widgets/survey_output.dart';

class SurveyListAll extends StatelessWidget {
  SurveyListVM surveyListVM;
  List<bool> isSelected = [true, false, false];

  SurveyListAll({@required this.surveyListVM});

  @override
  Widget build(BuildContext context) {
    switch (surveyListVM.listMode) {
      case 0:
        isSelected = [true, false, false];
        break;
      case 1:
        isSelected = [false, true, false];
        break;
      case 2:
        isSelected = [false, false, true];
        break;
      default:
    }
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          titleSpacing: 0,
          title: SearchField(),
          floating: true,
          elevation: 10,
          forceElevated: true,
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12, right: 12),
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(30),
                borderWidth: 1,
                borderColor: Colors.grey,
                selectedBorderColor: Colors.white,
                children: [
                  Icon(
                    Icons.all_inclusive,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  Icon(Icons.done, color: Colors.white)
                ],
                isSelected: isSelected,
                onPressed: (int index) {
                  surveyListVM.setListMode(index);
                },
              ),
            )
          ],
        ),
        SliverList(delegate: SliverChildListDelegate(_buildList())),
      ],
    );
  }

  List<Widget> _buildList() {
    List<Widget> listItems = List();
    for (int i = 0; i < surveyListVM.surveys.length; i++) {
      SurveyVM survey = surveyListVM.surveys[i];
      listItems.add(Padding(
          padding: EdgeInsets.all(20.0),
          child: !survey.voted() && !survey.ownSurvey()
              ? SurveyInput(survey: survey)
              : SurveyOutput(survey: survey)));
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
