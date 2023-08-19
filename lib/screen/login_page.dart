import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:intl/intl.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/components/login_page_elements.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/screen/first_page.dart';
import 'package:restaurant_app/screen/organisation_screen.dart';
import 'package:restaurant_app/screen/owner_dash.dart';
import 'package:restaurant_app/screen/sequence_manager.dart';
import 'package:restaurant_app/screen/splash_screen.dart';
import 'package:restaurant_app/screen/waiter_screen.dart';
import 'pos_screen.dart';
import 'package:restaurant_app/components/rounded_button.dart';
import 'new_dashBoard.dart';



String currentUser;
String currentDiscount;
String currentPriceEdit;
String currentWarehouse;
String currentBranch;
String currentTerminal;
String currentBusiness;
String currentPrinter;
String currentPrinterName;
double widthOf;
String tillCloseDate;
int tillCloseTime;
String userNam;
String userSalesPrefix='';
int dateNowDash;
DateTime beginDate;
class LoginScreen extends StatefulWidget {
    static const String id = 'login_screen';
    @override
    _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    loginfail(BuildContext context) {
        AlertDialog alert = AlertDialog(
            title: Text("Error"),
            content: Text("Wrong email/password"),
            actions: [
                GestureDetector(
                    onTap: (){
                        setState(() {
                            Navigator.pop(context);
                        });
                    },
                    child: Text('OK'))
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
    TextEditingController loginPasswordController=TextEditingController();
    // String dateNow(){
    //     final now = DateTime.now();
    //     final formatter = DateFormat('MM/dd/yyyy H:m');
    //     final String timestamp = formatter.format(now);
    //     return timestamp;
    // }
    bool showSpinner = false;
//  final _auth = FirebaseAuth.instance;
    String email;
    String password;

    @override
    void initState()   {
        password = '';
        email='';
        // TODO: implement initState
        //userList.isEmpty?check='empty':check='not';
        //  read('modifier_data');

        // read('warehouse');
        // read('main_paymentList');
        getSequenceData();
        var s=DateTime.now();
        orgClosedHour=orgClosedHour==''?'0':orgClosedHour;
        if(int.parse(s.hour.toString())>=int.parse(orgClosedHour)){
            String a=s.toString().substring(0,10);
            beginDate=DateTime.parse('$a 0$orgClosedHour:00:00');
            dateNowDash=beginDate.millisecondsSinceEpoch;
        }
        else{
            var s=  DateTime.now().subtract(Duration(days:1));
            String a=s.toString().substring(0,10);
            beginDate=DateTime.parse('$a 0$orgClosedHour:00:00');
            dateNowDash=beginDate.millisecondsSinceEpoch;
        }

         // SunmiPrinter.bindingPrinter();
        super.initState();
        //connectPostgres();
        //database('RestaurantData');
        // getData('companyDetails');
        // getData('category_data');
        // getData('product_data');
        // getData('modifier_data');
        //getTotalSales('invoice_data', dateNow());
    }

    @override
    Widget build(BuildContext context) {
        String userName='',password='',prefix='';
        Orientation orientation=MediaQuery.of(context).orientation;
        widthOf=orientation==Orientation.portrait?MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.width/4;

        return SafeArea(
            child:Scaffold(
                backgroundColor: Colors.white,
                body: ModalProgressHUD(
                    inAsyncCall: showSpinner,
                    child: Center(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Flex(
                                    direction: Axis.vertical,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        GestureDetector(
                                            onTap: ()async{
                                                // await read('customer_details');
                                                // for(int i =0;i<customerList.length;i++){
                                                //     firebaseFirestore.collection('customer_report').doc(customerList[i].toString().trim()).set({
                                                //         "data":[],
                                                //         "name":customerList[i].toString().trim(),
                                                //     }).then((_) {
                                                //     });
                                                // }



                                            },
                                          child: Container(
                                              height: MediaQuery.of(context).size.height/7,
                                              width:  200,
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
                                        Container(
                                            width: widthOf,
                                            child: TextField(
                                                keyboardType: TextInputType.emailAddress,
                                                textAlign: TextAlign.center,
                                                onChanged: (value) {
                                                    email = value;
                                                },
                                                decoration:
                                                kTextFileDecoration.copyWith(hintText: 'Username'),
                                            ),
                                        ),
                                        SizedBox(
                                            height: 8.0,
                                        ),
                                        Container(
                                            width:  widthOf,
                                            child: TextField(
                                                controller: loginPasswordController,
                                                obscureText: true,
                                                textAlign: TextAlign.center,
                                                onChanged: (value) {
                                                    password = value;
                                                },
                                                decoration: kTextFileDecoration.copyWith(
                                                    hintText: 'Password')),
                                        ),

                                        SizedBox(
                                            height: 24.0,
                                        ),
                                        RoundedButton(
                                            color: kGreenColor,
                                            title: 'Log In',
                                            onPressed: () async {
                                                await init();
                                                try {

                                                    var response = await client.post(
                                                        "/api/method/login",
                                                        data: {
                                                            "usr": "${email.toString().trim()}",
                                                            "pwd": "${loginPasswordController.text.toString().trim()}"
                                                        },
                                                    );

                                                        Navigator.pushReplacementNamed(context, SplashScreen.id);

                                                }
                                                catch(Exception){
                                                    loginfail(context);

                                                }



                                               // userList=[];
                                               //
                                               //  var url = Uri.https('${link.toString().trim()}', '/api/resource/User',
                                               //      {"fields": '["*"]'});
                                               //  var response =
                                               // await  http.get(url, headers: {'Authorization': "token $tokengeneral:$secretgeneral"});
                                               //  dynamic data = jsonDecode(response.body);
                                               //
                                               //
                                               //
                                               //
                                               //  for(int i = 0;i<data["data"].length;i++){
                                               //    userList.add(data["data"][i]["username"]);
                                               //
                                               //  }



                                                 // if(userList.isNotEmpty&&userList.contains(email.toString().trim())) {


                                                 // }
                                                 // else {
                                                 //     showDialog(
                                                 //         context: context,
                                                 //         builder: (
                                                 //             BuildContext context) {
                                                 //             return AlertDialog(
                                                 //                 title: Text(
                                                 //                     'Invalid '),
                                                 //             );
                                                 //         }
                                                 //
                                                 //     );
                                                 // }
                                            })
                                    ],
                                ),
                            ),
                        ),
                    ),
                ),
            ));
    }
}
