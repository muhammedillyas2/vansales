import 'package:flutter/material.dart';
// import 'package:flutter_app/reports_page.dart';
class MenuPage extends StatefulWidget {
  static const String id='menu_page';
  @override
  _MenuPageState createState() => _MenuPageState();
}
class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 1,top: 1),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child:SafeArea(
            child:ListView(children:[
              Row(children: [
                Padding(
                  padding: EdgeInsets.only(left: 38,top: 20),
                  child: Container(
                    width: 250,
                    height: 120,
                    decoration:BoxDecoration(
                      image:DecorationImage(
                        image:AssetImage(
                            'images/logo.jpg'
                        ),),
                    ),
                  ),
                ),],),
              Container(
                margin: EdgeInsets.only(left: 450,right: 100),
                height: 500,
                width: 10,
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: Image(
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                        'images/sales1.jpg'
                                    ),
                                  ),
                                ),
                                Text('Sales',style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],),
                            color: Colors.grey[100],
                            height: 150,
                            width: 150,
                          ),
                          Container(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: Image(
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                        'images/purchase.jpg'
                                    ),
                                  ),
                                ),
                                Text('Purchase',style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],),
                            color: Colors.grey[100],
                            height: 150,
                            width: 150,
                          ),
                          Container(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: Image(
                                    image: AssetImage(
                                        'images/reciept.jpg'
                                    ),
                                  ),
                                ),
                                Text('Reciepts',style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],),
                            color: Colors.grey[100],
                            height: 150,
                            width: 150,
                          ),
                          Container(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Container(
                                  height: 80,
                                  width: 170,
                                  child: Image(
                                    image: AssetImage(
                                        'images/payment.jpg'
                                    ),
                                  ),
                                ),
                                Text('Payments',style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],),
                            color: Colors.grey[100],
                            height: 150,
                            width: 150,
                          ),
                          Container(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: Image(
                                    image: AssetImage(
                                        'images/return.jpg'
                                    ),
                                  ),
                                ),
                                Text('Sales Returns',style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],),
                            color: Colors.grey[100],
                            height: 150,
                            width: 150,
                          ),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: Image(
                                    image: AssetImage(
                                        'images/return2.jpg'
                                    ),
                                  ),
                                ),
                                Text('Purchase',style: TextStyle(color: Colors.black,fontSize: 20),),
                                Text('Returns',style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],),
                            color: Colors.grey[100],
                            height: 150,
                            width: 150,
                          ),
                          Container(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: Image(
                                    image: AssetImage(
                                        'images/administration.jpg'
                                    ),
                                  ),
                                ),
                                Text('Administration',style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],),
                            color: Colors.grey[100],
                            height: 150,
                            width: 150,
                          ),
                          GestureDetector(
                            onTap: (){
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => ReportsPage()));
                            },
                            child: Container(
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children:[
                                    Container(
                                      height: 80,
                                      width: 80,
                                      child: Image(
                                        image: AssetImage(
                                            'images/report.jpg'
                                        ),
                                      ),
                                    ),
                                    Text('Reports',style: TextStyle(color: Colors.black,fontSize: 20),)
                                  ],),
                                color: Colors.white,
                                height: 150,
                                width: 15
                            ),
                          ),
                          Container(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: Image(
                                    image: AssetImage(
                                        'images/dashboard.jpg'
                                    ),
                                  ),
                                ),
                                Text('Dashboard',style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],),
                            color: Colors.grey[100],
                            height: 150,
                            width: 150,
                          ),
                          Container(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: Image(
                                    image: AssetImage(
                                        'images/settings.jpg'
                                    ),
                                  ),
                                ),
                                Text('Settings',style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],),
                            color: Colors.grey[100],
                            height: 150,
                            width: 150,
                          ),

                        ],
                      ),

                    ]),
              ),],)),),);}}