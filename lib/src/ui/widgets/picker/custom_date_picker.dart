import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import '../../../theme/app_theme.dart';

const double _kItemExtent = 32.0;
const double _kMagnification = 2.35 / 2.1;
const double _kDatePickerPadSize = 12.0;
const double _kSqueeze = 1.25;

List<String> _monthsName = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

TextStyle _themeTextStyle(BuildContext context, {bool isValid = true}) {
  const TextStyle style = TextStyle(
    fontFamily: AppTheme.fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 23,
    height: 1.2,
    color: AppTheme.purple,
  );
  return isValid
      ? style
      : style.copyWith(
    color: CupertinoDynamicColor.resolve(
      AppTheme.light,
      context,
    ),
  );
}

void _animateColumnControllerToItem(
    FixedExtentScrollController controller, int targetItem) {
  controller.animateToItem(
    targetItem,
    curve: Curves.easeInOut,
    duration: const Duration(milliseconds: 200),
  );
}

const Widget _leftSelectionOverlay =
CupertinoPickerDefaultSelectionOverlay(capStartEdge: false);
const Widget _centerSelectionOverlay = CupertinoPickerDefaultSelectionOverlay(
    capEndEdge: false, capStartEdge: false);
const Widget _rightSelectionOverlay =
CupertinoPickerDefaultSelectionOverlay(capEndEdge: false);

class _DatePickerLayoutDelegate extends MultiChildLayoutDelegate {
  _DatePickerLayoutDelegate({
    required this.columnWidths,
    required this.textDirectionFactor,
  });

  final List<double> columnWidths;
  final int textDirectionFactor;

  @override
  void performLayout(Size size) {
    double remainingWidth = size.width;

    for (int i = 0; i < columnWidths.length; i++) {
      remainingWidth -= columnWidths[i] + _kDatePickerPadSize * 2;
    }

    double currentHorizontalOffset = 0.0;

    for (int i = 0; i < columnWidths.length; i++) {
      final int index =
      textDirectionFactor == 1 ? i : columnWidths.length - i - 1;

      double childWidth = columnWidths[index] + _kDatePickerPadSize * 2;
      if (index == 0 || index == columnWidths.length - 1) {
        childWidth += remainingWidth / 2;
      }
      layoutChild(index,
          BoxConstraints.tight(Size(math.max(0.0, childWidth), size.height)));
      positionChild(index, Offset(currentHorizontalOffset, 0.0));

      currentHorizontalOffset += childWidth;
    }
  }

  @override
  bool shouldRelayout(_DatePickerLayoutDelegate oldDelegate) {
    return columnWidths != oldDelegate.columnWidths ||
        textDirectionFactor != oldDelegate.textDirectionFactor;
  }
}

enum _PickerColumnType {
  day,
  hour,
  minute,
}

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    required this.onDateTimeChanged,
    required this.initialDateTime,
    required this.minimumDate,
    required this.maximumDate,
  });

  final DateTime initialDateTime;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final ValueChanged<DateTime> onDateTimeChanged;

  @override
  State<StatefulWidget> createState() {
    return _CupertinoDatePickerDateState();
  }

  static double _getColumnWidth(
      _PickerColumnType columnType,
      BuildContext context,
      ) {
    String longestText = '';

    switch (columnType) {
      case _PickerColumnType.day:
        for (int i = 0; i <= 30; i++) {
          final DateTime date = DateTime.now().add(Duration(days: i));
          final String dayText = '${date.day} ${_monthsName[date.month - 1]}';
          if (longestText.length < dayText.length) longestText = dayText;
        }
        break;
      case _PickerColumnType.hour:
        longestText = '23';
        break;
      case _PickerColumnType.minute:
        longestText = '55';
        break;
    }
    final TextPainter painter = TextPainter(
      text: TextSpan(
        style: _themeTextStyle(context),
        text: longestText,
      ),
      textDirection: Directionality.of(context),
    );
    painter.layout();
    return painter.maxIntrinsicWidth;
  }
}

typedef _ColumnBuilder = Widget Function(
    double offAxisFraction, TransitionBuilder itemPositioningBuilder, Widget selectionOverlay);

class _CupertinoDatePickerDateState extends State<DatePicker> {
  late int textDirectionFactor;
  late Alignment alignCenterLeft;
  late Alignment alignCenterRight;
  late int selectedDayIndex;
  late int selectedHour;
  late int selectedMinute;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  bool isDayPickerScrolling = false;
  bool isHourPickerScrolling = false;
  bool isMinutePickerScrolling = false;

