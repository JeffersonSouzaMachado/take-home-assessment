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
    return AnalyticsSentiment(
      positive: _toDouble(json['positive']),
      neutral: _toDouble(json['neutral']),
      negative: _toDouble(json['negative']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
