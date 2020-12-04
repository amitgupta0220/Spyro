import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smackit/Styles.dart';

class EnterOTP extends StatefulWidget {
  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  TextEditingController textEditingController = TextEditingController();
  // StreamController<ErrorAnimationType> errorController;
  String currentText = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.11,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () => {Navigator.of(context).pop()},
            child: Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.03),
                child: SvgPicture.asset('assets/images/arrow.svg'))),
      ),
      backgroundColor: MyColors.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.16),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('OTP',
                      style: TextStyle(color: Color(0xff1c1c1c), fontSize: 22)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    'Please enter the code we just sent to\n your phone to proceed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xff858585)),
                  ),
                  SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
                      child: PinCodeTextField(
                        textStyle: TextStyle(fontFamily: 'Lato'),
                        appContext: context,
                        pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato'),
                        length: 6,
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if (v.length < 6) {
                            return "Enter all Digits properly";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          inactiveColor: Color(0xffc5c5c5),
                          selectedColor: MyColors.secondary,
                          shape: PinCodeFieldShape.underline,
                          fieldHeight: 50,
                          fieldWidth: 40,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        // backgroundColor: Colors.blue.shade50,
                        // enableActiveFill: true,
                        autoDismissKeyboard: true,
                        // errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        onCompleted: (v) {
                          // print("Done");
                        },
                        // onTap: () {
                        // },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          return true;
                        },
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    decoration: BoxDecoration(
                        color: MyColors.bg,
                        borderRadius: BorderRadius.circular(4)),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Center(
                      child: Text("Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.085,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn’t receive OTP?',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff858585)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        child: Text(
                          'Resend',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: MyColors.bg),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.075,
                  ),
                  Text(
                    'Having trouble logging in?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xffc5c5c5)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
