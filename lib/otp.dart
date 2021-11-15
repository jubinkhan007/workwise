import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:workwise/rounded_button.dart';
import 'constants.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class otp extends StatefulWidget {
  final String verificationId;
  const otp(String this.verificationId, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState(){
  return _otpState(this.verificationId);
}
}

class _otpState extends State<otp> {
  //inal otpController = TextEditingController();
  final otpController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String verificationId;
  _otpState(this.verificationId);
  bool showLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    key: _scaffoldKey;
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
            inAsyncCall: false,
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
    child: Column(
    children: <Widget>[
    Expanded(
    child: SingleChildScrollView(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[


    //Image.asset('assets/images/logo.png'),
    TextField(
        controller: otpController,
    keyboardType: TextInputType.emailAddress,
    textAlign: TextAlign.center,
    decoration: InputDecoration(
        hintText: 'Enter your OTP')),
      SizedBox(
      height: 8.0,
      ),
      RoundedButton(
        colour: Colors.blueAccent,
        title: 'Register',
        onPressed: () async {
          setState(() {
            showSpinner = true;
          });
          PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: otpController.text);

          signInWithPhoneAuthCredential(phoneAuthCredential);
          try {
              Navigator.pushNamed(context, 'home_screen');
          } catch (e) {
            showAlertDialog(BuildContext context) {

              // set up the button
              Widget okButton = TextButton(
                child: Text("OK"),
                onPressed: () { },
              );

              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text("Error"),
                content: Text("$e"),
                actions: [
                  okButton,
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            }
            showAlertDialog(context);
          }
          setState(() {
            showSpinner = false;
          });
        },
      )
    ],
    ),
    ),
    ),
    ],
    )
        )
        )
    );
  }
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if(authCredential?.user != null){

        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState
          ?.showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }
}
