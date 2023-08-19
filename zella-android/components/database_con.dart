import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/screen/login_page.dart';
import 'package:restaurant_app/screen/sequence_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import 'package:restaurant_app/screen/add_product.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
int decimals=0;
String check='not';
String bluetoothAddress='';
String defaultIpAddress, defaultPort;
List<String> taxNameList=[];
List<String> itemReport=[];
List<String> stockList=[];
List<String> percentageList=[];
List<double> dashBoardValues = [0, 0, 0, 0, 0, 0];
 List<String> waiterKotList = [];
List<String> kotCategory = [];
List<String> kotPrinter = [];
List<String> kotPrinterIpAddress = [];
List<String> allPrinter = [];
String defaultPrinter;
List<String> printersList = [];
List<String> uomList = [];
List uomEditSplit = [];
String ipAddress1;
List<String> networkName = [];
List<String> networkAddress = [];
List modifier = [];
PostgreSQLConnection _database;
String databaseName;
const oneSecond = Duration(seconds: 100);
List customerCheckoutList = [];
int customerCheckoutCount = 0;
int savedOrderCount = 0;
List orderToCheckout = [];
List savedOrders = [];
int checkoutListCount = 0;
String sequenceData = '';
String organisationData='';
String selectedVendor = '';
List<String> vendorFirstSplit = [];
List<String> vendorList = [];
List<String> vendorPriceList = [];
String selectedVendorPriceList;
List<String> vendorBalanceList = [];
List<String> productCategoryF = [];
List<String> productImages = [];
List<String> categoryCount = [];
List categoryFirstSplit = [];
List<String> userList = [];
List<String> userPrefixList = [];
List<String> passwordList = [];
List<String> terminalList = [];
String selectedCustomer = '';
List<String> customerList = [];
List<String> customerPriceList = [];
String selectedPriceList;
List<String> customerFirstSplit = [];
List<String> customerBalanceList = [];
List<String> expenseList=[];
List<String> expenseFirstSplit=[];
List<String> productNameF = [];
List<String> allProducts = [];
int productsLength;
List productRateF = [];
List productFirstSplit = [];
Database _databaseSqLite;
String dbConnected = '1';

String getTaxName(String itemName){
  for(int i=0;i<productFirstSplit.length;i++){
    List temp=productFirstSplit[i].toString().split(':');
    String name=temp[0].toString().trim();
    if(name==itemName){
      List temp=productFirstSplit[i].toString().split(':');
      return temp[5];
    }
  }
  return '';
}
String getHSNCode(String itemName){
  for(int i=0;i<productFirstSplit.length;i++){
    List temp=productFirstSplit[i].toString().split(':');
    String name=temp[0].toString().trim();
    if(name==itemName){
      List temp=productFirstSplit[i].toString().split(':');
      return temp[2];
    }
  }
  return '';
}
String getStockData(String itemName){
  for(int i=0;i<stockList.length;i++){
    if(stockList[i].toString().contains(itemName)){
      String tempText='${stockList[i]}~$i';
      return tempText;
    }
  }
  return '';
}

String getConversion(String productName,String uomName){
  for(int i=0;i<productFirstSplit.length;i++){
    List temp111=productFirstSplit[i].toString().split(':');
    if(temp111[0].toString().trim()==productName.trim()) {
      List temp=productFirstSplit[i].split(':');
      List tempPrice=temp[4].split('``');
      List tempUomSplit=tempPrice[0].toString().split('*');
      List tempConversionSplit=tempPrice[4].toString().split('*');
      for(int j=0;j<tempUomSplit.length;j++) {
        print(tempUomSplit[j]);
        print(uomName);
        if(tempUomSplit[j].toString().trim()==uomName.trim()) {
          String itemConversion;
          itemConversion=tempConversionSplit[j].toString().trim();
          return itemConversion;
          // print(tempPriceSplit[j]);
          // return tempPriceSplit[j].toString().trimLeft();
        }
      }
    }
  }
  return '';
}
String getCategory(String item){
  for(int i=0;i<productFirstSplit.length;i++){
    List temp=productFirstSplit[i].toString().split(':');
    if(item==temp[0].toString().trim())
      return temp[1].toString().trim();
  }
  return '';
}
String getPercent(String taxName){
  for(int i=0;i<taxNameList.length;i++){
    if(taxNameList[i].trim()==taxName.trim()){
      print('inside get percent $taxNameList[i');
      return percentageList[i];
    }
  }
  return '';
}
class DbCon with ChangeNotifier {
  String counter;
  String text = 'abc';
  int count = 0;
  // Future<int> getString()async {
  //    List tempList;
  //    tempList = await _database.query('SELECT * from invoice_list');
  //
  //    counter=tempList.length.toString();
  //    return tempList.length;
  // }
  Future<Tuple2> getCount(String tableName) async {
    List tempList;
    orderToCheckout = [];
    savedOrders = [];
    customerCheckoutList = [];
    count = 0;
    try {
      tempList = await _database.query('SELECT * from $tableName');
    } catch (e) {}
    List data = [];
    if (tempList == null) return Tuple2<int, List>(count, data);
    for (int i = 0; i < tempList.length; i++) {
      if (tableName == 'invoice_list') {
        orderToCheckout.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
        //print(orderToCheckout);
      } else if (tableName == 'saved_order') {
        savedOrders.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
      } else if (tableName == 'customer_checkout') {
        customerCheckoutList.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
      }
    }

    if (tableName == 'invoice_list') {
      data = orderToCheckout;
      count = orderToCheckout.length;
    } else if (tableName == 'saved_order') {
      data = savedOrders;
      count = savedOrders.length;
    } else if (tableName == 'customer_checkout') {
      data = customerCheckoutList;
      count = customerCheckoutList.length;
    }
    notifyListeners();
    var t = Tuple2<int, List>(count, data);

    // print(t.item1); // prints 'a'
    // print(t.item2); // prints '10'
    return t;
  }
}

Future database() async {
  databaseName = 'data';
  print('databaseName $databaseName');
  if (_databaseSqLite != null) return _databaseSqLite;
  // lazily instantiate the db the first time it is accessed
  _databaseSqLite = await _initDatabase(databaseName);
}

_initDatabase(String name) async {
  final databasePath = await _localPath;
  String path = join(databasePath, '$name.db');
  return await openDatabase(
    path,
    version: 1,
  );
}

Future<void> connectPostgres(BuildContext context) async {
  var connection;
  if (Platform.isWindows){
    var fs = const LocalFileSystem();
  final Directory tmp =  fs.directory('D:/');

  final File outputFile = tmp.childFile('ipa.txt');
  String ipa=  await outputFile.readAsString();
  List dbData=ipa.split(':');
  print('ipa $dbData');
    connection =  PostgreSQLConnection("${dbData[0]}", int.parse(dbData[1]), "${dbData[3]}",
        username: "${dbData[4]}", password: "${dbData[5]}");
    _database = connection;
    try{
      await _database.open();
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error $e')));
    }
    await getData('user_data');
    await getData('companyDetails');
    getData('category_data');
    getData('product_data');
    getData('modifier_data');
    return ;
  } else {
    print("ANDROID");
    var fs = const LocalFileSystem();
    final path = await _localPath;
    final file = fs.directory(path);
    final File outputFile = file.childFile('ipa.txt');
    String ipa = await outputFile.readAsString();
    List dbData=ipa.split(':');
    dbConnected=dbData[2];
    print('ipa $dbData');
    if (dbConnected == '1') {
      connection =  PostgreSQLConnection("${dbData[0]}", int.parse(dbData[1]), "${dbData[3]}",
          username: "${dbData[4]}", password: "${dbData[5]}");
      _database = connection;
      try{
        await _database.open();
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error $e')));
      }
      await getData('user_data');
      await getData('companyDetails');
      getData('category_data');
      getData('product_data');
      getData('modifier_data');
      return ;
    } else {
      await database();
      print('over');
      getData('user_data');
      getData('companyDetails');
      getData('category_data');
      getData('product_data');
      getData('modifier_data');
      return ;
    }
    //connection = PostgreSQLConnection("192.168.5.39", 5432, "pos_db", username: "postgres", password: "1201",timeoutInSeconds: 980,queryTimeoutInSeconds: 1080);
    //  connection = PostgreSQLConnection(ipa, 5432, "pos_db", username: "postgres", password: "1201");
    //await Future.delayed(oneSecond, () => Database());
  }
  try {
    // print("GOALLLLL");
    //await Future.delayed(oneSecond, () => connection.open());
    // connection = PostgreSQLConnection("192.168.5.39", 5432, "pos_db", username: "postgres", password: "1201",timeoutInSeconds: 980,queryTimeoutInSeconds: 1080);
    await connection.open();
  } catch (e) {
    //print("jjjj"+e.toString());


  }
  //await connection.open();

  _database = connection;
}

Future<String> get _localPath async {
  final directory = await getExternalStorageDirectory();
  print(directory.path);
  return directory.path;
}

