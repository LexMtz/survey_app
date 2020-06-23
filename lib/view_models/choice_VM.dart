import 'package:survey_app/models/choice.dart';
import 'package:survey_app/services/webservice.dart';
import 'package:survey_app/states/authentication_state.dart';

class ChoiceVM {
  Choice _choice;

  ChoiceVM(Choice choice) {
    this._choice = choice;
  }

  String get docId => this._choice.docId;
  int get index => this._choice.index;
  String get title => this._choice.title;
  int get votes => this._choice.votes;
  List<String> get voters => this._choice.voters;

  Future vote(String docIdSurvey) async {
    if (!_choice.voters.contains(AuthenticationState.userId)) {
      _choice.voters.add(AuthenticationState.userId);
      _choice.votes++;
      await Webservice.updateKeyValueChoice(
          docIdSurvey, _choice.docId, 'voters', voters);
      await Webservice.updateKeyValueChoice(
          docIdSurvey, _choice.docId, 'votes', votes);
    }
  }

  
}
