import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'package:restaurant_app/screen/login_page.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
import 'package:restaurant_app/screen/purchase_screen.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/screen/sequence_manager.dart';
List<String> paymentMode=['Cash','Bank'];
int receiptOrderNo;
int paymentOrderNo;
String amount;
String note;
String receiptSelectedPayment='Cash';
class ReceiptPayment extends StatefulWidget {
  static const String id='receipt/payment';
  final customer;

  const ReceiptPayment({Key key, this.customer}) : super(key: key);
  @override
  _ReceiptPaymentState createState() => _ReceiptPaymentState(customer);
}

class _ReceiptPaymentState extends State<ReceiptPayment> {
  RxString selectedInvNo=''.obs;
  final customer;
  TextEditingController amountController=TextEditingController(text: '');
  TextEditingController noteController=TextEditingController();
  TextEditingController customerVendorController=TextEditingController();
  TextEditingController netBalanceController=TextEditingController(text: '');
  String selected;
  List<String> type=['Receipt','Payment'];
  String selectedType='Receipt';
  List<String> customerVendor=customerList+vendorList;
  int selectedMode=0;
  List<bool> isSelected;

  _ReceiptPaymentState(this.customer);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected=customerVendorController.text=customer;
    isSelected = [true, false];
  }
  @override
  Widget build(BuildContext context) {
    double currentWidth=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('RECEIPT/PAYMENT',style: TextStyle(
            fontFamily: 'BebasNeue',
            letterSpacing: 2.0
        ),),
        titleSpacing: 0.0,
        backgroundColor: kGreenColor,
        automaticallyImplyLeading: true,

      ),
      body: Container(
        width: currentWidth>600?currentWidth/2:currentWidth,
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            ToggleButtons(
              isSelected: isSelected,
              borderColor: kAppBarItems,
              fillColor: kGreenColor,
              borderWidth: 2,
              selectedBorderColor: kAppBarItems,
              selectedColor: kItemContainer,
              borderRadius: BorderRadius.circular(0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Receipt',
                    style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Payment',
                    style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20,),
                  ),
                ),
              ],
              onPressed: (int index) {
                selectedMode=index+1;
                print(selectedMode);
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                  selectedType=type[index];
                  print('selectedType $selectedType');
                });
              },
            ),
            SizedBox(height: 10,),
            SizedBox(
              width:100,
             // height: 30,
              // child: DropdownButtonHideUnderline(
              //   child: ButtonTheme(
              //     alignedDropdown: true,
              //     child: DropdownButton(
              //       icon:Icon(Icons.account_circle_rounded) ,
              //       value: selected, // Not necessary for Option 1
              //       items: customerVendor.map((String val) {
              //         return DropdownMenuItem(
              //           child: new Text(val.toString(),
              //             style: TextStyle(
              //               fontSize: MediaQuery.of(context).textScaleFactor*20,
              //             ),
              //           ),
              //           value: val,
              //         );
              //       }).toList(),
              //       onChanged: (newValue) {
              //         setState(() {
              //           selected=newValue;
              //         });
              //       },
              //     ),
              //   ),
              // ),
              child:  SimpleAutoCompleteTextField(
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
                // focusNode: nameNode,
                controller: customerVendorController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      selected='';
                      customerVendorController.clear();
                      netBalanceController.clear();
                    });
                  },
                  icon: Icon(Icons.clear)),
                  suffixIconColor: kAppBarItems,
                  label: Text('search here..'),
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
                suggestions: customerVendor,
                clearOnSubmit: false,
                textSubmitted: (text) {
                  if(customerVendor.contains(text)) {
                    if(vendorList.contains(text)){
                      setState(() {
                        netBalanceController.text= getVendorBalance(text);
                        print('netttttttttt vendorrrrrrrrr ${ netBalanceController.text}');
                        selected=customerVendorController.text=text;
                      });
                    }
                    else{
                      setState(() {
                        netBalanceController.text=getCustomerBalance(text);
                        print('netttttttttt customerrrr ${ netBalanceController.text}');
                        selected=customerVendorController.text=text;
                      });
                    }
                  }
                  else
                  {
                    print('nothingggg');
                  }
                },
              ),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                    ),
                    controller: netBalanceController,
                    enabled: false,
                    // keyboardType:
                    // TextInputType.number,
                    // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      label: Text('Net Balance'),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:Colors.black, width: 2.0
                        ),
                        // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                      ),
                      disabledBorder:  OutlineInputBorder(
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
                ),
                TextButton(
                  onPressed: () {
                    if(customerVendorController.text==''){
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Error"),
                            content: Text("Select a party name"),
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
                      showDialog(context: context, builder: (context)=>Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Dialog(
                              child: StreamBuilder(
                stream: firebaseFirestore.collection(selectedType=='Receipt'?'invoice_data':'purchase').where(selectedType=='Receipt'?'customer':'vendor',isEqualTo: selected).where('balance',isGreaterThan: 0).snapshots(),
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return DataTable(columns: [
                    DataColumn(label: Text('Inv',)),
                    DataColumn(label: Text('Balance',)),
                    DataColumn(label: Text('Age',)),
                    DataColumn(label: Text('Date',)),
                  ], rows: snapshot.data.docs.map((document) {
                    return DataRow(cells: [
                      DataCell(
                          TextButton(
                          onPressed: () {
                       selectedInvNo.value=document['orderNo'];
                       Navigator.pop(context);
                          },
                          child: Text(document['orderNo']))),
                      DataCell(Text(document['balance'].toString())),
                      DataCell(Text(getAge(document['date']))),
                      DataCell(Text(convertEpox(document['date']).substring(0,16))),
                    ]);
                  }).toList());
                }
                              )
                            ),
                          ),
                        ),
                      ));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Obx(()=>Text(selectedInvNo.value.isNotEmpty?selectedInvNo.value:'Select Invoice',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ),
                    )),
                    decoration: BoxDecoration(
                      color: kGreenColor,
                      // borderRadius:
                      // BorderRadius.circular(15.0),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            PaymentMode(),
            SizedBox(height: 10,),
            TextField(
              onChanged: (value){
                amount=value;
              },
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*20,
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
            TextButton(
              onPressed: ()async {
                if(amountController.text==''){
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Enter the Amount"),
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
               else if(customerVendorController.text==''){
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Select a party name"),
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
                  int invNo;
                  List yourItemsList1=[];
                  int date=DateTime.now().millisecondsSinceEpoch;
                  if(selectedType=='Receipt') {
                    if(selectedInvNo.value.isNotEmpty){
                      firebaseFirestore.collection('invoice_data').doc(selectedInvNo.value).update({
                        "balance":FieldValue.increment(-(double.parse(amount))),
                      });
                    }
                    invNo=await getLastInv('receipt');
                    yourItemsList1.add({
                      "invNo":"$receiptPrefix$invNo",
                      "date":date,
                      "payment":receiptSelectedPayment,
                      "total":double.parse(amount),
                      "type":'Receipt',
                      "referenceInv":selectedInvNo.value,
                    });
                    String body='$receiptPrefix$invNo~$date~$receiptSelectedPayment~${double.parse(amount)}~$selected~$currentUser~${selectedInvNo.value}';
                   await create(selected, 'customer_report', yourItemsList1);
                    updateReport(selected, amount, 'customer_details',getCustomerUid(selected),getCustomerBalance(selected),'receipt');
                    create(body, 'receipt_data', yourItemsList1);
                    updateInv('receipt',invNo+1);
                  }
                  else{
                    if(selectedInvNo.value.isNotEmpty){
                      firebaseFirestore.collection('purchase').doc(selectedInvNo.value).update({
                        "balance":FieldValue.increment(-(double.parse(amount))),
                      });
                    }
                    invNo=await getLastInv('payment');
                    yourItemsList1.add({
                      "invNo":"$paymentPrefix$invNo",
                      "date":date,
                      "payment":receiptSelectedPayment,
                      "total":double.parse(amount),
                      "type":'Payment',
                      "referenceInv":selectedInvNo.value,
                    });
                    String body='$paymentPrefix$invNo~$date~$receiptSelectedPayment~${double.parse(amount)}~$selected~$currentUser~${selectedInvNo.value}';
                   await create(selected, 'vendor_report', yourItemsList1);
                    updateReport(selected, amount, 'vendor_data','',getVendorBalance(selected),'payment');
                    create(body, 'payment_data', yourItemsList1);
                    updateInv('payment',invNo+1);
                  }
                  amountController.clear();
                  customerVendorController.clear();
                  netBalanceController.clear();
                  noteController.clear();
                  selectedInvNo.value='';
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Status"),
                        content: Text("Transaction completed"),
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
}
class PaymentMode extends StatefulWidget {
  @override
  _PaymentModeState createState() => _PaymentModeState();
}

class _PaymentModeState extends State<PaymentMode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: kAppBarItems,
            style: BorderStyle.solid,
            width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            isDense: false,
            value: receiptSelectedPayment, // Not necessary for Option 1
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
                receiptSelectedPayment = newValue;
              });
            },
          ),
        ),
      ),
    );
  }
}
String dateNow(){
  final now = DateTime.now();
  final formatter = DateFormat('MM/dd/yyyy H:m');
  final String timestamp = formatter.format(now);
  return timestamp;
}
void customerVendorReport(String name,tempBody){
  // if(customerList.contains(name)){
  //     if(customerReport==null){
  //         customerReport='$name*$tempBody^';
  //     }
  //     else if(customerReport.contains('$name')){
  //         int ind1  = customerReport.indexOf(name);
  //         int ind2=customerReport.indexOf('^',ind1);
  //         String customerBlock=customerReport.substring(ind1,ind2);
  //         customerBlock=customerBlock+tempBody;
  //         customerBlock+='^';
  //         String beginningString=customerReport.substring(0,ind1);
  //         String endString=customerReport.substring(ind2+1,customerReport.length);
  //         customerReport=beginningString+customerBlock+endString;
  //     }
  //     else{
  //         String customerBlock='$name*$tempBody^';
  //         customerReport+=customerBlock;
  //     }
  //     allFile.writeFile(customerReport, 'customer_report');
  // }
  // else{
  //     if(vendorReport==null){
  //         vendorReport='$name*$tempBody^';
  //     }
  //     else if(vendorReport.contains('$name')){
  //         int ind1  = vendorReport.indexOf(name);
  //         int ind2=vendorReport.indexOf('^',ind1);
  //         String vendorBlock=vendorReport.substring(ind1,ind2);
  //         vendorBlock=vendorBlock+tempBody;
  //         vendorBlock+='^';
  //         String beginningString=vendorReport.substring(0,ind1);
  //         String endString=vendorReport.substring(ind2+1,vendorReport.length);
  //         vendorReport=beginningString+vendorBlock+endString;
  //     }
  //     else{
  //         String vendorBlock='$name*$tempBody^';
  //         vendorReport+=vendorBlock;
  //     }
  //     allFile.writeFile(vendorReport, 'vendor_report');
  // }
}
String convertEpox(int val){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
  return date.toString();
}
String getAge(int val){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
  DateTime date2 = DateTime.now();
  var diff=date2.difference(date).inDays;
  return diff.toString();
}