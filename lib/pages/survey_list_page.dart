import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/view_models/survey_list_VM.dart';
import 'package:survey_app/widgets/survey_list_all.dart';
import 'package:survey_app/widgets/survey_list_own.dart';

class SurveyListPage extends StatefulWidget {
  @override
  _SurveyListPageState createState() => _SurveyListPageState();
}

class _SurveyListPageState extends State<SurveyListPage> {
  SurveyListVM _surveyListVM;
  int _currentPageIndex = 0;
  List<Widget> _pages;


  @override
  Widget build(BuildContext context) {
    _surveyListVM = Provider.of<SurveyListVM>(context);
    if (_surveyListVM.surveysUnfiltered.isEmpty && !_surveyListVM.isLoading)
      _surveyListVM.downloadSurveys();

    _pages = <Widget>[
      SurveyListAll(
        surveyListVM: _surveyListVM,
      ),
      SurveyListOwn(
        surveyListVM: _surveyListVM,
      ),
    ];

    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  _buildBody() {
    return Stack(
      children: <Widget>[
        _pages.elementAt(_currentPageIndex),
        if(_surveyListVM.isLoading) Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),

        ))
      ],
    );
  }

  _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          title: Text('All surveys'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('My surveys'),
        ),
      ],
      currentIndex: _currentPageIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(context, '/survey_create_page');
      },
    );
  }
}
