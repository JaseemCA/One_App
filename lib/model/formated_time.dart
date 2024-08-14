class FormattedTime {
  final String hour;
  final String minutes;
  final String ticker;
  final String time;

  /// if any values like AM or PM will be addded with minutes
  FormattedTime(
      {required this.hour,
      required this.minutes,
      required this.ticker,
      required this.time});
}