// SQL code to create the database table
Future _onCreatePostgres(PostgreSQLConnection db, String tableName) async {
  if (tableName == 'companyDetails') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,organisationName TEXT,typeOfBusiness TEXT,address TEXT,mobileNo TEXT,VATGSTNO TEXT,currency TEXT,symbol TEXT,decimals INTEGER)");
  }
  else if (tableName == 'stock_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(itemName TEXT,quantity TEXT,costPrice TEXT,value Text)");
  }
  else if (tableName == 'tax_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,taxName TEXT,percentage TEXT)");
  }
  else if (tableName == 'customer_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,customerName TEXT,address TEXT,mobileNo TEXT,VATNO TEXT,selectedPrice TEXT,customerBalance TEXT)");
  }
  else if (tableName == 'expense_head') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,expenseHead TEXT,vatName TEXT,vatNo TEXT)");
  }
  else if (tableName == 'vendor_data') {
    // await db.execute('DROP TABLE $tableName');
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,vendorName TEXT,address TEXT,mobileNo TEXT,VATNO TEXT,selectedPrice TEXT,vendorBalance TEXT)");
  } else if (tableName == 'product_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,itemName TEXT,category TEXT,itemCode TEXT,barcodeType TEXT,uom TEXT,tax TEXT,discount TEXT,image TEXT)");
  } else if (tableName == 'sequence_manager') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,sales varchar(10),salesReturn varchar(10),purchase varchar(10),purchaseReturn varchar(10),receipt varchar(10),payment varchar(10),expense varchar(10))");
  } else if (tableName == 'category_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,categoryName TEXT,sequence TEXT)");
  } else if (tableName == 'printer_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(printerType TEXT,printerName TEXT,ipAddress TEXT,portNumber Text,defaultPrinter TEXT)");
  } else if (tableName == 'kot_data') {
    try{
      db.execute('DELETE FROM $tableName');
      print('delete');
    }
    catch(e){
      print('error $e');
    }
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(category TEXT,printerName TEXT,ipAddress TEXT)");
  } else if (tableName == 'uom_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,uomName TEXT,decimal TEXT)");
  } else if (tableName == 'modifier_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,modifier TEXT)");
  } else if (tableName == 'user_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,userName TEXT,password TEXT,terminal Text,prefix TEXT)");
  } else if (tableName == 'invoice_list') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,customerName TEXT,items TEXT,payment TEXT,delivery TEXT,total TEXT,typeStr TEXT,userName TEXT,tableNo TEXT)");
  } else if (tableName == 'saved_order') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(orderNo TEXT,dateStr TEXT,tableNo TEXT,customerName TEXT,priceList TEXT,userName TEXT,items TEXT)");
  } else if (tableName == 'invoice_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,customerName TEXT,items TEXT,payment TEXT,delivery TEXT,total TEXT,typeStr TEXT,userName TEXT)");
  }
  else if (tableName == 'vat_report') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,partyName TEXT,vatNo TEXT,total TEXT,taxable5 TEXT,tax5 TEXT,total5 TEXT,exempt TEXT,typeStr TEXT)");
  }
  else if (tableName == 'item_report') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,itemName TEXT,category TEXT,taxName TEXT,taxAmt TEXT,taxRate TEXT,qty TEXT,lineTotal TEXT,typeStr TEXT,itemUom TEXT)");
  }
  else if (tableName == 'expense_transaction') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,expenseHead TEXT,payment TEXT,amount TEXT,note TEXT,typeStr TEXT,userName TEXT,tax TEXT)");
  }
  else if (tableName == 'receipt' || tableName == 'payment') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,${tableName == 'receipt' ? 'customerName' : 'vendorName'} TEXT,paymentType TEXT,amount TEXT,typeStr TEXT,note TEXT)");
  } else if (tableName == 'sales_return') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,customerName TEXT,items TEXT,payment TEXT,total TEXT,typeStr TEXT,userName TEXT)");
  } else if (tableName == 'purchase_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,vendorName TEXT,items TEXT,payment TEXT,total TEXT,typeStr TEXT,userName TEXT)");
  } else if (tableName == 'purchase_return') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,vendorName TEXT,items TEXT,payment TEXT,total TEXT,typeStr TEXT,userName TEXT)");
  } else if (tableName == 'customer_checkout') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,customerName TEXT,items TEXT,total TEXT)");
  }
  // return;
}

Future _onCreateSqlLite(Database db, String tableName) async {
  if (tableName == 'companyDetails') {
    print('inside sql company $organisationData');
     if(organisationData.length>0)
      await db.delete(tableName);
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS $tableName(id INTEGER PRIMARY KEY,organisationName TEXT,typeOfBusiness TEXT,address TEXT,mobileNo TEXT,VATGSTNO TEXT,currency TEXT,symbol TEXT,decimals INTEGER)");
  } else if (tableName == 'profileData') {
    await db.execute('DROP TABLE profileData');
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(customerName TEXT,address TEXT)");
  } else if (tableName == 'printer_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(printerType TEXT,printerName TEXT,ipAddress TEXT,portNumber Text,defaultPrinter TEXT)");
  }else if (tableName == 'bluetooth_data') {
    if(bluetoothAddress.length>0)
      await db.delete(tableName);
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(address TEXT)");
  }else if (tableName == 'stock_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(itemName TEXT,quantity TEXT,costPrice TEXT,value Text)");
  } else if (tableName == 'kot_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(category TEXT,printerName TEXT,ipAddress TEXT)");
  } else if (tableName == 'customer_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,customerName TEXT,address TEXT,mobileNo TEXT,VATNO TEXT,selectedPrice TEXT,customerBalance TEXT)");
  } else if (tableName == 'vendor_data') {
    // await db.execute('DROP TABLE $tableName');
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,vendorName TEXT,address TEXT,mobileNo TEXT,VATNO TEXT,selectedPrice TEXT)");
  } else if (tableName == 'product_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,itemName TEXT,category TEXT,itemCode TEXT,barcodeType TEXT,uom TEXT,tax TEXT,discount TEXT,image TEXT)");
  } else if (tableName == 'sequence_manager') {
    if(sequenceData.length>0)
      await db.delete(tableName);
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,sales varchar(10),salesReturn varchar(10),purchase varchar(10),purchaseReturn varchar(10),receipt varchar(10),payment varchar(10),expense varchar(10))");
  } else if (tableName == 'category_data') {

    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,categoryName TEXT,sequence TEXT)");
  } else if (tableName == 'uom_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,uomName TEXT,decimal TEXT)");
  }else if (tableName == 'tax_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,taxName TEXT,percentage TEXT)");
  } else if (tableName == 'user_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,userName TEXT,password TEXT,terminal Text,prefix Text)");
  } else if (tableName == 'modifier_data') {
    print('inside create modifier');
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,modifier TEXT)");
  }
  else if (tableName == 'expense_head') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id SERIAL PRIMARY KEY,expenseHead TEXT,vatName,vatNo)");
  }
  else if (tableName == 'expense_transaction') {

    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,expenseHead TEXT,payment TEXT,amount TEXT,note TEXT,typeStr TEXT,userName TEXT,tax TEXT)");
  }
  else if (tableName == 'invoice_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,customerName TEXT,items TEXT,payment TEXT,delivery TEXT,total TEXT,typeStr TEXT,userName TEXT)");
  }
  else if (tableName == 'vat_report') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,dateStr TEXT,partyName TEXT,vatNo TEXT,total TEXT,taxable5 TEXT,tax5 TEXT,total5 TEXT,exempt TEXT,typeStr TEXT)");
  }
  else if (tableName == 'item_report') {
    print('inside on create item');
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,itemName TEXT,category TEXT,taxName TEXT,taxAmt TEXT,taxRate TEXT,qty TEXT,lineTotal TEXT,typeStr TEXT,itemUom TEXT)");
  } else if (tableName == 'receipt' || tableName == 'payment') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,${tableName == 'receipt' ? 'customerName' : 'vendorName'} TEXT,paymentType TEXT,amount TEXT,type TEXT,note TEXT)");
  } else if (tableName == 'sales_return') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,customerName TEXT,items TEXT,payment TEXT,total TEXT,typeStr TEXT,userName TEXT)");
  } else if (tableName == 'purchase_data') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,vendorName TEXT,items TEXT,payment TEXT,total TEXT,typeStr TEXT,userName TEXT)");
  } else if (tableName == 'purchase_return') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(id INTEGER PRIMARY KEY,invoiceNo TEXT,date TEXT,vendorName TEXT,items TEXT,payment TEXT,total TEXT,typeStr TEXT,userName TEXT)");
  }
  else if (tableName == 'saved_order') {
    return await db.execute(
        "CREATE TABLE IF NOT EXISTS  $tableName(orderNo TEXT,date TEXT,tableNo TEXT,customerName TEXT,priceList TEXT,userName TEXT,items TEXT)");
  }
  // return;
}

Future _onCreate(var db, String tableName) async {
  if (dbConnected == '1')
    _onCreatePostgres(db, tableName);
  else
    _onCreateSqlLite(db, tableName);
  // return;
}

