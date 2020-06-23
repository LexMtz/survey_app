class Survey {
  String docId;
  String question;
  String creator;
  DateTime createTime;
  DateTime startTime;
  int durationDays;
  List<String> likers;
  int likes;
  List<String> reporters;
  int reports;
  bool deleted;

  Survey(
      {this.docId,
      this.question,
      this.creator,
      this.createTime,
      this.startTime,
      this.durationDays,
      this.likers,
      this.likes,
      this.reporters,
      this.reports,
      this.deleted});

  factory Survey.fromJson(Map<String, dynamic> data) {
    return Survey(
      docId: data['doc_id'],
      question: data['question'],
      creator: data['creator'],
      createTime: DateTime.parse(data['create_time'].toDate().toString()),
      startTime: DateTime.parse(data['start_time'].toDate().toString()),
      durationDays: data['duration_days'],
      likers: data['likers'] != null ? List.from(data['likers']) : [],
      likes: data['likes'],
      reporters: data['reporters'] != null ? List.from(data['reporters']) : [],
      reports: data['reports'],
      deleted: data['deleted'] ?? false,
    );
  }

  Map<String, dynamic> get dataMap {
    likes = likes != null ? likers.length : 0;
    reports = reporters != null ? reporters.length : 0;

    return {
      'question': question,
      'creator': creator,
      'create_time': createTime,
      'start_time': startTime,
      'duration_days': durationDays,
      'likers': likers,
      'likes': likes,
      'reporters': reporters,
      'reports': reports,
      'deleted': deleted,
    };
  }
}
