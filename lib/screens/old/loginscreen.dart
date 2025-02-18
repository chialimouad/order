import 'dart:convert';
import 'dart:ui';
import 'package:femina/screens/old/otp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart'as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class sendrequest extends ChangeNotifier {
  
    bool iscon=false;
    sendr(bool iscon)  {
     
        this.iscon=iscon;
   
  }
}
class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  late SharedPreferences prefs;
bool trick=false;
@override
  void initState() {
initshared();
    super.initState();
      
  }
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'DZ';
  PhoneNumber number = PhoneNumber(isoCode: 'DZ');
 initshared() async {
    bool ==false? prefs = await SharedPreferences.getInstance():Container();
  }

  
  Future<void> loginuser() async {

try {


var regbody = {
        "phonenumber": number.phoneNumber,
      
};

var res = await http.post(
Uri.parse("https://femina.onrender.com/11/registeruser"),
headers: {"Content-Type": "application/json"},
body: jsonEncode(regbody),
);

var resjson = jsonDecode(res.body);
  var mytoken = resjson['token'];

if (resjson['status']) {
print(mytoken);
await prefs.setString('token', mytoken);
// Navigator.push(
// context,
// MaterialPageRoute(builder: ((context) => Otpscreen(token: mytoken,))),
// );
 await  sendSms();

} else {

}

} catch (e) {
}

}




  Future<void> sendSms() async {
    try {
      var regbody = {
        "phonenumber": number.phoneNumber,
      };

      var res = await http.post(
        Uri.parse("https://femina.onrender.com/11/sendotp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regbody),
      );

      var resjson = jsonDecode(res.body);

      if (res.statusCode == 200 && resjson['status']) {
        print("SMS sent successfully");
      } else {
        print("Failed to send SMS: ${resjson['message']}");
      }
    } catch (e) {
      print("Error during SMS sending: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
   trick= Provider.of<sendrequest>(context, listen: false).iscon;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
                          color: const Color.fromARGB(255, 2, 36, 63),

          child: Column(
            children: [
              // Header section with background image and blurred effect
              Container(
                width: screenWidth,
                height: 500,
                child: Stack(
                  children: [
                   
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.black.withOpacity(0),
                        ),
                      ),
                    ),
                   
                  ],
                ),
              ),
              // Main content section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "1. Écrivez votre numéro de téléphone",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: InternationalPhoneNumberInput(
                      
                        onInputChanged: (PhoneNumber number1) {
number=number1;                        
},
                        onInputValidated: (bool isValid) {
                          print(isValid ? "Valid" : "Invalid");
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DROPDOWN,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: number,
                        textFieldController: controller,
                        formatInput: false,
                        inputDecoration: InputDecoration(
                          hintText: 'Enter phone number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: false,
                        ),
                        inputBorder: OutlineInputBorder(),
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFBE1B7D),
                        ),
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                         loginuser();
                          }
                        },
                        child: Text(
                          "Continue",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            "En fournissant votre numéro de téléphone, vous consentez à nos ",
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: "modalités",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
