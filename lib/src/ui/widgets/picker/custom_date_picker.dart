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
    color: AppTheme.orange,
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
  dayOfMonth,
  month,
  year,
}

class DatePicker extends StatefulWidget {
  const DatePicker({super.key,
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
      case _PickerColumnType.dayOfMonth:
        for (int i = 1; i <= 31; i++) {
          final String dayOfMonth = i.toString();
          if (longestText.length < dayOfMonth.length) longestText = dayOfMonth;
        }
        break;
      case _PickerColumnType.month:
        for (int i = 1; i <= 12; i++) {
          final String month = _monthsName[i - 1];
          if (longestText.length < month.length) longestText = month;
        }
        break;
      case _PickerColumnType.year:
        longestText = " 2018 ";
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

typedef _ColumnBuilder = Widget Function(double offAxisFraction,
    TransitionBuilder itemPositioningBuilder, Widget selectionOverlay);

class _CupertinoDatePickerDateState extends State<DatePicker> {
  late int textDirectionFactor;
  late Alignment alignCenterLeft;
  late Alignment alignCenterRight;
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  bool isDayPickerScrolling = false;
  bool isMonthPickerScrolling = false;
  bool isYearPickerScrolling = false;

  bool get isScrolling =>
      isDayPickerScrolling || isMonthPickerScrolling || isYearPickerScrolling;
  Map<int, double> estimatedColumnWidths = <int, double>{};

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDateTime.day;
    selectedMonth = widget.initialDateTime.month;
    selectedYear = widget.initialDateTime.year;

    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController = FixedExtentScrollController(initialItem: selectedYear);

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
    monthController.dispose();
    yearController.dispose();

    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor =
    Directionality.of(context) == TextDirection.ltr ? 1 : -1;

    alignCenterLeft =
    textDirectionFactor == 1 ? Alignment.centerLeft : Alignment.centerRight;
    alignCenterRight =
    textDirectionFactor == 1 ? Alignment.centerRight : Alignment.centerLeft;

    _refreshEstimatedColumnWidths();
  }

  void _refreshEstimatedColumnWidths() {
    estimatedColumnWidths[_PickerColumnType.dayOfMonth.index] =
        DatePicker._getColumnWidth(
          _PickerColumnType.dayOfMonth,
          context,
        );
    estimatedColumnWidths[_PickerColumnType.month.index] =
        DatePicker._getColumnWidth(
          _PickerColumnType.month,
          context,
        );
    estimatedColumnWidths[_PickerColumnType.year.index] =
        DatePicker._getColumnWidth(
          _PickerColumnType.year,
          context,
        );
  }

  DateTime _lastDayInMonth(int year, int month) => DateTime(year, month + 1, 0);

  Widget _buildDayPicker(
      double offAxisFraction,
      TransitionBuilder itemPositioningBuilder,
      Widget selectionOverlay,
      ) {
    final int daysInCurrentMonth =
        _lastDayInMonth(selectedYear, selectedMonth).day;
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
          selectedDay = index + 1;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        looping: true,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(31, (int index) {
          final int day = index + 1;
          return itemPositioningBuilder(
            context,
            Text(
              day.toString(),
              style:
              _themeTextStyle(context, isValid: day <= daysInCurrentMonth),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMonthPicker(
      double offAxisFraction,
      TransitionBuilder itemPositioningBuilder,
      Widget selectionOverlay,
      ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isMonthPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isMonthPickerScrolling = false;
          _pickerDidStopScrolling();
        }
        return false;
      },
      child: CupertinoPicker(
        scrollController: monthController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        magnification: _kMagnification,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedMonth = index + 1;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(
              DateTime(selectedYear, selectedMonth, selectedDay),
            );
          }
        },
        looping: true,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(12, (int index) {
          final int month = index + 1;
          final bool isInvalidMonth =
              (widget.minimumDate.year == selectedYear &&
                  widget.minimumDate.month > month) ||
                  (widget.maximumDate.year == selectedYear &&
                      widget.maximumDate.month < month);

          return itemPositioningBuilder(
            context,
            Text(
              _monthsName[month - 1],
              style: _themeTextStyle(
                context,
                isValid: !isInvalidMonth,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildYearPicker(
      double offAxisFraction,
      TransitionBuilder itemPositioningBuilder,
      Widget selectionOverlay,
      ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isYearPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isYearPickerScrolling = false;
          _pickerDidStopScrolling();
        }
        return false;
      },
      child: CupertinoPicker.builder(
        scrollController: yearController,
        itemExtent: _kItemExtent,
        offAxisFraction: offAxisFraction,
        squeeze: _kSqueeze,
        magnification: _kMagnification,
        onSelectedItemChanged: (int index) {
          selectedYear = index;
          if (_isCurrentDateValid) {
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        itemBuilder: (BuildContext context, int year) {
          if (year < widget.minimumDate.year) return null;

          if (year > widget.maximumDate.year) return null;

          final bool isValidYear = (widget.minimumDate.year <= year &&
              widget.maximumDate.year >= year);

          return itemPositioningBuilder(
            context,
            Text(
              year.toString(),
              style: _themeTextStyle(context, isValid: isValidYear),
            ),
          );
        },
        selectionOverlay: selectionOverlay,
      ),
    );
  }

  bool get _isCurrentDateValid {
    final DateTime minSelectedDate =
    DateTime(selectedYear, selectedMonth, selectedDay);
    final DateTime maxSelectedDate =
    DateTime(selectedYear, selectedMonth, selectedDay + 1);

    final bool minCheck = widget.minimumDate.isBefore(maxSelectedDate);
    final bool maxCheck = widget.maximumDate.isBefore(minSelectedDate);

    return minCheck && !maxCheck && minSelectedDate.day == selectedDay;
  }

  void _pickerDidStopScrolling() {
    setState(() {});
    if (isScrolling) {
      return;
    }

    final DateTime minSelectDate =
    DateTime(selectedYear, selectedMonth, selectedDay);
    final DateTime maxSelectDate =
    DateTime(selectedYear, selectedMonth, selectedDay + 1);

    final bool minCheck = widget.minimumDate.isBefore(maxSelectDate);
    final bool maxCheck = widget.maximumDate.isBefore(minSelectDate);

    if (!minCheck || maxCheck) {
      final DateTime targetDate =
      minCheck ? widget.maximumDate : widget.minimumDate;
      _scrollToDate(targetDate);
      return;
    }

    if (minSelectDate.day != selectedDay) {
      final DateTime lastDay = _lastDayInMonth(selectedYear, selectedMonth);
      _scrollToDate(lastDay);
    }
  }

  void _scrollToDate(DateTime newDate) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (selectedYear != newDate.year) {
        _animateColumnControllerToItem(yearController, newDate.year);
      }

      if (selectedMonth != newDate.month) {
        _animateColumnControllerToItem(monthController, newDate.month - 1);
      }

      if (selectedDay != newDate.day) {
        _animateColumnControllerToItem(dayController, newDate.day - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[];
    List<double> columnWidths = <double>[];

    pickerBuilders = <_ColumnBuilder>[
      _buildDayPicker,
      _buildMonthPicker,
      _buildYearPicker
    ];
    columnWidths = <double>[
      estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
      estimatedColumnWidths[_PickerColumnType.month.index]!,
      estimatedColumnWidths[_PickerColumnType.year.index]!,
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
                alignment: i == columnWidths.length - 1
                    ? alignCenterLeft
                    : alignCenterRight,
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
