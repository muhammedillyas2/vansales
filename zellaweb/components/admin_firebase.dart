import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/screen/admin_screen.dart';
List<String> allCategoryList = [];
List<String> userLoginList = [];
List<String> taxNameList = [];
List<String> customerList=[];
List<String> vendorList=[];
List<String> modifierList=[];
List<String> warehouseList=[];
List<String> branchList=[];
List<String> percentageList = [];
List<String> allProducts = [];
List<String> floorList = [];
List productFirstSplit = [];
List<String> uomList = [];
List<String> allIp=[];
List<String> allNetwork=[];
List<String> allBluetooth=[];
String defaultPrinter='',defaultIpAddress='', defaultPort='';
RxString selectedFloor=''.obs;
List<String> allPrinter = [];
RxString productImage = ''.obs;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
String sequenceData = '';
List<String> addedCategoryList=[];
List<String> addedUomList=[];
List<String> addedTaxList=[];
Future<String> get _localPath async {
  final directory = await getApplicationSupportDirectory();

  return directory.path;
}
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/tx_data.csv');
}
Future<File> writeData(String csvData) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsString(csvData);
}
Future uploadCustomer(List name,List address,List flat,List bld,List block,List road,List area,List landmark,List note,List mobile,List gst,List balance,List priceList)async{
  for(int i=0;i<name.length;i++){
    firebaseFirestore
        .collection("customer_details")
        .doc()
        .set({
      'customerName': name[i],
      'address': address[i],
      'mobile': mobile[i],
      'vat': gst[i],
      'priceList': priceList[i],
      'balance': balance[i],
      'flatNo': flat[i],
      'buildNo': bld[i],
      'roadNo':road[i],
      'blockNo': block[i],
      'area':area[i],
      'landmark': landmark[i],
      'note': note[i],
    }).then((_) {
      print('success');
    });
  }
}
Future uploadData(List name,List category,List code,List barcode,List uom,List tax,List discount,List bom,List provision,List imageUrl,List stockQty,List costPrice)async{
  addedCategoryList=[];
  addedTaxList=[];
  for(int i=0;i<name.length;i++){
    if(!addedCategoryList.contains(category[i])){
      addedCategoryList.add(category[i]);
      firebaseFirestore.collection("category_data").doc('${category[i]}').set(
          {
            'categoryName': category[i],
          }).then((_){
        print('success');
      });
    }
    firebaseFirestore
        .collection("product_data")
        .doc()
        .set({
      'itemName': name[i],
      'category': category[i],
      'itemCode': code[i],
      'barcodeType': barcode[i],
      'uom': uom[i],
      'tax': tax[i],
      'discount':discount[i],
      'image': imageUrl[i],
      'bom': bom[i],
      'provision': provision[i],
      //'id':id
    }).then((_) {
      print('success');
    });
    if(double.parse(stockQty[i].toString())>0){
      double val=double.parse(stockQty[i].toString())*double.parse(costPrice[i].toString());
      firebaseFirestore
          .collection("stock")
          .doc(name[i])
          .set({
        'item': name[i],
        'qty': stockQty[i],
        'cost':costPrice[i],
        'value': val.toStringAsFixed(3),
      }).then((_) {
        print('success');
      });
    }
    else{
      firebaseFirestore
          .collection("stock")
          .doc(name[i])
          .set({
        'item': name[i],
        'qty': '0',
        'cost':'0',
        'value': '0',
      }).then((_) {
        print('success');
      });
    }

  }
  print('addedCategoryList $addedCategoryList');
}
Future uploadVendor(List name,List address,List mobile,List gst,List balance,List priceList)async{
for(int i=0;i<name.length;i++){
  firebaseFirestore
      .collection('vendor_data')
      .doc(name[i])
      .set({
    'vendorName': name[i],
    'address': address[i],
    'mobile': mobile[i],
    'vat': gst[i],
    'priceList':priceList[i],
    'balance': balance[i],
  }).then((_) {
    print('success');
  });
}
}
Future uploadExpense(List head,List tax,List gst,List balance)async{
  for(int i=0;i<head.length;i++){
    firebaseFirestore
        .collection("expense_head")
        .doc(head[i])
        .set({
      'expense': head[i],
      'vatNo': gst[i],
      'vatName': tax[i],
      'balance': balance[i],
    }).then((_) {
      print('success');
    });
  }
}
Future uploadInvoice(List balance,List cart,List created,List customer,List date,List dBoy,List dType,List discount,List kotNo,List orderNo,List payment,List total,List tType,List user)async{
  print('items 0th ${cart[0]}');
  // for(int i=0;i<balance.length;i++){
  //   firebaseFirestore
  //       .collection("invoice_data")
  //       .doc(orderNo[i])
  //       .set({
  //     'orderNo': orderNo[0],
  //     'date': int.parse(date[i]),
  //     'customer': customer[i],
  //     'cartList': FieldValue.arrayUnion(items),
  //     'payment':payment[i],
  //     'deliveryType': dType[i],
  //     'total': total[i],
  //     'transactionType': tType[i],
  //     'user': user[i],
  //     'kotNumber': kotNo[i],
  //     'createdBy': created[i],
  //     'balance': double.parse(balance[i].toString().trim()),
  //     'deliveryBoy': dBoy[i],
  //     'discount': discount[i],
  //   }).then((_) {
  //     print('success');
  //   });
  // }
}
Future create(String body, String collectionName) async {
  if (collectionName == 'product_data') {
    List temp = body.split('~');
    print('inside create product $temp');
    firebaseFirestore
        .collection("$collectionName")
        .doc()
        .set({
      'itemName': temp[0].toString().trim(),
      'category': temp[1].toString().trim(),
      'itemCode': temp[2].toString().trim(),
      'barcodeType': temp[3].toString().trim(),
      'uom': temp[4].toString().trim(),
      'tax': temp[5].toString().trim(),
      'discount': temp[6].toString().trim(),
      'image': temp[7].toString().trim(),
      'provision': temp[8].toString().trim(),
      'bom': temp[9].toString().trim(),
      'isCombo': temp[10].toString().trim(),
      'combo': temp[11].toString().trim(),
      //'id':id
    }).then((_) {
      print('success');
    });
  }
  else if(collectionName=='warehouse'){
    firebaseFirestore.collection(collectionName).doc(body).set({

    });
  }
  else if(collectionName=='main_paymentList'){
    firebaseFirestore.collection(collectionName).doc().set({
     "paymentMode":body,
    });
  }
  else if(collectionName=='branch_data'){
    firebaseFirestore.collection(collectionName).doc(body).set({
    "name":body,
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
      'roadNo':temp[8].toString().trim(),
      'blockNo': temp[9].toString().trim(),
      'area': temp[10].toString().trim(),
      'landmark': temp[11].toString().trim(),
      'note': temp[12].toString().trim(),
    }).then((_) {
      print('success');
    });
  }
  else if (collectionName == 'expense_head') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'expense': temp[0].toString().trim(),
      'vatNo': temp[1].toString().trim(),
      'vatName': temp[2].toString().trim(),
      'balance': temp[3].toString().trim(),
    }).then((_) {
      print('success');
    });
  }
  else if (collectionName == 'floor_data') {
    firebaseFirestore
        .collection("$collectionName")
        .doc(body)
        .set({
      'floorName': body,
    }).then((_) {
      print('success');
    });
  }
  else if (collectionName == 'table_data') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'tableName': '${temp[0].toString().trim()}',
      'area': temp[1].toString().trim(),
      'pax': temp[2].toString().trim(),
      'orders': '',
      'merged': false,
    }).then((_) {
      print('success');
    });
  }
  else if (collectionName == 'stock') {
    List temp = body.split('~');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'item': temp[0].toString().trim(),
      'qty': temp[1].toString().trim(),
      'cost': temp[2].toString().trim(),
      'value': temp[3].toString().trim(),
    }).then((_) {
      print('success');
    });
  }
  else if (collectionName == 'vendor_data') {
    List temp = body.split('~');
    print('inside vendor data $temp');
    firebaseFirestore
        .collection("$collectionName")
        .doc('${temp[0].toString().trim()}')
        .set({
      'vendorName': temp[0].toString().trim(),
      'address': temp[1].toString().trim(),
      'mobile': temp[2].toString().trim(),
      'vat': temp[3].toString().trim(),
      'priceList': temp[4].toString().trim(),
      'balance': temp[5].toString().trim(),
    }).then((_) {
      print('success');
    });
  }
  else if (collectionName == 'organisation') {
    print('org body $body');
    firebaseFirestore.collection("$collectionName").doc('data').set({'data': body,}).then((_) {
      print('success');
    });
  }
  else if(collectionName=='uom_data'){
    firebaseFirestore.collection("$collectionName").doc('$body').set(
        {
          'uomName': body,
        }).then((_){
      print('success');
    });
  }
  else if(collectionName=='modifier_data'){
    firebaseFirestore.collection("$collectionName").doc('$body').set(
        {
          'modifier': body,
        }).then((_){
      print('success');
    });
  }
  else if(collectionName=='sequence'){
    firebaseFirestore.collection("$collectionName").doc('data').set(
        {
          'data': body,
        }).then((_){
      print('success');
    });
  }
  else if(collectionName=='count'){
    print('inside counttttttttttttttttt');
    List temp = body.split('~');
    temp.removeLast();
    firebaseFirestore.collection("$collectionName").doc('data').set(
        {
          'sales': 1,
          'salesReturn': int.parse(temp[0].toString().trim()),
          'purchase': int.parse(temp[1].toString().trim()),
          'purchaseReturn': int.parse(temp[2].toString().trim()),
          'receipt': int.parse(temp[3].toString().trim()),
          'payment': int.parse(temp[4].toString().trim()),
          'expense': int.parse(temp[5].toString().trim()),
          'stock': int.parse(temp[6].toString().trim()),
          'kot': 1,
          'checkout': 1,
        }).then((_){
      print('success');
    });
  }
  else if(collectionName=='user_data'){
    List temp = body.split('~');
    print('inside createeeeeeeee $temp');
    firebaseFirestore.collection("$collectionName").doc( temp[0].toString().trim()).set(
        {
          'userName': temp[0].toString().trim(),
          'password': temp[1].toString().trim(),
          'terminal': temp[2].toString().trim(),
          'prefix': temp[3].toString().trim(),
          'tillClose':0,
          'startFrom': int.parse(temp[4].toString().trim()),
          'orderFrom': int.parse(temp[5].toString().trim()),
          'tillCloseDate': DateTime.now().millisecondsSinceEpoch,
          'warehouse':temp[6].toString().trim(),
          'printer':temp[7].toString().trim(),
          'branch':temp[8].toString().trim(),
          'discount':temp[9].toString().trim(),
          'priceEdit':temp[10].toString().trim(),
        }).then((_){
      print('success');
    });
  }
  else if(collectionName=='deliverBoy_data'){
    List temp = body.split('~');
    firebaseFirestore.collection("$collectionName").doc().set(
        {
          'userName': temp[0].toString().trim(),
          'password': temp[1].toString().trim(),
          'mobile': temp[2].toString().trim()
        }).then((_){
      print('success');
    });
  }
  else if(collectionName=='printer_data'){
    List temp = body.split('~');
    firebaseFirestore.collection("$collectionName").doc( temp[0].toString().trim()).set(
        {
          'printerName': temp[0].toString().trim(),
          'ip': temp[1].toString().trim(),
          'port': temp[2].toString().trim(),
          'default': temp[3].toString().trim(),
          'type': temp[4].toString().trim(),
        }).then((_){
      print('success');
    });
  }
  else if(collectionName=='tax_data'){
    List temp=body.split('~');
    firebaseFirestore.collection("$collectionName").doc(temp[0].toString().trim()).set(
        {
          'taxName': temp[0].toString().trim(),
          'percentage': temp[1].toString().trim(),
        }).then((_){
      print('success');
    });
  }
  else if(collectionName=='category_data'){
    firebaseFirestore.collection("$collectionName").doc('$body').set(
        {
          'categoryName': body,
        }).then((_){
      print('success');
    });
  }
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
  else if(collectionName=='branch_data'){
    branchList=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        addBranch++;
        branchController.add(TextEditingController(text: result.id));
        branchList.add(result.get('name'));
      });
    });
    selectedBranch=branchList.isNotEmpty?branchList[0]:'';
  }
  else if(collectionName=='user_data'){
    userLoginList=[];
    print('inside user');
    await firebaseFirestore.collection("$collectionName").where('terminal',isEqualTo: 'Admin-POS').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print('inside user');
        userLoginList.add(result.get('userName'));
      });
    });
  }
  else if(collectionName=='floor_data'){
    floorList=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        floorList.add(result.get('floorName'));
      });
    });
    selectedFloor.value=floorList.isNotEmpty?floorList[0]:'';
  }
  else  if(collectionName=='sequence'){
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        sequenceData=result.get('data');
      });
    });
  }
  else if(collectionName=='organisation'){
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        organisationData=result.get('data');
      });
    });
  }
  else if(collectionName=='warehouse'){
    print('inside warehouse read');
    warehouseList=[];
    await firebaseFirestore.collection(collectionName).get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        addWarehouse++;
        warehouseController.add(TextEditingController(text: result.id));
        warehouseList.add(result.id);
      });
    });
    selectedWarehouse=warehouseList.isNotEmpty?warehouseList[0]:'';
    print('warehouse 223322 $warehouseList');
  }
  else if(collectionName=='category_data'){
    allCategoryList=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        allCategoryList.add(result.get('categoryName'));
      });
    });
    selectedCategory=allCategoryList.isNotEmpty?allCategoryList[0]:'';
  }
  else if(collectionName=='printer_data'){
    allPrinter=[];
    allNetwork=[];
    allBluetooth=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        allPrinter.add(result.get('printerName'));
        allIp.add(result.get('ip'));
        if(result.get('type')=='Network'){
          allNetwork.add(result.get('printerName'));
        }
        else if(result.get('type')=='Bluetooth'){
          allBluetooth.add(result.get('printerName'));
        }
      });
    });

    await firebaseFirestore.collection("$collectionName").where('default',isEqualTo: 'true').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        defaultPrinter=result.get('printerName');
      });
    });
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
    tax=taxNameList.isNotEmpty?taxNameList[0]:'';
  }
  else if(collectionName=='product_data'){
    String temp='';
    allProducts = [];
    productFirstSplit=[];
    await firebaseFirestore.collection("$collectionName").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        allProducts.add(result.get('itemName'));
        temp='${result.get('itemName')}:${result.get('category')}:${result.get('itemCode')}:${result.get('barcodeType')}:${result.get('uom')}:${result.get('tax')}:${result.get('discount')}:${result.get('image')}';
        productFirstSplit.add(temp);
      });
    });
  }
}
