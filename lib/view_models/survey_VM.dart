import 'package:flutter/cupertino.dart';
import 'package:survey_app/models/survey.dart';
import 'package:survey_app/services/common_functions.dart';
import 'package:survey_app/services/webservice.dart';
import 'package:survey_app/states/authentication_state.dart';
import 'package:survey_app/view_models/choice_VM.dart';

class SurveyVM {
  Survey _survey;
  List<ChoiceVM> _choices;

  SurveyVM(Survey survey) {
    this._survey = survey;
  }

  Future<void> init() async {
    await getChoicesVM();
  }

  String get docId => this._survey.docId;
  String get question => this._survey.question;
  String get creator => this._survey.creator;
  DateTime get createTime => this._survey.createTime;
  DateTime get startTime => this._survey.startTime;
  int get durationDays => this._survey.durationDays;
  List<String> get likers => this._survey.likers;
  int get likes => this._survey.likers.length;
  List<String> get reporters => this._survey.reporters;
  int get reports => this._survey.reporters.length;
  List<ChoiceVM> get choices => _choices;
  bool get deleted => this._survey.deleted;

  Future getChoicesVM() async {
    final results = await Webservice.downloadDocuments(
        topCollection: 'surveys',
        docId: _survey.docId,
        collection: 'choices',
        orderBy: 'index');
    this._choices = results.map((choice) => ChoiceVM(choice)).toList();
  }

  int votesTotal() {
    int votesTotal = 0;
    for (var choice in _choices) {
      votesTotal += choice.votes;
    }
    return votesTotal;
  }

  Future<void> like() async {
    if (!likers.contains(AuthenticationState.userId)) {
      likers.add(AuthenticationState.userId);
      _survey.likes = likers.length;
      Webservice.updateKeyValue('surveys', docId, 'likers', likers);
      Webservice.updateKeyValue('surveys', docId, 'likes', likes);
    }
  }

  Future<void> report() async {
    if (!reporters.contains(AuthenticationState.userId)) {
      reporters.add(AuthenticationState.userId);
      _survey.reports = reporters.length;
      Webservice.updateKeyValue('surveys', docId, 'reporters', reporters);
      Webservice.updateKeyValue('surveys', docId, 'reports', reports);
    }
  }

  bool isFinished() {
    if (voted() || expired() || ownSurvey()) return true;
    return false;
  }

  bool voted() {
    bool voted = false;
    for (var choice in _choices) {
      if (AuthenticationState.userId != null &&
          choice.voters.contains(AuthenticationState.userId)) voted = true;
    }
    return voted;
  }

  bool expired() {
    if (daysToExpireDate() < 1) return true;
    return false;
  }

  int daysToExpireDate() {
    DateTime endTime = _survey.startTime.add(Duration(days: _survey.durationDays));
    Duration difference = endTime.difference(DateTime.now());
    return difference.inDays;
  }

  bool ownSurvey() {
    if (_survey.creator == AuthenticationState.userId) return true;
    return false;
  }

  bool reported() {
    if (_survey.reporters.contains(AuthenticationState.userId)) return true;
    return false;
  }

  Future<void> deleteSurvey() async{
    await Webservice.updateKeyValue('surveys', docId, 'deleted', true);
  }
}
