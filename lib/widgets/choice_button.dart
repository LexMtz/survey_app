import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/view_models/choice_VM.dart';
import 'package:survey_app/view_models/survey_VM.dart';
import 'package:survey_app/view_models/survey_list_VM.dart';

class ChoiceButton extends StatelessWidget {
  final SurveyVM survey;
  final ChoiceVM choice;
  SurveyListVM _surveyListVM;

  ChoiceButton({@required this.survey, @required this.choice});

  @override
  Widget build(BuildContext context) {
    _surveyListVM = Provider.of<SurveyListVM>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
                onTap: () => vote(),
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: Border.symmetric(),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      choice.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
    );
  }

  vote(){
    _surveyListVM.vote(survey, choice);
  }
}