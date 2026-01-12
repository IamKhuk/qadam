class Utils {
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

  static String scheduleDateFormat(DateTime time) {
    String weekDay = '';
    String month = '';
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
        ? month = 'Jan'
        : time.month == 2
            ? month = 'Feb'
            : time.month == 3
                ? month = 'March'
                : time.month == 4
                    ? month = 'Apr'
                    : time.month == 5
                        ? month = 'May'
                        : time.month == 6
                            ? month = 'June'
                            : time.month == 7
                                ? month = 'July'
                                : time.month == 8
                                    ? month = 'Aug'
                                    : time.month == 9
                                        ? month = 'Sep'
                                        : time.month == 10
                                            ? month = 'Oct'
                                            : time.month == 11
                                                ? month = 'Nov'
                                                : month = 'Dec';

    return '$weekDay, $month ${time.day}';
  }

  static String historyDateFormat(DateTime time) {
    String month = '';

    time.month == 1
        ? month = 'Jan'
        : time.month == 2
            ? month = 'Feb'
            : time.month == 3
                ? month = 'March'
                : time.month == 4
                    ? month = 'Apr'
                    : time.month == 5
                        ? month = 'May'
                        : time.month == 6
                            ? month = 'June'
                            : time.month == 7
                                ? month = 'July'
                                : time.month == 8
                                    ? month = 'Aug'
                                    : time.month == 9
                                        ? month = 'Sep'
                                        : time.month == 10
                                            ? month = 'Oct'
                                            : time.month == 11
                                                ? month = 'Nov'
                                                : month = 'Dec';

    return '${time.day} $month ${time.hour}:${time.minute}';
  }

  static String priceFormat(String price) {
    String priceResult = '';
    if(price.contains('.')){
      priceResult = price.split('.')[0];
    }else{
      priceResult = price;
    }
    priceResult = priceResult.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return priceResult;
  }

  String formatCardNumber(String cardNumber) {
    if (cardNumber.length <= 4) {
      return cardNumber; // or handle as an error, card number too short
    }
    String lastFourDigits = cardNumber.substring(cardNumber.length - 4);
    return "**** **** **** $lastFourDigits";
  }

  int stringToInt(String value) {
    String cleaned = value.replaceAll(',', '');
    double parsed = double.parse(cleaned);
    return parsed.toInt();
  }


}
