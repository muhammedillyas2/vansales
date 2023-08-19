import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/screen/login_page.dart';
import 'package:restaurant_app/screen/menu_screen.dart';
import 'package:restaurant_app/screen/sequence_manager.dart';
import '../constants.dart';
int expenseInvNo;
RxBool expenseEditInv=false.obs;
RxString invEditNumber=''.obs;
RxString invEditPaymentMethod=''.obs;
RxString invEditTotal=''.obs;
RxInt invDate=0.obs;
RxString invEditHead=''.obs;
RxString invEditNote=''.obs;
RxString invEditTax=''.obs;
class ExpenseTransaction extends StatefulWidget {
  static const String id='expense_transaction';
  @override
  _ExpenseTransactionState createState() => _ExpenseTransactionState();
}

class _ExpenseTransactionState extends State<ExpenseTransaction> {
  List<String> paymentMode=['Cash','Credit','Card'];
  String selectedPayment='Cash';
  String selectedExpense;
  String selectedTax;
  TextEditingController amountController=TextEditingController();
  TextEditingController noteController=TextEditingController();
  String amount='',note='';
  @override
  void initState() {
    // TODO: implement initState
    if(expenseEditInv.value){
      selectedExpense=invEditHead.value!=''?invEditHead.value:expenseList.isNotEmpty?expenseList[0]:'';
      selectedTax=invEditTax.value!=''?invEditTax.value:taxNameList.isNotEmpty?taxNameList[0]:'';
      selectedPayment=invEditPaymentMethod.value;
      amountController.text=invEditTotal.value;
      noteController.text=invEditNote.value;
    }
    else{
      selectedExpense=expenseList.isNotEmpty?selectedExpense=expenseList[0]:'';
      selectedTax=taxNameList.isNotEmpty?taxNameList[0]:'';
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('EXPENSE',style: TextStyle(
            fontFamily: 'BebasNeue',
            letterSpacing: 2.0
        ),),
        titleSpacing: 0.0,
        backgroundColor: kGreenColor,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding:EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width/2,
        child: ListView(
          children: [
            // Text(
            //   'Expense',
            //   style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20,),
            // ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color:kAppBarItems,
                    style: BorderStyle.solid,
                    width: 2),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    value: selectedExpense, // Not necessary for Option 1
                    items: expenseList.map((String val) {
                      return DropdownMenuItem(
                        child: new Text(val.toString(),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),
                        ),
                        value: val,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedExpense = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            // Text(
            //   'Payment Mode',
            //   style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20,),
            // ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color:kAppBarItems,
                    style: BorderStyle.solid,
                    width: 2),
              ),
              child: DropdownButtonHideUnderline(
                child : ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    value: selectedPayment, // Not necessary for Option 1
                    items: paymentMode.map((String val) {
                      return DropdownMenuItem(
                        child: new Text(val.toString(),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),
                        ),
                        value: val,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedPayment = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            // Text(
            //   'Amount',
            //   style: TextStyle(
            //     fontSize: MediaQuery.of(context).textScaleFactor*20,
            //   ),
            // ),
            TextField(
              onChanged: (value){
                amount=value;
                print('amount $amount');
              },
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*16,
              ),
              controller: amountController,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
              keyboardType: TextInputType.numberWithOptions(decimal: true),//
              decoration: InputDecoration(
                label: Text('Enter the Amount'),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:Colors.black, width: 2.0
                  ),
                  // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, width: 2.0),
                  //  borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                ),
              ),
            ),
            SizedBox(height: 10,),
            // Text('Note',style: TextStyle(
            //   fontSize: MediaQuery.of(context).textScaleFactor*20,
            // ),),
            TextField(
              controller: noteController,
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*16,
              ),
              onChanged: (value){
                note=value;
              },
              decoration: InputDecoration(
                label: Text('Enter the Note'),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:Colors.black, width: 2.0
                  ),
                  // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, width: 2.0),
                  //  borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                ),
              ),
            ),
            TextButton(
              onPressed: ()async {
                if(amountController.text.length>0){
                  if(expenseEditInv.value){
                    await firebaseFirestore.collection('vat_report').doc(invEditNumber.value).delete();
                    if(invEditPaymentMethod.value=='Cash' && invDate.value<tillCloseTime){
                      print('inv before till close');
                      await firebaseFirestore.collection('user_data').doc(currentUser).update(
                          {
                            "tillClose":FieldValue.increment(double.parse(invEditTotal.value)),
                          }
                      );
                    }
                  }
                  int invNo;
                  invNo=await getLastInv('expense');
                  // String tempPercent=getPercent(selectedTax);
                  // double temp=double.parse(tempPercent)/double.parse(amount)*100;
                  // temp=temp+double.parse(amount);
                  String getVatName(String name){
                    print('name $name');
                    for(int i=0;i<expenseFirstSplit.length;i++){
                      List tempExpense=expenseFirstSplit[i].toString().split('~');
                      if(tempExpense[0].toString().trim()==name.trim()){
                        print('vat name ${tempExpense[2].toString().trim()}');
                        return tempExpense[2].toString().trim();
                      }
                    }
                  }
                  String getVatNo(String name){
                    for(int i=0;i<expenseFirstSplit.length;i++){
                      List tempExpense=expenseFirstSplit[i].toString().split('~');
                      if(tempExpense[0].toString().trim()==selectedExpense.trim()){
                        print('vat no ${tempExpense[1].toString().trim()}');
                        return tempExpense[1].toString().trim();
                      }
                    }
                  }
                  double taxable5=0;
                  double tax5=0;
                  double total5=0;
                  double total0=0;
                  String taxName=getVatName(selectedExpense);
                  String body='$expensePrefix$invNo~${dateNow()}~$selectedExpense~$selectedPayment~${amountController.text}~$note~expense~$currentUser~${getVatName(selectedExpense)}';
    if(expenseEditInv.value){
      firebaseFirestore
          .collection('expense_transaction')
          .doc(invEditNumber.value)
          .set({
        'orderNo':invEditNumber.value,
        'date': DateTime.now().millisecondsSinceEpoch,
        'expense': selectedExpense,
        'payment':selectedPayment,
        'total': amountController.text,
        'note': noteController.text,
        'transactionType': 'expense',
        'user': currentUser,
        'tax': getVatName(selectedExpense),
      }).then((_) {
        print('success');
      });
      expenseEditInv.value=false;
    }
    else{
      create(body, 'expense_transaction', []);
      updateInv('expense', invNo+1);
    }

                  print('taxName $taxName');
                  String vatPercent=getPercent(taxName);
                  if(vatPercent.trim()=='5'){
                    print('inside tax percent 5');
                    taxable5+=double.parse(amountController.text)*100/105;
                    tax5+=5*double.parse(amountController.text)/105;
                    total5+=double.parse(amountController.text);
                  }
                  else{
                    print('inside 0 tax');
                    total0+=double.parse(amountController.text);
                  }
                  print('body $body');
                  String tempEditInv='';
                  if(expenseEditInv.value){
                    tempEditInv=invEditNumber.value;
                  }
                  else{
                    tempEditInv='$expensePrefix$invNo';
                  }
                  String vatBody='$tempEditInv~${dateNow()}~$selectedExpense~${getVatNo(selectedExpense)}~${amountController.text}~${taxable5.toStringAsFixed(decimals)}~${tax5.toStringAsFixed(decimals)}~$total5~$total0~expense';
                  create(vatBody, 'vat_report', []);
                  // await insertData(body, 'expense_transaction');

                  amount='';
                  amountController.clear();
                  noteController.clear();
                }
                else{
                  print('inside else');
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Enter the amount"),
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
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Text('SUBMIT',
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
  String dateNow(){
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    return timestamp;
  }
}
