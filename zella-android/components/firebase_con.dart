import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/screen/admin_screen.dart' as ad;
import 'package:restaurant_app/screen/login_page.dart';
import 'package:restaurant_app/screen/organisation_screen.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
import 'package:restaurant_app/screen/stock_transfer.dart';
import 'package:restaurant_app/screen/waiter_screen.dart';
import 'package:get/get.dart';
List<int> invNo=[];
Rx<List<String>> uom123 = RxList<String>([]).obs;
Rx<List<String>> price123 = RxList<String>([]).obs;
List<String> customerVatNo=[];
List<String> mainPaymentList=['Cash','Card','Credit','UPI','EFT'];
List<String> allProductsImages1=[];
List<String> allProductsImages2=[];
List<String> allBranch=[];
List<String> tempUserList=[];
List<String> vendorVatNo=[];
List<String> allCustomerMobile=[];
List<String> allCustomerAddress=[];
List<String> customerUidList = [];
List<String> deliveryBoyList = [];
List<String> warehouseList = [];
List<String> allSalableProducts = [];
List<String> allPrinterType = [];
List<String> allPrinterIp = [];
List<String> allPurchasableProducts = [];
String selectedWarehouse='';
String organisationName='';
String organisationAddress='';
String organisationMobile='';
String organisationGstNo='';
String organisationSymbol='';
String organisationTaxType='';
String organisationTaxTitle='';
String organisationDiscount='';
String organisationInvPrint='';
String organisationCallCenter='';
String orgInvoiceEdit='';
String orgComposite='';
String orgCall='';
String orgMultiLine='';
String orgQrCodeIs='';
String orgClosedHour='';
String orgWaiterIs='';
FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
extension FirestoreQueryExtension on Query {
  Future<QuerySnapshot> getSavyQuery() async {
    try {
      QuerySnapshot qs = await this.get(GetOptions(source: Source.cache));
      if (qs.docs.isEmpty) return this.get(GetOptions(source: Source.server));
      return qs;
    } catch (_) {
      return this.get(GetOptions(source: Source.server));
    }
  }
}
extension FirestoreDocumentExtension on DocumentReference {
  Future<DocumentSnapshot> getSavy() async {
    try {
      DocumentSnapshot ds = await this.get(GetOptions(source: Source.cache));
      if (ds == null) return this.get(GetOptions(source: Source.server));
      return ds;
    } catch (_) {
      return this.get(GetOptions(source: Source.server));
    }
  }
}
Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('www.google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
Future<bool> checkIfDocExists(String docId,String collection) async {
  try {
    // Get reference to Firestore collection
    var collectionRef =firebaseFirestore.collection(collection);

    var doc = await collectionRef.doc(docId).get();
    return doc.exists;
  } catch (e) {
    throw e;
  }
}
Future<bool> checkIfFieldExists(String docId,String collection,String field) async {
  try {
    // Get reference to Firestore collection
    DocumentSnapshot collectionRef =await firebaseFirestore.collection(collection).doc(docId).get();
    Map<String, dynamic> map = collectionRef.data();
    if(map.containsKey(field)){
      return true;
    }
    return false;
  } catch (e) {
    throw e;
  }
}
List getBluetoothPrinter(){
  List temp=[];
  for(int i=0;i<allPrinterIp.length;i++){
    if(allPrinterType[i]=='Bluetooth')
      temp.add(allPrinterIp[i]);
  }
  return temp;
}
List getNetworkPrinter(){
  List temp=[];
  for(int i=0;i<allPrinterIp.length;i++){
    if(allPrinterType[i]=='Network')
      temp.add(allPrinterIp[i]);
  }
  return temp;
}
Future read(String collectionName)async {
  if(collectionName=='uom_data'){
    uomList=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        uomList.add(result.get('uomName'));
      });
    });
  }
  else if(collectionName=='main_paymentList'){
    mainPaymentList=['Cash','Card','Credit','UPI','EFT'];
    await firebaseFirestore.collection(collectionName).get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        mainPaymentList.add(result.get('paymentMode'));
      });
    });
  }
  else if(collectionName=='branch_data'){
    allBranch=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        allBranch.add(result.get('name'));
      });
    });
  }
  else if(collectionName=='kotOrders'){
    kotOrderList=[];
    await firebaseFirestore.collection("kot_order").where('user',isEqualTo: currentUser).get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        List temp=[];
        temp=result.get('cartList');
        for(int i=0;i<temp.length;i++){
          temp[i]=temp[i].toString().replaceAll(',', '#');
        }
        String body='${result.get('orderNo')}~${result.get('date')}~${result.get('tableNo')}~${result.get('customer')}~${result.get('priceList')}~${result.get('user')}~${result.get('note')}~${result.get('type')}~$temp';
        kotOrderList.add(body);

      });
    });
  }
  else if(collectionName=='deliverBoy_data'){
    deliveryBoyList=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        deliveryBoyList.add(result.get('userName').toString().trim());
      });
    });
  }
  else if(collectionName=='modifier_data'){
    modifier=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        modifier.add(result.get('modifier'));
      });
    });
  }
  else  if(collectionName=='sequence'){
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        sequenceData=result.get('data');
      });
    });
  }
  else if(collectionName=='category_data'){
    productCategoryF = [];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        productCategoryF.add(result.get('categoryName'));
      });
    });
    lastSelectedCategory=productCategoryF.isNotEmpty?productCategoryF[0]:'';//selectedCategory=productCategoryF.isNotEmpty?productCategoryF[0]:'';
  }
  else if(collectionName=='customer_details'){
    customerFirstSplit = [];
    customerList = [];
    customerPriceList = [];
    customerBalanceList=[];
    allCustomerMobile=[];
    allCustomerAddress=[];
    customerVatNo=[];
    customerUidList=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        customerList.add(result.get('customerName'));
        customerPriceList.add(result.get('priceList'));
        customerVatNo.add(result.get('vat'));
        customerBalanceList.add(result.get('balance'));
        allCustomerMobile.add(result.get('mobile'));
        allCustomerAddress.add(result.get('address'));
        customerUidList.add(result.id);
      });
    });
    // customerList.isNotEmpty?selectedCustomer=customerList[0]:selectedCustomer='';
    customerList.isNotEmpty?selectedPriceList=customerPriceList[0]:selectedPriceList='';
