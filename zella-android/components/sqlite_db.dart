// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// Database _databaseSqLite;
// String databaseName;
// // List<String> userList=[];
// // List<String> passwordList=[];
// // List<String> terminalList=[];
// Future<Database>  database(String name) async {
//   databaseName=name;
//   if (_databaseSqLite != null) return _databaseSqLite;
//   // lazily instantiate the db the first time it is accessed
//   _databaseSqLite = await _initDatabase(name);
//   return _databaseSqLite;
// }
// _initDatabase(String name) async {
//   Directory documentsDirectory = await getExternalStorageDirectory();
//   String path = join(documentsDirectory.path, '$name.db');
//   return await openDatabase(path,
//     version: 1,
//   );
// }
// // SQL code to create the database table
// Future _onCreate(Database db,String tableName) async {
//   if (tableName == 'companyDetails') {
//     await db.execute('DROP TABLE companyDetails');
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,organisationName TEXT,typeOfBusiness TEXT,address TEXT,mobileNo TEXT,VATGSTNO TEXT,currency TEXT,symbol TEXT,decimals INTEGER)");
//   }
//   else if (tableName == 'profileData') {
//     await db.execute('DROP TABLE profileData');
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(customerName TEXT,address TEXT)");
//   }
//   else if (tableName == 'customer_data') {
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,customerName TEXT,address TEXT,mobileNo TEXT,VATNO TEXT,selectedPrice TEXT,customerBalance TEXT)");
//   }
//   else if (tableName == 'vendor_data') {
//     // await db.execute('DROP TABLE $tableName');
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,vendorName TEXT,address TEXT,mobileNo TEXT,VATNO TEXT,selectedPrice TEXT)");
//   }
//   else if (tableName == 'product_data') {
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,itemName TEXT,category TEXT,itemCode TEXT,barcodeType TEXT,uom TEXT,tax TEXT,discount TEXT)");
//   }
//   else if (tableName == 'sequence_manager') {
//     await db.execute('DROP TABLE sequence_manager');
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,sales varchar(10),salesReturn varchar(10),purchase varchar(10),purchaseReturn varchar(10),receipt varchar(10),payment varchar(10),expense varchar(10))");
//   }
//   else if (tableName == 'category_data') {
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,categoryName TEXT,sequence TEXT,count TEXT)");
//   }
//   else if (tableName == 'uom_data') {
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,uomName TEXT,decimal TEXT)");
//   }
//   else if (tableName == 'user_data') {
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,userName TEXT,password TEXT,terminal Text)");
//   }
//   else if (tableName == 'invoice_data') {
//     // await db.execute('DROP TABLE $tableName');
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,customerName TEXT,items TEXT,payment TEXT,delivery TEXT,total TEXT,type TEXT)");
//   }
//   else if (tableName == 'receipt' || tableName == 'payment') {
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,${tableName == 'receipt' ? 'customerName' : 'vendorName'} TEXT,paymentType TEXT,amount TEXT,type TEXT,note TEXT)");
//   }
//   else if (tableName == 'sales_return') {
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,customerName TEXT,items TEXT,payment TEXT,delivery TEXT,total TEXT,type TEXT)");
//   }
//   else if (tableName == 'purchase') {
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,vendorName TEXT,items TEXT,payment TEXT,total TEXT,type TEXT)");
//   }
//   else if (tableName == 'purchase_return') {
//     return await db.execute(
//         "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,vendorName TEXT,items TEXT,payment TEXT,total TEXT,type TEXT)");
//   }
//   // return;
// }
// Future insertDataSqLite(String body, String tableName) async {
//   List tempSplit = body.split(':');
//   if(tableName=='companyDetails')
//   {
//     await  _onCreate(_databaseSqLite, "companyDetails");
//     Map<String,dynamic> row={
//       'organisationName':tempSplit[0],
//       'typeOfBusiness':tempSplit[1],
//       'address':tempSplit[2],
//       'mobileNo':tempSplit[3],
//       'VATGSTNO':tempSplit[4],
//       'currency':tempSplit[5],
//       'symbol':tempSplit[6],
//       'decimals':tempSplit[7]
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='profileData')
//   {
//     await  _onCreate(_databaseSqLite, "profileData");
//     Map<String,dynamic> row={
//       'customerName':tempSplit[0],
//       'address':tempSplit[1],
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='invoice_data')
//   {
//     List tempBody=body.split('-');
//     tempBody.removeLast();
//     print('tempBody $tempBody');
//     await  _onCreate(_databaseSqLite, "invoice_data");
//     Map<String,dynamic> row={
//       'invoiceNo':tempBody[0],
//       'date':tempBody[1],
//       'customerName':tempBody[2],
//       'items':tempBody[3],
//       'payment':tempBody[4],
//       'delivery':tempBody[5],
//       'total':tempBody[6],
//       'type':tempBody[7],
//       // 'tax':tempBody[8]
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='sales_return')
//   {
//     List tempBody=body.split('-');
//     print('tempBody $tempBody');
//     await  _onCreate(_databaseSqLite, "sales_return");
//     Map<String,dynamic> row={
//       'invoiceNo':tempBody[0],
//       'date':tempBody[1],
//       'customerName':tempBody[2],
//       'items':tempBody[3],
//       'payment':tempBody[4],
//       'delivery':tempBody[5],
//       'total':tempBody[6],
//       'type':tempBody[7],
//       // 'tax':tempBody[8]
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='purchase')
//   {
//     List tempBody=body.split('-');
//     print('tempBody $tempBody');
//     await  _onCreate(_databaseSqLite, "purchase");
//     Map<String,dynamic> row={
//       'invoiceNo':tempBody[0],
//       'date':tempBody[1],
//       'vendorName':tempBody[2],
//       'items':tempBody[3],
//       'payment':tempBody[4],
//       'total':tempBody[5],
//       'type':tempBody[6],
//       // 'tax':tempBody[8]
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='receipt' || tableName=='payment')
//   {
//     List tempBody=body.split('-');
//     print('tempBody $tempBody');
//     await  _onCreate(_databaseSqLite, tableName);
//     Map<String,dynamic> row={
//       'invoiceNo':tempBody[0],
//       'date':tempBody[1],
//       '${tableName == 'receipt' ? 'customerName' : 'vendorName'}':tempBody[2],
//       'paymentType':tempBody[3],
//       'amount':tempBody[4],
//       'type':tempBody[5],
//       'note':tempBody[6],
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='purchase_return')
//   {
//     List tempBody=body.split('-');
//     print('tempBody $tempBody');
//     await  _onCreate(_databaseSqLite, "purchase_return");
//     Map<String,dynamic> row={
//       'invoiceNo':tempBody[0],
//       'date':tempBody[1],
//       'vendorName':tempBody[2],
//       'items':tempBody[3],
//       'payment':tempBody[4],
//       'total':tempBody[5],
//       'type':tempBody[6],
//       // 'tax':tempBody[8]
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='customer_data')
//   {
//     print('inside customer if');
//     await  _onCreate(_databaseSqLite, "customer_data");
//     Map<String,dynamic> row={
//       'customerName':tempSplit[0],
//       'address':tempSplit[1],
//       'mobileNo':tempSplit[2],
//       'VATNO':tempSplit[3],
//       'selectedPrice':tempSplit[4],
//       'customerBalance':tempSplit[5]
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='vendor_data')
//   {
//     await  _onCreate(_databaseSqLite, "vendor_data");
//     Map<String,dynamic> row={
//       'vendorName':tempSplit[0],
//       'address':tempSplit[1],
//       'mobileNo':tempSplit[2],
//       'VATNO':tempSplit[3],
//       'selectedPrice':tempSplit[4],
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='product_data')
//   {
//     await  _onCreate(_databaseSqLite, "product_data");
//     Map<String,dynamic> row={
//       'itemName':tempSplit[0],
//       'category':tempSplit[1],
//       'itemCode':tempSplit[2],
//       'barcodeType':tempSplit[3],
//       'uom':tempSplit[4],
//       'tax':tempSplit[5],
//       'discount':tempSplit[6]
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='category_data')
//   {
//     await  _onCreate(_databaseSqLite, "category_data");
//     Map<String,dynamic> row={
//       'categoryName':tempSplit[0],
//       'sequence':tempSplit[1],
//       'count':tempSplit[2]
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='uom_data')
//   {
//     await  _onCreate(_databaseSqLite, "uom_data");
//     Map<String,dynamic> row={
//       'uomName':tempSplit[0],
//       'decimal':tempSplit[1],
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='user_data')
//   {
//     await  _onCreate(_databaseSqLite, "user_data");
//     Map<String,dynamic> row={
//       'userName':tempSplit[0],
//       'password':tempSplit[1],
//       'terminal':tempSplit[2],
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   else if(tableName=='sequence_manager')
//   {
//     List tempBody=body.split('~');
//     tempBody.removeLast();
//     await  _onCreate(_databaseSqLite, "sequence_manager");
//     Map<String,dynamic> row={
//       'sales':tempBody[0],
//       'salesReturn':tempBody[1],
//       'purchase':tempBody[2],
//       'purchaseReturn':tempBody[3],
//       'receipt':tempBody[4],
//       'payment':tempBody[5],
//       'expense':tempBody[6]
//     };
//     print('row $row');
//     await _databaseSqLite.insert(tableName,row);
//   }
//   return;
// }
// Future updateDataSqLite(String body, String tableName,int id) async {
//   List tempSplit = body.split(':');
//   if(tableName=='customer_data')
//   {
//     print('inside customer if');
//     await  _onCreate(_databaseSqLite, "customer_data");
//     Map<String,dynamic> row={
//       'customerName':tempSplit[0],
//       'address':tempSplit[1],
//       'mobileNo':tempSplit[2],
//       'VATNO':tempSplit[3],
//       'selectedPrice':tempSplit[4],
//       'customerBalance':tempSplit[5]
//     };
//     print('row $row');
//     await _databaseSqLite.update(tableName,row,where: 'id=$id');
//   }
//   else if(tableName=='vendor_data')
//   {
//     await  _onCreate(_databaseSqLite, "vendor_data");
//     Map<String,dynamic> row={
//       'vendorName':tempSplit[0],
//       'address':tempSplit[1],
//       'mobileNo':tempSplit[2],
//       'VATNO':tempSplit[3],
//       'selectedPrice':tempSplit[4],
//     };
//     print('row $row');
//     await _databaseSqLite.update(tableName,row,where: 'id=$id');
//   }
//   else if(tableName=='product_data')
//   {
//     await  _onCreate(_databaseSqLite, "product_data");
//     Map<String,dynamic> row={
//       'itemName':tempSplit[0],
//       'category':tempSplit[1],
//       'itemCode':tempSplit[2],
//       'barcodeType':tempSplit[3],
//       'uom':tempSplit[4],
//       'tax':tempSplit[5],
//       'discount':tempSplit[6]
//     };
//     print('row $row');
//     await _databaseSqLite.update(tableName,row,where: 'id=$id');
//   }
//   else if(tableName=='category_data')
//   {
//     await  _onCreate(_databaseSqLite, "category_data");
//     Map<String,dynamic> row={
//       'categoryName':tempSplit[0],
//       'sequence':tempSplit[1],
//       'count':tempSplit[2]
//     };
//     print('row $row');
//     await _databaseSqLite.update(tableName,row,where: 'id=$id');
//   }
//   else if(tableName=='uom_data')
//   {
//     await  _onCreate(_databaseSqLite, "uom_data");
//     print('tempSplit $tempSplit');
//     Map<String,dynamic> row={
//       'uomName':tempSplit[0],
//       'decimal':tempSplit[1],
//     };
//     print('row $row');
//     await _databaseSqLite.update(tableName,row,where: 'id=$id');
//   }
//   return;
// }
// Future<List> getDataSqLite(String tableName)async{
//   List tempList;
//   if(tableName=='invoice_data'){
//     tempList=await _databaseSqLite.query(tableName);
//   }
//   if(tableName=='profileData'){
//     tempList=await _databaseSqLite.query(tableName);
//     print('tempList $tempList');
//   }
//   // else if(tableName=='user_data'){
//   //   try{
//   //     tempList=await _databaseSqLite.query(tableName);
//   //     List tempList1=[];
//   //     for(int i=0;i<tempList.length;i++){
//   //       tempList1.add(tempList[i].toString().substring(1,tempList[i].toString().length-1));
//   //     }
//   //     for(int i=0;i<tempList1.length;i++){
//   //       List temp=tempList1[i].toString().split(',');
//   //       temp.removeAt(0);
//   //       userList.add(temp[0].toString().substring(10).trim());
//   //       passwordList.add(temp[1].toString().substring(10).trim());
//   //       terminalList.add(temp[2].toString().substring(10).trim());
//   //     }
//   //     print('user $userList $passwordList $terminalList');
//   //   }
//   //   catch(e){
//   //     print(e);
//   //   }
//   // }
//   return tempList;
// }