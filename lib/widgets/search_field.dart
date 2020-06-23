import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/view_models/survey_list_VM.dart';

class SearchField extends StatelessWidget {
  BuildContext context;
  SurveyListVM _surveyListVM;
  var textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _surveyListVM = Provider.of<SurveyListVM>(context);

    init();

    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: TextField(
        controller: textEditingController,
        onChanged: (input) {
          if (input.toLowerCase() != _surveyListVM.keyword.toLowerCase())
            _surveyListVM.searchSurveysByKeyword(input);
        },
        decoration: InputDecoration(
            //isDense: true,
            labelText: 'Search',
            labelStyle: TextStyle(color: Colors.white),
            suffixIcon: Visibility(
              visible: textEditingController.text.isNotEmpty,
              child: IconButton(
                icon: Icon(Icons.highlight_off, color: Colors.white),
                onPressed: () {
                  _surveyListVM.searchSurveysByKeyword('');
                },
              ),
            )),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void init() {
    if (textEditingController.text != _surveyListVM.keyword)
      textEditingController.text = _surveyListVM.keyword;
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
  }
}
