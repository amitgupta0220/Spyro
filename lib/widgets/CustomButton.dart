import 'package:flutter/material.dart';

import '../Styles.dart';

class MyButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function action;
  final Color buttonColor, textColor, iconColor;
  const MyButton(
      {this.text,
      this.textColor,
      this.buttonColor,
      this.action,
      this.icon,
      this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RaisedButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (icon != null) _icon(),
                  if (text != null)
                    Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Raleway',
                            letterSpacing: 2)),
                ],
              ),
            ),
          ),
          textColor: textColor ?? Colors.black,
          color: buttonColor ?? Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: action),
    );
  }

  Widget _icon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: iconColor ?? Colors.white),
        SizedBox(width: 5),
      ],
    );
  }
}

class SmallButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color textColor, btnColor, iconColor;
  final Function() action;
  SmallButton(
      {Key key,
      @required this.text,
      @required this.action,
      this.icon,
      this.textColor,
      this.btnColor,
      this.iconColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: action,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(text,
                style: TextStyle(
                    fontSize: 20, fontFamily: 'Raleway', letterSpacing: 2)),
            if (icon != null) SizedBox(width: 10),
            if (icon != null)
              Icon(icon, color: iconColor ?? MyColors.primaryLight)
          ],
        ),
      ),
      textColor: textColor ?? MyColors.primaryLight,
      color: btnColor ?? MyColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
