import 'package:flutter/material.dart';
import 'login_screen_widgets.dart';
class LoginScreen extends StatefulWidget {
  static const String id='login_screen';
  // const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
child: SizedBox(
  height: 100,
  width: double.infinity,
  child:   Row(
    children: [
      Expanded(
    child:   Container(
      decoration: const BoxDecoration(
        color: Colors.red,
        image: DecorationImage(image: AssetImage('images/logo.png'))
      ),
    ),
  ),
      Expanded(
        child:   Container(
          color: Colors.black,
          child:numericKeypad(context),
        ),
      ),
    ],
  ),
),
      ),
    );
  }


}
