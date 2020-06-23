import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:survey_app/view_models/choice_VM.dart';
import 'package:survey_app/view_models/survey_VM.dart';
import 'package:survey_app/widgets/hash_tag_text.dart';
import 'package:survey_app/widgets/survey_footer.dart';
import 'package:survey_app/widgets/survey_pop_up_menu_button.dart';

class SurveyOutput extends StatelessWidget {
  final SurveyVM survey;

  SurveyOutput({@required this.survey});

  @override
  Widget build(BuildContext context) {
    return survey == null
        ? Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),

        ))
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(child: HashTagText(inputText: survey.question)),
                  Visibility(
                  visible: !survey.reported(),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: SurveyPopUpMenuButton(survey: survey))),
                ],
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: survey.choices.length,
                itemBuilder: (BuildContext context, int index) {
                  ChoiceVM choice = survey.choices[index];
                  double result = survey.votesTotal() > 0
                      ? choice.votes / survey.votesTotal()
                      : 0;
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      Bar(result, choice.votes.toString()),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text(choice.title, style: TextStyle(color: Colors.grey[800])),
                      ),

                    ],
                  );
                },
              ),
              SurveyFooter(survey: survey)
            ],
          );
  }
}

class Bar extends StatelessWidget {
  final double width;
  final String label;

  final int _baseDurationMs = 1000;
  final double _maxElementWidth = 300;

  Bar(this.width, this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: PlayAnimation<double>(
        duration: Duration(milliseconds: (width * _baseDurationMs).round()),
        tween: Tween(begin: 0.0, end: width),
        builder: (context, child, animatedWidth) {
          return Row(
            children: <Widget>[
              Text(label),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 30,
                width: animatedWidth * _maxElementWidth,
                decoration: BoxDecoration(
                  border: Border.symmetric(),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
