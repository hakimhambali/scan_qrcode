class History {
  final String docID;
  String link;
  final String date;
  final String userID;
  bool isFavorite;

  History({
    required this.docID,
    this.link = '',
    required this.date,
    required this.userID,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
        'docID': docID,
        'link': link,
        'date': date,
        'userID': userID,
        'isFavorite': isFavorite,
      };

  static History fromJson(Map<String, dynamic> json) => History(
        docID: json['docID'],
        link: json['link'],
        date: json['date'],
        userID: json['userID'],
        isFavorite: json['isFavorite'] ?? false,
      );
}

class Feedback {
  String feedback;
  final String date;
  final String type;
  final String userID;

  Feedback({
    this.feedback = '',
    required this.date,
    required this.type,
    required this.userID,
  });

  Map<String, dynamic> toJson() => {
        'feedback': feedback,
        'date': date,
        'type': type,
        'userID': userID,
      };

  static Feedback fromJson(Map<String, dynamic> json) => Feedback(
        feedback: json['feedback'],
        date: json['date'],
        type: json['type'],
        userID: json['userID'],
      );
}
