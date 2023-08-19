import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/components/database_con.dart';

import '../constants.dart';
class TaxScreen extends StatefulWidget {
  static const String id='tax';
  @override
  _TaxScreenState createState() => _TaxScreenState();
}

class _TaxScreenState extends State<TaxScreen> {
  String taxName='',percentage='';
  TextEditingController taxNameController=TextEditingController();
  TextEditingController percentageController=TextEditingController();
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
                'Tax Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                controller: taxNameController,
                onChanged: (value) {
                  taxName=value;
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
                'Percentage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: percentageController,
                onChanged: (value) {
                  percentage=value;
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
                  if(taxName==''|| percentage=='' ){
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
                    for(int i=0;i<taxNameList.length;i++){
                      if(taxNameList[i].toLowerCase() == taxName.toLowerCase().trim()){
                        inside='contains';
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Tax name Exists"),
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
                      String body='$taxName:$percentage~';
                      await insertData(body.substring(0,body.length-1),'tax_data');
                      setState(() {
                        taxNameList.add(taxName);
                        percentageList.add(percentage);
                      });
                      taxName='';
                      percentage='';
                      taxNameController.clear();
                      percentageController.clear();
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
