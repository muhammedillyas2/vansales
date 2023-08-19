import 'package:flutter/material.dart';
import 'first_page.dart';
import 'package:restaurant_app/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_app/screen/sales_drawer.dart';
import 'package:restaurant_app/screen/stream_reports.dart';
import 'waiter_screen.dart';
import 'login_page.dart';
import 'package:restaurant_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'splash_screen.dart';
class CustomerVisit extends StatefulWidget {
  TextEditingController appbarCustomerController=TextEditingController();
  static const String id='visit';
  @override
  _CustomerVisitState createState() => _CustomerVisitState();
}
class _CustomerVisitState extends State<CustomerVisit> {
  Future<bool> _onBackPressed() {
    return showDialog(
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
                MaterialPageRoute(builder: (context) => SplashScreen()),
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
            body:Column(
              children: [
                ClipPath(
                  clipper:CustomClipPath(),

                  child: Container(
                    height:MediaQuery.of(context).size.height*0.12,
                    // decoration: new BoxDecoration(
                    color: bottomColor,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => FirstScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(17),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: MediaQuery.of(context).size.width*0.04,
                              child: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: MediaQuery.of(context).size.width*0.072,),
                            ),
                          ),
                        ),
                        Text('Customer Visit',style: TextStyle(fontSize:MediaQuery.of(context).size.width*0.06,color: Colors.white ),)
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
                SizedBox( height: MediaQuery.of(context).size.height*0.03,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue)),
                  width: MediaQuery.of(context).size.width *0.9,
                  child: Center(
                    child: TextField(
                      cursorColor: Colors.lightBlue,
                      maxLines: 10,

                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        // email = value;
                      },
                    ),
                  ),
                ),
                SizedBox( height: MediaQuery.of(context).size.height*0.07,),

                Container(
                  height: MediaQuery.of(context).size.height*0.07,
                  width: MediaQuery.of(context).size.width*0.93,

                  child: Center(
                    child: Text('SUBMIT',
                      style: TextStyle(
                        color: Colors.white,

                        letterSpacing: 2.0,
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: bottomColor,
                    borderRadius:
                    BorderRadius.circular(10.0),
                  ),
                )
              ],
            )

        ),
      ),
    );
  }

}