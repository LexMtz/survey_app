import 'package:flutter/material.dart';
import 'package:survey_app/models/choice.dart';
import 'package:survey_app/models/survey.dart';
import 'package:survey_app/services/webservice.dart';
import 'package:survey_app/states/authentication_state.dart';
import 'package:survey_app/view_models/choice_VM.dart';
import 'package:survey_app/view_models/survey_VM.dart';

class SurveyListVM extends ChangeNotifier {
  var _surveys = List<SurveyVM>();
  bool isLoading = false;
  String keyword = '';
  int listMode = 0; // 0: all, 1: input only, 2: output only

  List<SurveyVM> get surveys => surveysFiltered();
  List<SurveyVM> get surveysOwn =>
      surveysFiltered(userId: AuthenticationState.userId);
  List<SurveyVM> get surveysUnfiltered => _surveys;

  List<SurveyVM> surveysFiltered({String userId}) {
    var surveysNew = List<SurveyVM>();
    for (var survey in _surveys) {
      if ((keyword == null ||
                  survey.question
                      .toLowerCase()
                      .contains(keyword.toLowerCase())) &&
              listModeChecked(survey) &&
              (userId == null ||
          survey.creator == userId) && !survey.deleted) {
        surveysNew.add(survey);
      }
    }
    return surveysNew;
  }

  bool listModeChecked(SurveyVM survey) {
    if (listMode == 0 ||
        listMode == 1 && !survey.voted() ||
        listMode == 2 && survey.voted()) return true;
    return false;
  }

  searchSurveysByKeyword(String keyword) {
    this.keyword = keyword;
    notifyListeners();
  }

  Future downloadSurveys() async {
    //isLoading = true;
    notifyListeners();
    final results = await Webservice.downloadDocuments(
        collection: 'surveys', orderBy: 'start_time', descending: true);
    _surveys = results.map((survey) => SurveyVM(survey)).toList();
    await initSurveys();
    //isLoading = false;
    notifyListeners();
  }

  Future initSurveys() async {
    for (var survey in _surveys) {
      await survey.init();
    }
  }

  Future createSurvey(Survey survey, List<Choice> choices) async {
    isLoading = true;
    notifyListeners();
    String docId = await Webservice.uploadDocument('surveys', survey.dataMap);
    for (var choice in choices) {
      await Webservice.uploadDocumentToSubCollection(
          'surveys', docId, 'choices', choice.dataMap);
    }
    await downloadSurveys();
    isLoading = false;
  }

  Future deleteSurvey(SurveyVM survey) async {
    await survey.deleteSurvey();
    await downloadSurveys();
  }

  Future<void> vote(SurveyVM survey, ChoiceVM choice) async {
    await choice.vote(survey.docId);
    await downloadSurveys();
  }

  Future<void> likeSurvey(SurveyVM survey) async {
    survey.like();
    await downloadSurveys();
  }

  Future<void> reportSurvey(SurveyVM survey) async {
    survey.report();
    await downloadSurveys();
  }

  void setListMode(int listMode) {
    this.listMode = listMode;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
