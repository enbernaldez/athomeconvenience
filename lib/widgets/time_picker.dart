import 'package:flutter/material.dart';

// ==========Time Picker==========
TimeOfDay? selectedTimeST; //*
TimeOfDay? selectedTimeET; //*
TimePickerEntryMode entryMode = TimePickerEntryMode.dialOnly;
TextDirection textDirection = TextDirection.ltr;
MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
Orientation orientation = Orientation.portrait;
bool use24HourTime = false;
String startTime = '';
String buttonTextST = 'Start Time';
String buttonTextET = 'End Time';
//================================

Future<TimeOfDay?> showTimePickerFunction(
  BuildContext context,
  TimeOfDay? initialTime,
) async {
  return await showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
    initialEntryMode: entryMode,
    orientation: orientation,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          materialTapTargetSize: tapTargetSize,
        ),
        child: Directionality(
          textDirection: textDirection,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: use24HourTime,
            ),
            child: child!,
          ),
        ),
      );
    },
  );
}
