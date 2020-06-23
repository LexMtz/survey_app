import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:survey_app/view_models/survey_VM.dart';
import 'package:survey_app/widgets/choice_button.dart';
import 'package:survey_app/widgets/hash_tag_text.dart';
import 'package:survey_app/widgets/survey_footer.dart';
import 'package:survey_app/widgets/survey_pop_up_menu_button.dart';

class SurveyInput extends StatelessWidget {
  final SurveyVM survey;

  SurveyInput({@required this.survey});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            return ChoiceButton(
              survey: this.survey,
              choice: this.survey.choices[index],
            );
          },
        ),
        SurveyFooter(
          survey: survey,
        )
      ],
    );
  }
}
