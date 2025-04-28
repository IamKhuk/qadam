class Utils{
  static String tripDateFormat(DateTime time) {
    String weekDay = '';
    String month = '';
    String t1 = '';
    String h1 = '';
    time.weekday == 1
        ? weekDay = 'Monday'
        : time.weekday == 2
        ? weekDay = 'Tuesday'
        : time.weekday == 3
        ? weekDay = 'Wednesday'
        : time.weekday == 4
        ? weekDay = 'Thursday'
        : time.weekday == 5
        ? weekDay = 'Friday'
        : time.weekday == 6
        ? weekDay = 'Saturday'
        : weekDay = 'Sunday';

    time.month == 1
        ? month = 'January'
        : time.month == 2
        ? month = 'February'
        : time.month == 3
        ? month = 'March'
        : time.month == 4
        ? month = 'April'
        : time.month == 5
        ? month = 'May'
        : time.month == 6
        ? month = 'June'
        : time.month == 7
        ? month = 'July'
        : time.month == 8
        ? month = 'August'
        : time.month == 9
        ? month = 'September'
        : time.month == 10
        ? month = 'October'
        : time.month == 11
        ? month = 'November'
        : month = 'December';

    time.hour < 13 ? t1 = 'AM' : t1 = 'PM';
    h1 = time.hour < 13 ? time.hour.toString() : (time.hour - 12).toString();

    return '$weekDay, $month ${time.day}, ${time.year}, $h1 $t1';
  }
}