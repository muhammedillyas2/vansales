
import 'package:flutter/material.dart';

import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';

import '../constants.dart';
List<String> transactionTypePrefix=[];
List<String> transactionTypeFrom=[];
String salesPrefix,salesReturnPrefix,purchasePrefix,purchaseReturnPrefix,receiptPrefix,paymentPrefix,expensePrefix,stockPrefix;
String salesFrom,salesReturnFrom,purchaseFrom,purchaseReturnFrom,receiptFrom,paymentFrom,expenseFrom,stockFrom;
List<String> type=['Sales','Sales Return','Purchase','Purchase Return','Receipt','Payment','Expense'];
List<TextEditingController> prefixController=[];
List<TextEditingController> fromController=[];
class SequenceManager extends StatefulWidget {
  static const String id='sequence';
  @override
  _SequenceManagerState createState() => _SequenceManagerState();
}

class _SequenceManagerState extends State<SequenceManager> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      appBar: AppBar(
        title: Text('POSIMATE',style: TextStyle(
            fontFamily: 'BebasNeue',
            letterSpacing: 2.0
        ),),
        titleSpacing: 0.0,
        backgroundColor: kGreenColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width/1.5,
        child: ListView(
          children: [
            DataTable(columns:[ DataColumn(label: Text(
              'Transaction Type',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).textScaleFactor * 20,
              ),
            ),
            ),
              DataColumn(label: Text(
                'Prefix',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),
              ),
              ),
              DataColumn(label: Text(
                'Start From',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),
              ),
              ),

            ], rows: List.generate(type.length, (index) => DataRow(cells:[
              DataCell(Text(
                type[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                ),
              ),
              ),
              DataCell(TextField(

                controller: prefixController[index],
                onChanged: (value){
                  transactionTypePrefix[index]=value;
                  print(transactionTypePrefix[index]);
                },
              ),
                showEditIcon: true,),
              DataCell(TextField(
                controller: fromController[index],
                onChanged: (value){
                  transactionTypeFrom[index]=value;
                  print(transactionTypeFrom[index]);
                },
              ),
                showEditIcon: true,
              ),
            ]))),
            SizedBox(height: 20.0,),
            TextButton(onPressed: () async {
              String temp='';
              for(int i=0;i<type.length;i++){
                temp+='${transactionTypePrefix[i]}:${transactionTypeFrom[i]}~';
              }
              print('sequence body $temp');
              await insertData(temp,'sequence_manager');
              // allFile.writeFile(temp, 'sequence_data');
            }, child: Container(
              decoration: BoxDecoration(
                color: kLightBlueColor,
              ),
              padding: EdgeInsets.all(8.0),
              child: Text('SAVE',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
            ))
          ],
        ),
      ),

    )
    );
  }
}
Future getSequenceData()async{
await read('sequence');
  prefixController=[];
  fromController=[];
  transactionTypeFrom=[];
  transactionTypePrefix=[];
  if(sequenceData==''){
    for(int i=0;i<type.length;i++){
      print(i);
      transactionTypePrefix.add('');
      transactionTypeFrom.add('');
      prefixController.add(TextEditingController(
          text: ''
      ));
      fromController.add(TextEditingController(
          text: ''
      ));
      if(i==0){
        salesPrefix=transactionTypePrefix[i];
        salesFrom=transactionTypeFrom[i];
      }
      else if(i==1){
        salesReturnPrefix=transactionTypePrefix[i];
        salesReturnFrom=transactionTypeFrom[i];
      }
      else if(i==2){
        purchasePrefix=transactionTypePrefix[i];
        purchaseFrom=transactionTypeFrom[i];
      }
      else if(i==3){
        purchaseReturnPrefix=transactionTypePrefix[i];
        purchaseReturnFrom=transactionTypeFrom[i];
      }
      else if(i==4){
        receiptPrefix=transactionTypePrefix[i];
        receiptFrom=transactionTypeFrom[i];
      }
      else if(i==5){
        paymentPrefix=transactionTypePrefix[i];
        paymentFrom=transactionTypeFrom[i];
      }
      else if(i==6){
        expensePrefix=transactionTypePrefix[i];
        expenseFrom=transactionTypeFrom[i];
      }
      else if(i==7){
        stockPrefix=transactionTypePrefix[i];
        stockFrom=transactionTypeFrom[i];
      }
    }
  }
  else{
    List temp=sequenceData.split('~');
if(temp.length>7){
  temp.removeAt(temp.length-1);
}
    for(int i=0;i<temp.length;i++){
      List tempSplit=temp[i].toString().split(':');
      transactionTypePrefix.add(tempSplit[0]);
      transactionTypeFrom.add(tempSplit[1]);
      prefixController.add(TextEditingController(
          text: tempSplit[0]
      ));
      fromController.add(TextEditingController(
          text: tempSplit[1]
      ));
      // if(i==0){
      //   salesPrefix=transactionTypePrefix[i];
      //   salesFrom=transactionTypeFrom[i];
      // }
       if(i==0){
        salesReturnPrefix=transactionTypePrefix[i];
        salesReturnFrom=transactionTypeFrom[i];
      }
      else if(i==1){
        purchasePrefix=transactionTypePrefix[i];
        purchaseFrom=transactionTypeFrom[i];
      }
      else if(i==2){
        purchaseReturnPrefix=transactionTypePrefix[i];
        purchaseReturnFrom=transactionTypeFrom[i];
      }
      else if(i==3){
        receiptPrefix=transactionTypePrefix[i];
        receiptFrom=transactionTypeFrom[i];
      }
      else if(i==4){
        paymentPrefix=transactionTypePrefix[i];
        paymentFrom=transactionTypeFrom[i];
      }
      else if(i==5){
        expensePrefix=transactionTypePrefix[i];
        expenseFrom=transactionTypeFrom[i];
      }
       else if(i==6){
         stockPrefix=transactionTypePrefix[i];
         stockFrom=transactionTypeFrom[i];
       }
    }
  }
  return;
}