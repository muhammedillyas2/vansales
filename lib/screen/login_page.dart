import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

                                        SizedBox(
                                            height: 24.0,
                                        ),
                                        RoundedButton(
                                            color: kGreenColor,
                                            title: 'Log In',
                                            onPressed: () async {


                                                await read('user_data');
                                               // passwordList=[];
                                               // userList=[];
                                               //  String token = "afadbeecb20dfb7";
                                               //  String secret = "30bef8338f7a5e8";
                                               //  var url = Uri.https('sandf.dm.dot1.dotorders.com', '/api/resource/User',
                                               //      {"fields": '["*"]'});
                                               //  var response =
                                               //  await http.get(url, headers: {'Authorization': "token $token:$secret"});
                                               //  dynamic data = jsonDecode(response.body);
                                               //  print(data['data'][5]);
                                               //
                                               //
                                               //  for(int i = 0;i<data["data"].length;i++){
                                               //    userList.add(data["data"][i]["username"]);
                                               //     passwordList.add(data["data"][i]["new_password"]);
                                               //
                                               //  }
                                                print(userList);
                                                print(passwordList);

                                                if(userList.isNotEmpty){
                                                    for(int i=0;i<userList.length;i++){
                                                        if(email==userList[i] && loginPasswordController.text==passwordList[i])
                                                        {
                                                            currentUser=email;
                                                            currentTerminal=terminalList[i];
                                                            print('ct:$currentTerminal');
                                                            if(currentTerminal=='Admin-POS'){
                                                                selectedmenu = 'sales';
                                                                await firebaseFirestore.collection("user_data").where('userName',isEqualTo: email.toString().trim()).where('password',isEqualTo:password.toString().trim() ).get().then((querySnapshot) {
                                                                    querySnapshot.docs.forEach((result) {
                                                                         userSalesPrefix=result.get('prefix');
                                                                        currentWarehouse=result.get('warehouse');
                                                                        currentPrinter=result.get('printer');
                                                                        currentPrinterName=result.get('printerName');
                                                                        currentDiscount=result.get('discount');
                                                                        currentPriceEdit=result.get('priceEdit');
                                                                        currentBranch=result.get('branch');
                                                                         userNam=result.get('userName');
                                                                    });
                                                                });
                                                                // DocumentSnapshot doc=await firebaseFirestore.collection('user_data').doc(currentUser).get();
                                                                // // tillCloseTime=doc.get('tillCloseDate');
                                                                // userSalesPrefix=doc.get('prefix');
                                                                // currentWarehouse=doc.get('warehouse');
                                                                // currentPrinter=doc.get('printer');
                                                                // currentPrinterName=doc.get('printerName');
                                                                // currentDiscount=doc.get('discount');
                                                                // currentPriceEdit=doc.get('priceEdit');
                                                                // currentBranch=doc.get('branch');
                                                                // await displayAllProducts('Salable');
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => WaiterScreen()));
                                                            }
                                                            else if(currentTerminal=='Owner'){
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => OwnerDash()),
                                                                );
                                                            }
                                                            else if(currentTerminal=='Kitchen'){


                                                            }
                                                            else if(currentTerminal=='POS'){
                                                                DocumentSnapshot doc=await firebaseFirestore.collection('user_data').doc(currentUser).get();
                                                                tillCloseTime=doc.get('tillCloseDate');
                                                                userSalesPrefix=doc.get('prefix');
                                                                currentPrinter=doc.get('printer');
                                                                currentWarehouse=doc.get('warehouse');
                                                                currentPrinterName=doc.get('printerName');
                                                                currentDiscount=doc.get('discount');
                                                                currentPriceEdit=doc.get('priceEdit');
                                                                currentBranch=doc.get('branch');
                                                                await displayAllProducts('Salable');
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => PosScreen()),
                                                                );
                                                            }
                                                            else if(currentTerminal=='Call Center'){
                                                               await read('branch_data');
                                                                DocumentSnapshot doc=await firebaseFirestore.collection('user_data').doc(currentUser).get();
                                                                tillCloseTime=doc.get('tillCloseDate');
                                                                userSalesPrefix=doc.get('prefix');
                                                                // currentPrinter=doc.get('printer');
                                                                currentWarehouse=doc.get('warehouse');
                                                                // currentPrinterName=doc.get('printerName');
                                                                currentDiscount=doc.get('discount');
                                                                currentPriceEdit=doc.get('priceEdit');
                                                                await displayAllProducts('Salable');
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => PosScreen()),
                                                                );
                                                            }
                                                            else{

                                                                DocumentSnapshot doc=await firebaseFirestore.collection('user_data').doc(currentUser).get();
                                                                tillCloseTime=doc.get('tillCloseDate');
                                                                userSalesPrefix=doc.get('prefix');
                                                                currentPrinter=doc.get('printer');
                                                                currentWarehouse=doc.get('warehouse');
                                                                currentPrinterName=doc.get('printerName');
                                                                userNam=doc.get('userName');
                                                                if(selectedScreen=='withImage'){
                                                                    currentPage=1;
                                                                   await displayAllProducts('Salable');
                                                                }
                                                              // await  read('stock');
                                                                // await read('route_data');
                                                                //  await read('customer_report');

                                                                // read('product_data');
                                                                // read('category_data');

                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => SplashScreen()),
                                                                );
                                                            }
                                                        }
                                                    }
                                                }
                                                 else if(email=='admin'){
                                                    currentTerminal='Admin-POS';
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) =>  NewDash()),
                                                    );
                                                }
                                                else
                                                    showDialog(context:context,
                                                        builder: (BuildContext context){
                                                            return AlertDialog(
                                                                title: Text('Invalid '),
                                                            );
                                                        }
                                                    );
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
