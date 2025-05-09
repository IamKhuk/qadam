class Utils{
  static String tripDateFormat(DateTime time) {
    String month = '';
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

    String hourFormat = '';
    time.hour > 12 || time.hour == 0 ? hourFormat = 'pm' : 'am';

    String hour = '';
    time.hour > 12
        ? hour = (time.hour - 12).toString()
        : hour = time.hour.toString();

    return "$month ${time.day.toString()} at $hour:${time.minute} $hourFormat";
  }
}