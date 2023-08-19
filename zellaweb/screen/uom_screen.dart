import 'package:flutter/material.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/screen/add_product.dart';

import '../constants.dart';
class UomScreen extends StatefulWidget {
  static const String id='uom';
  @override
  _UomScreenState createState() => _UomScreenState();
}

class _UomScreenState extends State<UomScreen> {
  String uomName='',decimal='';
  TextEditingController nameController=TextEditingController();
  TextEditingController decimalController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('POSIMATE',style: TextStyle(
              fontFamily: 'BebasNeue',
              letterSpacing: 2.0
          ),),
          titleSpacing: 0.0,
          backgroundColor: kGreenColor,
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width/2,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Text(
                'UOM Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                controller: nameController,
                onChanged: (value) {
                  uomName=value;
                },
                keyboardType:
                TextInputType.name,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                'No of Decimal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                controller: decimalController,
                onChanged: (value) {
                  decimal=value;
                },
                keyboardType:
                TextInputType.number,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0,),
              TextButton(
                onPressed: ()async {
                  if(uomName==''|| decimal==''){
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text("Fill all the fields"),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new TextButton(
                              child: new Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                    );
                  }
                  else{
                    String inside='not';
                    for(int i=0;i<uomList.length;i++){
                      if(uomList[i].toLowerCase() == uomName.toLowerCase().trim()){
                        inside='contains';
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("UOM name Exists"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                        );
                      }
                    }
                    if(inside=='not'){
                      setState(() {
                        uomList.add(uomName);
                      });
                      String body='$uomName:$decimal~';
                      await insertData(body.substring(0,body.length-1),'uom_data');
                      uomName='';
                      decimal='';
                      nameController.clear();
                      decimalController.clear();
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text('SAVE',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: kGreenColor,
                    borderRadius:
                    BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
