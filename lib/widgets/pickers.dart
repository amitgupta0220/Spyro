import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';

import '../Styles.dart';

class Pickers {
  DateTime _pickedDate;
  TimeOfDay _pickedTime;

  Future<DateTime> presentTimePicker(BuildContext ctx, DateTime time) async {
    _pickedTime = await showTimePicker(
      context: ctx,
      initialTime: time == null
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(time),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: MyColors.primary,
            accentColor: MyColors.secondary,
            scaffoldBackgroundColor: MyColors.primaryLight,
            colorScheme: ColorScheme.light(primary: MyColors.primary),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    return DateTimeField.convert(_pickedTime);
  }
}
