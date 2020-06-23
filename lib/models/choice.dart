class Choice {
  String docId;
  int index;
  String title;
  int votes;
  List<String> voters;

  Choice(
      {this.docId,
      this.index,
      this.title,
      this.votes,
      this.voters,});

  factory Choice.fromJson(Map<String, dynamic> data) {
    return Choice(
      docId: data['doc_id'],
      index: data['index'],
      title: data['title'],
      votes: data['votes'],
      voters:
          data['voters'] != null ? List.from(data['voters']) : [],
    );
  }

  Map<String, dynamic> get dataMap {
    votes = voters != null ? voters.length : 0;

    return {
      'title': title,
      'index': index,
      'votes': votes,
      'voters': voters,
    };
  }
}