Future insertDataPostgres(String body, String tableName) async {
  List tempSplit = body.split(':');
  if (tableName == 'companyDetails') {
    if(organisationData.length>0) {
        await updateDataPostgres(body, tableName, 1, '');
    } else{
      print('inside else');
      await _onCreate(_database, "companyDetails");
      await _database.query(
          '''INSERT INTO $tableName(organisationName,typeOfBusiness,address,mobileNo,VATGSTNO,currency,symbol,decimals)VALUES('${tempSplit[0]}','${tempSplit[1]}','${tempSplit[2]}','${tempSplit[3]}','${tempSplit[4]}','${tempSplit[5]}','${tempSplit[6]}','${tempSplit[7]}')''');
    }
    organisationData=body;
  }
  else if (tableName == 'printer_data') {
    await _onCreate(_database, "printer_data");
    await _database.query(
        '''INSERT INTO $tableName(printerType,printerName,ipAddress,portNumber,defaultPrinter)VALUES('${tempSplit[0]}','${tempSplit[1]}','${tempSplit[2]}','${tempSplit[3]}','${tempSplit[4]}')''');
  } else if (tableName == 'kot_data') {

    await _onCreate(_database, "kot_data");
    List tempBody = body.split('~');
    tempBody.removeAt(tempBody.length - 1);
    print('tempBody $tempBody');
    for (int i = 0; i < tempBody.length; i++) {
      List tempSplit1 = tempBody[i].toString().split(':');
      await _database.query(
          '''INSERT INTO $tableName(category,printerName,ipAddress)VALUES('${tempSplit1[0]}','${tempSplit1[1]}','${tempSplit1[2]}')''');
    }
  }else if (tableName == 'stock_data') {
    await _onCreate(_database, "stock_data");
    List tempBody = body.split('~');
    print('tempBody $tempBody');
      await _database.query(
          '''INSERT INTO $tableName(itemName,quantity,costPrice,value)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}')''');

  } else if (tableName == 'invoice_list') {
    print('inside db $body');
    List tempBody = body.split('#');
    tempBody.removeLast();
    print('tempBody $tempBody');
    await _onCreate(_database, "invoice_list");
    await _database.query(
        '''INSERT INTO $tableName(invoiceNo,dateStr,customerName,items,payment,delivery,total,typeStr,userName,tableNo)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}','${tempBody[5]}','${tempBody[6]}','${tempBody[7]}','${tempBody[8]}','${tempBody[9]}')''');
  } else if (tableName == 'saved_order') {
    print('inside db $body');
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_database, "saved_order");
    await _database.query(
        '''INSERT INTO $tableName(orderNo,dateStr,tableNo,customerName,priceList,userName,items)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}','${tempBody[5]}','${tempBody[6]}')''');
  }
  else if (tableName == 'expense_transaction') {
    List tempBody = body.split('-');
    print('tempBody $tempBody');
    await _onCreate(_database, "expense_transaction");
    await _database.query(
        '''INSERT INTO $tableName(invoiceNo,dateStr,expenseHead,payment,amount,note,typeStr,userName,tax)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}','${tempBody[5]}','${tempBody[6]}','${tempBody[7]}','${tempBody[8]}')''');
  }
  else if (tableName == 'invoice_data') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_database, "invoice_data");
    await _database.query(
        '''INSERT INTO $tableName(invoiceNo,dateStr,customerName,items,payment,delivery,total,typeStr,userName)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}','${tempBody[5]}','${tempBody[6]}','${tempBody[7]}','${tempBody[9]}')''');
  }
  else if (tableName == 'vat_report') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_database, "vat_report");
    await _database.query(
        '''INSERT INTO $tableName(invoiceNo,dateStr,partyName,vatNo,total,taxable5,tax5,total5,exempt,typeStr)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}','${tempBody[5]}','${tempBody[6]}','${tempBody[7]}','${tempBody[8]}','${tempBody[9]}')''');
  }
  else if (tableName == 'item_report') {
    List tempBody = body.split('~');
    print('item_report $tempBody');
    await _onCreate(_database, "item_report");
    await _database.query(
        '''INSERT INTO $tableName(invoiceNo,dateStr,itemName,category,taxName,taxAmt,taxRate,qty,lineTotal,typeStr,itemUom)VALUES('${tempBody[0].toString().trim()}','${tempBody[1].toString().trim()}','${tempBody[2].toString().trim()}','${tempBody[3].toString().trim()}','${tempBody[4].toString().trim()}','${tempBody[5].toString().trim()}','${tempBody[6].toString().trim()}','${tempBody[7].toString().trim()}','${tempBody[8].toString().trim()}','${tempBody[9].toString().trim()}','${tempBody[10].toString().trim()}') ''');
  } else if (tableName == 'customer_checkout') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_database, "customer_checkout");
    await _database.query(
        '''INSERT INTO $tableName(invoiceNo,dateStr,customerName,items,total)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}')''');
  } else if (tableName == 'sales_return') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_database, "sales_return");
    await _database.query(
        '''INSERT INTO $tableName(invoiceNo,dateStr,customerName,items,payment,total,typeStr,userName)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}','${tempBody[5]}','${tempBody[6]}','${tempBody[7]}')''');
  } else if (tableName == 'purchase_data') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_database, "purchase_data");
    await _database.query(
        '''INSERT INTO $tableName(invoiceNo,dateStr,vendorName,items,payment,total,typeStr,userName)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}','${tempBody[5]}','${tempBody[6]}','${tempBody[7]}')''');
  } else if (tableName == 'receipt' || tableName == 'payment') {
    List tempBody = body.split('-');
    print('tempBody $tempBody');
    await _onCreate(_database, tableName);
    await _database.query(
        '''INSERT INTO $tableName(invoiceNo,dateStr,'${tableName == 'receipt' ? 'customerName' : 'vendorName'}',paymentType,amount,typeStr,note)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}','${tempBody[5]}','${tempBody[6]}')''');
  } else if (tableName == 'purchase_return') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_database, "purchase_return");
    await _database.query(
        '''INSERT INTO $tableName(invoiceNo,dateStr,vendorName,items,payment,total,typeStr,userName)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}','${tempBody[5]}','${tempBody[6]}','${tempBody[7]}')''');
  } else if (tableName == 'customer_data') {
    print('inside customer if');
    await _onCreate(_database, "customer_data");
    await _database.query(
        '''INSERT INTO $tableName(customerName,address,mobileNo,VATNO,selectedPrice,customerBalance)VALUES('${tempSplit[0]}','${tempSplit[1]}','${tempSplit[2]}','${tempSplit[3]}','${tempSplit[4]}','${tempSplit[5]}')''');
  } else if (tableName == 'vendor_data') {
    await _onCreate(_database, "vendor_data");
    await _database.query(
        '''INSERT INTO $tableName(vendorName,address,mobileNo,VATNO,selectedPrice,vendorBalance)VALUES('${tempSplit[0]}','${tempSplit[1]}','${tempSplit[2]}','${tempSplit[3]}','${tempSplit[4]}','${tempSplit[5]}')''');
  } else if (tableName == 'product_data') {
    await _onCreate(_database, "product_data");
    await _database.query(
        '''INSERT INTO $tableName(itemName,category,itemCode,barcodeType,uom,tax,discount,image)VALUES('${tempSplit[0]}','${tempSplit[1]}','${tempSplit[2]}','${tempSplit[3]}','${tempSplit[4]}','${tempSplit[5]}','${tempSplit[6]}','${tempSplit[7]}')''');
  } else if (tableName == 'category_data') {
    await _onCreate(_database, "category_data");
    await _database.query(
        '''INSERT INTO $tableName(categoryName,sequence)VALUES('${tempSplit[0]}','${tempSplit[1]}')''');
  } else if (tableName == 'uom_data') {
    await _onCreate(_database, "uom_data");
    await _database.query(
        '''INSERT INTO $tableName(uomName,decimal)VALUES('${tempSplit[0]}','${tempSplit[1]}')''');
  }else if (tableName == 'tax_data') {
    await _onCreate(_database, "tax_data");
    await _database.query(
        '''INSERT INTO $tableName(taxName,percentage)VALUES('${tempSplit[0]}','${tempSplit[1]}')''');
  } else if (tableName == 'modifier_data') {
    await _onCreate(_database, "modifier_data");
    await _database
        .query('''INSERT INTO $tableName(modifier)VALUES('$body')''');
  }
  else if (tableName == 'expense_head') {
    List tempBody=body.split('~');
    await _onCreate(_database, "expense_head");
    await _database
        .query('''INSERT INTO $tableName(expenseHead,vatName,vatNo)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}')''');
  }
  else if (tableName == 'user_data') {
    await _onCreate(_database, "user_data");
    await _database.query(
        '''INSERT INTO $tableName(userName,password,terminal,prefix)VALUES('${tempSplit[0]}','${tempSplit[1]}','${tempSplit[2]}','${tempSplit[3]}')''');
  } else if (tableName == 'sequence_manager') {
    List tempBody = body.split('~');
    tempBody.removeLast();
    print('sequence $tempBody');
    if(sequenceData.length>0){
      print('inside seq if update');
      updateDataPostgres(body, tableName, 1, '');
    }
    else{
      print('inside seq else create');
      await _onCreate(_database, "sequence_manager");
      await _database.query(
          '''INSERT INTO $tableName(sales,salesReturn,purchase,purchaseReturn,receipt,payment,expense)VALUES('${tempBody[0]}','${tempBody[1]}','${tempBody[2]}','${tempBody[3]}','${tempBody[4]}','${tempBody[5]}','${tempBody[6]}')''');
    }
    sequenceData=body;
  }
  return;
}

