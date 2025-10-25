import 'package:intl/intl.dart';

class WeekDaysNDate {
  WeekDaysNDate._();

  //Get 7 Days of the Week
  static List<Map<String, dynamic>> getWeekDates() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    //final DateFormat formatter = DateFormat('EEEE, d');
    final DateFormat weekDay = DateFormat('EEEE');
    final DateFormat date = DateFormat('d');
    final DateFormat month = DateFormat('MMM'); // Customize format if needed

    return List.generate(7, (index) {
      final day = monday.add(Duration(days: index));
      return {
        'weekDay': weekDay.format(day),
        'day': date.format(day),
        'month': month.format(day),
        'isToday': (now.weekday - 1) == index,
      };
      // return formatter.format(date);
    });
  }

  static String currentMoth() {
    String currMoth = '';
    final List<Map<String, dynamic>> dates = getWeekDates();
    for (var date in dates) {
      if (date['isToday'] == true) {
        currMoth = date['month'];
      }
    }
    return currMoth;
  }
}
