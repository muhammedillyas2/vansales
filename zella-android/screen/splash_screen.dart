import 'package:flutter/material.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/screen/organisation_screen.dart';
import 'login_page.dart';
class SplashScreen extends StatefulWidget {
  static const String id = 'splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
  //  connectPostgres(context);
    read('user_data');
    read('category_data');
    read('product_data');
    read('organisation');
    read('customer_details');
    read('vendor_data');
    read('tax_data');
    read('uom_data');
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child:  Container(
            height: MediaQuery.of(context).size.height/5,
            width:  300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/dot_order.png'),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.rectangle,
            ),
          ),

      ),
    );
  }
}