  bool get isScrolling => isDayPickerScrolling || isHourPickerScrolling || isMinutePickerScrolling;
  Map<int, double> estimatedColumnWidths = <int, double>{};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final initialDate = widget.initialDateTime;

    // Calculate day index (days from today)
    selectedDayIndex = initialDate.difference(DateTime(now.year, now.month, now.day)).inDays;
    selectedDayIndex = selectedDayIndex.clamp(0, 30); // Ensure within 0-30 days
    selectedHour = initialDate.hour;
    selectedMinute = (initialDate.minute ~/ 5) * 5; // Round to nearest 5-minute interval

    dayController = FixedExtentScrollController(initialItem: selectedDayIndex);
    hourController = FixedExtentScrollController(initialItem: selectedHour);
    minuteController = FixedExtentScrollController(initialItem: selectedMinute ~/ 5);

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(() {
      _refreshEstimatedColumnWidths();
    });
  }

  @override
  void dispose() {
    dayController.dispose();
    hourController.dispose();
    minuteController.dispose();

    PaintingBinding.instance.systemFonts.removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor = Directionality.of(context) == TextDirection.ltr ? 1 : -1;

    alignCenterLeft = textDirectionFactor == 1 ? Alignment.centerLeft : Alignment.centerRight;
    alignCenterRight = textDirectionFactor == 1 ? Alignment.centerRight : Alignment.centerLeft;

    _refreshEstimatedColumnWidths();
  }

  void _refreshEstimatedColumnWidths() {
    estimatedColumnWidths[_PickerColumnType.day.index] = DatePicker._getColumnWidth(
      _PickerColumnType.day,
      context,
    );
    estimatedColumnWidths[_PickerColumnType.hour.index] = DatePicker._getColumnWidth(
      _PickerColumnType.hour,
      context,
    );
    estimatedColumnWidths[_PickerColumnType.minute.index] = DatePicker._getColumnWidth(
      _PickerColumnType.minute,
      context,
    );
  }

  DateTime _getSelectedDateTime() {
    final DateTime today = DateTime.now();
    final DateTime selectedDate = today.add(Duration(days: selectedDayIndex));
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedHour,
      selectedMinute,
    );
  }

  Widget _buildDayPicker(
      double offAxisFraction,
      TransitionBuilder itemPositioningBuilder,
      Widget selectionOverlay,
      ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isDayPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isDayPickerScrolling = false;
          _pickerDidStopScrolling();
        }
        return false;
      },
      child: CupertinoPicker(
        scrollController: dayController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        magnification: _kMagnification,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedDayIndex = index;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(_getSelectedDateTime());
          }
        },
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(31, (int index) {
          final DateTime date = DateTime.now().add(Duration(days: index));
          final String displayText = '${date.day} ${_monthsName[date.month - 1]}';
          return itemPositioningBuilder(
            context,
            Text(
              displayText,
              style: _themeTextStyle(context, isValid: index <= 30),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHourPicker(
      double offAxisFraction,
      TransitionBuilder itemPositioningBuilder,
      Widget selectionOverlay,
      ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isHourPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isHourPickerScrolling = false;
          _pickerDidStopScrolling();
        }
        return false;
      },
      child: CupertinoPicker(
        scrollController: hourController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        magnification: _kMagnification,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedHour = index;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(_getSelectedDateTime());
          }
        },
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(24, (int index) {
          return itemPositioningBuilder(
            context,
            Text(
              index.toString().padLeft(2, '0'),
              style: _themeTextStyle(context, isValid: true),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMinutePicker(
      double offAxisFraction,
      TransitionBuilder itemPositioningBuilder,
      Widget selectionOverlay,
      ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isMinutePickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isMinutePickerScrolling = false;
          _pickerDidStopScrolling();
        }
        return false;
      },
      child: CupertinoPicker(
        scrollController: minuteController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        magnification: _kMagnification,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedMinute = index * 5;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(_getSelectedDateTime());
          }
        },
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(12, (int index) {
          final int minute = index * 5;
          return itemPositioningBuilder(
            context,
            Text(
              minute.toString().padLeft(2, '0'),
              style: _themeTextStyle(context, isValid: true),
            ),
          );
        }),
      ),
    );
  }

  bool get _isCurrentDateValid {
    final DateTime selectedDateTime = _getSelectedDateTime();
    final DateTime maxAllowedDate = DateTime.now().add(Duration(days: 30));
    return selectedDayIndex >= 0 &&
        selectedDayIndex <= 30 &&
        selectedHour >= 0 &&
        selectedHour <= 23 &&
        selectedMinute >= 0 &&
        selectedMinute <= 55 &&
        selectedMinute % 5 == 0 &&
        selectedDateTime.isAfter(widget.minimumDate.subtract(Duration(seconds: 1))) &&
        selectedDateTime.isBefore(maxAllowedDate.add(Duration(seconds: 1)));
  }

  void _pickerDidStopScrolling() {
    if (isScrolling) {
      return;
    }

    final DateTime selectedDateTime = _getSelectedDateTime();
    if (!_isCurrentDateValid) {
      // Clamp selections to valid ranges
      setState(() {
        final now = DateTime.now();
        final maxAllowedDate = now.add(Duration(days: 30));
        DateTime targetDate = selectedDateTime;

        if (selectedDateTime.isBefore(widget.minimumDate)) {
          targetDate = widget.minimumDate;
        } else if (selectedDateTime.isAfter(maxAllowedDate)) {
          targetDate = maxAllowedDate;
        }

        selectedDayIndex = targetDate.difference(DateTime(now.year, now.month, now.day)).inDays.clamp(0, 30);
        selectedHour = targetDate.hour.clamp(0, 23);
        selectedMinute = (targetDate.minute ~/ 5) * 5;
      });

      _scrollToDate(selectedDateTime);
    } else {
      // Ensure the callback is called with the current valid selection
      widget.onDateTimeChanged(selectedDateTime);
    }
  }

  void _scrollToDate(DateTime newDate) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      final now = DateTime.now();
      final dayIndex = newDate.difference(DateTime(now.year, now.month, now.day)).inDays;
      if (selectedDayIndex != dayIndex) {
        _animateColumnControllerToItem(dayController, dayIndex.clamp(0, 30));
      }
      if (selectedHour != newDate.hour) {
        _animateColumnControllerToItem(hourController, newDate.hour);
      }
      if (selectedMinute != newDate.minute) {
        _animateColumnControllerToItem(minuteController, (newDate.minute ~/ 5));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[];
    List<double> columnWidths = <double>[];

    pickerBuilders = <_ColumnBuilder>[
      _buildDayPicker,
      _buildHourPicker,
      _buildMinutePicker,
    ];
    columnWidths = <double>[
      estimatedColumnWidths[_PickerColumnType.day.index]!,
      estimatedColumnWidths[_PickerColumnType.hour.index]!,
      estimatedColumnWidths[_PickerColumnType.minute.index]!,
    ];

    final List<Widget> pickers = <Widget>[];

    for (int i = 0; i < columnWidths.length; i++) {
      final double offAxisFraction = (i - 1) * 0.3 * textDirectionFactor;

      EdgeInsets padding = const EdgeInsets.only(right: _kDatePickerPadSize);
      if (textDirectionFactor == -1) {
        padding = const EdgeInsets.only(left: _kDatePickerPadSize);
      }

      Widget selectionOverlay = _centerSelectionOverlay;
      if (i == 0) {
        selectionOverlay = _leftSelectionOverlay;
      } else if (i == columnWidths.length - 1) {
        selectionOverlay = _rightSelectionOverlay;
      }

      pickers.add(
        LayoutId(
          id: i,
          child: pickerBuilders[i](
            offAxisFraction,
                (BuildContext context, Widget? child) {
              return Container(
                alignment: i == columnWidths.length - 1 ? alignCenterLeft : alignCenterRight,
                padding: i == 0 ? null : padding,
                child: Container(
                  alignment: i == 0 ? alignCenterLeft : alignCenterRight,
                  width: columnWidths[i] + _kDatePickerPadSize,
                  child: child,
                ),
              );
            },
            selectionOverlay,
          ),
        ),
      );
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: DefaultTextStyle.merge(
        child: CustomMultiChildLayout(
          delegate: _DatePickerLayoutDelegate(
            columnWidths: columnWidths,
            textDirectionFactor: textDirectionFactor,
          ),
          children: pickers,
        ),
      ),
    );
  }
}