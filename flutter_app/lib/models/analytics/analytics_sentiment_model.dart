class AnalyticsSentiment {
  final double positive;
  final double neutral;
  final double negative;

  const AnalyticsSentiment({
    required this.positive,
    required this.neutral,
    required this.negative,
  });

  factory AnalyticsSentiment.fromJson(Map<String, dynamic> json) {

    double pos = 0, neu = 0, neg = 0;

    final news = json['newsSentiment'];
    final social = json['socialSentiment'];

    if (news is Map) {
      pos += _toDouble(news['positive']);
      neu += _toDouble(news['neutral']);
      neg += _toDouble(news['negative']);
    }

    if (social is Map) {
      pos += _toDouble(social['positive']);
      neu += _toDouble(social['neutral']);
      neg += _toDouble(social['negative']);
    }

    if ((pos + neu + neg) == 0) {
      final score = _toDouble(json['score']);
      pos = score.clamp(0, 100);
      neg = (100 - pos).clamp(0, 100);
      neu = 0;
    }

    return AnalyticsSentiment(
      positive: pos,
      neutral: neu,
      negative: neg,
    );
  }


  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
