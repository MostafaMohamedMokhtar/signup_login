import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/config/config.dart';
import 'package:firebase_login/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneSignInScreen extends StatefulWidget {
  @override
  _PhoneSignInScreenState createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {

  final _codeController = TextEditingController();
  PhoneNumber _phoneNumber ;
  String phoneNumber, verificationId;
  String otp, authStatus = "";

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
         /* _auth.signInWithCredential(authCredential)
              .then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => StartPage(),
            )) ;
          })
          .catchError((e){
            print(e);
          });*/

        });
      },
      verificationFailed: (FirebaseAuthException authException) {
        setState(() {
          authStatus = "Authentication failed";
        });
      },
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
        });
        otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
    );
  } // end verifyPhoneNumber()
  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otp = value;
                },
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  signIn(otp);
                },
                child: Text(
                  'Submit',
                ),
              ),
            ],
          );
        });
  } // end otpDialogBox()
  Future<void> signIn(String otp) async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: otp,
    ));
    print('successful Login');
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => StartPage(),
    )) ;
  } // end signIn()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('phone Sign In  '),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                "Phone Auth demo📱",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image(
                image: AssetImage('assets/phoneSignin.png'),
                height: 150,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                child: InternationalPhoneNumberInput(
                  textStyle: TextStyle(fontWeight: FontWeight.bold , fontSize: 18 ,color: primaryColor),
                  inputDecoration: InputDecoration(
                   // icon: Icon(Icons.phone_android )
                    suffixIcon: Icon(Icons.phone_android , color: Colors.lightBlue,),
                  ),
                   /*initialValue: PhoneNumber(
                    isoCode: '+20',
                    dialCode: '+20',
                    phoneNumber: '1112139832'
                  ),*/
                 countries: ['EG','KW' , 'IN' , 'US' , 'FR' , 'IT'],
                 // inputBorder: OutlineInputBorder(),
                  autoFocus: true,

                  onInputChanged: (phoneNumberTXT){
                    setState(() {
                      phoneNumber = phoneNumberTXT.toString() ;
                    });
                  },

                ),
              ),
            /*  Container(
                margin: EdgeInsets.only(left: 20 , right: 20 , top: 30 ,bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: 'Write the code',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8) ,
                    ) ,
                  )
                ),
              ),*/
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  verifyPhoneNumber(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 20 , horizontal: 30),
                  padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 30),
                  child: Center(child: Text('Generate OTP' , style: TextStyle(fontSize: 18 , color: Colors.white),) ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [primaryColor , secondaryColor]
                    ) ,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Need Help?"),

            ],
          ),
        ),
      ),
    );
  }
}
