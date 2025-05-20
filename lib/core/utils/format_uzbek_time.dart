
String formatUzbekTime(Duration duration, String locale, {bool showMinutesOnly = false,Suffix suffix=Suffix.noSuffix}) {
  int minutes = duration.inMinutes;
  int hours = duration.inHours;

  bool isCyrillic = locale == "uz_Cyrl";

  if (showMinutesOnly || hours == 0) {
    return isCyrillic ? "$minutes дақиқа${suffix.toCyrl}" : "$minutes daqiqa${suffix.toLatn}";
  } else {
    return isCyrillic ? "$hours соат${suffix.toCyrl}" : "$hours soat${suffix.toLatn}";
  }
}
enum Suffix{
  da, noSuffix,
}
extension SuffixX on Suffix{
  String get toCyrl{
    switch(this) {
      case Suffix.da:
        return 'да';
      case Suffix.noSuffix:
        return '';

    }}
  String get toLatn{
    switch(this) {
      case Suffix.da:
        return 'da';
      case Suffix.noSuffix:
        return '';

    }}
}