const int sunday = 0x01;
const int monday = 0x02;
const int tuesday = 0x04;
const int wednesday = 0x08;
const int thursday = 0x10;
const int friday = 0x20;
const int saturday = 0x40;

const List<dynamic> weekdays = [
  {"en": "Sunday", "code": "Sunday", "he": "יום ראשון"},
  {"en": "Monday", "code": "Monday", "he": "יום שני"},
  {"en": "Tuesday", "code": "Tuesday", "he": "יום שלישי"},
  {"en": "Wednesday", "code": "Wednesday", "he": "יום רביעי"},
  {"en": "Thursday", "code": "Thursday", "he": "יום חמישי"},
  {"en": "Friday", "code": "Friday", "he": "יום שישי"},
  {"en": "Saturday", "code": "Saturday", "he": "שבת"},
];
String translateWeekday(String englishWeekday) {
  final weekdayData = weekdays.firstWhere(
    (data) => data['en'] == englishWeekday,
    orElse: () => null,
  );
  return weekdayData != null ? weekdayData['he'] : englishWeekday;
}