//     var collectionRef =firebaseFirestore.collection('customer_report');
// for(int i=0;i<customerList.length;i++){
//   var doc = await collectionRef.doc(customerList[i]).get();
// }
  }
  else if(collectionName=='vendor_data'){
    vendorFirstSplit=[];
    vendorList = [];
    vendorPriceList = [];
    vendorBalanceList=[];
    vendorVatNo=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        vendorList.add(result.get('vendorName'));
        vendorPriceList.add(result.get('priceList'));
        vendorVatNo.add(result.get('vat'));
        vendorBalanceList.add(result.get('balance'));
      });
    });
    //vendorList.isNotEmpty?selectedVendor=vendorList[0]:selectedVendor='';
    vendorList.isNotEmpty?selectedVendorPriceList=vendorPriceList[0]:selectedVendorPriceList='';
  }
  else if(collectionName=='organisation'){
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        organisationData=result.get('data');
      });
    });
    List temp=organisationData.split('~');

    decimals=int.parse(temp[7]);
    selectedBusiness=temp[1].toString().trim();
    selectedScreen=temp[8].toString().trim();
    organisationName=temp[0].toString().trim();
    organisationAddress=temp[2].toString().trim();
    organisationMobile=temp[3].toString().trim();
    organisationGstNo=temp[4].toString().trim();
    organisationSymbol=temp[6].toString().trim();
    organisationTaxType=temp[9].toString().trim();
    organisationTaxTitle=temp[10].toString().trim();
    organisationDiscount=temp[11].toString().trim();
    organisationInvPrint=temp[11].toString().trim();
    organisationCallCenter=temp[12].toString().trim();
    orgInvoiceEdit=temp[13].toString().trim();
    orgCall=temp[14].toString().trim();
    orgMultiLine=temp[15].toString().trim();
    orgQrCodeIs=temp[16].toString().trim();
    orgComposite=temp[17].toString().trim();
    orgClosedHour=temp[18].toString().trim();
    orgWaiterIs=temp[19].toString().trim();
  }
  else if(collectionName=='printer_data'){
    allPrinter=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        allPrinter.add(result.get('printerName'));
        allPrinterType.add(result.get('type'));
        allPrinterIp.add(result.get('ip'));
      });
    });
    await firebaseFirestore.collection("$collectionName").where('default',isEqualTo: 'true').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        defaultPrinter=result.get('printerName');
        defaultIpAddress=result.get('ip');
        defaultPort=result.get('port');
      });
    });
  }
  else if(collectionName=='kot_data'){
    kotCategory=[];
    kotPrinter=[];
    kotPrinterIpAddress=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        kotCategory.add(result.get('category'));
        kotPrinter.add(result.get('printer'));
        kotPrinterIpAddress.add(result.get('ip'));
      });
    });
  }
  else if(collectionName=='product_data'){
    String temp='';
    allProducts = [];
    allProductsImages1 = [];
    allProductsImages2 = [];
    allSalableProducts = [];
    allPurchasableProducts = [];
    productFirstSplit=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.get('provision')=='Salable'){
          allSalableProducts.add(result.get('itemName'));
          allProductsImages1.add(result.get('image'));
        }
        else if(result.get('provision')=='Purchasable'){
          allPurchasableProducts.add(result.get('itemName'));
          allProductsImages2.add(result.get('image'));
        }
        else{
          allSalableProducts.add(result.get('itemName'));
          allPurchasableProducts.add(result.get('itemName'));
          allProductsImages1.add(result.get('image'));
          allProductsImages2.add(result.get('image'));
        }
        allProducts.add(result.get('itemName').trim());
        List docLength=result.data().toString().split(',');
        if(docLength.length==12){
          temp='${result.get('itemName').trim()}:${result.get('category')}:${result.get('itemCode')}:${result.get('barcodeType')}:${result.get('uom')}:${result.get('tax')}:${result.get('discount')}:${result.get('image')}:${result.get('provision')}:${result.get('bom')}:${result.get('isCombo')}:${result.get('combo')}';
        }
        else{
          temp='${result.get('itemName').trim()}:${result.get('category')}:${result.get('itemCode')}:${result.get('barcodeType')}:${result.get('uom')}:${result.get('tax')}:${result.get('discount')}:${result.get('image')}:${result.get('provision')}:${result.get('bom')}:false:';
        }
        productFirstSplit.add(temp);
      });
    });
    // for(int i=0;i<allProducts.length;i++){
    //   String stockDetails=await readStock(allProducts[i]);
    // }
  }
  else if(collectionName=='tax_data'){
    taxNameList=[];
    percentageList=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        taxNameList.add(result.get('taxName'));
        percentageList.add(result.get('percentage'));
      });
    });
    // tax=taxNameList.isNotEmpty?taxNameList[0]:'';
  }
  else if(collectionName=='user_data'){
    userList=[];
    passwordList=[];
    terminalList=[];
    userPrefixList=[];
    tempUserList=['*'];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        userList.add(result.get('userName'));
        passwordList.add(result.get('password'));
        terminalList.add(result.get('terminal'));
        userPrefixList.add(result.get('prefix'));
      });
    });
    tempUserList.addAll(userList);
  }
  else if(collectionName=='expense_head'){
    expenseFirstSplit=[];
    expenseList=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        expenseList.add(result.get('expense'));
        expenseFirstSplit.add('${result.get('expense')}~${result.get('vatNo')}~${result.get('vatName')}');
      });
    });
  }
  else if(collectionName=='warehouse'){
    warehouseList=[];
    await firebaseFirestore.collection(collectionName).get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        warehouseList.add(result.id);
      });
    });
    selectedWarehouse=warehouseList.isNotEmpty?warehouseList[0]:'';
  }
}
String checkIfBomExist(String name){
  for(int i=0;i<productFirstSplit.length;i++){
    List temp=productFirstSplit[i].split(':');
    if(temp[0]==name){
      //List temp=productFirstSplit[i].split(':');
      // List tempBom=temp[temp.length-1].split('``');
      // List tempBomSplit=tempBom[0].toString().split('*');
      // tempBomSplit.removeLast();
      return temp[temp.length-3];
    }
  }
  return '';
}
String getCustomerUid(String name){
  if(name.isNotEmpty){
    int pos = customerList.indexOf(name);
    return customerUidList[pos];
  }
  return '';
}
String getCustomerBalance(String name){
  if(name.isNotEmpty){
    int pos = customerList.indexOf(name);
    return customerBalanceList[pos];
  }
  return '';
}
String getVendorBalance(String name){
  if(name.isNotEmpty){
    int pos = vendorList.indexOf(name);
    return vendorBalanceList[pos];
  }
  return '';
}
Future addTable(String table,String orders,String orderNo)async{
  if(table.contains('~')){
    List temp=table.split('~');
    for(int i=0;i<temp.length;i++){
      firebaseFirestore.collection('table_data').doc(temp[i].toString().trim()).update({
        "orders":'$orderNo',
      });
    }
  }
  else if(orders.isEmpty){
    firebaseFirestore.collection('table_data').doc(table).update({
      "orders":'$orderNo',
    });
  }
  else{
    orders+='~$orderNo';
    firebaseFirestore.collection('table_data').doc(table).update({
      "orders":'$orders',
    });
  }
}
Future removeTable(String table,String orderNo)async{
  if(table.contains('~')){
    List temp=table.split('~');
    for(int i=0;i<temp.length;i++){
      firebaseFirestore.collection('table_data').doc(temp[i].toString().trim()).update({
        "orders":'',
        "merged":false
      });
    }
  }
  else{
    DocumentSnapshot documentSnapshot=await firebaseFirestore.collection('table_data').doc(table).get();
    String orders=documentSnapshot['orders'];
    if(orders.contains('~')) {
      List temp = orders.split('~');
      int pos=temp.indexOf(orderNo);
      temp.removeAt(pos);
      String finalTemp='';
      for(int i=0;i<temp.length;i++){
        finalTemp+=temp[i].toString().trim();
        if(i!=temp.length-1)
          finalTemp+='~';
      }
      firebaseFirestore.collection('table_data').doc(table).update({
        "orders":finalTemp,
      });
    }
    else{
      firebaseFirestore.collection('table_data').doc(table).update({
        "orders":'',
      });
    }
  }
}
Future warehouseProduct(String warehouse)async{
  warehouseProducts.value=[];
  await firebaseFirestore.collection('warehouse').doc(warehouse).get().then((DocumentSnapshot) {
    DocumentSnapshot.data().forEach((key, value) {
      warehouseProducts.add(key);
    });
  });
}
Future updateStock(String body)async{
  List temp=body.split('~');
  firebaseFirestore.collection('stock').doc(temp[0]).update({
    "item":temp[0],
    "qty":temp[1],
    "cost":temp[2],
    "value":temp[3],
  }).then((_) {
  });
}
Future updateWarehouse(String name,String qty,String type)async{
  if(type=='purchase' || type=='salesReturn'){
    if(currentWarehouse.length>0) {
      firebaseFirestore.collection('warehouse').doc(currentWarehouse).update({
        "$name": FieldValue.increment(double.parse(qty)),
      }).then((_) {
      });
    }
  }
  else{
    if(currentWarehouse.length>0){
      firebaseFirestore.collection('warehouse').doc(currentWarehouse).update({
        "$name":FieldValue.increment(-(double.parse(qty))),
      }).then((_) {
      });
    }
  }

}
Future stockTransfer(String name,String qty,String w1,String w2)async{
  firebaseFirestore.collection('warehouse').doc(w2).update({
    "$name":FieldValue.increment(double.parse(qty)),
  }).then((_) {
  });
  firebaseFirestore.collection('warehouse').doc(w1).update({
    "$name":FieldValue.increment(-(double.parse(qty))),
  }).then((_) {
  });
}
Future<String> readStock(String name)async{
  String temp;
  await firebaseFirestore.collection("stock").where('item',isEqualTo: name).get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      temp='${result.get('item')}~${result.get('qty')}~${result.get('cost')}~${result.get('value')}';
    });
  });
  return temp;
}
Future update(String collection,List items,String orderNo)async{
  if(collection=='kot_order'){
    await firebaseFirestore.collection(collection).doc(orderNo).update({
      'cartList': FieldValue.arrayUnion(items),
    }).then((_) {
    });
  }
}
Future updateReport(String name,String amount,String collection,String uid,String balance,String type)async{
  if(collection=='customer_details'){
    double tempBalance;
    if(type=='sales'){
      tempBalance=double.parse(balance.isNotEmpty?balance:'0')+double.parse(amount);
    }
    else{
      tempBalance=double.parse(balance.isNotEmpty?balance:'0')-double.parse(amount);
    }
    int pos = customerList.indexOf(name);
    customerBalanceList[pos]=tempBalance.toString();
    await firebaseFirestore.collection(collection).doc(uid).update({
      "balance":tempBalance.toString(),
    }).then((_) {
    });
  }
  else{
    double tempBalance;
    if(type=='purchase'){
      tempBalance=double.parse(balance.isNotEmpty?balance:'0')+double.parse(amount);
    }
    else{
      tempBalance=double.parse(balance.isNotEmpty?balance:'0')-double.parse(amount);
    }
    int pos = vendorList.indexOf(name);
    vendorBalanceList[pos]=tempBalance.toString();
    await firebaseFirestore.collection(collection).doc(name).update({
      "balance":tempBalance.toString(),
    }).then((_) {
    });
  }
}
Future create(String body,String collectionName,List items)async{
  if (collectionName == 'invoice_data') {
    List temp = body.split('~');
    try{
      firebaseFirestore
          .collection("$collectionName")
          .doc('${temp[0].toString().trim()}')
          .set({
        'orderNo': temp[0].toString().trim(),
        'date': DateTime.now().millisecondsSinceEpoch,
        'customer': temp[2].toString().trim(),
        'cartList': items,
        'payment':temp[3].toString().trim(),
        'deliveryType': temp[4].toString().trim(),
        'total': temp[5].toString().trim(),
        'transactionType': temp[6].toString().trim(),
        'user': temp[7].toString().trim(),
        'kotNumber': temp[8].toString().trim(),
        'createdBy': temp[9].toString().trim(),
        'balance': double.parse(temp[10].toString().trim()),
        'deliveryBoy': temp[11].toString().trim(),
        'discount': temp[12].toString().trim(),
        'uid': '',
        'textFile':false,
      }).then((_) {
      });
    }
    on FirebaseException catch (e) {
      // Caught an exception from Firebase.
    }
  }
  else if(collectionName=='stock_transfer'){
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': DateTime.now().millisecondsSinceEpoch,
      'fromWarehouse': temp[1].toString().trim(),
      'toWarehouse':temp[2].toString().trim(),
      'user': temp[3].toString().trim(),
      'cartList': items,
    }).then((_) {
    });
  }
  else if (collectionName == 'item_report') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc()
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': DateTime.now().millisecondsSinceEpoch,
      'name': temp[1].toString().trim(),
      'uom':temp[2].toString().trim(),
      'qty': temp[3].toString().trim(),
      'price': temp[4].toString().trim(),
      'category': temp[5].toString().trim(),
      'itemTax': temp[6].toString().trim(),
      'taxPercent': temp[7].toString().trim(),
      'taxAmt': temp[8].toString().trim(),
      'lineTotal': temp[9].toString().trim(),
      'deliveryType': temp[10].toString().trim(),
    }).then((_) {
    });
  }
  else if (collectionName == 'receipt_data') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': int.parse(temp[1].toString().trim()),
      'payment': temp[2].toString().trim(),
      'total': temp[3].toString().trim(),
      'partyName': temp[4].toString().trim(),
      'user': temp[5].toString().trim(),
      'referenceInv': temp[6].toString().trim(),
    }).then((_) {
    });
  }
  else if (collectionName == 'payment_data') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': int.parse(temp[1].toString().trim()),
      'payment': temp[2].toString().trim(),
      'total': temp[3].toString().trim(),
      'partyName': temp[4].toString().trim(),
      'user': temp[5].toString().trim(),
      'referenceInv': temp[6].toString().trim(),
    }).then((_) {
    });
  }
  else if (collectionName == 'customer_report') {
    bool docExists = await checkIfDocExists(body,'customer_report');
    if(docExists){
      DocumentSnapshot documentSnapshot=await firebaseFirestore.collection(collectionName).doc(body).get();
      List tempData=documentSnapshot.get('data');
      tempData.add(items[0]);
      firebaseFirestore
          .collection("$collectionName")
          .doc(body)
          .update({
        'data': tempData,
      }).then((_) {
      });
    }
    else{
      firebaseFirestore
          .collection("$collectionName")
          .doc(body)
          .set({
        'data': items,
      }).then((_) {
      });
    }
  }
  else if (collectionName == 'vendor_report') {
    bool docExists = await checkIfDocExists(body,'vendor_report');
    if(docExists){
      DocumentSnapshot documentSnapshot=await firebaseFirestore.collection(collectionName).doc(body).get();
      List tempData=documentSnapshot.get('data');
      tempData.add(items[0]);
      firebaseFirestore
          .collection("$collectionName")
          .doc(body)
          .update({
        'data': tempData,
      }).then((_) {
      });
    }
    else{
      firebaseFirestore
          .collection("$collectionName")
          .doc(body)
          .set({
        'data': items,
      }).then((_) {
      });
    }
  }
  else if(collectionName=='kot_order'){
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': temp[1].toString().trim(),
      'tableNo': temp[2].toString().trim(),
      'customer': temp[3].toString().trim(),
      'priceList': temp[4].toString().trim(),
      'user': temp[5].toString().trim(),
      'note': temp[6].toString().trim(),
      'type': temp[7].toString().trim(),
      'cartList':items,
    }).then((_) {
    });
  }
  else if(collectionName=='vat_report'){
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': temp[1].toString().trim(),
      'partyName': temp[2].toString().trim(),
      'vatNo': temp[3].toString().trim(),
      'total': temp[4].toString().trim(),
      'taxable5': temp[5].toString().trim(),
      'tax5': temp[6].toString().trim(),
      'total5':temp[7].toString().trim(),
      'exempt': temp[8].toString().trim(),
      'typeStr': temp[9].toString().trim(),
    }).then((_) {
    });
  }
  else if(collectionName=='invoice_list'){
    List temp = body.split('#');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': DateTime.now().millisecondsSinceEpoch,
      'delivery': temp[2].toString().trim(),
      'total': temp[3].toString().trim(),
      'user': temp[4].toString().trim(),
      'table': temp[5].toString().trim(),
      'note': temp[6].toString().trim(),
      'cartList':items,
    }).then((_) {
    });
  }
  else if (collectionName == 'sales_return') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': DateTime.now().millisecondsSinceEpoch,
      'customer': temp[2].toString().trim(),
      'cartList': items,
      'payment':temp[3].toString().trim(),
      'total': temp[4].toString().trim(),
      'transactionType': temp[5].toString().trim(),
      'user': temp[6].toString().trim(),
      'discount':'0'
    }).then((_) {
    });
  }
  else if (collectionName == 'expense_transaction') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': DateTime.now().millisecondsSinceEpoch,
      'expense': temp[2].toString().trim(),
      'payment':temp[3].toString().trim(),
      'total': temp[4].toString().trim(),
      'note': temp[5].toString().trim(),
      'transactionType': temp[6].toString().trim(),
      'user': temp[7].toString().trim(),
      'tax': temp[8].toString().trim(),
    }).then((_) {
    });
  }
  else if (collectionName == 'till_close') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[7].toString().trim()}${temp[8].toString().trim().toString().replaceAll('/', ':')}')
        .set({
      'user': temp[7].toString().trim(),
      'date': int.parse(temp[8].toString().trim()),
      'cashWithdrawn': temp[6].toString().trim(),
      'cashAvailable': temp[5].toString().trim(),
      'expense': temp[4].toString().trim(),
      'upiSales': temp[3].toString().trim(),
      'creditSales': temp[2].toString().trim(),
      'cashSales': temp[1].toString().trim(),
      'openingCash': temp[0].toString().trim(),
      'closingCash': temp[9].toString().trim(),
      'cardSales': temp[10].toString().trim(),
      'eftSales': temp[11].toString().trim(),
    }).then((_) {
    });
  }
  else if (collectionName == 'purchase_return') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': DateTime.now().millisecondsSinceEpoch,
      'vendor': temp[2].toString().trim(),
      'cartList': items,
      'payment':temp[3].toString().trim(),
      'total': temp[4].toString().trim(),
      'transactionType': temp[5].toString().trim(),
      'user': temp[6].toString().trim(),
      'discount':'0'
    }).then((_) {
    });
  }
  else if (collectionName == 'purchase') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'orderNo': temp[0].toString().trim(),
      'date': DateTime.now().millisecondsSinceEpoch,
      'vendor': temp[2].toString().trim(),
      'cartList': items,
      'payment':temp[3].toString().trim(),
      'total': temp[4].toString().trim(),
      'transactionType': temp[5].toString().trim(),
      'user': temp[6].toString().trim(),
      'balance': double.parse(temp[7].toString().trim()),
      'discount':'0'
    }).then((_) {
    });
  }
  else if (collectionName == 'customer_details') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc()
        .set({
      'customerName': temp[0].toString().trim(),
      'address': temp[1].toString().trim(),
      'mobile': temp[2].toString().trim(),
      'vat': temp[3].toString().trim(),
      'priceList': temp[4].toString().trim(),
      'balance': temp[5].toString().trim(),
      'flatNo': temp[6].toString().trim(),
      'buildNo': temp[7].toString().trim(),
      'roadNo': temp[8].toString().trim(),
      'blockNo': temp[9].toString().trim(),
      'area': temp[10].toString().trim(),
      'landmark': temp[11].toString().trim(),
      'note': temp[12].toString().trim(),
      'cart':[],
    }).then((_) {
    });
  }
  return;
}
Future updateInv(String transaction,int num)async{
  if(transaction=='sales'){
    await firebaseFirestore.collection("user_data").doc(currentUser).update(
        {
          "startFrom":FieldValue.increment(1)
        }
    );
  }
  else if(transaction=='kot'){
    await firebaseFirestore.collection("user_data").doc(currentUser).update(
        {
          "orderFrom":FieldValue.increment(1)
        }
    );
  }
  else{
    await firebaseFirestore.collection("count").doc('data').update(
        {
          "$transaction":num
        }
    );
  }
}
Future<int> getLastInv(String transaction) async {
  int inv=0;
  try{
    if(transaction=='sales'){
      DocumentSnapshot documentSnapshot=await firebaseFirestore.collection("user_data").doc(currentUser).getSavy();
      inv=documentSnapshot['startFrom'];
    }
    else if(transaction=='kot'){
      DocumentSnapshot documentSnapshot=await firebaseFirestore.collection("user_data").doc(currentUser).getSavy();
      inv=documentSnapshot['orderFrom'];
    }
    else{
      await firebaseFirestore.collection("count").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          inv=result.get(transaction);
        });
      });
    }
    return inv;
  }
  catch(e){
    print('error $e');
  }

}
String getBasePrice(String productName,String priceList){
  for(int i=0;i<productFirstSplit.length;i++){
    if(productFirstSplit[i].contains(productName)){

      List temp=productFirstSplit[i].split(':');
      List tempUom=temp[4].split('``');
      List tempUomSplit=tempUom[1].toString().split('*');
      String basePrice;
      if(tempUomSplit[0].toString().contains('>')){
        List tempPriceListSplit=tempUomSplit[0].toString().split('>');
        int pos=int.parse(selectedPriceList.substring(6));
        pos=pos-1;
        basePrice=tempPriceListSplit[pos];
      }
      else
        basePrice=tempUomSplit[0];

      return basePrice;
    }
  }
}
String getBaseUom(String productName){
  for(int i=0;i<productFirstSplit.length;i++){
    if(productFirstSplit[i].contains(productName)){
      List temp=productFirstSplit[i].split(':');
      List tempUom=temp[4].split('``');
      List tempUomSplit=tempUom[0].toString().split('*');
      return tempUomSplit[0].toString().trim();
    }
  }

}
void displayProducts(String categoryName)async{
  productNameF = [];
  productImages = [];
  price123.value = RxList<String>([]);
  uom123.value =RxList<String>([]);
  for(int i=0;i<productFirstSplit.length;i++){
    List tempSplit=productFirstSplit[i].toString().split(':');
    if(categoryName==tempSplit[1].toString().trim()){
      productNameF.add(tempSplit[0].toString().trim());
      price123.value.add(getBasePrice(tempSplit[0].toString().trim(), selectedPriceList));
      uom123.value.add(getBaseUom(tempSplit[0].toString().trim()));
      if(tempSplit[7]!='')
        productImages.add('https:${tempSplit[8].toString().trim()}');
      else
        productImages.add('');
    }
  }

}
List categoryProducts(String category){
  List temp=[];
  for(int i=0;i<productFirstSplit.length;i++){
    List tempSplit=productFirstSplit[i].toString().split(':');
    if(category==tempSplit[1].toString().trim()){
      temp.add(tempSplit[0].toString().trim());
    }
  }
  return temp;
}
Future displayAllProducts(String provision)async{
  productNameF = [];
  productImages = [];
  price123.value = RxList<String>([]);
  uom123.value =RxList<String>([]);
  if(provision=='Salable'){
    productNameF=allSalableProducts;
    productImages=allProductsImages1;
    for(int j=0;j<productNameF.length;j++){
      price123.value.add(getBasePrice(productNameF[j], selectedPriceList));
      uom123.value.add(getBaseUom(productNameF[j]));
    }
  }
  else if(provision=='Purchasable'){
    productNameF=allPurchasableProducts;
    productImages=allProductsImages2;
    for(int j=0;j<productNameF.length;j++){
      price123.value.add(getBasePrice(productNameF[j], selectedPriceList));
      uom123.value.add(getBaseUom(productNameF[j]));
    }
  }
  // await firebaseFirestore
  //     .collection("product_data")
  //     .orderBy('itemName', descending: true)
  //     .get()
  //     .then((querySnapshot) {
  //   querySnapshot.docs.forEach((result) {
  //     if(result.get('provision')==provision){
  //       print('inside iffffffff $provision');
  //       productNameF.add(result.get('itemName'));
  //       productImages.add(result.get('image'));
  //     }
  //     if(result.get('provision')=='Both'){
  //       productNameF.add(result.get('itemName'));
  //       productImages.add(result.get('image'));
  //     }
  //   });
  // });
  // return;
}