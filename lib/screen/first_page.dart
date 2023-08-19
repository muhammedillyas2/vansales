import 'package:flutter/material.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_app/screen/customer_visit.dart';
import 'package:restaurant_app/screen/sales_drawer.dart';
import 'package:restaurant_app/screen/stream_reports.dart';
import 'waiter_screen.dart';
import 'package:restaurant_app/screen/waiter_screen.dart';
import 'login_page.dart';
import 'package:restaurant_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'splash_screen.dart';
class FirstScreen extends StatefulWidget {
  TextEditingController appbarCustomerController=TextEditingController();
  static const String id='first';
  @override
  _FirstScreenState createState() => _FirstScreenState();
}
class _FirstScreenState extends State<FirstScreen> {
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: new Text('Are you sureee?'),
        content: new Text('Do you want to Log Out'),
        actions: <Widget>[
          new TextButton(
            onPressed: () =>Navigator.pop(context),
            child: Container(
                padding: EdgeInsets.all(6.0),
                width: 100,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(10.0),
                    border: Border.all(color: kBlack)
                ),
                child: Center(
                  child: Text("No",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),),
                )),
          ),
          SizedBox(height: 16),

          new TextButton(
            onPressed: ()  {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            } ,
            child: Container(
                padding: EdgeInsets.all(6.0),
                width: 100,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(10.0),
                    border: Border.all(color: kBlack)
                ),
                child: Center(child: Text("Yes",style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                )))),
          ),
        ],
      ),

    ) ??
        false;
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,


          // appBar: AppBar(
          //   centerTitle: false,
          //   leadingWidth: 0,
          //   title: Text('Dashboard',),
          //
          //   backgroundColor: bottomColor,
          //    shape: MyCurveClipper(),
          //   leading:  Container(
          //     width:   MediaQuery.of(context).size.width,
          //
          //   ),
          // ),





            resizeToAvoidBottomInset: false,
            body:Padding(
              padding: EdgeInsets.only(bottom:MediaQuery.of(context).size.height*0.01  ),
              child: Container(
                height:MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    ClipPath(
                clipper:CustomClipPath(),

                      child: Container(
                        height:MediaQuery.of(context).size.height*0.11,
                        // decoration: new BoxDecoration(
                          color: bottomColor,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    builder: (context)=>AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                      title: new Text('Are you sure?'),
                                      content: new Text('Do you want to Log Out'),
                                      actions: <Widget>[
                                        new TextButton(
                                          onPressed: () =>Navigator.pop(context),
                                          child: Container(
                                              padding: EdgeInsets.all(6.0),
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                  border: Border.all(color: kBlack)
                                              ),
                                              child: Center(
                                                child: Text("No",style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
                                                ),),
                                              )),
                                        ),
                                        SizedBox(height: 16),

                                        new TextButton(
                                          onPressed: ()  {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => LoginScreen()),
                                                  (Route<dynamic> route) => false,
                                            );
                                          } ,
                                          child: Container(
                                              padding: EdgeInsets.all(6.0),
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                  border: Border.all(color: kBlack)
                                              ),
                                              child: Center(child: Text("Yes",style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold
                                              )))),
                                        ),
                                      ],
                                    ),

                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(17),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: MediaQuery.of(context).size.width*0.046,
                                    child: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: MediaQuery.of(context).size.width*0.083,),
                                  ),
                                ),
                              ),
                              Text('Dashboard',style: TextStyle(fontSize:MediaQuery.of(context).size.width*0.06,color: Colors.white ),)
                            ],
                          ),
                          // borderRadius: BorderRadius.only(
                          //
                          //   bottomLeft:Radius.elliptical(
                          //       MediaQuery.of(context).size.width, 65.0) ,
                          //
                          //
                          //
                          //     bottomRight: Radius.elliptical(
                          //         MediaQuery.of(context).size.width, 110.0)
                          // ),
                        ),
                      ),

                    Padding(
                       padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.01 ,right:MediaQuery.of(context).size.width*0.01  ),
                      child: Container(
                        height:MediaQuery.of(context).size.height*0.83,
                        child: Column(

                          children: [
                            // Container(
                            //   width:MediaQuery.of(context).size.width,
                            //
                            //   child: StreamBuilder(
                            //       stream: firebaseFirestore.collection('user_data').where('userName',isEqualTo:'SALES A').snapshots(),
                            //       builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                            //         if (!snapshot.hasData) {
                            //           return Center(
                            //             child: CircularProgressIndicator(),
                            //           );
                            //         }
                            //         return ListView(
                            //             scrollDirection: Axis.vertical,
                            //             shrinkWrap: true,
                            //             children: snapshot.data.docs.map((document) {
                            //               tillavailablecash=document['cashsales'].toDouble()-document['salesreturn'].toDouble();
                            //               tillavailablecash=document['openingcash'].toDouble()+tillavailablecash;
                            //               return           Padding(
                            //                 padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.038,right:MediaQuery.of(context).size.width*0.038,),
                            //                 child: Column(
                            //                   crossAxisAlignment: CrossAxisAlignment.start,
                            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                   children: [
                            //                     Row(
                            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                       children: [
                            //                         Text('Cash Available',style: TextStyle(color:Colors.grey.shade600,fontSize:MediaQuery.of(context).size.width*0.04 ),),
                            //                         Text('₹ $tillavailablecash',style: TextStyle(fontSize:MediaQuery.of(context).size.width*0.055 , fontFamily: 'FrancoisOne',color: bottomColor),)
                            //
                            //                       ],
                            //                     ),
                            //
                            //
                            //                   ],
                            //                 ),
                            //               );
                            //             }).toList());
                            //       }
                            //     //       Padding(
                            //     //   padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.062,),
                            //     //   child: Column(
                            //     //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     //     children: [
                            //     //
                            //     //       Container(
                            //     //         margin:EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
                            //     //         height:  MediaQuery.of(context).size.height*0.12,
                            //     //         width:MediaQuery.of(context).size.width*0.4,
                            //     //         child: Card(
                            //     //           elevation: 5,
                            //     //           color: Colors.white,
                            //     //           child: Padding(
                            //     //             padding: const EdgeInsets.all(8.0),
                            //     //             child: Column(
                            //     //               mainAxisAlignment: MainAxisAlignment.center,
                            //     //               crossAxisAlignment: CrossAxisAlignment.start,
                            //     //               children: [
                            //     //                 Text('Sales Return',style: TextStyle(color:Colors.grey.shade600,fontSize:MediaQuery.of(context).size.width*0.045 ),),
                            //     //                 Text('₹ 230000',style: TextStyle(color:bottomColor,fontSize:MediaQuery.of(context).size.width*0.055 , fontFamily: 'FrancoisOne',),)
                            //     //
                            //     //               ],
                            //     //             ),
                            //     //           ),
                            //     //         ),
                            //     //       ),
                            //     //
                            //     //
                            //     //     ],
                            //     //   ),
                            //     // ),
                            //   ),
                            //
                            // ),

                            // Expanded(
                            //     flex: 3,
                            //     child: Container(
                            //       width:MediaQuery.of(context).size.width,
                            //       child: Card(
                            //           color: Colors.white,
                            //
                            //
                            //           elevation: 5,
                            //           child: Row(
                            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //
                            //             children: [
                            //               Column(
                            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //                 children: [
                            //                   Container(
                            //                     height: height*0.095,
                            //                     width: width*0.43,
                            //                     child: StreamBuilder(
                            //                         stream: firebaseFirestore
                            //                             .collection('user_data')
                            //                             .where('userName', isEqualTo: 'SALES A')
                            //                             .snapshots(),
                            //                         builder: (BuildContext context,
                            //                             AsyncSnapshot<QuerySnapshot> snapshot) {
                            //                           // List ab =
                            //                           if (!snapshot.hasData) {
                            //                             return Center(
                            //                               child: CircularProgressIndicator(),
                            //                             );
                            //                           }
                            //                           return Column(
                            //                             mainAxisAlignment: MainAxisAlignment.center,
                            //                             children: snapshot.data.docs.map((document) {
                            //                               print('u:$userNam');
                            //                               return Column(
                            //
                            //                                 children: [
                            //                                   Text('Cash Sales',style: TextStyle(color: Colors.grey.shade500,fontSize: width*0.035),),
                            //                                   SizedBox(height: height*0.004,),
                            //                                   Text('₹ ${document['cashsales'].toString()}',style: TextStyle(fontSize: width*0.042,fontWeight: FontWeight.bold),),
                            //
                            //                                 ],
                            //                               );
                            //                             }).toList(),
                            //                           );
                            //                         }
                            //                     ),
                            //                     decoration: BoxDecoration(
                            //                         color: Colors.white,
                            //                         borderRadius: BorderRadius.circular(width*0.02),
                            //                         border: Border.all(
                            //                             color: bottomColor
                            //                         )
                            //                     ),
                            //                   ),
                            //                   Container(
                            //                     height: height*0.095,
                            //                     width: width*0.43,
                            //                     child: StreamBuilder(
                            //                         stream: firebaseFirestore
                            //                             .collection('user_data')
                            //                             .where('userName', isEqualTo: 'SALES A')
                            //                             .snapshots(),
                            //                         builder: (BuildContext context,
                            //                             AsyncSnapshot<QuerySnapshot> snapshot) {
                            //                           // List ab =
                            //                           if (!snapshot.hasData) {
                            //                             return Center(
                            //                               child: CircularProgressIndicator(),
                            //                             );
                            //                           }
                            //                           return Column(
                            //                             mainAxisAlignment: MainAxisAlignment.center,
                            //                             children: snapshot.data.docs.map((document) {
                            //                               print('u:$userNam');
                            //                               return Column(
                            //
                            //                                 children: [
                            //                                   Text('Invoice Count',style: TextStyle(color: Colors.grey.shade500,fontSize: width*0.035),),
                            //                                   SizedBox(height: height*0.004,),
                            //                                   Text('${document['invoicecount'].toString()}',style: TextStyle(fontSize: width*0.042,fontWeight: FontWeight.bold),),
                            //
                            //                                 ],
                            //                               );
                            //                             }).toList(),
                            //                           );
                            //                         }
                            //                     ),
                            //                     decoration: BoxDecoration(
                            //                         borderRadius: BorderRadius.circular(width*0.02),
                            //                         color: Colors.white,
                            //                         border: Border.all(
                            //                             color: bottomColor
                            //                         )
                            //                     ),
                            //                   ),
                            //                   Container(
                            //                     height: height*0.095,
                            //                     width: width*0.43,
                            //                     child: StreamBuilder(
                            //                         stream: firebaseFirestore
                            //                             .collection('user_data')
                            //                             .where('userName', isEqualTo: 'SALES A')
                            //                             .snapshots(),
                            //                         builder: (BuildContext context,
                            //                             AsyncSnapshot<QuerySnapshot> snapshot) {
                            //                           // List ab =
                            //                           if (!snapshot.hasData) {
                            //                             return Center(
                            //                               child: CircularProgressIndicator(),
                            //                             );
                            //                           }
                            //                           return Column(
                            //                             mainAxisAlignment: MainAxisAlignment.center,
                            //                             children: snapshot.data.docs.map((document) {
                            //                               print('u:$userNam');
                            //                               return Column(
                            //
                            //                                 children: [
                            //                                   Text('Receipt',style: TextStyle(color: Colors.grey.shade500,fontSize: width*0.035),),
                            //                                   SizedBox(height: height*0.004,),
                            //                                   Text('₹ ${document['receipt'].toString()}',style: TextStyle(fontSize: width*0.042,fontWeight: FontWeight.bold),),
                            //
                            //                                 ],
                            //                               );
                            //                             }).toList(),
                            //                           );
                            //                         }
                            //                     ),
                            //                     decoration: BoxDecoration(
                            //                         borderRadius: BorderRadius.circular(width*0.02),
                            //                         color: Colors.white,
                            //                         border: Border.all(
                            //                             color: bottomColor
                            //                         )
                            //                     ),
                            //                   )
                            //
                            //                 ],
                            //               ),
                            //               Column(
                            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //                 children: [
                            //                   Container(
                            //                     height: height*0.095,
                            //                     width: width*0.43,
                            //                     child: StreamBuilder(
                            //                         stream: firebaseFirestore
                            //                             .collection('user_data')
                            //                             .where('userName', isEqualTo: 'SALES A')
                            //                             .snapshots(),
                            //                         builder: (BuildContext context,
                            //                             AsyncSnapshot<QuerySnapshot> snapshot) {
                            //                           // List ab =
                            //                           if (!snapshot.hasData) {
                            //                             return Center(
                            //                               child: CircularProgressIndicator(),
                            //                             );
                            //                           }
                            //                           return Column(
                            //                             mainAxisAlignment: MainAxisAlignment.center,
                            //                             children: snapshot.data.docs.map((document) {
                            //                               print('u:$userNam');
                            //                               return Column(
                            //
                            //                                 children: [
                            //                                   Text('Credit Sales',style: TextStyle(color: Colors.grey.shade500,fontSize: width*0.035),),
                            //                                   SizedBox(height: height*0.004,),
                            //                                   Text('₹ ${document['creditsales'].toString()}',style: TextStyle(fontSize: width*0.042,fontWeight: FontWeight.bold),),
                            //
                            //                                 ],
                            //                               );
                            //                             }).toList(),
                            //                           );
                            //                         }
                            //                     ),
                            //                     decoration: BoxDecoration(
                            //                         borderRadius: BorderRadius.circular(width*0.02),
                            //                         color: Colors.white,
                            //                         border: Border.all(
                            //                             color: bottomColor
                            //                         )
                            //                     ),
                            //                   ),
                            //                   Container(
                            //                     height: height*0.095,
                            //                     width: width*0.43,
                            //                     child: StreamBuilder(
                            //                         stream: firebaseFirestore
                            //                             .collection('user_data')
                            //                             .where('userName', isEqualTo: 'SALES A')
                            //                             .snapshots(),
                            //                         builder: (BuildContext context,
                            //                             AsyncSnapshot<QuerySnapshot> snapshot) {
                            //                           // List ab =
                            //                           if (!snapshot.hasData) {
                            //                             return Center(
                            //                               child: CircularProgressIndicator(),
                            //                             );
                            //                           }
                            //                           return Column(
                            //                             mainAxisAlignment: MainAxisAlignment.center,
                            //                             children: snapshot.data.docs.map((document) {
                            //                               print('u:$userNam');
                            //                               return Column(
                            //
                            //                                 children: [
                            //                                   Text('Sales Return',style: TextStyle(color: Colors.grey.shade500,fontSize: width*0.035),),
                            //                                   SizedBox(height: height*0.004,),
                            //                                   Text('₹ ${document['salesreturn'].toString()}',style: TextStyle(fontSize: width*0.042,fontWeight: FontWeight.bold),),
                            //
                            //                                 ],
                            //                               );
                            //                             }).toList(),
                            //                           );
                            //                         }
                            //                     ),
                            //                     decoration: BoxDecoration(
                            //                         borderRadius: BorderRadius.circular(width*0.02),
                            //                         color: Colors.white,
                            //                         border: Border.all(
                            //                             color: bottomColor
                            //                         )
                            //                     ),
                            //                   ),
                            //                   Container(
                            //                     height: height*0.095,
                            //                     width: width*0.43,
                            //                     child: StreamBuilder(
                            //                         stream: firebaseFirestore
                            //                             .collection('user_data')
                            //                             .where('userName', isEqualTo: 'SALES A')
                            //                             .snapshots(),
                            //                         builder: (BuildContext context,
                            //                             AsyncSnapshot<QuerySnapshot> snapshot) {
                            //                           // List ab =
                            //                           if (!snapshot.hasData) {
                            //                             return Center(
                            //                               child: CircularProgressIndicator(),
                            //                             );
                            //                           }
                            //                           return Column(
                            //                             mainAxisAlignment: MainAxisAlignment.center,
                            //                             children: snapshot.data.docs.map((document) {
                            //                               print('u:$userNam');
                            //                               return Column(
                            //
                            //                                 children: [
                            //                                   Text('Customer Visit',style: TextStyle(color: Colors.grey.shade500,fontSize: width*0.035),),
                            //                                   SizedBox(height: height*0.004,),
                            //                                   Text('${document['customervisit'].toString()}',style: TextStyle(fontSize: width*0.042,fontWeight: FontWeight.bold),),
                            //
                            //                                 ],
                            //                               );
                            //                             }).toList(),
                            //                           );
                            //                         }
                            //                     ),
                            //                     decoration: BoxDecoration(
                            //                         borderRadius: BorderRadius.circular(width*0.02),
                            //                         color: Colors.white,
                            //                         border: Border.all(
                            //                             color: bottomColor
                            //                         )
                            //                     ),
                            //                   )
                            //
                            //                 ],
                            //               )
                            //
                            //
                            //
                            //
                            //             ],
                            //           )
                            //       ),
                            //     )),


                            Expanded(
                                flex: 4,
                                child: Container(
                                  width:MediaQuery.of(context).size.width,
                                  child: Card(
                                      color: cartColor,
                                      elevation: 5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: height*0.03,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap:(){
                                                  setState(() {

                                                  });
                                                  selectedCustomer='';
                                                  print('sales');
                                                  selectedmenu= 'sales';
                                                  Navigator.pushNamed(context, WaiterScreen.id);
                                                },
                                                child: Container(
                                                  height:  MediaQuery.of(context).size.height*0.135,
                                                  width:MediaQuery.of(context).size.width*0.28,

                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(width*0.02)
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      CircleAvatar(
                                                          backgroundColor: bottomColor,
                                                          radius:width*0.05,
                                                          child: Icon(Icons.point_of_sale_sharp,color: Colors.white,)
                                                      ),
                                                      SizedBox(height: MediaQuery.of(context).size.height*0.009,),

                                                      Text('Sales',style: TextStyle(fontWeight: FontWeight.bold,color: dotColor),)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap:(){
                                                  setState(() {

                                                  });
                                                  selectedCustomer='';
                                                  print('sales');
                                                  selectedmenu= 'salesreturn';
                                                   Navigator.pushNamed(context, WaiterScreen.id);
                                                },
                                                child: Container(
                                                  height:  MediaQuery.of(context).size.height*0.135,
                                                  width:MediaQuery.of(context).size.width*0.28,

                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(width*0.02)
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      CircleAvatar(
                                                          backgroundColor: bottomColor,
                                                          radius:width*0.05,
                                                          child:  Image.asset('images/c2.png')
                                                      ),
                                                      SizedBox(height: MediaQuery.of(context).size.height*0.009,),

                                                      Text('Sales Return',style: TextStyle(fontWeight: FontWeight.bold,color: dotColor),)
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              GestureDetector(
                                                onTap:(){



                                                  setState(() {

                                                  });

                                                  selectedCustomer='';
                                                  selectedmenu= 'Receipt';


                                                    Navigator.pushNamed(context, WaiterScreen.id);
                                                },
                                                child: Container(
                                                  height:  MediaQuery.of(context).size.height*0.135,
                                                  width:MediaQuery.of(context).size.width*0.28,

                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(width*0.02)
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      CircleAvatar(
                                                          backgroundColor: bottomColor,
                                                          radius:width*0.05,
                                                          child:  Image.asset('images/c3.png')
                                                      ),
                                                      SizedBox(height: MediaQuery.of(context).size.height*0.009,),

                                                      Text('Receipt',style: TextStyle(fontWeight: FontWeight.bold,color: dotColor),)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),



                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          //   children: [
                                          //     GestureDetector(
                                          //       onTap:(){
                                          //         setState(() {
                                          //
                                          //         });
                                          //         selectedreport= 'sales';
                                          //         Navigator.pushNamed(context, StreamReports.id);
                                          //       },
                                          //       child: Container(
                                          //         height:  MediaQuery.of(context).size.height*0.135,
                                          //         width:MediaQuery.of(context).size.width*0.28,
                                          //
                                          //         decoration: BoxDecoration(
                                          //             color: Colors.white,
                                          //             borderRadius: BorderRadius.circular(width*0.02)
                                          //         ),
                                          //         child: Column(
                                          //           mainAxisAlignment: MainAxisAlignment.center,
                                          //           children: [
                                          //             CircleAvatar(
                                          //                 backgroundColor: bottomColor,
                                          //                 radius:width*0.05,
                                          //                 child:  Image.asset('images/c4.png')
                                          //             ),
                                          //             SizedBox(height: MediaQuery.of(context).size.height*0.009,),
                                          //
                                          //             Text('Sales Report',style: TextStyle(fontWeight: FontWeight.bold,color: dotColor),)
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //
                                          //
                                          //     GestureDetector(
                                          //       onTap:(){
                                          //         setState(() {
                                          //
                                          //         });
                                          //         print('sales');
                                          //         selectedreport= 'salesreturn';
                                          //         Navigator.pushNamed(context, StreamReports.id);
                                          //       },
                                          //       child: Container(
                                          //         height:  MediaQuery.of(context).size.height*0.135,
                                          //         width:MediaQuery.of(context).size.width*0.28,
                                          //
                                          //         decoration: BoxDecoration(
                                          //             color: Colors.white,
                                          //             borderRadius: BorderRadius.circular(width*0.02)
                                          //         ),
                                          //         child: Column(
                                          //           mainAxisAlignment: MainAxisAlignment.center,
                                          //           children: [
                                          //             CircleAvatar(
                                          //                 backgroundColor: bottomColor,
                                          //                 radius:width*0.05,
                                          //                 child:  Image.asset('images/c2.png')
                                          //             ),
                                          //             SizedBox(height: MediaQuery.of(context).size.height*0.009,),
                                          //
                                          //             Text('Return Report',style: TextStyle(fontWeight: FontWeight.bold,color: dotColor),)
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     GestureDetector(
                                          //       onTap:(){
                                          //         setState(() {
                                          //
                                          //         });
                                          //         print('sales');
                                          //         selectedreport= 'Receipt';
                                          //         Navigator.pushNamed(context, StreamReports.id);
                                          //       },
                                          //       child: Container(
                                          //         height:  MediaQuery.of(context).size.height*0.135,
                                          //         width:MediaQuery.of(context).size.width*0.28,
                                          //
                                          //         decoration: BoxDecoration(
                                          //             color: Colors.white,
                                          //             borderRadius: BorderRadius.circular(width*0.02)
                                          //         ),
                                          //         child: Column(
                                          //           mainAxisAlignment: MainAxisAlignment.center,
                                          //           children: [
                                          //             CircleAvatar(
                                          //                 backgroundColor: bottomColor,
                                          //                 radius:width*0.05,
                                          //                 child:  Image.asset('images/c4.png')
                                          //             ),
                                          //             SizedBox(height: MediaQuery.of(context).size.height*0.009,),
                                          //
                                          //             Text('Receipt  Report',style: TextStyle(fontWeight: FontWeight.bold,color: dotColor),)
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          //   children: [
                                          //     GestureDetector(
                                          //       onTap:(){
                                          //         Navigator.pushNamed(context, CustomerVisit.id);
                                          //         setState(() {
                                          //
                                          //         });
                                          //
                                          //       },
                                          //       child: Container(
                                          //         height:  MediaQuery.of(context).size.height*0.135,
                                          //         width:MediaQuery.of(context).size.width*0.43,
                                          //
                                          //         decoration: BoxDecoration(
                                          //             color: Colors.white,
                                          //             borderRadius: BorderRadius.circular(width*0.02)
                                          //         ),
                                          //         child: Column(
                                          //           mainAxisAlignment: MainAxisAlignment.center,
                                          //           children: [
                                          //             CircleAvatar(
                                          //                 backgroundColor: bottomColor,
                                          //                 radius:width*0.05,
                                          //                 child: FaIcon(FontAwesomeIcons.user,color: Colors.white,)
                                          //             ),
                                          //             SizedBox(height: MediaQuery.of(context).size.height*0.009,),
                                          //
                                          //             Text('Customer Visit',style: TextStyle(fontWeight: FontWeight.bold,color: dotColor),)
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     GestureDetector(
                                          //       onTap:(){
                                          //
                                          //       },
                                          //       child: Container(
                                          //         height:  MediaQuery.of(context).size.height*0.135,
                                          //         width:MediaQuery.of(context).size.width*0.43,
                                          //
                                          //         decoration: BoxDecoration(
                                          //             color: Colors.white,
                                          //             borderRadius: BorderRadius.circular(width*0.02)
                                          //         ),
                                          //         child: Column(
                                          //           mainAxisAlignment: MainAxisAlignment.center,
                                          //           children: [
                                          //             CircleAvatar(
                                          //                 backgroundColor: bottomColor,
                                          //                 radius:width*0.05,
                                          //                 child:  Image.asset('images/c4.png')
                                          //             ),
                                          //             SizedBox(height: MediaQuery.of(context).size.height*0.009,),
                                          //
                                          //             Text('Visit Report',style: TextStyle(fontWeight: FontWeight.bold,color: dotColor),)
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //
                                          //
                                          //
                                          //   ],
                                          // ),





                                        ],
                                      )
                                  ),
                                )
                            ),

                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            )

        ),
      ),
    );
  }

}


ShapeBorder MyCurveClipper()  {
  @override
  Path getClip(Size size) {
    print('enter shape');
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class CustomClipPath extends CustomClipper<Path> {
  var radius=5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width / 2, size.height+20, size.width, size.height * 0.55);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;


  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}