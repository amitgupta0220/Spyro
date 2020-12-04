import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as u;
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../Animations/fade.dart';
import '../Styles.dart';
import '../services/authentication.dart';
import '../services/database.dart';
import '../widgets/DailogBox.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  // bool _autovalidate = false;
  bool _codeSent = false;
  bool hasError = false;
  TextEditingController verCodeController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  String _email, _password, _phone, _smsCode, _type;
  u.AuthCredential _creds;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    _email = data['email'];
    _password = data['password'];
    _type = data['type'];
    _creds = data['creds'];
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        body: SingleChildScrollView(
            child: FadeAnimation(
          delay: 1,
          child: Container(
            margin: const EdgeInsets.only(top: 150),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image(
                      image: AssetImage('images/otp.png'),
                      fit: BoxFit.contain,
                      height: 100,
                      width: 100),
                  SizedBox(height: 20),
                  FittedBox(
                    child: Text('Phone Verification',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: MyColors.secondary)),
                  ),
                  SizedBox(height: 20),
                  _codeSent
                      ? RichText(
                          text: TextSpan(
                            text:
                                'Please enter 6-digit Verification code\n sent to: ',
                            style: TextStyle(
                                fontSize: 18, color: MyColors.primary),
                            children: [
                              TextSpan(
                                  text: '+91$_phone',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).accentColor,
                                  ))
                            ],
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          'Please enter 10-digit Phone number.\nWe will send you an OTP for verification',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                  SizedBox(height: 20),
                  _codeSent
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            PinCodeTextField(
                              appContext: context,
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeColor: MyColors.primary,
                                  activeFillColor: MyColors.primaryLight,
                                  selectedColor: MyColors.primary,
                                  selectedFillColor: MyColors.primary,
                                  inactiveColor: MyColors.primary,
                                  inactiveFillColor: MyColors.primaryLight),
                              animationDuration: Duration(milliseconds: 300),
                              backgroundColor: MyColors.primaryLight,
                              autoDismissKeyboard: true,
                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: verCodeController,
                              onChanged: (code) {
                                if (code.isNotEmpty) {
                                  setState(() => hasError = false);
                                }
                                _smsCode = code;
                              },
                              onCompleted: (code) => _smsCode = code,
                              onSubmitted: (code) async {
                                if (code.isEmpty)
                                  setState(() => hasError = true);
                                else if (code.length < 6)
                                  setState(() => hasError = true);
                                else
                                  await signInwithOTP(_verificationID, _smsCode,
                                      _phone, _email);
                              },
                            ),
                            Text(
                              hasError
                                  ? "*Please fill up all the cells properly"
                                  : "",
                              style: TextStyle(
                                  color: Colors.red.shade300, fontSize: 15),
                            ),
                          ],
                        )
                      : Form(
                          key: _formkey,
                          // autovalidate: _autovalidate,
                          child: TextFormField(
                            autocorrect: false,
                            enabled: !_isLoading,
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Enter Phone Number';
                              else if (value.trim().length != 10)
                                return 'Phone number must have 10-digits only';
                              else
                                return null;
                            },
                            onChanged: (value) => _phone = value.trim(),
                            onSaved: (value) => _phone = value.trim(),
                            decoration: InputDecoration(
                                hintText: 'Phone Number',
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: MyColors.primary,
                                )),
                          ),
                        ),
                  SizedBox(height: 30),
                  _isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          onPressed: () async {
                            // if (_formkey.currentState.validate()) {
                            if (true) {
                              // _formkey.currentState.save();
                              FocusScope.of(context).unfocus();
                              setState(() => _isLoading = true);
                              print(_phone);
                              bool exists = await DatabaseService()
                                  .checkPhoneExists(_phone);
                              if (!exists) {
                                if (_codeSent) {
                                  if (_smsCode.isEmpty)
                                    setState(() => hasError = true);
                                  else if (_smsCode.length < 6)
                                    setState(() => hasError = true);
                                  else
                                    await signInwithOTP(_verificationID,
                                        _smsCode, _phone, _email);
                                } else
                                  await sendOTP();
                              } else {
                                setState(() => _isLoading = false);
                                showDialog(
                                    context: context,
                                    builder: (_) => DialogBox(
                                        title: 'Error :(',
                                        description:
                                            "This phone number is already registered with another user",
                                        buttonText1: 'Ok',
                                        button1Func: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        }));
                              }
                            }
                            // else
                            // setState(() => _autovalidate = true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Text(_codeSent ? 'Verify' : 'Send',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Raleway',
                                    letterSpacing: 2)),
                          ),
                          color: MyColors.primary,
                          textColor: MyColors.primaryLight,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                  SizedBox(height: 10),
                  _isLoading
                      ? Text("Sending OTP...",
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor))
                      : FlatButton(
                          onPressed: () => onBackPressed(context),
                          child: Text("Back",
                              style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).accentColor)
                                  .copyWith(letterSpacing: 2)),
                        )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  String _verificationID;

  Future<void> sendOTP() async {
    AuthService authService = AuthService();
    await authService.phoneVerification(
        phone: _phone,
        verificationCompleted: (u.AuthCredential creds) async {
          u.User user = await authService.credentialSignIn(creds);
          DatabaseService().verifyPhone(_email, _phone);
          authService.deleteUser(user);
          showSuccess(context, _email, _password, _creds);
        },
        verificationFailed: (e) {
          print(e.code + "\n" + e.message);
          showFail(context);
        },
        codeSent: (verID, [int forceResend]) async {
          print('code sent');
          setState(() {
            _isLoading = false;
            _codeSent = true;
            _verificationID = verID;
          });
        },
        codeAutoRetrievalTimeout: (verID) => {});
  }

  Future<void> signInwithOTP(
      String verID, String smsCode, String phone, String email) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Center(child: CircularProgressIndicator()));
    u.AuthCredential creds =
        u.PhoneAuthProvider.credential(verificationId: verID, smsCode: smsCode);
    try {
      u.User user = await AuthService().credentialSignIn(creds);
      DatabaseService().verifyPhone(email, phone);
      AuthService().deleteUser(user);
      Navigator.of(context, rootNavigator: true).pop();
      showSuccess(context, email, _password, _creds);
    } catch (e) {
      print(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      showFail(context);
    }
  }

  void showSuccess(BuildContext context, String email, String password,
      u.AuthCredential creds) async {
    showDialog(
        builder: (ctx) => DialogBox(
            title: "Verification",
            description: "Phone Verification Successful",
            icon: Icons.check,
            iconColor: Colors.teal,
            buttonText1: null,
            button1Func: () {}),
        context: context);
    await Future.delayed(Duration(seconds: 2));
    final auth = u.FirebaseAuth.instance;
    final user = _type == 'email'
        ? (await auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user
        : (await auth.signInWithCredential(creds)).user;
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushReplacementNamed(context, '/main', arguments: user);
  }

  void showFail(BuildContext context) {
    showDialog(
        builder: (ctx) => DialogBox(
            title: "Error :(",
            description: "Phone Verification Failed",
            icon: Icons.clear,
            iconColor: Colors.red,
            buttonText1: "OK",
            button1Func: () =>
                Navigator.of(context, rootNavigator: true).pop()),
        context: context);
  }

  Future<bool> onBackPressed(BuildContext context) async {
    final user = await AuthService().getCurrentUser();
    user == null
        ? Navigator.pushReplacementNamed(context, '/auth')
        : Navigator.pushReplacementNamed(context, '/main', arguments: user);
    return Future.value(true);
  }
}
