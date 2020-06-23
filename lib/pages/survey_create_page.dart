import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/models/choice.dart';
import 'package:survey_app/models/survey.dart';
import 'package:survey_app/states/authentication_state.dart';
import 'package:survey_app/view_models/survey_list_VM.dart';

class SurveyCreatePage extends StatefulWidget {
  @override
  _SurveyCreatePageState createState() => _SurveyCreatePageState();
}

class _SurveyCreatePageState extends State<SurveyCreatePage> {
  List<String> _choices = ['', ''];
  bool _submitted = false;
  var _choiceTextFields = List<Widget>();
  SurveyListVM _surveyListVM;
  int _initChoicesAmount = 2;
  static final formKey = GlobalKey<FormState>();
  TextEditingController _questionController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _questionController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');

    _surveyListVM = Provider.of<SurveyListVM>(context);

    if (_choiceTextFields.isEmpty) _initChoiceTextFields();

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildQuestion(),
                _buildChoiceTextFields(),
                SizedBox(height: 10),
                _buildSubmitSurveyButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initChoiceTextFields() {
    for (var i = 0; i < _initChoicesAmount; i++) {
      _choiceTextFields.add(_choiceTextField());
    }
  }

  _choiceTextField() {
    int index = _choiceTextFields.length;
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: index < 2 ? 'Choice' : 'Choice (optional)',
        errorText: null
          //  _submitted && _choices[index] == '' ? 'Enter choice' : null,
      ),
      onChanged: (input) {
        if (input.isNotEmpty) {
          if(_choices.length == index) 
              _choices.add('');
          _choices[index] = input;
          if (index == _choiceTextFields.length - 1) {
            setState(() {
              _choiceTextFields.add(_choiceTextField());
            });
          }
        }
      },
    );
  }

  _buildAppBar() {
    return AppBar(
      //titleSpacing: 0,
      title: Text('Create survey'),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  _buildQuestion() {
    return TextField(
      controller: _questionController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Question',
        errorText: _submitted && _questionController.text.isEmpty
            ? 'Enter question'
            : null,
      ),
    );
  }

  _buildChoiceTextFields() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _choiceTextFields.length,
      itemBuilder: (BuildContext context, int index) {
        return _choiceTextFields.elementAt(index);
      },
    );
  }

  _buildSubmitSurveyButton() {
    return RaisedButton(
        child: Text('Create survey', style: TextStyle(
      fontSize: 16.0,
    ),),
        shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  
        onPressed: () {
          _submitted = true;
          if (_surveyCompleted()) {
                      _surveyListVM.createSurvey(
                          Survey(
                            question: _questionController.text,
                            creator: AuthenticationState.userId,
                            createTime: DateTime.now(),
                            startTime: DateTime.now(),
                            durationDays: 7,
                          ),
                          _choiceList());
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        Fluttertoast.showToast(
                            msg: "Survey incomplete",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey[600],
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    }
                  });
            }
          
            List<Choice> _choiceList() {
              var choices = List<Choice>();
              for (var i = 0; i < this._choices.length; i++) {
                choices.add(Choice(index: i, title: this._choices[i]));
              }
              return choices;
            }
          
            bool _surveyCompleted() {
              if(_questionController.text.isNotEmpty && (!_choices.contains(''))) return true;
              return false;
            }
}