Future insertDataSqlLite(String body, String tableName) async {
  List tempSplit = body.split(':');
  if (tableName == 'companyDetails') {
    await _onCreate(_databaseSqLite, "companyDetails");
    Map<String, dynamic> row = {
      'organisationName': tempSplit[0],
      'typeOfBusiness': tempSplit[1],
      'address': tempSplit[2],
      'mobileNo': tempSplit[3],
      'VATGSTNO': tempSplit[4],
      'currency': tempSplit[5],
      'symbol': tempSplit[6],
      'decimals': tempSplit[7]
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }
  else if (tableName == 'invoice_data') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_databaseSqLite, "invoice_data");
    Map<String, dynamic> row = {
      'invoiceNo': tempBody[0],
      'date': tempBody[1],
      'customerName': tempBody[2],
      'items': tempBody[3],
      'payment': tempBody[4],
      'delivery': tempBody[5],
      'total': tempBody[6],
      'typeStr': tempBody[7],
      'userName': tempBody[9]
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }  else if (tableName == 'vat_report') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_databaseSqLite, "vat_report");
    Map<String, dynamic> row = {
      'invoiceNo': tempBody[0],
      'date': tempBody[1],
      'partyName': tempBody[2],
      'vatNo': tempBody[3],
      'total': tempBody[4],
      'taxable5': tempBody[5],
      'tax5': tempBody[6],
      'total5': tempBody[7],
      'exempt': tempBody[8],
      'typeStr': tempBody[9]
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }
  else if (tableName == 'saved_order') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_databaseSqLite, "saved_order");
    Map<String, dynamic> row = {
      'orderNo': tempBody[0],
      'date': tempBody[1],
      'tableNo': tempBody[2],
      'customerName': tempBody[3],
      'priceList': tempBody[4],
      'userName': tempBody[5],
      'items': tempBody[6]
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }else if (tableName == 'bluetooth_data') {
    print('bluetooth_data $body');
    await _onCreate(_databaseSqLite, "bluetooth_data");
    Map<String, dynamic> row = {
      'address': body,
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'item_report') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_databaseSqLite, "item_report");
    Map<String, dynamic> row = {
      'invoiceNo': tempBody[0].toString().trim(),
      'date': tempBody[1].toString().trim(),
      'itemName': tempBody[2].toString().trim(),
      'category': tempBody[3].toString().trim(),
      'taxName': tempBody[4].toString().trim(),
      'taxAmt': tempBody[5].toString().trim(),
      'taxRate': tempBody[6].toString().trim(),
      'qty': tempBody[7].toString().trim(),
      'lineTotal': tempBody[8].toString().trim(),
      'typeStr': tempBody[9].toString().trim(),
      'itemUom': tempBody[10].toString().trim(),
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }
  else if (tableName == 'expense_transaction') {
    List tempBody = body.split('-');
    print('tempBody $tempBody');
    await _onCreate(_databaseSqLite, "expense_transaction");
    Map<String, dynamic> row = {
      'invoiceNo': tempBody[0],
      'date': tempBody[1],
      'expenseHead': tempBody[2],
      'payment': tempBody[3],
      'amount': tempBody[4],
      'note': tempBody[5],
      'typeStr': tempBody[6],
      'userName': tempBody[7],
      'tax': tempBody[8]
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }
  else if (tableName == 'sales_return') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_databaseSqLite, "sales_return");
    Map<String, dynamic> row = {
      'invoiceNo': tempBody[0],
      'date': tempBody[1],
      'customerName': tempBody[2],
      'items': tempBody[3],
      'payment': tempBody[4],
      'total': tempBody[5],
      'typeStr': tempBody[6],
      'userName': tempBody[7]
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'purchase_data') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_databaseSqLite, "purchase_data");
    Map<String, dynamic> row = {
      'invoiceNo': tempBody[0],
      'date': tempBody[1],
      'vendorName': tempBody[2],
      'items': tempBody[3],
      'payment': tempBody[4],
      'total': tempBody[5],
      'typeStr': tempBody[6],
      'userName': tempBody[7],
      // 'tax':tempBody[8]
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'receipt' || tableName == 'payment') {
    List tempBody = body.split('-');
    print('tempBody $tempBody');
    await _onCreate(_databaseSqLite, tableName);
    Map<String, dynamic> row = {
      'invoiceNo': tempBody[0],
      'date': tempBody[1],
      '${tableName == 'receipt' ? 'customerName' : 'vendorName'}': tempBody[2],
      'paymentType': tempBody[3],
      'amount': tempBody[4],
      'type': tempBody[5],
      'note': tempBody[6],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'purchase_return') {
    List tempBody = body.split('~');
    print('tempBody $tempBody');
    await _onCreate(_databaseSqLite, "purchase_return");
    Map<String, dynamic> row = {
      'invoiceNo': tempBody[0],
      'date': tempBody[1],
      'vendorName': tempBody[2],
      'items': tempBody[3],
      'payment': tempBody[4],
      'total': tempBody[5],
      'typeStr': tempBody[6],
      'userName': tempBody[7],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'customer_data') {
    print('inside customer if');
    await _onCreate(_databaseSqLite, "customer_data");
    Map<String, dynamic> row = {
      'customerName': tempSplit[0],
      'address': tempSplit[1],
      'mobileNo': tempSplit[2],
      'VATNO': tempSplit[3],
      'selectedPrice': tempSplit[4],
      'customerBalance': tempSplit[5]
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'printer_data') {
    print('inside printer if');
    await _onCreate(_databaseSqLite, "printer_data");
    Map<String, dynamic> row = {
      'printerType': tempSplit[0],
      'printerName': tempSplit[1],
      'ipAddress': tempSplit[2],
      'portNumber': tempSplit[3],
      'defaultPrinter': tempSplit[4],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }else if (tableName == 'stock_data') {
    List tempBody=body.split('~');
    print('inside stock if');
    await _onCreate(_databaseSqLite, "stock_data");
    Map<String, dynamic> row = {
      'itemName': tempBody[0],
      'quantity': tempBody[1],
      'costPrice': tempBody[2],
      'value': tempBody[3],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'kot_data') {
    print('inside printer if');
    await _onCreate(_databaseSqLite, "kot_data");
    Map<String, dynamic> row = {
      'category': tempSplit[0],
      'printerName': tempSplit[1],
      'ipAddress': tempSplit[2],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'vendor_data') {
    await _onCreate(_databaseSqLite, "vendor_data");
    Map<String, dynamic> row = {
      'vendorName': tempSplit[0],
      'address': tempSplit[1],
      'mobileNo': tempSplit[2],
      'VATNO': tempSplit[3],
      'selectedPrice': tempSplit[4],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'product_data') {
    await _onCreate(_databaseSqLite, "product_data");
    Map<String, dynamic> row = {
      'itemName': tempSplit[0],
      'category': tempSplit[1],
      'itemCode': tempSplit[2],
      'barcodeType': tempSplit[3],
      'uom': tempSplit[4],
      'tax': tempSplit[5],
      'discount': tempSplit[6],
      'image': tempSplit[7]
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'category_data') {
    await _onCreate(_databaseSqLite, "category_data");
    Map<String, dynamic> row = {
      'categoryName': tempSplit[0],
      'sequence': tempSplit[1],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'uom_data') {
    await _onCreate(_databaseSqLite, "uom_data");
    Map<String, dynamic> row = {
      'uomName': tempSplit[0],
      'decimal': tempSplit[1],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }else if (tableName == 'tax_data') {
    await _onCreate(_databaseSqLite, "tax_data");
    Map<String, dynamic> row = {
      'taxName': tempSplit[0],
      'percentage': tempSplit[1],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'user_data') {
    await _onCreate(_databaseSqLite, "user_data");
    Map<String, dynamic> row = {
      'userName': tempSplit[0],
      'password': tempSplit[1],
      'terminal': tempSplit[2],
      'prefix': tempSplit[3],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  } else if (tableName == 'modifier_data') {
    await _onCreate(_databaseSqLite, "modifier_data");
    Map<String, dynamic> row = {
      'modifier': body,
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }
  else if (tableName == 'expense_head') {
    List tempBody=body.split('~');
    await _onCreate(_databaseSqLite, "expense_head");
    Map<String, dynamic> row = {
      'expenseHead': tempBody[0],
      'vatName': tempBody[1],
      'vatNo': tempBody[2],
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }
  else if (tableName == 'sequence_manager') {
    List tempBody = body.split('~');
    tempBody.removeLast();
    print('inside sequence $tempBody');
    await _onCreate(_databaseSqLite, "sequence_manager");
    Map<String, dynamic> row = {
      'sales': tempBody[0],
      'salesReturn': tempBody[1],
      'purchase': tempBody[2],
      'purchaseReturn': tempBody[3],
      'receipt': tempBody[4],
      'payment': tempBody[5],
      'expense': tempBody[6]
    };
    print('row $row');
    await _databaseSqLite.insert(tableName, row);
  }
  return;
}

Future insertData(String body, String tableName) async {
  if (dbConnected == '1')
    insertDataPostgres(body, tableName);
  else
    insertDataSqlLite(body, tableName);
}

Future deleteDataPostgres(String tableName, int id, String name) async {
  if (tableName == 'invoice_list') {
    print('deleted $id');
    await _database.query("DELETE FROM $tableName WHERE invoiceNo='$name'");
  } else if (tableName == 'saved_order') {
    await _database.query("DELETE FROM $tableName WHERE orderNo='$name'");
  } else if (tableName == 'customer_checkout') {
    await _database.query("DELETE FROM $tableName WHERE id='$id'");
  } else if (tableName == 'printer_data') {
    await _database.query("DELETE FROM $tableName WHERE printerName='$name'");
  } else if (tableName == 'kot_data') {
    await _database.query("DELETE FROM $tableName WHERE category='$name'");
  }
}

Future deleteDataSqlLite(String tableName, int id, String name) async {
  if (tableName == 'invoice_list') {
    print('deleted $id');
    await _databaseSqLite
        .query("DELETE FROM $tableName WHERE invoiceNo='$name'");
  } else if (tableName == 'saved_order') {
    await _databaseSqLite.query("DELETE FROM $tableName WHERE orderNo='$name'");
  } else if (tableName == 'customer_checkout') {
    await _databaseSqLite.query("DELETE FROM $tableName WHERE id='$id'");
  } else if (tableName == 'printer_data') {
    await _databaseSqLite
        .rawQuery("DELETE FROM $tableName WHERE printerName='$name'");
  } else if (tableName == 'kot_data') {
    await _databaseSqLite
        .query("DELETE FROM $tableName WHERE category='$name'");
  }
}

Future deleteData(String tableName, int id, String name) async {
  if (dbConnected == '1')
    deleteDataPostgres(tableName, id, name);
  else
    deleteDataSqlLite(tableName, id, name);
}
Future updateData(String body, String tableName, int id, String orderNo) async {
  print('inside update');
  if (dbConnected == '1')
    updateDataPostgres(body, tableName, id,orderNo);
  else
    updateDataSqlLite(body, tableName, id,orderNo);
}
Future updateDataPostgres(String body, String tableName, int id, String orderNo) async {
  if (tableName == 'customer_data') {
    List tempSplit = body.split(':');
    await _database.query(
        "UPDATE $tableName SET customerName='${tempSplit[0]}',address='${tempSplit[1]}',mobileNo='${tempSplit[2]}',VATNO='${tempSplit[3]}',selectedPrice='${tempSplit[4]}',customerBalance='${tempSplit[5]}' WHERE id=$id");
    getData(tableName);
  } else if (tableName == 'saved_order') {
    List tempSplit = body.split('~');
    await _database.query(
        "UPDATE $tableName SET items='${tempSplit[6]}' WHERE orderNo='$orderNo'");
    getData(tableName);
  } else if (tableName == 'category_data') {
    List tempSplit = body.split(':');
    await _database.query(
        "UPDATE $tableName SET categoryName='${tempSplit[0]}',sequence='${tempSplit[1]} WHERE id=$id");
  }
  else if (tableName == 'companyDetails') {
    print('inside update company $id');
    List tempSplit = body.split(':');
    await _database.query(
        "UPDATE $tableName SET organisationName='${tempSplit[0]}',typeOfBusiness='${tempSplit[1]}',address='${tempSplit[2]}',mobileNo='${tempSplit[3]}',VATGSTNO='${tempSplit[4]}',currency='${tempSplit[5]}',symbol='${tempSplit[6]}',decimals='${tempSplit[7]}' WHERE id=$id");
  }
  else if (tableName == 'sequence_manager') {
    print('inside update sequence $id');
    List tempSplit = body.split('~');
    await _database.query(
        "UPDATE $tableName SET sales='${tempSplit[0].toString().trim()}',salesReturn='${tempSplit[1].toString().trim()}',purchase='${tempSplit[2].toString().trim()}',purchaseReturn='${tempSplit[3].toString().trim()}',receipt='${tempSplit[4].toString().trim()}',payment='${tempSplit[5].toString().trim()}',expense='${tempSplit[6].toString().trim()}' WHERE id=$id");
  }
  else if (tableName == 'uom_data') {
    List tempSplit = body.split(':');
    await _database.query(
        "UPDATE $tableName SET uomName='${tempSplit[0]}',decimal='${tempSplit[1]}' WHERE id=$id");
  } else if (tableName == 'product_data') {
    List tempSplit = body.split(':');
  //  await _onCreate(_database, "product_data");
    await _database.query(
        "UPDATE $tableName SET itemName='${tempSplit[0]}',category='${tempSplit[1]}',itemCode='${tempSplit[2]}',barcodeType='${tempSplit[3]}',uom='${tempSplit[4]}',tax='${tempSplit[5]}',discount='${tempSplit[6]}' WHERE id=$id");
  }
 else if (tableName == 'stock_data') {
    List tempBody=body.split('~');
    print('inside stock $tempBody');
    print('inside stock id $id');
    if(id==2){
      await _database.query(" UPDATE $tableName SET itemName='$body' WHERE itemName='$orderNo' ");
      return;
    }
    await _database.query(
        "UPDATE $tableName SET itemName='${tempBody[0]}',quantity='${tempBody[1]}',costPrice='${tempBody[2]}',value='${tempBody[3]}' WHERE itemName='${tempBody[0]}' ");
  }
 else if(tableName== 'printer_data'){
   List temp=body.split(':');
   print('inside printer update $temp');
   await _database.query("UPDATE $tableName SET printerType='${temp[0]}',printerName='${temp[1]}',ipAddress='${temp[2]}',portNumber='${temp[3]}',defaultPrinter='${temp[4]}' WHERE printerName='${temp[1]}' ");
  }
  // else if(tableName=='vendor_data')
  // {
  //   await  _onCreate(_database, "vendor_data");
  //   Map<String,dynamic> row={
  //     'vendorName':tempSplit[0],
  //     'address':tempSplit[1],
  //     'mobileNo':tempSplit[2],
  //     'VATNO':tempSplit[3],
  //     'selectedPrice':tempSplit[4],
  //   };
  //   print('row $row');
  //   await _database.update(tableName,row,where: 'id=$id');
  //}

  return;
}
Future updateDataSqlLite(String body, String tableName, int id, String orderNo)async{
  List tempSplit = body.split(':');
   if (tableName == 'stock_data') {
    List tempBody=body.split('~');
    if(id==2){
      await _databaseSqLite.rawUpdate(" UPDATE $tableName SET itemName='$body' WHERE itemName='$orderNo' ");
      return;
    }
    await _databaseSqLite.rawUpdate(
        "UPDATE $tableName SET itemName='${tempBody[0]}',quantity='${tempBody[1]}',costPrice='${tempBody[2]}',value='${tempBody[3]}' WHERE itemName='${tempBody[0]}' ");
  }
   else if (tableName == 'product_data') {
     await _databaseSqLite.rawUpdate(
         "UPDATE $tableName SET itemName='${tempSplit[0]}',category='${tempSplit[1]}',itemCode='${tempSplit[2]}',barcodeType='${tempSplit[3]}',uom='${tempSplit[4]}',tax='${tempSplit[5]}',discount='${tempSplit[6]}',image='${tempSplit[7]}' WHERE id=$id");

   }
}

Future<String> getInvNo(String tableName) async {
  if (tableName == 'saved_order') {
    var value = await _database.query(
        '''SELECT MAX(regexp_replace(orderNo, '[^0-9]', '', 'g')::int) FROM saved_order''');
    print(value);
    return value.toString();
  } else if (tableName == 'invoice_list') {
    var value = await _database.query(
        '''SELECT MAX(regexp_replace(invoiceNo, '[^0-9]', '', 'g')::int) FROM invoice_list''');
    print(value);
    return value.toString();
  }
  else if (tableName == 'invoice_data') {
    var value;
    if (dbConnected == '1') {
      value = await _database.query(
          '''SELECT MAX(regexp_replace(invoiceNo, '[^0-9]', '', 'g')::int) FROM invoice_data''');
    } else {
      print('inside else');
      value = await _databaseSqLite
          .rawQuery('''select MAX(CAST(REPLACE(REPLACE(invoiceNo , '$salesPrefix', ''), '', '') as int)) from invoice_data''');
    }
    print('value $value');
    return value.toString();
  }
  else if (tableName == 'expense_transaction') {
    var value;
    if (dbConnected == '1') {
      value = await _database.query(
          '''SELECT MAX(regexp_replace(invoiceNo, '[^0-9]', '', 'g')::int) FROM expense_transaction''');
    } else {
      value = await _databaseSqLite
          .rawQuery('''select MAX(CAST(REPLACE(REPLACE(invoiceNo , '$expensePrefix', ''), '', '') as int)) from expense_transaction''');
    }
    print('value $value');
    return value.toString();
  }
  else if (tableName == 'purchase_data') {
    var value;
    if (dbConnected == '1') {
      value = await _database.query(
          '''SELECT MAX(regexp_replace(invoiceNo, '[^0-9]', '', 'g')::int) FROM purchase_data''');
    } else {
      value = await _databaseSqLite
          .rawQuery('''select MAX(CAST(REPLACE(REPLACE(invoiceNo , '$purchasePrefix', ''), '', '') as int)) from purchase_data''');
    }
    print('value $value');
    return value.toString();
  }
  else if (tableName == 'purchase_return') {
    var value;
    if (dbConnected == '1') {
      value = await _database.query(
          '''SELECT MAX(regexp_replace(invoiceNo, '[^0-9]', '', 'g')::int) FROM purchase_return''');
    } else {
      value = await _databaseSqLite
          .rawQuery('''select MAX(CAST(REPLACE(REPLACE(invoiceNo , '$purchaseReturnPrefix', ''), '', '') as int)) from purchase_return''');
    }
    print('value $value');
    return value.toString();
  }
  else if (tableName == 'sales_return') {
    var value;
    if (dbConnected == '1') {
      value = await _database.query(
          '''SELECT MAX(regexp_replace(invoiceNo, '[^0-9]', '', 'g')::int) FROM sales_return''');
    } else {
      value = await _databaseSqLite
          .rawQuery('''select MAX(CAST(REPLACE(REPLACE(invoiceNo , '$salesReturnPrefix', ''), '', '') as int)) from sales_return''');
    }
    print('value $value');
    return value.toString();
  }
}

Future displayItems(String categoryName) async {
  productNameF = [];
  productImages = [];
  List temp = [];
  List<String> items = [];
  print('inside function category name $categoryName');
  if (dbConnected == '1') {
    temp = await _database.query(
        "SELECT * from product_data WHERE category='$categoryName' order by id ASC");
    for (int i = 0; i < temp.length; i++) {
      List tempItems = temp[i].toString().split(',');
      items.add(tempItems[1].toString().trim());
      productImages.add(tempItems[8]
          .toString()
          .trim()
          .substring(0, tempItems[8].toString().length-2));
    }
  } else {
    print('insid else');
    temp = await _databaseSqLite.query('product_data',
        columns: ['*'], where: ' "category" = ?', whereArgs: [categoryName]);
    temp = formatResult(temp);
    print('temp $temp');
    for (int i = 0; i < temp.length; i++) {
      List tempItems = temp[i].toString().split(',');
      tempItems.removeAt(0);
      items.add(tempItems[0].toString().trim());
      print('items $items');
      productImages.add(tempItems[7].toString().trim());
      print('productImages $productImages');
    }
  }
  productNameF = items;
  productsLength = items.length;
  print('productNameF $productNameF');
  //print('productImages $productImages');
}
String getPrefix(){
  for(int i=0;i<userList.length;i++){
    if(currentUser==userList[i]){
      return userPrefixList[i];
    }
  }
  return '';
}
// Future getKotOrders(String userName) async {
//   List tempList;
//   List tempList1 = [];
//   waiterKotList = [];
//   if(dbConnected=='1'){
//     tempList = await _database.query('''select * from saved_order where userName='$currentUser' ''');
//     for (int i = 0; i < tempList.length; i++) {
//       waiterKotList.add(
//           tempList[i].toString().substring(1, tempList[i].toString().length - 1));
//     }
//     print('waiterKotList $waiterKotList');
//   }
//   else{
//     tempList = await _databaseSqLite
//         .rawQuery('''select * from saved_order where userName='$currentUser' ''');
//     for (int i = 0; i < tempList.length; i++) {
//       waiterKotList.add(
//           tempList[i].toString().substring(1, tempList[i].toString().length - 1));
//     }
//     for(int k=0;k<waiterKotList.length;k++){
//       String text1='';
//       List temp=waiterKotList[k].split(',');
//       for(int j=0;j<temp.length;j++){
//         if(j==1){
//           text1+='${temp[j].toString().substring(7)},';
//         }
//         else if(j==6){
//           text1+='${temp[j].toString().substring(7)},';
//         }
//         else{
//           List temp1=temp[j].toString().split(':');
//           text1+='${temp1[1].toString().trim()},';
//         }
//       }
//       waiterKotList[k]=text1.substring(0,text1.length-1);
//     }
//   }
//   print('inside get kot orders $waiterKotList');
//   return;
// }

Future getTotalSales(String tableName, String date) async {
  print('date ${date.substring(0, 10)}');
  List tempList;
  if (tableName == 'invoice_data') {
    dashBoardValues[0] = 0;
    if(dbConnected =='1'){
      tempList = await _database.query(
          '''select * from invoice_data where dateStr >= '${date.substring(0, 10)}' ''');
      for (int i = 0; i < tempList.length; i++) {
        List temp = tempList[i].toString().split(',');
        dashBoardValues[0] +=
            double.parse(temp[temp.length - 3].toString().trim());
      }
    }
    else{
      tempList = await _databaseSqLite.rawQuery(
          '''select * from invoice_data where date >= '${date.substring(0, 10)}' ''');
      tempList=formatSalesReport(tempList);
      for (int i = 0; i < tempList.length; i++) {
        List temp = tempList[i].toString().split(',');
        dashBoardValues[0] +=
            double.parse(temp[temp.length - 3].toString().trim());
      }
      print('inside get total $tempList');
    }

    print('dashBoardSales ${dashBoardValues[0]}');
  }
  else if (tableName == 'purchase_data') {
    dashBoardValues[1] = 0;
    if(dbConnected =='1'){
      tempList = await _database.query(
          '''select * from purchase_data where dateStr >= '${date.substring(0, 10)}' ''');
      for (int i = 0; i < tempList.length; i++) {
        List temp = tempList[i].toString().split(',');
        dashBoardValues[1] +=
            double.parse(temp[temp.length - 3].toString().trim());
      }
    }
    else{
      tempList = await _databaseSqLite.rawQuery(
          '''select * from purchase_data where date >= '${date.substring(0, 10)}' ''');
      tempList=formatPurchaseReport(tempList);
      for (int i = 0; i < tempList.length; i++) {
        List temp = tempList[i].toString().split(',');
        dashBoardValues[1] +=
            double.parse(temp[temp.length - 3].toString().trim());
      }
      print('inside get total $tempList');
    }

    print('dashBoardSales ${dashBoardValues[0]}');
  }
  else if (tableName == 'expense_transaction') {
    dashBoardValues[2] = 0;
    if(dbConnected =='1'){
      tempList = await _database.query(
          '''select * from expense_transaction where dateStr >= '${date.substring(0, 10)}' ''');
      for (int i = 0; i < tempList.length; i++) {
        List temp = tempList[i].toString().split(',');
        dashBoardValues[2] +=
            double.parse(temp[temp.length - 3].toString().trim());
      }
    }
    else{
      tempList = await _databaseSqLite.rawQuery(
          '''select * from expense_transaction where date >= '${date.substring(0, 10)}' ''');
      tempList=formatResult(tempList);
      for (int i = 0; i < tempList.length; i++) {
        List temp = tempList[i].toString().split(',');
        dashBoardValues[2] +=
            double.parse(temp[5].toString().trim());
      }
      print('inside get total $tempList');
    }

    print('dashBoardSales ${dashBoardValues[0]}');
  }
  return;
}

Future<List> getReports(String tableName, String dateFrom, dateTo, user) async {
  dateFrom = dateFrom.substring(0, 10);
  dateTo = dateTo.substring(0, 10);
  List tempFrom = dateFrom.split('-');
  List tempTo = dateTo.split('-');
  dateFrom = '';
  dateTo = '';
  dateFrom += '${tempFrom[1]}/${tempFrom[2]}/${tempFrom[0]}';
  dateTo += '${tempTo[1]}/${tempTo[2]}/${tempTo[0]}';
  print('date $dateFrom $dateTo');
  List tempList;
  List tempList1 = [];
  if (tableName == 'invoice_data') {
    dashBoardValues[0] = 0;
    if (dbConnected == '1') {
      print('user $user');
      // tempList = await _database.query(
      //     '''select * from invoice_data where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' and userName='$user' ''');
      // print('inside else before $tempList1 ');
      tempList = await _database.query(
          '''select * from invoice_data where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' and userName='$user' ''');
      print('inside else before $tempList ');
      return tempList;
    } else {
      tempList = await _databaseSqLite.rawQuery(
          '''select * from invoice_data where date >= '${dateFrom.substring(0, 10)}'  and date<='${dateTo.substring(0, 10)} 24:00'  and userName='$user'  ''');
      print('inside else before $tempList1 ');
      List temp = formatSalesReport(tempList);
      print('inside else after $temp ');
      return temp;
    }
  }
  else if(tableName=='vat_report'){
    if(dbConnected=='1'){
      if(user=='Input Tax'){
        print('dateFrom $dateFrom');
        tempList = await _database.query(
            '''select * from vat_report where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' and typeStr IN('purchase','salesReturn','expense')  ''');
        print('tempList $tempList');
        return tempList;
      }
      else if(user=='Output Tax'){
        tempList = await _database.query(
            '''select * from vat_report where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' and typeStr IN('sales','purchaseReturn') ''');
        return tempList;
      }
      else{
        tempList = await _database.query(
            '''select * from vat_report where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' ''');
        return tempList;
      }
    }
    else{
      if(user=='Input Tax'){
        tempList = await _databaseSqLite.rawQuery(
            '''select * from vat_report where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' and typeStr='purchase' and typeStr='salesReturn'  and typeStr='expense' ''');
        print('inside else before $tempList1 ');
        List temp = formatResult(tempList);
        print('inside else after $temp ');
        return temp;
      }
      else{
        tempList = await _databaseSqLite.rawQuery(
            '''select * from vat_report where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' and typeStr='sales' and typeStr='purchaseReturn' ''');
        print('inside else before $tempList1 ');
        List temp = formatResult(tempList);
        print('inside else after $temp ');
        return temp;
      }
    }
  }
  else if (tableName == 'expense_transaction') {
    dashBoardValues[0] = 0;
    if (dbConnected == '1') {
      tempList = await _database.query(
          '''select * from expense_transaction where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' ''');
      return tempList;
    } else {
      tempList = await _databaseSqLite.rawQuery(
          '''select * from expense_transaction where date >= '${dateFrom.substring(0, 10)}'  and date<='${dateTo.substring(0, 10)} 24:00'  ''');
      print('inside else before $tempList1 ');
      List temp = formatResult(tempList);
      print('inside else after $temp ');
      return temp;
    }
  } else if (tableName == 'item_report') {
    dashBoardValues[0] = 0;
    if (dbConnected == '1') {
      tempList = await _database.query(
          '''select * from item_report where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' ''');
      return tempList;
    } else {
      tempList = await _databaseSqLite.rawQuery(
          '''select * from item_report where date >= '${dateFrom.substring(0, 10)}'  and date<='${dateTo.substring(0, 10)} 24:00' ''');
      print('inside else before $tempList1 ');
      List temp = formatResult(tempList);
      print('inside else after $temp ');
      return temp;
    }
  } else if (tableName == 'purchase_data') {
    dashBoardValues[0] = 0;
    if (dbConnected == '1') {
      tempList = await _database.query(
          '''select * from purchase_data where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' and userName='$user' ''');
      return tempList;
    } else {
      tempList = await _databaseSqLite.rawQuery(
          '''select * from purchase_data where date >= '${dateFrom.substring(0, 10)}'  and date<='${dateTo.substring(0, 10)} 24:00'  and userName='$user'  ''');
      print('inside else before $tempList ');
      List temp = formatPurchaseReport(tempList);
      print('inside else after $temp ');
      return temp;
    }
  }
  else if (tableName == 'purchase_return') {
    dashBoardValues[0] = 0;
    if (dbConnected == '1') {
      tempList = await _database.query(
          '''select * from purchase_return where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' and userName='$user' ''');
      return tempList;
    } else {
      tempList = await _databaseSqLite.rawQuery(
          '''select * from purchase_return where date >= '${dateFrom.substring(0, 10)}'  and date<='${dateTo.substring(0, 10)} 24:00'  and userName='$user'  ''');
      print('inside else before $tempList ');
      List temp = formatPurchaseReport(tempList);
      print('inside else after $temp ');
      return temp;
    }
  }
  else if (tableName == 'sales_return') {
    dashBoardValues[0] = 0;
    if (dbConnected == '1') {
      tempList = await _database.query(
          '''select * from sales_return where dateStr >= '${dateFrom.substring(0, 10)}' and dateStr<='${dateTo.substring(0, 10)} 24:00' and userName='$user' ''');
      return tempList;
    } else {
      tempList = await _databaseSqLite.rawQuery(
          '''select * from sales_return where date >= '${dateFrom.substring(0, 10)}'  and date<='${dateTo.substring(0, 10)} 24:00'  and userName='$user'  ''');
      print('inside else before $tempList ');
      List temp = formatPurchaseReport(tempList);
      print('inside else after $temp ');
      return temp;
    }
  }
}

List formatSalesReport(List tempList) {
  List tempList1 = [];
  for (int i = 0; i < tempList.length; i++) {
    tempList1.add(
        tempList[i].toString().substring(1, tempList[i].toString().length - 1));
  }
  for (int j = 0; j < tempList1.length; j++) {
    String tempText1 = '';
    String tempText = tempList1[j].toString();
    int ind1 = tempText.indexOf('[');
    int ind2 = tempText.indexOf(']', ind1);
    String items = tempText.substring(ind1, ind2 + 1);
    items = items.trim();
    print('items $items');
    List temp = tempList1[j].toString().split(',');
    tempText1 =
        '${temp[0].toString().substring(4)},${temp[1].toString().substring(12).trim()},${temp[2].toString().substring(7).trim()},${temp[3].toString().substring(15).trim()},$items,${temp[temp.length - 5].toString().substring(10).trim()},${temp[temp.length - 4].toString().substring(10).trim()},${temp[temp.length - 3].toString().substring(8).trim()},${temp[temp.length - 2].toString().substring(10).trim()},${temp[temp.length - 1].toString().substring(11).trim()}';
    tempList1[j] = tempText1;
  }
  return tempList1;
}

List formatPurchaseReport(List tempList) {
  List tempList1 = [];
  for (int i = 0; i < tempList.length; i++) {
    tempList1.add(
        tempList[i].toString().substring(1, tempList[i].toString().length - 1));
  }
  for (int j = 0; j < tempList1.length; j++) {
    String tempText1 = '';
    String tempText = tempList1[j].toString();
    int ind1 = tempText.indexOf('[');
    int ind2 = tempText.indexOf(']', ind1);
    String items = tempText.substring(ind1, ind2 + 1);
    items = items.trim();
    print('items $items');
    List temp = tempList1[j].toString().split(',');
    tempText1 =
        '${temp[0].toString().substring(4)},${temp[1].toString().substring(12).trim()},${temp[2].toString().substring(7).trim()},${temp[3].toString().substring(13).trim()},$items,${temp[temp.length - 4].toString().substring(10).trim()},${temp[temp.length - 3].toString().substring(8).trim()},${temp[temp.length - 2].toString().substring(10).trim()},${temp[temp.length - 1].toString().substring(11).trim()}';
    tempList1[j] = tempText1;
  }
  return tempList1;
}
List formatSavedOrder(List tempList) {
  List tempList1 = [];
  for (int i = 0; i < tempList.length; i++) {
    tempList1.add(
        tempList[i].toString().substring(1, tempList[i].toString().length - 1));
  }
  for (int j = 0; j < tempList1.length; j++) {
    String tempText1 = '';
    // String tempText = tempList1[j].toString();
    // int ind1 = tempText.indexOf('items:');
    // int ind2 = tempText.indexOf('-', ind1);
    // String items = tempText.substring(ind1, ind2 + 1);
    // items = items.trim();
    // print('items $items');
    List temp = tempList1[j].toString().split(',');
    print('inisde function $temp');
    tempText1 =
        '${temp[0].toString().substring(9)},${temp[1].toString().substring(7).trim()},${temp[2].toString().substring(11).trim()},${temp[3].toString().substring(15).trim()},${temp[4].toString().substring(12).trim()},${temp[5].toString().substring(11).trim()},${temp[6].toString().substring(7).trim()}';
    tempList1[j] = tempText1;
  }
  return tempList1;
}

List formatResult(List value) {
  List tempList1 = [];
  for (int i = 0; i < value.length; i++) {
    tempList1
        .add(value[i].toString().substring(1, value[i].toString().length - 1));
  }
  print('inside format $tempList1');
  for (int j = 0; j < tempList1.length; j++) {
    String tempText = '';
    List temp = tempList1[j].toString().split(',');
    for (int k = 0; k < temp.length; k++) {
      List temp1 = temp[k].toString().split(':');
      tempText += '${temp1[1].toString().trim()},';
    }
    tempText = tempText.substring(0, tempText.length - 1);
    tempList1[j] = tempText.trim();
  }

  return tempList1;
}

Future<List> getDataSqLite(String tableName) async {
  List tempList;
  if (tableName == 'invoice_data') {
    tempList = await _databaseSqLite.query(tableName);
    print('sql invoice_data $tempList');
  }
  else if(tableName == 'bluetooth_data'){
    try{
      tempList=await _databaseSqLite.query(tableName);
      String tempList1=tempList[0].toString();
      tempList1=tempList1.substring(9,tempList1.length-1).trim();
      bluetoothAddress=tempList1;
      print('bluetooth $bluetoothAddress');
    }
    catch(e){

    }
  }
  else if (tableName == 'companyDetails') {
    try {
      tempList = await _databaseSqLite.query(tableName);
      print('inside company $tempList');
      List tempSplit = [];
      tempSplit = formatResult(tempList);
      print('inside company after $tempSplit');
      List tempSplit1 = tempSplit[0].toString().split(',');
      tempSplit1.removeAt(0);
      print('organisationData $tempSplit1');
      String temp = tempSplit1.toString();
      temp = temp.substring(1, temp.length - 1);
      organisationData = temp.replaceAll(',', ':');
      print('organisationData $organisationData');
    } catch (e) {}
  } else if (tableName == 'sequence_manager') {
    try {
      tempList = await _databaseSqLite.query('$tableName');
      List tempSplit = tempList[0].toString().split(',');
      // tempSplit=formatResult(tempList);
      tempSplit.removeAt(0);
      String tempText = '';
      for (int i = 0; i < tempSplit.length; i++) {
        List temp = tempSplit[i].toString().split(':');
        tempText += '${temp[1]}:${temp[2]}~';
      }
      print('sequenceData1 $tempText');
      sequenceData = tempText.substring(0, tempText.length - 2);
      print('sequenceData $sequenceData');

    } catch (e) {}
  } else if (tableName == 'customer_data') {
    customerFirstSplit = [];
    customerList = [];
    customerPriceList = [];
    customerBalanceList=[];
    try {
      tempList = await _databaseSqLite.query('$tableName');
      List tempList1 = formatResult(tempList);
      print('tempList1 $tempList1');
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        temp.removeAt(0);
        String tempText = temp.toString().replaceAll(',', ':');
        customerFirstSplit
            .add(tempText.substring(1, tempText.toString().length - 1));
        if (i == 0) {
          selectedCustomer = temp[0].toString().trim();
          selectedPriceList = temp[4].toString().trim();
        }
        customerList.add(temp[0].toString().trim());
        customerPriceList.add(temp[4].toString().trim());
        customerBalanceList.add(temp[5].toString().trim());
      }
    } catch (e) {}
  } else if (tableName == 'vendor_data') {
    vendorFirstSplit=[];
    vendorList = [];
    vendorPriceList = [];
    vendorBalanceList=[];
    try {
      tempList = await _databaseSqLite.query(
        '$tableName',
      );
      List tempList1 = [];
      tempList1 = formatResult(tempList);
      print('tempList1 $tempList1');
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        temp.removeAt(0);
        String tempText = temp.toString().replaceAll(',', ':');
        vendorFirstSplit
            .add(tempText.substring(1, tempText.toString().length - 1));
        if (i == 0) {
          selectedVendor = temp[0].toString().trim();
          selectedVendorPriceList = temp[4].toString().trim();
        }
        vendorList.add(temp[0].toString().trim());
        vendorPriceList.add(temp[4].toString().trim());
        vendorBalanceList.add(temp[5].toString().trim());
        print('vendorFirstSplit $vendorFirstSplit');
      }
    } catch (e) {}
  } else if (tableName == 'user_data') {
    userList=[];
    passwordList=[];
    terminalList=[];
    userPrefixList=[];
    try {
      tempList = await _databaseSqLite.query('$tableName');
      List tempList1 = formatResult(tempList);
      print('tempList1 $tempList1');
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        temp.removeAt(0);
        userList.add(temp[0].toString().trim());
        passwordList.add(temp[1].toString().trim());
        terminalList.add(temp[2].toString().trim());
        userPrefixList.add(temp[3].toString().trim());
      }
      print('user $userList $passwordList $terminalList');
    } catch (e) {

      print(e);
    }
  } else if (tableName == 'category_data') {
    categoryFirstSplit = [];
    productCategoryF = [];
    categoryCount = [];
    try {
      tempList = await _databaseSqLite.query('$tableName');
      List tempList1 = formatResult(tempList);
      print('tempList1 $tempList1');
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        temp.removeAt(0);
        categoryFirstSplit.add(temp);
        productCategoryF.add(temp[0].toString().trim());
        categoryCount.add(temp[1].toString().trim());
      }
      for (int i = 0; i < categoryFirstSplit.length; i++) {
        categoryFirstSplit[i] = categoryFirstSplit[i]
            .toString()
            .substring(1, categoryFirstSplit[i].toString().length - 1);
      }
      print('categoryFirstSplit $categoryFirstSplit');
    } catch (e) {}
  } else if (tableName == 'uom_data') {
    tempList = await _databaseSqLite.query('$tableName');
    print('tempList $tempList');
    uomList = [];
    List tempList1 = [];
    tempList1 = formatResult(tempList);
    print('uomEditSplit $uomEditSplit');
    uomEditSplit = tempList1;
    for (int i = 0; i < uomEditSplit.length; i++) {
      List tempSplit2 = uomEditSplit[i].toString().split(',');
      uomList.add(tempSplit2[1].toString().trim());
    }
    print('uomList $uomList');
  }
  else if (tableName == 'stock_data') {
    stockList=[];
    tempList = await _databaseSqLite.query('$tableName');
    print('tempList $tempList');
    List tempList1 = [];
    tempList1 = formatResult(tempList);
    for (int i = 0; i < tempList1.length; i++) {
      stockList.add(tempList1[i].toString().trim());
    }
   print('stockList $stockList');
  }
  else if (tableName == 'tax_data') {
    taxNameList=[];
    percentageList=[];
    tempList = await _databaseSqLite.query('$tableName');
    print('tempList $tempList');
    List tempList1 = [];
    tempList1 = formatResult(tempList);
    print('tax $tempList1');
    for (int i = 0; i < tempList1.length; i++) {
      List tempSplit2 = tempList1[i].toString().split(',');
      taxNameList.add(tempSplit2[1].toString().trim());
      percentageList.add(tempSplit2[2].toString().trim());
    }
    print('taxNameList $taxNameList');
    print('percentageList $percentageList');
  }
  else if (tableName == 'product_data') {
    productFirstSplit = [];
    allProducts=[];
    try {
      tempList = await _databaseSqLite.query('$tableName');
      List tempList1 = [];
      tempList1 = formatResult(tempList);
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        temp.removeAt(0);
        productFirstSplit.add(temp
            .toString()
            .replaceAll(',', ':')
            .substring(1, temp.toString().length - 1));

        allProducts.add(temp[0].toString().trim());
      }
      print('productFirstSplit $productFirstSplit');
    } catch (e) {}
  }
  else if (tableName == 'modifier_data') {
    modifier=[];
    print('inside modifier');
    try {
      tempList = await _databaseSqLite.query('$tableName');
      List tempList1 = [];
      tempList1 = formatResult(tempList);
      modifier = [];
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        modifier.add(temp[1].toString().trim());
      }
      print('modifier $modifier');
    } catch (e) {}
  }
  else if (tableName == 'expense_head') {
    print('inside expense');
    try {
      tempList = await _databaseSqLite.query('$tableName');
      List tempList1 = [];
      tempList1 = formatResult(tempList);
      expenseList = [];
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        expenseList.add(temp[1].toString().trim());
      }
      print('expense $expenseList');
    } catch (e) {}
  }else if (tableName == 'item_report') {
    print('inside item_report');
    try {
      tempList = await _databaseSqLite.query('$tableName');
      List tempList1 = [];
      tempList1 = formatResult(tempList);
      itemReport = [];
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        itemReport.add(temp[1].toString().trim());
      }
      print('itemReport $itemReport');
    } catch (e) {}
  }
  else if (tableName == 'printer_data') {
    printersList = [];
    allPrinter = [];
    tempList = await _databaseSqLite.query('$tableName');
    List tempList1 = [];
    tempList1 = formatResult(tempList);
    for (int j = 0; j < tempList1.length; j++) {
      printersList.add(tempList1[j]);
      List temp = tempList1[j].toString().split(',');
      print('inside get printer $temp');
      allPrinter.add(temp[1].toString().trim());
      if (temp[4].toString().trim() == 'true') {
        defaultPrinter = temp[1].toString().trim();
        defaultIpAddress = temp[2].toString().trim();
        defaultPort = temp[3].toString().trim();
      }
    }
  }
  else if (tableName == 'saved_order') {
    savedOrders = [];
    tempList = await _databaseSqLite.query('$tableName');
    tempList=formatSavedOrder(tempList);
    print('saved order tempList $tempList');
    // for (int i = 0; i < tempList.length; i++) {
    //   savedOrders.add(tempList[i]
    //       .toString()
    //       .substring(1, tempList[i].toString().length - 1));
    //   List temp = savedOrders[i].split(',');
    //   //salesOrderNoList.add(int.parse(temp[0].toString().trim()));
    // }
    savedOrderCount = savedOrders.length;
    print('savedOrders $savedOrders');
    print('savedOrderCount $savedOrderCount');
  }
  else if (tableName == 'kot_data') {
    print('inside kot data');
    try {
      tempList = await _databaseSqLite.query('$tableName');
      List tempList1 = [];
      tempList1 = formatResult(tempList);
      kotCategory = [];
      kotPrinter = [];
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        kotCategory.add(temp[0].toString().trim());
        kotPrinter.add(temp[1].toString().trim());
      }
      print('kotCategory $kotCategory');
      print('kotPrinter $kotPrinter');
    } catch (e) {}
  }
  return tempList;
}

Future<List> getDataPostgres(String tableName) async {
  List tempList;
  //connectPostgres(context);
  if (tableName == 'invoice_data') {
    tempList = await _database.query('SELECT * from $tableName');
    print('postgress invoice_data $tempList');
  } else if (tableName == 'purchase') {
    tempList = await _database.query('SELECT * from $tableName');
    print('tempList $tempList');
  } else if (tableName == 'purchase_return') {
    tempList = await _database.query('SELECT * from $tableName');
    print('tempList $tempList');
  } else if (tableName == 'sales_return') {
    tempList = await _database.query('SELECT * from $tableName');
    print('tempList $tempList');
  } else if (tableName == 'invoice_list') {
    orderToCheckout = [];
    tempList = await _database.query('SELECT * from $tableName');
    for (int i = 0; i < tempList.length; i++) {
      orderToCheckout.add(tempList[i]
          .toString()
          .substring(1, tempList[i].toString().length - 1));
    }
    checkoutListCount = orderToCheckout.length;
    print('orderToCheckout $orderToCheckout');
  } else if (tableName == 'customer_checkout') {
    tempList = await _database.query('SELECT * from $tableName');
    for (int i = 0; i < tempList.length; i++) {
      customerCheckoutList.add(tempList[i]
          .toString()
          .substring(1, tempList[i].toString().length - 1));
    }
    return customerCheckoutList;
    //checkoutListCount=orderToCheckout.length;
    //print('orderToCheckout $orderToCheckout');
  } else if (tableName == 'saved_order') {
    savedOrders = [];
    tempList = await _database.query('SELECT * from $tableName');
    for (int i = 0; i < tempList.length; i++) {
      savedOrders.add(tempList[i]
          .toString()
          .substring(1, tempList[i].toString().length - 1));
      List temp = savedOrders[i].split(',');
      //salesOrderNoList.add(int.parse(temp[0].toString().trim()));
    }
    savedOrderCount = savedOrders.length;
    // print('savedOrders $savedOrders');
    // print('savedOrderCount $savedOrderCount');
  } else if (tableName == 'uom_data') {
    tempList =
        await _database.query('SELECT * from $tableName order by id ASC');
    uomList = [];
    List tempList1 = [];
    for (int i = 0; i < tempList.length; i++) {
      tempList1.add(tempList[i]
          .toString()
          .substring(1, tempList[i].toString().length - 1));
    }
    uomEditSplit = tempList1;
    for (int i = 0; i < tempList.length; i++) {
      List tempSplit1 = tempList[i].toString().split(',');
      uomList.add(tempSplit1[1].toString().trim());
    }
    print('uomList $uomList');
  } else if (tableName == 'user_data') {
    userList=[];
    passwordList=[];
    terminalList=[];
    userPrefixList=[];
    try {
      tempList = await _database.query('SELECT * from $tableName');
      print('inisde user $tempList');
      List tempList1 = [];
      for (int i = 0; i < tempList.length; i++) {
        tempList1.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
      }
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        temp.removeAt(0);
        userList.add(temp[0].toString().trim());
        passwordList.add(temp[1].toString().trim());
        terminalList.add(temp[2].toString().trim());
        userPrefixList.add(temp[3].toString().trim());
      }
      print('user $userList $passwordList $terminalList');
    } catch (e) {
      print(e);
    }
  } else if (tableName == 'printer_data') {
    printersList = [];
    allPrinter = [];
    List tempPrint = [];
    tempPrint = await _database.query('SELECT printerName from $tableName');
    tempList = await _database.query('SELECT * from $tableName');
    for (int i = 0; i < tempList.length; i++) {
      String tempValue;
      tempValue=tempPrint[i].toString();
      tempValue=tempValue.substring(1, tempValue.length - 1);
      allPrinter.add(tempValue.trim());
      printersList.add(tempList[i]
          .toString()
          .substring(1, tempList[i].toString().length - 1));
    }
    print('inside get data printer $allPrinter');
    for (int j = 0; j < printersList.length; j++) {
      List temp = printersList[j].toString().split(',');
      //allPrinter.add(temp[1].toString().trim());
      if (temp[4].toString().trim() == 'true') {
        print('inside true ${temp[1].toString().trim()}');
        defaultPrinter = temp[1].toString().trim();
        defaultIpAddress = temp[2].toString().trim();
        defaultPort = temp[3].toString().trim();
      }
    }
    print('defaultPrinter $defaultPrinter');
  } else if (tableName == 'kot_data') {
    kotPrinter = [];
    kotCategory = [];
    kotPrinterIpAddress=[];
    List tempList1 = [];
    tempList = await _database.query('SELECT * from $tableName');
    for (int i = 0; i < tempList.length; i++) {
      tempList1.add(tempList[i]
          .toString()
          .substring(1, tempList[i].toString().length - 1));
    }
    for (int i = 0; i < tempList1.length; i++) {
      List temp = tempList1[i].toString().split(',');
      kotCategory.add(temp[0]);
      kotPrinter.add(temp[1]);
      kotPrinterIpAddress.add(temp[2]);
    }
  } else if (tableName == 'customer_data') {
    customerFirstSplit = [];
    customerList = [];
    customerPriceList = [];
    customerBalanceList=[];
    try {
      tempList =
          await _database.query('SELECT * from $tableName order by id ASC');
      List tempList1 = [];
      print('tempList $tempList');
      for (int i = 0; i < tempList.length; i++) {
        tempList1.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
      }
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        temp.removeAt(0);
        String tempText = temp.toString().replaceAll(',', ':');
        customerFirstSplit
            .add(tempText.substring(1, tempText.toString().length - 1));
        if (i == 0) {
          selectedCustomer = temp[0].toString().trim();
          selectedPriceList = temp[4].toString().trim();
        }
        customerList.add(temp[0].toString().trim());
        customerPriceList.add(temp[4].toString().trim());
        customerBalanceList.add(temp[5].toString().trim());
      }
    } catch (e) {}
  } else if (tableName == 'vendor_data') {
    vendorFirstSplit=[];
    vendorList = [];
    vendorPriceList = [];
    vendorBalanceList=[];
    try {
      tempList = await _database.query(
        'SELECT * from $tableName',
      );
      List tempList1 = [];
      for (int i = 0; i < tempList.length; i++) {
        tempList1.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
      }
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        temp.removeAt(0);
        String tempText = temp.toString().replaceAll(',', ':');
        vendorFirstSplit
            .add(tempText.substring(1, tempText.toString().length - 1));
        if (i == 0) {
          selectedVendor = temp[0].toString().trim();
          selectedVendorPriceList = temp[4].toString().trim();
        }
        vendorList.add(temp[0].toString().trim());
        vendorPriceList.add(temp[4].toString().trim());
        vendorBalanceList.add(temp[5].toString().trim());
        print('vendorFirstSplit $vendorFirstSplit');
      }
    } catch (e) {}
  } else if (tableName == 'category_data') {
    categoryFirstSplit = [];
    productCategoryF = [];
    categoryCount = [];
    try {
      tempList =
          await _database.query('SELECT * from $tableName order by id ASC');
      print('tempList $tempList');
      List tempList1 = [];
      for (int i = 0; i < tempList.length; i++) {
        tempList1.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
      }
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        temp.removeAt(0);
        categoryFirstSplit.add(temp);
        productCategoryF.add(temp[0].toString().trim());
        categoryCount.add(temp[1].toString().trim());
      }
      for (int i = 0; i < categoryFirstSplit.length; i++) {
        categoryFirstSplit[i] = categoryFirstSplit[i]
            .toString()
            .substring(1, categoryFirstSplit[i].toString().length - 1);
      }
      print('categoryFirstSplit $categoryFirstSplit');
    } catch (e) {}
  }
  else if (tableName == 'product_data') {
    allProducts=[];
    productFirstSplit = [];
    productNameF = [];
    try {
      tempList =
          await _database.query('SELECT * from $tableName order by id ASC');
      List tempList1 = [];
      for (int i = 0; i < tempList.length; i++) {
        tempList1.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
        tempList1[i] = tempList1[i].toString().replaceAll(',', ':');
      }
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(':');
        temp.removeAt(0);
        productFirstSplit.add(temp
            .toString()
            .replaceAll(',', ':')
            .substring(1, temp.toString().length - 1));
        allProducts.add(temp[0].toString().trim());
      }
    } catch (e) {}
  } else if (tableName == 'sequence_manager') {
    try {
      tempList = await _database.query('SELECT * from $tableName');
      print('inside get seq $tempList');
      List tempList1 = [];
      for (int i = 0; i < tempList.length; i++) {
        tempList1.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
      }
      List temp=tempList1[0].toString().split(',');
      temp.removeAt(0);
      sequenceData = temp.toString().replaceAll(',', '~');
      sequenceData = sequenceData.substring(1, sequenceData.length - 1);
      print('sequenceData $sequenceData');
    } catch (e) {}
  } else if (tableName == 'companyDetails') {
    try {
      tempList = await _database.query('SELECT * from $tableName');
      List tempList1 = [];
      for (int i = 0; i < tempList.length; i++) {
        tempList1.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
      }
      List temp1=tempList1[0].toString().split(',');
      temp1.removeAt(0);
      print('inside get org $temp1');
      organisationData = temp1.toString().replaceAll(',', ':');
      organisationData =
          organisationData.substring(1, organisationData.length - 1);
    decimals=int.parse(temp1[7].toString().trim());
      print('decimals $decimals');
      print('organisationData $organisationData');
    } catch (e) {}
  } else if (tableName == 'modifier_data') {
    try {
      tempList = await _database.query('SELECT * from $tableName');
      List tempList1 = [];
      for (int i = 0; i < tempList.length; i++) {
        tempList1.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
      }
      modifier = [];
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        modifier.add(temp[1].toString().trim());
      }
      print('modifier $modifier');
    } catch (e) {}
  } else if (tableName == 'kot_data') {
    print('inside kot data');
    try {
      tempList = await _database.query('SELECT * from $tableName');
      List tempList1 = [];
      for (int i = 0; i < tempList.length; i++) {
        tempList1.add(tempList[i]
            .toString()
            .substring(1, tempList[i].toString().length - 1));
      }
      kotCategory = [];
      kotPrinter = [];
      for (int i = 0; i < tempList1.length; i++) {
        List temp = tempList1[i].toString().split(',');
        kotCategory.add(temp[0].toString().trim());
        kotPrinter.add(temp[1].toString().trim());
      }
      print('kotCategory $kotCategory');
      print('kotPrinter $kotPrinter');
    } catch (e) {}
  }
  else if (tableName == 'stock_data') {
    stockList=[];
    tempList = await _database.query('SELECT * from $tableName');
    List tempList1 = [];
    for (int i = 0; i < tempList.length; i++) {
      tempList1.add(tempList[i]
          .toString()
          .substring(1, tempList[i].toString().length - 1));
    }
    for(int j=0;j<tempList1.length;j++){
      stockList.add(tempList1[j]);
    }
    print('stockList $stockList');
  } else if (tableName == 'expense_head') {
    expenseFirstSplit=[];
    expenseList=[];
    tempList = await _database.query('SELECT * from $tableName');
    List tempList1 = [];
    for (int i = 0; i < tempList.length; i++) {
      tempList1.add(tempList[i]
          .toString()
          .substring(1, tempList[i].toString().length - 1));
    }
    for(int j=0;j<tempList1.length;j++){
      List temp = tempList1[j].toString().split(',');
      temp.removeAt(0);
      expenseFirstSplit.add('${temp[0]}~${temp[1]}~${temp[2]}');
      print('expenseFirstSplit  $expenseFirstSplit');
      expenseList.add(temp[0]);
    }
    print('expenseList $expenseList');
  }
  else if (tableName == 'tax_data') {
    taxNameList=[];
    percentageList=[];
    tempList = await _database.query('SELECT * from $tableName');
    List tempList1 = [];
    for (int i = 0; i < tempList.length; i++) {
      tempList1.add(tempList[i]
          .toString()
          .substring(1, tempList[i].toString().length - 1));
    }
    for(int j=0;j<tempList1.length;j++){
      List temp = tempList1[j].toString().split(',');
      taxNameList.add(temp[1]);
      percentageList.add(temp[2]);
    }
    print('taxNameList $taxNameList');
    print('percentageList $percentageList');
  }
  return tempList;
}
Future<List> getVatItemReport(String invNo)async{
  List tempList=[];
  tempList = await _database.query('''SELECT * from item_report where invoiceNo='${invNo.trim()}' ''');
  List tempList1 = [];
  for (int i = 0; i < tempList.length; i++) {
    tempList1.add(tempList[i]
        .toString()
        .substring(1, tempList[i].toString().length - 1));
  }
  print('tempList1 $tempList1');
  return tempList1;
}
Future<List> getData(String tableName) async {
  print('inside get data');
  if (dbConnected == '1')
    getDataPostgres(tableName);
  else
    getDataSqLite(tableName);
}
