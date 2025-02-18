import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class Otpscreen extends StatefulWidget {
const Otpscreen({super.key, });

@override
State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
   int time =60;
   //late Timer timer;
  late int number=0;
  late String id='';
    String otp = '';
  bool isLoading = false;
  void starttimer(){
    const sec=const Duration(seconds: 1);
    // timer = new Timer.periodic(sec, (Timer timer){
    //   if(time==0){
    //     setState(() {
    //       timer.cancel();
    //     });
    //   }else{
    //     setState(() {
    //       time--;
    //     });
    //   }
    // });
  }
    @override
  void dispose() {
    //timer.cancel();
    super.dispose();
  }
  Future<void> sendSms() async {
    try {
      var regbody = {
        "phonenumber": number,
      };

      var res = await http.post(
        Uri.parse("http://192.168.1.3:3500/11/sendotp"),
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
 Future<void> fetchOtp() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://femina.onrender.com/11/fetchotp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          otp = data['otp'];
          isLoading = false;
        });

        // Check if entered OTP matches fetched OTP
        String enteredOtp = n1.text + n2.text + n3.text + n4.text;
        if (enteredOtp == otp) {
          // Navigate to InfoLogin screen
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => infologin(token: widget.token)),
          // );
        } else {
          // Handle OTP mismatch
          print('Entered OTP does not match');
        }

      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to fetch OTP');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      // Handle error
    }
  }
  @override
  void initState() {
    super.initState();
    //   Map<String,dynamic> jwtDecodedToken =JwtDecoder.decode(widget.token);
    // number=jwtDecodedToken['phonenumber'];
    // id=jwtDecodedToken['id'];
  }

  final key = GlobalKey<FormState>();
  final n1=TextEditingController();
  final n2=TextEditingController();
  final n3=TextEditingController();
  final n4=TextEditingController();

@override
Widget build(BuildContext context) {
return Scaffold(
body: LayoutBuilder(
builder: (context, constraints) {
var screenHeight = constraints.maxHeight;
var screenWidth = constraints.maxWidth;

return SingleChildScrollView(
child: ConstrainedBox(
constraints: BoxConstraints(
minHeight: screenHeight,
),
child: Column(
children: [
Stack(
children: [
Padding(
padding: EdgeInsets.only(top: screenHeight * 0.5),


),
Positioned.fill(
child: BackdropFilter(
filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
child: Container(
color: Colors.black.withOpacity(0),
),
),
),
SafeArea(
child: Padding(
padding: EdgeInsets.only(top: 30, left: 30),
child: Text(
"FEMINA",
style: GoogleFonts.karantina(
color: Color(0xFFBE1B7D),
fontWeight: FontWeight.bold,
fontSize: 40,
),
),
),
),
Positioned(
top: screenHeight * 0.19,
left: screenWidth * 0.1,
right: screenWidth * 0.1,
child: Text("Veuillez entrer le code à 4 chiffres envoyé à $number ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
Positioned(
        top: screenHeight * 0.3,
  left: screenWidth * 0.1,
  right: screenWidth * 0.1,
  child: Form(
    key: key,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
      children: [
       Container(
        width: 50,height: 50,
        decoration: BoxDecoration(color: Color.fromARGB(43, 79, 73, 77),borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          controller: n1,
          onSaved: (pin1){},
          onChanged: (value){
            if (value.length==1) {
              FocusScope.of(context).nextFocus();
            }
          },
        style: Theme.of(context).textTheme.headlineMedium,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
       ),),
              Padding(
                padding: EdgeInsets.all(7),
                child: Container(
                        width: 50,height: 50,
                        decoration: BoxDecoration(color: Color.fromARGB(43, 79, 73, 77),borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          controller: n2,
                          onSaved: (pin1){},
                          onChanged: (value){
                            if (value.length==1) {
                FocusScope.of(context).nextFocus();
                            }
                          },
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                       ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                        width: 50,height: 50,
                        decoration: BoxDecoration(color: Color.fromARGB(43, 79, 73, 77),borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          controller: n3,
                          onSaved: (pin1){},
                          onChanged: (value){
                            if (value.length==1) {
                FocusScope.of(context).nextFocus();
                            }
                          },
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                       ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                        width: 50,height: 50,
                        decoration: BoxDecoration(color: Color.fromARGB(43, 79, 73, 77),borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          controller: n4,
                          onSaved: (pin1){},
                          onChanged: (value){
                            if (value.length==1) {
                FocusScope.of(context).nextFocus();
                            }
                          },
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                       ),),
              ),
   
       
      

      

      

      
  

         
        ],),
    )),
),
Positioned(
          top: screenHeight * 0.39,
  left: screenWidth * 0.09,
  child: TextButton(onPressed: (){
    sendSms();
  }, child: Text("Je n’ai pas reçu le code"))),
  Positioned(
              top: screenHeight * 0.5,
  left: screenWidth * 0.09,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFBE1B7D)
      ),
      onPressed: (){
        Navigator.pop(context);
      }, label: Icon(Icons.arrow_back,color: Colors.white,)
      
      ),
  ),
    Positioned(
              top: screenHeight * 0.5,
  right: screenWidth * 0.09,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFBE1B7D)
      ),
      onPressed: (){
fetchOtp();

      }, child: Text("Continue",style: TextStyle(color: Colors.white),)
      
      ),
  ),
],
),
],
),
),
);
},
),
);
}
}
