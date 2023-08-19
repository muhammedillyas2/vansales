import 'package:flutter/material.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/screen/expense_report.dart';
import '../constants.dart';
class ExpenseHead extends StatefulWidget {
  static const String id='expense_head';
  @override
  _ExpenseHeadState createState() => _ExpenseHeadState();
}

class _ExpenseHeadState extends State<ExpenseHead> {
  TextEditingController expenseHeadController=TextEditingController();
  TextEditingController vatController=TextEditingController();
  String expenseHead='',vatNo='';
  String selectedVat;
  @override
  void initState() {
    // TODO: implement initState
    taxNameList.isNotEmpty?selectedVat=taxNameList[0]:selectedVat='';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('POSIMATE',style: TextStyle(
            fontFamily: 'BebasNeue',
            letterSpacing: 2.0
        ),),
        titleSpacing: 0.0,
        backgroundColor: kGreenColor,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width/2,
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expense Head',style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*20,
            )),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: expenseHeadController,
              onChanged: (value){
                expenseHead=value;
              },
              decoration: InputDecoration(
                border:
                OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'VAT',
              style: TextStyle(

                fontSize: MediaQuery.of(context).textScaleFactor*20,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black38,
                    style: BorderStyle.solid,
                    width: 0.80),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value:
                  selectedVat, // Not necessary for Option 1
                  items: taxNameList.map((String val) {
                    return DropdownMenuItem(
                      child: new Text(val.toString(),style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ),),
                      value: val,
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedVat = newValue;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
                  Text('VAT/GST NO',
                    style: TextStyle(
                     // fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),),
            SizedBox(
              height: 10.0,
            ),
                  TextField(
                    controller: vatController,
                    onChanged: (value){
                      vatNo=value;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
            SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: ()async {
                if(expenseHead==''|| vatNo==''){
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
                  String inside='no';
                  print('expenseList $expenseList');
                  for(int i=0;i<expenseList.length;i++){
                    if(expenseList[i].toString().trim().toLowerCase()==expenseHead.toLowerCase()){
                      inside='yes';
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Error"),
                            content: Text("Expense Head Exists"),
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
                  if(inside=='no'){
                    String body='$expenseHead~$vatNo~$selectedVat';
                    await insertData(body, 'expense_head');
                    expenseList.add(expenseHead);
                    expenseHead='';
                    vatNo='';
                    expenseHeadController.clear();
                    vatController.clear();
                  }
                }

              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Text('SAVE',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                  ),
                ),
                decoration: BoxDecoration(
                  color: kGreenColor,
                  borderRadius:
                  BorderRadius.circular(15.0),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
