import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/models/choice.dart';
import 'package:survey_app/models/survey.dart';

class Webservice {
  static CollectionReference colRefChoices(String docId) {
    return Firestore.instance
        .collection('surveys')
        .document(docId)
        .collection('choices');
  }

  static Future<List<dynamic>> downloadDocuments(
      {String topCollection,
      String docId,
      @required String collection,
      String orderBy,
      bool descending = false}) async {
    CollectionReference colRef;
    colRef = docId != null && collection != null
        ? Firestore.instance
            .collection(topCollection)
            .document(docId)
            .collection(collection)
        : Firestore.instance.collection(collection);
    var reference = orderBy != null
        ? colRef.orderBy(orderBy, descending: descending)
        : colRef;
    return reference.getDocuments().then((snapshot) {
      return snapshot.documents
          .map((document) => objectFromJson(collection, document.data))
          .toList();
    });
  }

  static Future<String> uploadDocument(
      String collection, Map<String, dynamic> dataMap) async {
    CollectionReference colRef = Firestore.instance.collection(collection);
    DocumentReference docRef = await colRef.add(dataMap);
    await updateKeyValue(
        colRef, docRef.documentID, 'doc_id', docRef.documentID);
    return docRef.documentID;
  }

  static Future<String> uploadDocumentToSubCollection(String collection,
      String docId, String subCollection, Map<String, dynamic> dataMap) async {
    CollectionReference colRef = Firestore.instance
        .collection(collection)
        .document(docId)
        .collection(subCollection);
    DocumentReference docRef = await colRef.add(dataMap);
    await updateKeyValue(
        colRef, docRef.documentID, 'doc_id', docRef.documentID);
    return docRef.documentID;
  }

  static Future uploadDocumentToDocId(
      String collection, String docId, Map<String, dynamic> dataMap) async {
    CollectionReference colRef = Firestore.instance.collection(collection);
    DocumentReference docRef = colRef.document(docId);
    await docRef.setData(dataMap);
    if (collection != 'users')
      await updateKeyValue(
          colRef, docRef.documentID, 'doc_id', docRef.documentID);
  }

  static Future deleteDocument(String collection, String docId) async {}

  static Future updateKeyValue(
      var colRef, String docId, String key, dynamic value) async {
    if (colRef is String) colRef = Firestore.instance.collection(colRef);
    try {
      await colRef.document(docId).updateData({key: value});
    } catch (e) {
      print(e.toString());
    }
  }

  static Future updateKeyValueChoice(
      String docIdSurvey, String docIdChoice, String key, dynamic value) async {
    CollectionReference colRef = Firestore.instance
        .collection('surveys')
        .document(docIdSurvey)
        .collection('choices');

    try {
      await colRef.document(docIdChoice).updateData({key: value});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> downloadDocumentByField(
      String collection, String fieldKey, String fieldValue) async {
    var _document;
    await Firestore.instance
        .collection(collection)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((document) {
        if (document.data[fieldKey] == fieldValue) {
          _document = objectFromJson(collection, document.data);
        }
      });
    });
    return _document;
  }

  Future<dynamic> downloadDocumentByDocId(
      String collection, String docId) async {
    var document =
        await Firestore.instance.collection(collection).document(docId).get();
    return objectFromJson(collection, document.data);
  }

  static dynamic objectFromJson(String collection, Map<String, dynamic> data) {
    switch (collection) {
      case 'surveys':
        return Survey.fromJson(data);
        break;
      case 'choices':
        return Choice.fromJson(data);
        break;
    }
  }
}
