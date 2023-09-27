class ExchangeRate {
  final String timePeriodStart;
  final String timePeriodEnd;
  final String timeOpen;
  final String timeClose;
  final double rateOpen;
  final double rateHigh;
  final double rateLow;
  final double rateClose;

  ExchangeRate({
    required this.timePeriodStart,
    required this.timePeriodEnd,
    required this.timeOpen,
    required this.timeClose,
    required this.rateOpen,
    required this.rateHigh,
    required this.rateLow,
    required this.rateClose,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      timePeriodStart: json["time_period_start"] ?? "",
      timePeriodEnd: json["time_period_end"] ?? "",
      timeOpen: json["time_open"] ?? "",
      timeClose: json["time_close"] ?? "",
      rateOpen: json["rate_open"] ?? 0.0,
      rateHigh: json["rate_high"] ?? 0.0,
      rateLow: json["rate_low"] ?? 0.0,
      rateClose: json["rate_close"] ?? 0.0,
    );
  }
}

