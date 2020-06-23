import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';

class CommonFunctions{

static RichText hashTagText(String inputText){
  return RichText(
          text: getHashTagTextSpan(
            TextStyle(fontSize: 16, color: Colors.blue),
            TextStyle(fontSize: 16, color: Colors.black),
            inputText,
            (text) {
              print(text);
            },
          ),
        );
}

}