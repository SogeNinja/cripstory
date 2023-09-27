class CryptoPeriod{
  final String periodId;
  final int lengthSeconds;
  final int lenghtMonths;
  final int unitCount;
  final String unitName;
  final String displayName;

  CryptoPeriod({
    required this.periodId,
    required this.lengthSeconds,
    required this.lenghtMonths,
    required this.unitCount,
    required this.unitName,
    required this.displayName
  });
  
  factory CryptoPeriod.fromJson(Map<String, dynamic> json) {
    return CryptoPeriod(
      periodId: json["period_id"],
      lengthSeconds: json["length_seconds"],
      lenghtMonths: json["length_months"],
      unitCount: json["unit_count"],
      unitName: json["unit_name"],
      displayName: json["display_name"],
    );
  }
}