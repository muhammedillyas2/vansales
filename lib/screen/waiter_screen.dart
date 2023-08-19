import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'first_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
import 'sequence_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'dart:async';

import 'package:restaurant_app/constants.dart';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
import 'package:restaurant_app/screen/receivable_payable.dart';
import 'package:restaurant_app/screen/splash_screen.dart';
import 'package:restaurant_app/screen/stream_reports.dart';

// import 'package:sunmi_printer_plus/column_maker.dart';
// import 'package:sunmi_printer_plus/enums.dart';
// import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
// import 'package:sunmi_printer_plus/sunmi_style.dart';
import 'package:tuple/tuple.dart';
import 'login_page.dart';
import 'printer_settings.dart';
import 'package:badges/badges.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:intl/intl.dart';
import 'report_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'organisation_screen.dart';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_sunmi_printer_t2/flutter_sunmi_printer_t2.dart';
import 'package:restaurant_app/components/database_con.dart';
List<TextEditingController> cartController=[];
List<TextEditingController> cartdup=[];
String taxCum = "";

String customerName="";
TextEditingController bottomSheetQtyController = TextEditingController();
double salesTotal=0;
List<TextEditingController> cartQtyController=[];
RxBool kotOrderBadge=false.obs;
List currentKotOldList=[];
List currentKotOldList11=[];
String currentKotDate='';

String currentKotNote='';
String selectedCategory='All';
String lastSelectedCategory='All';
int currentPage=0;
List<double> salesTotalList=[];
List kotFailedList=[];
List<String> salesUomList=[];
String selectedDelivery='Spot';
String selectedPayment='Cash';
List<String> deliveryMode=['Spot','Take Away','Drive Through'];
List<String> paymentMode=[];
List<String> pMode=['Cash','Credit'];
String currentOrder='';
int badgeContent=0;
TextEditingController quantityController=TextEditingController();
TextEditingController nameController=TextEditingController();
TextEditingController cntctController=TextEditingController();
FocusNode quantityNode=FocusNode();
FocusNode nameNode=FocusNode();
int categoryPressed;
int productsLength;
List<bool> isSelected= [true, false,false];
RxString tableSelected='TABLE'.obs;
bool show = false;
bool enableQuantity=false;
bool _showOrderList=false;
String _orderDetails='';
List<int> salesOrderNoList=[];
List<int> selectedTableList=[];
int salesOrderNo;
int _selectedTable=1;
List <String> cartListText=[];
List <bool> cartbool=[];
List<bool> selected = List<bool>();
List<String> _orderDetailsList=[];
String _selectedItem='';
bool netconnect = false;
TextEditingController driveNoteController=TextEditingController();
TextEditingController takeAwayNoteController=TextEditingController();
class WaiterScreen extends StatefulWidget {
  TextEditingController appbarCustomerController=TextEditingController();
  static const String id='waiter';
  @override
  _WaiterScreenState createState() => _WaiterScreenState();
}
double getTotal(List total){
  double tempRate=0;
  for(int i=0;i<total.length;i++){
    tempRate+=total[i];
  }
  salesTotal=tempRate;
  return tempRate;
}
class _WaiterScreenState extends State<WaiterScreen> {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      netconnect=true;
      print('res:$result');
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }
  TextEditingController netBalanceController=TextEditingController(text: '');
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      print('con:${_connectionStatus.toString().trim()}');
    });
  }
  // FlutterOtp otp = FlutterOtp();
  // Twilio twilio = Twilio(
  //     accountSid : 'AC0ad34a6cb914a51a2b711609962368b2', // replace *** with Account SID
  //     authToken : '01703d787f46bb7e1502c27c9e14a99f',  // replace xxx with Auth Token
  //     twilioNumber : '+14256001968'  // replace .... with Twilio Number
  // );
  // Future<void> sendMessage(String anotherNumber) async {
  //   Message message = await twilio.messages.sendMessage(
  //       anotherNumber, 'your otp is dasf');
  //
  // }
  final salesdone = SnackBar(
      backgroundColor: bottomColor,
      duration: Duration(seconds: 5),
      content: Text('Sales Completed Successfully'));
  final salesreturndone = SnackBar(
      backgroundColor: bottomColor,
      duration: Duration(seconds: 5),
      content: Text('Sales Return Completed  Successfully'));
  final creditpaid = SnackBar(
      backgroundColor: bottomColor,
      duration: Duration(seconds: 5),
      content: Text('Credit Paid Successfully'));
  nonet(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(" internet Connection Required"),
      actions: [
        GestureDetector(
            onTap: (){
              setState(() {
                Navigator.pop(context);
              });
            },
            child: Text('OK'))
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  selectacustomer(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Select a Customer"),
      actions: [
        GestureDetector(
            onTap: (){
              setState(() {
                Navigator.pop(context);
              });
            },
            child: Text('OK'))
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

 addproduct(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Add Products"),
      actions: [
        GestureDetector(
            onTap: (){
              setState(() {
                Navigator.pop(context);
              });
            },
            child: Text('OK'))
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
 fillall(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Fill All Fields"),
      actions: [
        GestureDetector(
            onTap: (){
              setState(() {
                Navigator.pop(context);
              });
            },
            child: Text('OK'))
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  void addModifier(String name,String modifierName,String price,int pos){
    String tempModifier='';
    double tempPrice1=0;
    List temp=cartListText[pos].split(':');
    if(temp.length>4){
      List temp1=temp[4].toString().split('/');
      temp1.removeLast();
      for(int i=0;i<temp1.length;i++) {
        List temp2 = temp1[i].toString().split('*');
        if (temp2[0].toString().trim() == modifierName) {
          int tempQty = int.parse(temp2[1]) + 1;
          temp1[i] = '${temp2[0]}*$tempQty';
          tempModifier = temp1.toString();
          tempModifier =
              tempModifier.substring(1, tempModifier.length - 1).replaceAll(',', '/');
          tempModifier+='/';
          double tempPrice = double.parse(price);
          tempPrice1 = double.parse(temp[2]);
          tempPrice1 += tempPrice;
          temp[2] = tempPrice1.toString();
          setState(() {
            cartListText[pos]='${temp[0]}:${temp[1]}:${temp[2]}:${temp[3]}:$tempModifier';
            salesTotalList[pos] = tempPrice1;
            cartController[pos].text = tempPrice1.toStringAsFixed(decimals);
            getTotal(salesTotalList);
          });
          return;
        }
      }
      tempModifier=temp[4];
      tempModifier+='$modifierName*1/';
      double tempPrice=double.parse(price);
      tempPrice1=double.parse(temp[2]);
      tempPrice1+=tempPrice;
      temp[2]=tempPrice1.toString();
    }
    else{
      tempModifier='$modifierName*1/';
      double tempPrice=double.parse(price);
      tempPrice1=double.parse(temp[2]);
      tempPrice1+=tempPrice;
      temp[2]=tempPrice1.toString();
    }
    setState(() {
      cartListText[pos]='${temp[0]}:${temp[1]}:${temp[2]}:${temp[3]}:$tempModifier';
      salesTotalList[pos] = tempPrice1;
      cartController[pos].text = tempPrice1.toStringAsFixed(decimals);
      getTotal(salesTotalList);
    });
  }

  void removeModifier(String name,String modifierName,String price,int pos){
    String tempModifier='';
    double tempPrice1=0;
    List temp=cartListText[pos].split(':');
    if(temp.length>4){
      List temp1=temp[4].toString().split('/');
      temp1.removeLast();
      for(int i=0;i<temp1.length;i++) {
        List temp2 = temp1[i].toString().split('*');
        if (temp2[0].toString().trim() == modifierName) {
          int tempQty = int.parse(temp2[1]) -1;
          if(tempQty==0){
            temp1.removeAt(i);
            tempModifier = temp1.toString();
            if(temp1.isNotEmpty){
              tempModifier =
                  tempModifier.substring(1, tempModifier.length - 1).replaceAll(',', '/');
              tempModifier+='/';
              double tempPrice = double.parse(price);
              tempPrice1 = double.parse(temp[2]);
              tempPrice1 -= tempPrice;
              temp[2] = tempPrice1.toString();
              cartListText[pos]='${temp[0]}:${temp[1]}:${temp[2]}:${temp[3]}:$tempModifier';
            }
            else{
              double tempPrice = double.parse(price);
              tempPrice1 = double.parse(temp[2]);
              tempPrice1 -= tempPrice;
              temp[2] = tempPrice1.toString();
              cartListText[pos]='${temp[0]}:${temp[1]}:${temp[2]}:${temp[3]}';
            }
            setState(() {
              salesTotalList[pos] = tempPrice1;
              cartController[pos].text = tempPrice1.toStringAsFixed(decimals);
              getTotal(salesTotalList);
            });
            return;
          }
          else{
            temp1[i] = '${temp2[0]}*$tempQty';
            tempModifier = temp1.toString();
            tempModifier =
                tempModifier.substring(1, tempModifier.length - 1).replaceAll(',', '/');
            tempModifier+='/';
            double tempPrice = double.parse(price);
            tempPrice1 = double.parse(temp[2]);
            tempPrice1 -= tempPrice;
            temp[2] = tempPrice1.toString();
            setState(() {
              cartListText[pos]='${temp[0]}:${temp[1]}:${temp[2]}:${temp[3]}:$tempModifier';
              salesTotalList[pos] = tempPrice1;
              cartController[pos].text = tempPrice1.toStringAsFixed(decimals);
              getTotal(salesTotalList);
            });
            return;
          }
        }
      }
    }
  }
  void addToCart(int index){
    String tempText='';
    if(cartListText.isEmpty){
      String priceList=getBasePrice(productNameF[index], selectedPriceList);
      String uom=getBaseUom(productNameF[index]);
      cartController.add(TextEditingController());
      cartQtyController.add(TextEditingController());
      tempText='${productNameF[index]}:$uom:$priceList: 1';
      setState(() {
        salesTotalList.add(double.parse(priceList.trimLeft()));
        cartController[0].text=double.parse(priceList.trimLeft()).toStringAsFixed(decimals);
        cartQtyController[0].text='1';
        salesUomList.add(uom);
        cartListText.add(tempText.trim());
      });
    }
    else {
      for(int i=0;i<cartListText.length;i++) {
        if (cartListText[i].contains(
            productNameF[index])) {
          List tempList = cartListText[i].split(':');
          if (tempList[1].toString().trim() ==
              getBaseUom(productNameF[index]).toString().trim()) {
            int tempQuantity = int.parse(
                tempList[3]);
            //   print(tempQuantity);
            tempQuantity = tempQuantity + 1;
            //  print('${tempList[0]},${tempList[1].toString().trimLeft()}');
            String tempr = getPrice(tempList[0], tempList[1]);
            //print('tempr $tempr');
            double tempRate = double.parse(tempr);
            tempRate = tempRate * tempQuantity;
            //  print(tempRate);
            tempList[2] = '$tempRate';
            tempList[3] = tempQuantity.toString();
            //tempList[4] = "HK";
            tempText = tempList.toString();
            tempText =
                tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
            // print(tempText);
            tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
            setState(() {
              salesTotalList[i] = double.parse(tempRate.toString());
              cartController[i].text = tempRate.toString();
              cartQtyController[i].text = tempQuantity.toString();
              cartListText[i] = tempText.trim();
            });
            return;
          }
        }
      }
      setState(() {
        String uom=getBaseUom(productNameF[index]);
        salesUomList.add(uom);
        String priceList=getBasePrice(productNameF[index], selectedPriceList);
        tempText='${productNameF[index]}:$uom:$priceList: 1';
        cartController.add(TextEditingController(text: priceList));
        cartQtyController.add(TextEditingController(text: '1'));
        salesTotalList.add(double.parse(priceList.trimLeft()));
        cartListText.add(tempText.trim());
      });
    }
  }
  void addFromBottomSheet(String name,String uom,String price,String qty){
    print('inside add bottom');
    String tempText='';
    if(cartListText.isEmpty){
      double tempRate=double.parse(price);
      double unit = tempRate;
      tempRate=double.parse(qty)*tempRate;
      cartController.add(TextEditingController());
      cartQtyController.add(TextEditingController());
      cartdup.add(TextEditingController());
      tempText='$name:$uom:$tempRate:$qty';
      setState(() {
        salesTotalList.add(tempRate);
        cartController[0].text=tempRate.toStringAsFixed(decimals);
        cartQtyController[0].text=qty;
        cartdup[0].text=unit.toStringAsFixed(decimals);;
        salesUomList.add(uom);
        cartListText.add(tempText.trim());
      });
      print('inside add bottom ${cartController[0].text}');
    }
    else{
      for (int i = 0; i < cartListText.length; i++) {
        if (cartListText[i].contains(
            name)) {
          List tempList = cartListText[i].split(
              ':');
          if (tempList[1].toString().trim() ==
              getBaseUom(name).toString().trim()) {
            double tempRate=double.parse(price);
            double unit2 = tempRate;
            tempRate=double.parse(qty)*tempRate;
            tempText='$name:$uom:$tempRate:$qty';
            setState(() {
              salesTotalList[i] = tempRate;
              cartController[i].text = tempRate.toString();
              cartQtyController[i].text = qty;
              cartdup[i].text = unit2.toString();
              cartListText[i] = tempText.trim();
            });
            return;
          }
        }
      }
      setState(() {
        double tempRate=double.parse(price);
        double unit3 =tempRate;

        tempRate=double.parse(qty)*tempRate;
        tempText='$name:$uom:$tempRate:$qty';
        cartController.add(TextEditingController(text: tempRate.toString()));
        cartQtyController.add(TextEditingController(text: qty));
        cartdup.add(TextEditingController(text:unit3.toString()));
        salesTotalList.add(tempRate);
        salesUomList.add(uom);
        cartListText.add(tempText.trim());
      });
    }
  }
  void addFromSearch(String name,String quantityValue){
    print('sel:$_selectedItem');
    print(cartdup);
    print(cartController);

    String tempText='';
    if(cartListText.isEmpty){
       String uom=allSalableProductuom[allSalableProducts.indexOf(name.toString().trim())];
       String tempr=allSalableProductPrice[allSalableProducts.indexOf(name.toString().trim())];

      double tempRate=double.parse(tempr);
      cartController.add(TextEditingController());
      cartdup.add(TextEditingController());
      cartQtyController.add(TextEditingController());
      double urate =double.parse(tempr);
      tempRate=double.parse(quantityValue)*tempRate;
      tempText='$name:$uom:$tempRate: $quantityValue';
      setState(() {
        salesTotalList.add(tempRate);
        cartController[0].text=tempRate.toString();
        cartdup[0].text=urate.toString();
        cartQtyController[0].text=quantityValue;
        salesUomList.add(getBaseUom(name));
        cartListText.add(tempText.trim());
      });
      _selectedItem='';
    }
    else {

      for (int i = 0; i < cartListText.length; i++) {
        if (cartListText[i].contains(name.toString().trim())) {
          print('nameherw:$name');
          List tempList = cartListText[i].split(
              ':');

          if (tempList[0].toString().trim() == name.toString().trim()) {
            double rrr = 0;

            String tempr=allSalableProductPrice[allSalableProducts.indexOf(name.toString().trim())];

            double tempRate = double.parse(tempr);
            int qty = int.parse(tempList[3]) + int.parse(quantityValue);
           rrr = double.parse(tempr);
           print('rrr:$rrr');
            tempRate = qty * tempRate;
            double up = tempRate/qty;
            tempList[2] = tempRate.toString();
            tempList[3] = qty.toString();
            tempText = tempList.toString();
            tempText =  tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
            tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
            setState(() {
              salesTotalList[i] = tempRate;
              cartController[i].text = tempRate.toString();
              print('rrr:$rrr');
              cartdup[i].text = tempr.toString();
              cartQtyController[i].text = qty.toString();
              cartListText[i] = tempText.trim();
            });
            _selectedItem='';
            return;
          }
        }
      }
      setState(() {
        print('namess:$name');
        String uom=getBaseUom(name);
        print('name:$uom');
        String tempr=allSalableProductPrice[allSalableProducts.indexOf(name.toString().trim())];
        double tempRate=double.parse(tempr);
        double rrr=double.parse(tempr);
        print('rrr:$rrr');
        tempRate=double.parse(quantityValue)*tempRate;
        tempText='$name:$uom:$tempRate: $quantityValue';
        cartController.add(TextEditingController(text: tempRate.toString()));
        cartdup.add(TextEditingController(text: rrr.toString()));
        cartQtyController.add(TextEditingController(text:quantityValue));
        salesTotalList.add(tempRate);
        salesUomList.add(getBaseUom(name));
        cartListText.add(tempText.trim());
      });
      _selectedItem='';
    }
    print(cartdup);
    print(cartController);

  }
  String selected;
  TextEditingController customerVendorController=TextEditingController();

  TextEditingController amountController=TextEditingController(text: '');
  void removeFromCart(String text,String uom){
    String tempText='';
    for(int i=0;i<cartListText.length;i++) {
      if (cartListText[i].contains(
          text)) {
        List tempList = cartListText[i].split(
            ':');
        if (tempList[1].toString().trim() ==
            uom.toString().trim()) {
          double tempQuantity = double.parse(
              tempList[3]);
          tempQuantity = tempQuantity - 1;
          if (tempQuantity == 0) {
            setState(() {
              salesTotalList.removeAt(i);
              cartController.removeAt(i);
              cartQtyController.removeAt(i);
              cartListText.removeAt(i);
              salesUomList.removeAt(i);
            });
            return;
          }
          else {
            double tempRate = double.parse(getPrice(tempList[0], tempList[1]));
            tempRate = tempRate * tempQuantity;
            tempList[2] = '$tempRate';
            tempList[3] = tempQuantity.toString();
            tempText = tempList.toString();
            tempText =
                tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
            tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
            setState(() {
              salesTotalList[i] = tempRate;
              cartController[i].text = tempRate.toString();
              cartQtyController[i].text = tempQuantity.toString();
              cartListText[i] = tempText.trim();
            });
            return;
          }
        }

      }
    }
  }

  void addQuantity(String text,String uom){
    String tempText='';
    for(int i=0;i<cartListText.length;i++) {
      if (cartListText[i].contains(
          text)) {
        List tempList = cartListText[i].split(
            ':');
        if (tempList[1].toString().trim() ==
            uom.toString().trim()) {
          double tempQuantity = double.parse(
              tempList[3]);
          tempQuantity = tempQuantity + 1;
          double tempRate = double.parse(getPrice(tempList[0], tempList[1]));
          print('tempRate $tempRate');
          tempRate = tempRate * tempQuantity;
          tempList[2] = '$tempRate';
          tempList[3] = tempQuantity.toString();
          tempText = tempList.toString();
          tempText =
              tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
          tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
          setState(() {
            salesTotalList[i] = tempRate;
            cartController[i].text = tempRate.toString();
            cartQtyController[i].text = tempQuantity.toString();
            cartListText[i] = tempText.trim();
            print(cartListText[i]);
          });
          return;
        }
      }
    }
  }
  void barcodeEntry(String barcodeVal){
    String tempText='';
    if(productFirstSplit.toString().contains(barcodeVal)) {
      for (int i = 0; i < productFirstSplit.length; i++) {
        if (productFirstSplit[i].toString().contains(barcodeVal)) {
          List tempFirstSplit = productFirstSplit[i].toString().split(':');
          String barcodeType = tempFirstSplit[3].toString().trim();
          String name = tempFirstSplit[0].toString().trimLeft();
          barcodeType= barcodeType.substring(13);
          //  print('barcode type $barcodeType');
          List tempSplit = tempFirstSplit[4].split('``');

          List tempUomSplit = tempSplit[0].split('*');
          List tempPriceSplit = tempSplit[1].split('*');
          List tempBarcodeSplit = tempSplit[3].split('*');
          tempBarcodeSplit.removeLast();
          tempPriceSplit.removeLast();
          tempUomSplit.removeLast();
          // print(tempBarcodeSplit);
          for (int j = 0; j < tempBarcodeSplit.length; j++) {
            if (tempBarcodeSplit[j] == barcodeVal) {
              String name = tempFirstSplit[0];
              String tempPrice;
              if(tempPriceSplit[j].toString().trimLeft().contains('>')){
                List tempPriceListSplit=tempPriceSplit[j].toString().split('>');
                print(tempPriceListSplit);
                int pos=int.parse(selectedPriceList.substring(6));
                pos=pos-1;
                tempPrice=tempPriceListSplit[pos];
              }
              else
                tempPrice=tempPriceSplit[j].toString().trimLeft();
              for (int i = 0; i < cartListText.length; i++) {
                if (cartListText[i].contains(name.trim())) {
                  print('contains name');
                  List tempList = cartListText[i].split(':');
                  if(tempList[1].toString().trim()==tempUomSplit[j].toString().trim()) {
                    print('contains name');
                    int tempQuantity = int.parse(tempList[3]);
                    tempQuantity = tempQuantity + 1;
                    double tempRate =
                    double.parse(getPrice(tempList[0], tempList[1]));
                    print('tempRate $tempRate');
                    tempRate = tempRate * tempQuantity;
                    tempList[2] = '$tempRate';
                    tempList[3] = tempQuantity.toString();
                    tempText = tempList.toString();
                    tempText = tempText
                        .substring(1, tempText.length - 1)
                        .replaceAll(',', ':');
                    tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
                    setState(() {
                      salesTotalList[i] = tempRate;
                      cartController[i].text = tempRate.toString();
                      cartQtyController[i].text = tempQuantity.toString();
                      cartListText[i] = tempText;
                    });
                    print(tempText);
                    return;
                  }
                }
              }

              setState(() {
                tempText = '$name:${tempUomSplit[j]}:$tempPrice: 1';
                salesTotalList.add(double.parse(tempPrice));
                cartController.add(TextEditingController(text: tempPrice));
                cartQtyController.add(TextEditingController(text: '1'));
                salesUomList.add(tempUomSplit[j]);
                cartListText.add(tempText.trim());
              });
              print(tempText);
              return;
            }
          }

        }
      }
    }
    else{
      String tempBarcode=barcodeVal.substring(0,7);
      print('tempBarcode $tempBarcode');
      for (int i = 0; i < productFirstSplit.length; i++) {
        if (productFirstSplit[i].toString().contains(tempBarcode)){
          List tempFirstSplit = productFirstSplit[i].toString().split(':');
          print('tempFirstSplit $tempFirstSplit');
          String barcodeType = tempFirstSplit[3].toString().trim();
          List tempSplit = tempFirstSplit[4].split('``');
          if (barcodeType == 'selectedMode.Weighted') {
            print('barcodeType $barcodeType');
            String name = tempFirstSplit[0];
            List uom = tempSplit[0].toString().split('*');
            uom.removeLast();
            List amount = tempSplit[1].toString().split('*');
            amount.removeLast();
            double price=0;
            if(amount[0].contains('>')){
              print(amount);
              List tempAmountSplit=amount[0].toString().split('>');
              print(tempAmountSplit);
              int pos=int.parse(selectedPriceList.substring(6));
              pos=pos-1;
              price=double.parse(tempAmountSplit[pos].toString().trimLeft());
            }
            else
              price=double.parse(amount[0].toString().trimLeft());
            String weight = barcodeVal.substring(7);
            double tempWeight = (int.parse(weight) / 1000);
            double tempPrice = tempWeight * price;
            tempText = '$name:${uom[0]}:$tempPrice:$tempWeight';
            setState(() {
              cartController.add(TextEditingController(text: tempPrice.toString()));
              cartQtyController.add(TextEditingController(text: tempWeight.toString()));
              salesTotalList.add(tempPrice);
              salesUomList.add(uom[0]);
              cartListText.add(tempText.trim());
            });
            print(tempText);
            return;
          }
        }
      }}
  }
  // ignore: missing_return
  String getPrice(String productName,String uomName){
    print('uomName $uomName');
    for(int i=0;i<productFirstSplit.length;i++){
      if(productFirstSplit[i].contains(productName)) {
        List temp=productFirstSplit[i].split(':');
        if(temp[0].toString().trim()==productName.toString().trim()) {
          List tempPrice = temp[4].split('``');
          List tempUomSplit = tempPrice[0].toString().split('*');
          List tempPriceSplit = tempPrice[1].toString().split('*');
          print('split');
          for (int j = 0; j < tempUomSplit.length; j++) {
            print(tempUomSplit[j]);
            print(tempPriceSplit[j]);
            if (tempUomSplit[j].contains(uomName.trim())) {
              print('inside if');
              String basePrice;
              if (tempPriceSplit[j].toString().trimLeft().contains('>')) {
                List tempPriceListSplit = tempPriceSplit[j].toString().split(
                    '>');
                print(tempPriceListSplit);
                int pos = int.parse(selectedPriceList.substring(6));
                pos = pos - 1;
                basePrice = tempPriceListSplit[pos];
              }
              else
                basePrice = tempPriceSplit[j].toString().trimLeft();
              return basePrice;
              // print(tempPriceSplit[j]);
              // return tempPriceSplit[j].toString().trimLeft();
            }
          }
        }
      }
    }
  }
  // ignore: missing_return
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
  Future<void> shareFile() async {
    await WhatsappShare.shareFile(
      text: 'Whatsapp share text',
      phone: '+917510113345',
      filePath: ['/storage/emulated/0/Download/301282020_626066882213871_8078152638472788570_n.jpg'],
    );
  }
  String getBaseUom(String productName){
    print('cg');
    print(productFirstSplit);
    print(productName);
    for(int i=0;i<productFirstSplit.length;i++){
      if(productFirstSplit[i].contains(productName)){
        List temp=productFirstSplit[i].split(':');
        print(temp[4].toString().trim());
        print(temp[0].toString().trim());
        if(temp[0].toString().trim()==productName.toString().trim()) {
          List tempUom = temp[4].split('``');
          List tempUomSplit = tempUom[0].toString().split('*');
          print('base uommm ${tempUomSplit[0].toString().trim()}');
          return tempUomSplit[0].toString().trim();
        }
      }
    }

  }
  // ignore: missing_return
  List<String> getUom(String productName){
    print('cgf');
    print(productName);
    for(int i=0;i<productFirstSplit.length;i++){
      if(productFirstSplit[i].contains(productName)){
        List temp=productFirstSplit[i].split(':');
        if(temp[0].toString().trim()==productName.toString().trim()) {
          List tempUom = temp[4].split('``');
          List tempUomSplit = tempUom[0].toString().split('*');
          tempUomSplit.removeLast();
          print('tempUomSplit $tempUomSplit');
          return tempUomSplit;
        }
      }
    }
  }
  void showOrderList(List order){
    print('order $order');
    List showOrder=order;
    print('show order $showOrder');
    String currentTable=showOrder[2].toString().trim();
    String orderNo=showOrder[0].toString().trim();
    print(orderNo);
    selectedCustomer=showOrder[3].toString().trim();
    print('selectedPriceList ${showOrder[4].toString().trim()}');
    selectedPriceList=showOrder[4].toString().trim();
    String itemsTemp=showOrder[6].toString().trim();
    List showItems=itemsTemp.split('-');
    showItems.removeAt(showItems.length-1);
    setState(() {
      salesTotalList=[];
      salesUomList=[];
      cartController=[];
      cartListText=[];
      currentOrder=orderNo;
      _selectedTable=int.parse(currentTable);
    });
    for(int i=0;i<showItems.length;i++)
    {
      List tempCart=showItems[i].toString().split(':');
      print('tempCart $tempCart');
      setState(() {
        salesTotalList.add(double.parse(tempCart[2].toString().trim()));
        salesUomList.add(tempCart[1].toString().trim());
        cartController.add(TextEditingController(text: tempCart[2].toString().trim()));
        cartListText.add(showItems[i].toString().trim());
      });
    }
    print(cartListText);
  }
  Future checkOut(String currentOrderNo,bool checkoutPrint,int pMode,String dPaymentS,String dTotalS,bool prints) async {
    double balance=0;
    double tempDiscount=0;
    double tempNetPayable=0;
    if (cartListText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add Items')));
      return;
    }
    String tempBody;
    String reportBody;
    double tot = getTotal(salesTotalList);
    if(selectedBusiness=='Restaurant' && orgWaiterIs=='false'){
      String note = '';
      if (currentOrderNo.length > 0) {
        if(selectedDelivery=='Spot'){
          removeTable(tableSelected.value.replaceAll(',',  '~'),currentOrderNo);
        }
        firebaseFirestore.collection('kot_order').doc(currentOrderNo).delete();
      }
      else {
        if (selectedDelivery == 'Drive Through') {
          note = driveNoteController.text;
        }
        else if (selectedDelivery == 'Take Away') {
          note = takeAwayNoteController.text;
        }
      }
      String temp;
      int invNo;
      String  tableNumber=tableSelected.value;
      customerName = "";

        if (currentOrderNo.length < 1) {
          invNo = await getLastInv('kot');
          temp = '${getPrefix()}$invNo';
          currentOrder = temp;
        }
        String body = '$currentOrder#${dateNow()}#$selectedDelivery#$tot#$currentUser#$tableNumber#$note';
        List yourItemsList = [];
        for (int k = 0; k < cartListText.length; k++) {
          List temp = cartListText[k].split(':');
          String itemName = temp[0];
          String itemQty = temp[3];
          String itemUom = temp[1];
          String itemPrice = temp[2];
          String tempModifier1='';
          if(temp.length==5)
            tempModifier1=temp[4].toString().trim();
          else
            tempModifier1='';
          yourItemsList.add({
            "name": itemName,
            "uom": itemUom,
            "qty": itemQty,
            "price": itemPrice,
            "modifier":tempModifier1,
          });
        }
        create(body, 'invoice_list', yourItemsList);
      if (currentOrderNo.length < 1) {
        updateInv('kot', 1);
      }
    }
   else {
      if (currentOrderNo.length > 0) {
        if(selectedBusiness=='Restaurant'&& selectedDelivery=='Spot'){
          removeTable(tableSelected.value.replaceAll(',',  '~'),currentOrderNo);
        }
        firebaseFirestore.collection('kot_order').doc(currentOrderNo).delete();
      }
      if(pMode==1){
        balance=dPaymentS=='Credit'?salesTotal:0;
      }
      else{
        List tempDPayment=dPaymentS.split('*');
        List tempDTotal=dTotalS.split('*');
        for(int i=0;i<2;i++){
          if(tempDPayment[i].toString().trim()=='Credit'){
            balance=double.parse(tempDTotal[i].toString().trim());
          }
        }
      }
      createdBy = currentUser;
      int invNo;
      String routecust = '';
     // await getLastInv('customer_details');
       invNo = await getLastInv('sales');

      print('sales inv $invNo');
      List yourItemsList1 = [];
      selectedCustomer = selectedCustomer == '' ? 'Standard' : selectedCustomer;
      if(double.parse(totalDiscountController.text)>0){
        if(discountTypeSelected=='VAL'){
          tempDiscount=double.parse(totalDiscountController.text);
        }
        else{
          double val=double.parse(totalDiscountController.text);
          val=val/100;
          val=val*tempNetPayable;
          tempDiscount=val;
        }
      }
      print(selectedCustomer.toString().trim());
      if(selectedCustomer.toString().trim()!='Standard') {

        final index1 = customerList.indexWhere((element) => element == selectedCustomer.toString().trim());
        // DocumentSnapshot documentSnapshot= await firebaseFirestore.collection("customer_details").doc(selectedCustomer.toString().trim()).getSavy();
       routecust =  allroutecust[index1].toString().trim();
        // await firebaseFirestore.collection("customer_details").where(
        //     'customerName', isEqualTo: selectedCustomer.toString().trim())
        //     .get()
        //     .then((querySnapshot) {
        //   querySnapshot.docs.forEach((result) {
        //     routecust = result.get('route');
        //   });
        // });
      }
      String body = '$userSalesPrefix$invNo~$routecust~$selectedCustomer~$dPaymentS~$selectedDelivery~$dTotalS~Sales~$currentUser~$currentOrderNo~$createdBy~$balance~~$tempDiscount~$routecust';
      yourItemsList1.add({
        "invNo": "$userSalesPrefix$invNo",
        "date": DateTime
            .now()
            .millisecondsSinceEpoch,
        "payment": dPaymentS,
        "total": dTotalS,
        "type": 'Sales'
      });
      double taxable5 = 0;
      double tax5 = 0;
      double total5 = 0;
      double total0 = 0;
      List yourItemsList = [];
      print('cart:$cartListText');

      String bill = '';
      String invoic = 'Invoice no: ${invNo.toString()}';
      double af =0;
      for(int i =0;i<cartListText.length;i++){
        List a = cartListText[i].toString().split(':');
        bill=bill+'${cartListText[i].toString().trim().substring(0, cartListText[i].length)},\n';
        af+=double.parse(a[2]);


      }
      String ad='*LUSH*';
      String ad2='GLOBAL VILLAGE';
      String total = 'Total : ${af.toString()}';
      String news = '${ad.toString().trim()}\n$ad2\n$invoic\n${bill.trim().trim()}\n$total';

      // otp.sendOtp('7510113345', news,
      //     1000, 6000, '+91');
      // sendMessage('+916238001564');
      // Share.shareFiles(['C:\Users\lenovo/Downloads/yourPdf.pdf'], text: 'Your PDF!');


         // await launch("https://wa.me/${'+91${customerUserMobile.toString().trim()}'}?text=${news}");
      for (int k = 0; k < cartListText.length; k++) {
        List temp = cartListText[k].split(':');
        String itemName = temp[0];
        String itemQty = temp[3];
        String itemUom = temp[1];
        String itemPrice = temp[2];
        String itemTax = getTaxName(itemName);
        String taxPercent = getPercent(itemTax);
        if (taxPercent.trim() == '10') {
          taxable5 = double.parse(itemPrice) * 0.1;
          taxable5 = double.parse(itemPrice) - double.parse(itemPrice) / 1.1;
          tax5 = tax5 + double.parse(itemPrice) - double.parse(itemPrice) / 1.1;
          total5 += double.parse(itemPrice);
          taxable5 = total5 - tax5;
        }
        else {
          total0 += double.parse(itemPrice);
        }
        print('taxPercent error $taxPercent');
        double taxAmt = (double.parse(taxPercent) / 100) *
            double.parse(itemPrice);
        double lineTotal = double.parse(itemPrice);
        yourItemsList.add({
          "name": itemName,
          "uom": itemUom,
          "qty": itemQty,
          "price": itemPrice,
          "category": getCategory(itemName),
          "taxName": itemTax,
          "taxRate": taxPercent,
          "taxAmt": taxAmt
        });
        String itemBody = '$userSalesPrefix$invNo~$itemName~$itemUom~$itemQty~$itemPrice~${getCategory(
            itemName)}~$itemTax~$taxPercent~$taxAmt~$lineTotal~$selectedDelivery';
        create(itemBody, 'item_report', yourItemsList);
      }
      if(currentPrinter=='Network'){
        print('inside networkkk');
        const PaperSize paper = PaperSize.mm80;
        final profile = await CapabilityProfile.load();
        final printer = NetworkPrinter(paper, profile);
        //defaultIpAddress = "192.168.5.80";
        //defaultPort = "9100";
        try{
          print("Print result:::: "+allPrinterIp[allPrinter.indexOf(currentPrinterName)]);
          // final PosPrintResult res = await printer.connect(defaultIpAddress, port: int.parse(defaultPort),timeout: Duration(seconds: 10));
          final PosPrintResult res = await printer.connect(allPrinterIp[allPrinter.indexOf(currentPrinterName)], port: 9100);

          if (res == PosPrintResult.success) {

            if(organisationInvPrint=='One'){
              await  networkPrint('$invNo',printer );
            }
            else{
              await  networkPrint('$invNo',printer );
              await  networkPrint('$invNo',printer );

            }

            printer.disconnect();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print result: ${res.msg}')));

            //  await networkPrint1(printer);

          }
          else{
            print("FAILURE");
            //await  networkPrint('$userSalesPrefix$invNo',printer );
            //printer.disconnect();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print result: ${res.msg}')));
          }
          print('Print result: ${res.msg}');
        }
        catch(e){

        }
      }
      else if(currentPrinter=='T2MINI' ){

      }
      else if(currentPrinter=='V2PRO'&&prints==true){
        print('here print');
        print(reportnow);
        print(selectedPayment);

      }
      create(body, 'invoice_data', yourItemsList);
      print(invNo);
      updateInv('sales',invNo+1);

      int b = reportnow.indexOf(selectedCustomer.toString().trim());
      reportdat[b].add(yourItemsList1[0]);
      List tempData =reportdat[b];


        firebaseFirestore
            .collection('customer_report')
            .doc(selectedCustomer.toString().trim())
            .update({
          'data':tempData,
        }).then((_) {
        });

      if(selectedPayment.toString().trim()=='Credit'){
        print('true cred');
        updateReport(selectedCustomer, salesTotal.toStringAsFixed(3), 'customer_details',getCustomerUid(selectedCustomer),getCustomerBalance(selectedCustomer),'sales');
      }
        for(int k=0;k<cartListText.length;k++){
          List temp=cartListText[k].split(':');
          String itemName=temp[0];
          String itemQty=temp[3].toString().trim();
          String itemPrice=temp[2];
          String itemUom=temp[1];
          String tempBom=checkIfBomExist(itemName);
          if(tempBom.isNotEmpty){
            print('contains bommmmmm');
            List tempBom1=tempBom.split('``');
            List tempBomItem=tempBom1[0].toString().split('*');
            List tempBomUom=tempBom1[1].toString().split('*');
            List tempBomQty=tempBom1[2].toString().split('*');
            tempBomItem.removeLast();
            tempBomUom.removeLast();
            tempBomQty.removeLast();
            for(int i=0;i<tempBomItem.length;i++){
              String itemConversion=getConversion(tempBomItem[i], tempBomUom[i]);
              itemConversion=itemConversion=='0'?'1':itemConversion;
              double tempQty=double.parse(tempBomQty[i])*double.parse(itemConversion);
              tempBomQty[i]=tempQty.toString();
              // String stockDetails=await readStock(tempBomItem[i]);
              DocumentSnapshot documentSnapshot= await firebaseFirestore.collection("stock").doc(itemName.toString().trim()).getSavy();
              String stockDetails =  '${documentSnapshot['item']}~${documentSnapshot['qty']}~${documentSnapshot['cost']}~${documentSnapshot['value']}';
              List itemStockDetailsSplit = stockDetails.split('~');
              String stockQuantity=itemStockDetailsSplit[1].toString().trim();
              String costPrice=itemStockDetailsSplit[2].toString().trim();
              String stockValue=itemStockDetailsSplit[3].toString().trim();
              double newStockQuantity=double.parse(stockQuantity)-double.parse(tempBomQty[i]);
              double newSockValue=newStockQuantity*double.parse(costPrice);
              String stockBody='${tempBomItem[i]}~${newStockQuantity.toString()}~$costPrice~${newSockValue.toStringAsFixed(3)}';
               await updateStock(stockBody);
              print('after bommmmmm stock');
              updateWarehouse(tempBomItem[i],tempBomQty[i],'sales');
              print('after bommmmmm warehouse');

            }
          }
          String itemConversion=getConversion(itemName, itemUom);
          itemConversion=itemConversion=='0'?'1':itemConversion;
          double tempQty=double.parse(itemQty)*double.parse(itemConversion);
          itemQty=tempQty.toString();
          print('issue');
          print(itemName);
          DocumentSnapshot documentSnapshot = await firebaseFirestore.collection("stock").doc(itemName.toString().trim()).getSavy();
          String stockDetails =  '${documentSnapshot['item']}~${documentSnapshot['qty']}~${documentSnapshot['cost']}~${documentSnapshot['value']}';
          print('sde:$stockDetails');
          print(stocknow);

          List itemStockDetailsSplit = stockDetails.split('~');
          String stockQuantity=itemStockDetailsSplit[1].toString().trim();
          String costPrice=itemStockDetailsSplit[2].toString().trim();
          String stockValue=itemStockDetailsSplit[3].toString().trim();
          double newStockQuantity=double.parse(stockQuantity)-double.parse(itemQty);
          double newSockValue=newStockQuantity*double.parse(costPrice);
          String stockBody='$itemName~${newStockQuantity.toString()}~$costPrice~${newSockValue.toStringAsFixed(3)}';
          print(stockBody);

            await updateStock(stockBody);
           updateWarehouse(itemName,itemQty,'sales');
        }
    }
    return;
  }
  String getFirstTable(String text){
    List temp=text.split('~');
    return temp[0].toString().trim();
  }
  Future networkPrint(String invNo,NetworkPrinter printer)async{
    print('inside network ip ${appbarCustomerController.text}');
    double tax5=0;
    double tax10=0;
    double tax12=0;
    double tax18=0;
    double tax28=0;
    double cess=0;
    // Ticket testTicket() {
    printer.text('$organisationName',
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true
        ));
    printer.text('$organisationAddress', styles: PosStyles(align: PosAlign.center,));
    if(organisationMobile.length>0)
      printer.text('Mobile Number:$organisationMobile', styles: PosStyles(align: PosAlign.center,));
    if(organisationGstNo.length>0){
      printer.text('$organisationTaxType Number:$organisationGstNo', styles: PosStyles(align: PosAlign.center,));
      printer.text('$organisationTaxTitle' , styles: PosStyles(align: PosAlign.center,bold: true));
    }
    printer.hr(ch: '-');
    printer.text('Invoice No: $userSalesPrefix$invNo',
        styles: PosStyles(align: PosAlign.left,bold: true));
    printer.text(dateNow(),
        styles: PosStyles(align: PosAlign.left,bold:true));
    if(customerUserUid.length>0){
      print('iddddddddd $customerUserUid');
      printer.text('Customer details',);
      printer.text('Name : $customerUserName',);
      printer.text('Mobile No:$customerUserMobile', );
      printer.row([
        PosColumn(text: 'Flat NO:', width: 3,styles: PosStyles(bold:true,align: PosAlign.left),),
        PosColumn(text: customerUserFlatNo, width: 3,styles: PosStyles(bold:true,align: PosAlign.center)),
        PosColumn(text: 'BLD NO:', width: 3,styles: PosStyles(bold:true,align: PosAlign.right)),
        PosColumn(text: customerUserBldNo, width: 3,styles: PosStyles(bold:true,align: PosAlign.center)),
      ]);
      printer.row([
        PosColumn(text: 'ROAD NO:', width: 3,styles: PosStyles(bold:true,align: PosAlign.left),),
        PosColumn(text: customerUserRoadNo, width: 3,styles: PosStyles(bold:true,align: PosAlign.center)),
        PosColumn(text: 'BLOCK NO:', width: 3,styles: PosStyles(bold:true,align: PosAlign.right)),
        PosColumn(text: customerUserBlockNo, width: 3,styles: PosStyles(bold:true,align: PosAlign.center)),
      ]);
      printer.row([
        PosColumn(text: 'Area:', width: 3,styles: PosStyles(bold:true,align: PosAlign.left),),
        PosColumn(text: customerUserArea, width: 3,styles: PosStyles(bold:true,align: PosAlign.center)),
        PosColumn(text: 'Landmark:', width: 3,styles: PosStyles(bold:true,align: PosAlign.right)),
        PosColumn(text: customerUserLandmark, width: 3,styles: PosStyles(bold:true,align: PosAlign.center)),
      ]);
      firebaseFirestore.collection('customer_orders').doc(customerOrderUid).update({
        'checkOut':true
      });
    }
    else if (appbarCustomerController.text.length>0){
      printer.text('Customer Name: ${appbarCustomerController.text}',
          styles: PosStyles(align: PosAlign.left,bold: true));
      if(allCustomerAddress[customerList.indexOf(appbarCustomerController.text)].length>0)
        printer.text('Customer Address: ${allCustomerAddress[customerList.indexOf(appbarCustomerController.text)]}',
            styles: PosStyles(align: PosAlign.left,bold: true));
    }
    printer.hr(ch: '-');
    printer.text('Particulars',
        styles: PosStyles(align: PosAlign.left,bold: true));
    printer.row([
      // PosColumn(text: 'Particulars', width: organisationGstNo.length>0?6:7,styles: PosStyles(bold:true,align: PosAlign.left),),

      PosColumn(text: 'Qty', width: organisationGstNo.length>0?7:8,styles: PosStyles(bold:true,align: PosAlign.right)),
      PosColumn(text: 'Rate', width: 2,styles: PosStyles(bold:true,align: PosAlign.right)),
      if(organisationGstNo.length>0)
        PosColumn(text: 'Tax%', width: 1,styles: PosStyles(bold:true,align: PosAlign.right)),
      PosColumn(text: 'Amount', width: 2,styles: PosStyles(bold:true,align: PosAlign.right)),
    ]);
    printer.hr(ch: '-');
    grandTotal=0;double exclTotal =0;
    totalTax=0;
    for(int i=0;i<cartListText.length;i++)
    {
      List cartItemsString = cartListText[i].split(':');
      String itemNameSplit=cartItemsString[0].toString();
      if(cartItemsString[0].toString().contains('#')){
        itemNameSplit=itemNameSplit.substring(0,itemNameSplit.indexOf('#'));
      }
      double tempTotal = double.parse(cartItemsString[2]);
      String tax = getTaxName(cartItemsString[0].toString().trim());
      double amt = double.parse(cartItemsString[2]);
      double price = double.parse(cartItemsString[2]) /
          double.parse(cartItemsString[3]);
      amt = double.parse((amt).toStringAsFixed(3));
      grandTotal += amt;
      if(organisationTaxType=='VAT'){
        if (tax.trim() == 'VAT 10') {
          //tax10 += (double.parse( getPercent(tax)) / 100) * price;
          //tax10 =  tax10 + 0.1*amt;
          tax10 =  tax10 + amt-amt/1.1;
        }
      }
      else{
        if (tax.trim() == 'GST 5') {
          tax5 += (double.parse( getPercent(tax)) / 100) * price;
          totalTax+=tax5;
        }
        if (tax.trim() == 'GST 10') {
          tax10 =  tax10 + amt-amt/1.1;
          totalTax+=tax10;
        }
        if (tax.trim() == 'GST 12') {
          tax12 += (double.parse(getPercent(tax)) / 100) * price;
          totalTax+=tax12;
        }
        if (tax.trim() == 'GST 18') {
          tax18 += (double.parse(getPercent(tax)) / 100) * price;
          totalTax+=tax18;
        }
        if (tax.trim() == 'GST 28') {
          tax28 += (double.parse(getPercent(tax)) / 100) * price;
          cess += (12 / 100) * price;
          totalTax+=tax28+cess;
        }
        print('${cartItemsString[0]} totalTax $totalTax   tax $tax');
      }
      printer.text(itemNameSplit,
          styles: PosStyles(align: PosAlign.left,bold: true));
      printer.row([
        // PosColumn(text: '${cartItemsString[0]}', width:organisationGstNo.length>0?6:7,styles: PosStyles(align: PosAlign.left,bold:true)),
        PosColumn(text: cartItemsString[3], width: organisationGstNo.length>0?7:8,styles: PosStyles(align: PosAlign.right,bold:true)),
        PosColumn(text:price.toStringAsFixed(decimals), width:2,styles: PosStyles(align: PosAlign.right,bold:true)),
        if(organisationGstNo.length>0)
          PosColumn(text: getPercent(tax), width:1,styles: PosStyles(align: PosAlign.right,bold:true)),
        PosColumn(
            text: double.parse(cartItemsString[2].toString()).toStringAsFixed(
                decimals), width: 2,styles: PosStyles(align: PosAlign.right,bold:true)),
      ]);
    }
    printer.hr(ch: '-');
    if(organisationTaxType=='VAT'){
      exclTotal = grandTotal - tax10;
      printer.row([
        PosColumn(text: 'Bill Amount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
        PosColumn(text: '${exclTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
      ]);

      printer.row([
        PosColumn(text: 'Vat 10%', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
        PosColumn(text: '${tax10.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
      ]);

      grandTotal = exclTotal + tax10;

      printer.row([
        PosColumn(text: 'Net Payable', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
        PosColumn(text: '$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
      ]);

    }

    else{

      if(organisationGstNo.length>0){
        exclTotal = grandTotal - totalTax;
        printer.row([
          PosColumn(text: 'Bill Amount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '${exclTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
        ]);

        printer.row([
          PosColumn(text: 'Total Tax', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '${totalTax.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
        ]);
        if(double.parse(totalDiscountController.text)>0){
          printer.row([
            PosColumn(text: 'Discount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
            PosColumn(text: '${double.parse(totalDiscountController.text).toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
          ]);
          grandTotal = grandTotal - double.parse(totalDiscountController.text);
        }
        printer.row([
          PosColumn(text: 'Net Payable', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
        ]);
        printer.hr(ch: '-');
        if(tax5>0){
          printer.row( [
            PosColumn(text: 'CGST 2.5%', width: 3,styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: '${(tax5/2).toStringAsFixed(decimals)}', width: 3,styles: PosStyles(align: PosAlign.right)),
            PosColumn(text: ' SGST 2.5%', width: 3,styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: '${(tax5/2).toStringAsFixed(decimals)}', width: 3,styles: PosStyles(align: PosAlign.right)),
          ]);
        }
        if(tax12>0){
          printer.row([
            PosColumn(text: 'CGST 6%', width: 3 ,styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: '${(tax12/2).toStringAsFixed(decimals)}', width: 3,styles: PosStyles(align: PosAlign.right)),
            PosColumn(text: ' SGST 6%', width: 3,styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: '${(tax12/2).toStringAsFixed(decimals)}', width: 3,styles: PosStyles(align: PosAlign.right)),
          ]);
        }
        if(tax18>0){
          printer.row([
            PosColumn(text: 'CGST 9%', width: 3,styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: '${(tax18/2).toStringAsFixed(decimals)}', width: 3,styles: PosStyles(align: PosAlign.right)),
            PosColumn(text: ' SGST 9%', width:3 ,styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: '${(tax18/2).toStringAsFixed(decimals)}', width: 3,styles: PosStyles(align: PosAlign.right)),
          ]);
        }
        if(tax28>0){
          printer.row([
            PosColumn(text: 'CGST 14%', width: 3 ,styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: '${(tax28/2).toStringAsFixed(decimals)}', width: 3,styles: PosStyles(align: PosAlign.right)),
            PosColumn(text: ' SGST 14%', width: 3,styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: '${(tax28/2).toStringAsFixed(decimals)}', width: 3,styles: PosStyles(align: PosAlign.right)),
          ]);

          printer.row([
            PosColumn(text: 'cess 12%', width: 6 ,styles: PosStyles(align: PosAlign.left)),
            PosColumn(text: '${cess.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
          ]);
        }
      }
      else{
        if(double.parse(totalDiscountController.text)>0){
          printer.row([
            PosColumn(text: 'Bill Amount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
            PosColumn(text: '${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
          ]);
          printer.row([
            PosColumn(text: 'Discount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
            PosColumn(text: '${double.parse(totalDiscountController.text).toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
          ]);
          grandTotal = grandTotal - double.parse(totalDiscountController.text);

          printer.row([
            PosColumn(text: 'Net Payable', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
            PosColumn(text: '$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
          ]);
        }
        else{
          printer.row([
            PosColumn(text: 'Bill Amount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
            PosColumn(text: '$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
          ]);
          printer.hr(ch: '-');
        }
      }
    }
    if(organisationGstNo.length>0) printer.hr(ch: '-');
    printer.text('Thank You,Visit Again',
        styles: PosStyles(align: PosAlign.center,bold: true));
    printer.cut();
    printer.drawer();
  }
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: new Text('Are you sure?'),
        content: new Text('Do you want to Log Out'),
        actions: <Widget>[
          new TextButton(
            onPressed: () =>Navigator.pop(context),
            child: Container(
                padding: EdgeInsets.all(6.0),
                width: 100,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(10.0),
                    border: Border.all(color: kBlack)
                ),
                child: Center(
                  child: Text("No",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),),
                )),
          ),
          SizedBox(height: 16),

          new TextButton(
            onPressed: ()  {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            } ,
            child: Container(
                padding: EdgeInsets.all(6.0),
                width: 100,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(10.0),
                    border: Border.all(color: kBlack)
                ),
                child: Center(child: Text("Yes",style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                )))),
          ),
        ],
      ),

    ) ??
        false;
  }
  void searchOperation(String text) {
    searchResult.clear();
    if(text.length>0){
      print(allSalableProducts);
      for (int i = 0; i < allSalableProducts.length; i++) {
        String data = allSalableProducts[i];
        if (data.toLowerCase().contains(text.toLowerCase())) {
            searchResult.add(data);
        }
      }
    }
    else{
      searchResult.clear();
    }
  }
  PageController _pageController = PageController();
  int countValueOrder=0;
  Timer _timer;
  DbCon dbCon=DbCon();

  @override
  void initState() {
    // TODO: implement initState
    read('printer_data');
    read('kot_data');
    // read('customer_details');
    selectedCategory='All';
    lastSelectedCategory='All';
    paymentMode=[];
    paymentMode=['Cash','Credit'];
    // getKotOrders(currentUser);
    // getData('sequence_manager');
    // getData('customer_data');
    // getData('uom_data');
    // getData('kot_data');
    // getData('printer_data');
    // getOrganisationData();


     _pageController = PageController(
      initialPage: currentPage,
    );
    isSelected = [true, false,false];


    // if(selectedBusiness=='Restaurant')
    //   SchedulerBinding.instance.addPostFrameCallback((_) => showDialog(
    //     context: context,
    //     builder:(BuildContext context)=>tableView(context),));
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    // nameNode.dispose();
    // quantityNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ScrollController cartjump= ScrollController(initialScrollOffset: 0);
    // _animateToIndex(i) => cartjump.animateTo(i, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    // var offset = cartjump.offset;
    Padding buildDelivery(BuildContext context)  {

      int selectedMode=0;
      return Padding(
        padding: const EdgeInsets.only(left:6.0,right: 6.0),
        child: ToggleButtons(
          isSelected: isSelected,
          color:kGreenColor ,
          borderColor: kGreenColor,
          fillColor: kGreenColor,
          borderWidth: 2,
          selectedColor: kFont1Color,
          selectedBorderColor: kFont3Color,
          borderRadius: BorderRadius.circular(0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Dine In',
                style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*15, ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Take Away',
                style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Drive Through',
                style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*15,),
              ),
            ),
          ],
          onPressed: (int index) {
            selectedMode=index+1;
            setState(() {
              print('delivery type changed');
              selectedDelivery=deliveryMode[index];
              cartListText=[];
              totalDiscountController.text='0';
              currentOrder='';
              customerUserUid='';
              cartController=[];
              cartQtyController=[];
              salesUomList=[];
              salesTotalList=[];
              salesTotal=0;
              allCustomerMobileController.text='';
              for (int i = 0; i < isSelected.length; i++) {
                isSelected[i] = i == index;
              }

            });
             if(selectedDelivery=='Drive Through'){
              driveNoteController.text='';
              showDialog(context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        width: MediaQuery.of(context).size.width/3,
                        //height: MediaQuery.of(context).size.height/3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              TextField(
                                maxLines: 4,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                ),
                                controller: driveNoteController,
                                keyboardType: TextInputType.streetAddress,
                                decoration:InputDecoration(
                                  hintText: 'Enter customer details',
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
                                  //labelText: 'Username',
                                  labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                ),
                              ),
                              RawMaterialButton(
                                onPressed: () => Navigator.pop(context),
                                fillColor: kHighlight,
                                //splashColor: Colors.greenAccent,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Done",
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white,
                                      //letterSpacing: 1.0,
                                      fontSize: MediaQuery.of(context).textScaleFactor*18,
                                    ),
                                  ),
                                ),
                                shape: const StadiumBorder(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
            else if(selectedDelivery=='Take Away'){
              takeAwayNoteController.text='';
              showDialog(context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        width: MediaQuery.of(context).size.width/3,
                        //height: MediaQuery.of(context).size.height/3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              TextField(
                                maxLines: 4,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                ),
                                controller: takeAwayNoteController,
                                keyboardType: TextInputType.streetAddress,
                                decoration:InputDecoration(
                                  hintText: 'Enter customer details',
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
                                  //labelText: 'Username',
                                  labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                ),
                              ),
                              RawMaterialButton(
                                onPressed: () => Navigator.pop(context),
                                fillColor: kHighlight,
                                //splashColor: Colors.greenAccent,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Done",
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white,
                                      //letterSpacing: 1.0,
                                      fontSize: MediaQuery.of(context).textScaleFactor*18,
                                    ),
                                  ),
                                ),
                                shape: const StadiumBorder(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      );
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(

            // appBar:  AppBar(
            //   title:selectedmenu!='Receipt'?
            //   Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height*0.08,
            //     margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05,),
            //     child:selectedCustomer==''?SimpleAutoCompleteTextField(
            //
            //       decoration: InputDecoration(
            //         isDense: true,
            //         labelText: 'Search Customers',labelStyle: TextStyle(color: Colors.white),
            //         prefixIcon: const Icon(Icons.search, color: Colors.white,),
            //         enabledBorder:OutlineInputBorder(
            //             borderSide: BorderSide(
            //                 color: Colors.grey,width: 1.0
            //             )
            //         ),
            //         focusedBorder:
            //         OutlineInputBorder(
            //           borderSide: BorderSide(
            //               color: Colors.white, width: 1.0),
            //         ),
            //
            //       ),
            //       style: TextStyle(
            //         color: Colors.white,
            //
            //         fontSize: MediaQuery.of(context).textScaleFactor*14,
            //       ),
            //        controller: cntctController,
            //       clearOnSubmit: false,
            //       suggestions: customerList,
            //
            //       textSubmitted: (text){
            //          setState(() {
            //            selectedCustomer= cntctController.text = text;
            //            // selectedCustomer = customerList[allCustomerMobile.indexOf(text.toString().trim())];
            //           // print('sc:$selectedCustomer');
            //          });
            //          },
            //     )
            //         :Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(selectedCustomer.toString().trim(),style: TextStyle(fontFamily: 'Montserrat-SemiBold',fontSize: MediaQuery.of(context).size.width*0.045),),
            //         Text( allCustomerAddress[customerList.indexOf(selectedCustomer.toString().trim())],style: TextStyle(fontFamily: 'Montserrat-SemiBold',fontSize: MediaQuery.of(context).size.width*0.035),),
            //       ],
            //     ),
            //   ):Text('Dot Orders'),
            //   titleSpacing: 0.0,
            //   backgroundColor: bottomColor,
            //
            //   automaticallyImplyLeading: true,
            //   leading: GestureDetector(
            //     onTap: (){
            //       Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(builder: (context) => FirstScreen()));
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.all(17),
            //       child: CircleAvatar(
            //         backgroundColor: Colors.white,
            //         radius: MediaQuery.of(context).size.width*0.002,
            //         child: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: MediaQuery.of(context).size.width*0.061,),
            //       ),
            //     ),
            //   ),
            //
            // ),
          backgroundColor: selectedmenu=='Receipt'?Colors.white:Colors.grey.shade100,

            // bottomNavigationBar: BottomAppBar(
            //   color: Colors.white,
            //   child:Container(
            //
            //     child: Row(
            //
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //       GestureDetector(
            //           onTap: (){
            //             setState(() {
            //               selectedmenu = 'sales';
            //               currentOrder='';
            //               cartController=[];
            //               cartQtyController=[];
            //               cartdup =[];
            //
            //               print(cartdup.length);
            //               print(cartController.length);
            //               print(cartQtyController.length);
            //               salesTotalList=[];
            //               salesUomList=[];
            //               cartListText=[];
            //               customerName="";
            //             });
            //
            //
            //           },
            //           child: Container(
            //             margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.018),
            //             height: MediaQuery.of(context).size.height*0.08,
            //
            //             child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //               Icon(Icons.home_outlined, color: selectedmenu =='sales'?bottomColor:Colors.black87,size: MediaQuery.of(context).size.width*0.08,),
            //                 SizedBox(       height: MediaQuery.of(context).size.height*0.001,),
            //
            //                 Text('Sales',style: TextStyle(
            //                     color: selectedmenu =='sales'?bottomColor:Colors.black87,
            //                     fontSize: MediaQuery.of(context).size.width*0.035,),)
            //
            //               ],
            //             ),
            //           ),
            //         ),
            //
            //         TextButton(
            //           onPressed: (){
            //             setState(() {
            //               selectedmenu = 'salesreturn';
            //               currentOrder='';
            //               cartController=[];
            //               cartQtyController=[];
            //               cartdup =[];
            //
            //               print(cartdup.length);
            //               print(cartController.length);
            //               print(cartQtyController.length);
            //               salesTotalList=[];
            //               salesUomList=[];
            //               cartListText=[];
            //               customerName="";
            //             });
            //
            //
            //           },
            //           child: Container(
            //             height: MediaQuery.of(context).size.height*0.08,
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Icon(Icons.assignment_returned_outlined, color: selectedmenu =='salesreturn'?bottomColor:Colors.black87,size: MediaQuery.of(context).size.width*0.08,),
            //                 SizedBox(       height: MediaQuery.of(context).size.height*0.001,),
            //
            //                 Text('Sales Return',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035, color: selectedmenu =='salesreturn'?bottomColor:Colors.black87),)
            //
            //               ],
            //             ),
            //           ),
            //         ),
            //         TextButton(
            //           onPressed: (){
            //             setState(() {
            //               selectedmenu = 'Receipt';
            //             });
            //
            //           },
            //           child: Container(
            //             margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.028),
            //             height: MediaQuery.of(context).size.height*0.08,
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Icon(Icons.payments_outlined, color: selectedmenu =='Receipt'?bottomColor:Colors.black87,size: MediaQuery.of(context).size.width*0.08,),
            //                 SizedBox(       height: MediaQuery.of(context).size.height*0.001,),
            //
            //                 Text('Receipt',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035,  color: selectedmenu =='Receipt'?bottomColor:Colors.black87),)
            //
            //               ],
            //             ),
            //           ),
            //         ),
            //
            //
            //
            //
            //
            //       ],
            //     ),
            //   ) ,
            // ),
            resizeToAvoidBottomInset: false,
            body:(selectedmenu=='sales')?
            Column(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //       color:kBoxTextColor
                //   ),
                //   height: MediaQuery.of(context).size.height/11,
                //   width: MediaQuery.of(context).size.width,
                //   child:Row(
                //       mainAxisAlignment:MainAxisAlignment.start,
                //       children:[
                //         Container(
                //           height: MediaQuery.of(context).size.height/2,
                //           width:   MediaQuery.of(context).size.width*0.37,
                //           decoration: BoxDecoration(
                //             image: DecorationImage(
                //               image: AssetImage(
                //                   'images/dot_order.png'),
                //               fit: BoxFit.fill,
                //             ),
                //             shape: BoxShape.rectangle,
                //           ),
                //         ),
                //
                //   ]),
                // ),

                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height*0.076,
                //   margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,right: MediaQuery.of(context).size.width*0.01),
                //   child: SimpleAutoCompleteTextField(
                //     style: TextStyle(
                //       fontSize: MediaQuery.of(context).textScaleFactor*14,
                //     ),
                //      controller: cntctController,
                //     clearOnSubmit: false,
                //     suggestions: customerList,
                //
                //     textSubmitted: (text){
                //        setState(() {
                //
                //          selectedCustomer= cntctController.text = text;
                //         // selectedCustomer = customerList[allCustomerMobile.indexOf(text.toString().trim())];
                //         // print('sc:$selectedCustomer');
                //        });
                //
                //     },
                //     decoration: new InputDecoration(
                //         border: OutlineInputBorder(),
                //         disabledBorder: OutlineInputBorder(
                //         ),
                //         enabledBorder: OutlineInputBorder(),
                //         hintText: 'search for Customers'
                //     ),
                //
                //   ),
                // ),
                ClipPath(
                  clipper:CustomClipPath(),

                  child: Container(
                    height:MediaQuery.of(context).size.height*0.12,
                    // decoration: new BoxDecoration(
                    color: bottomColor,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => FirstScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(17),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: MediaQuery.of(context).size.width*0.04,
                              child: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: MediaQuery.of(context).size.width*0.072,),
                            ),
                          ),
                        ),
                        selectedmenu!='Receipt'?
                        Row(
                          children: [
                           MouseRegion(
                              onHover: (y){
                                selectedCustomer='';
                                cntctController.text='';

                                getCustomer();
                                setState(() {
                                  print('hi');

                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.6,
                                height: MediaQuery.of(context).size.height*0.08,

                                child:selectedCustomer==''?SimpleAutoCompleteTextField(

                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Search Customers',labelStyle: TextStyle(color: Colors.white),
                                    prefixIcon: const Icon(Icons.search, color: Colors.white,),
                                    enabledBorder:OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey,width: 1.0
                                        )
                                    ),
                                    focusedBorder:
                                    OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1.0),
                                    ),

                                  ),
                                  style: TextStyle(
                                    color: Colors.white,

                                    fontSize: MediaQuery.of(context).textScaleFactor*14,
                                  ),
                                  controller: cntctController,
                                  clearOnSubmit: false,
                                  suggestions: customerList,

                                  textSubmitted: (text){
                                    setState(() {
                                      selectedCustomer= cntctController.text = text;
                                      // selectedCustomer = customerList[allCustomerMobile.indexOf(text.toString().trim())];
                                      // print('sc:$selectedCustomer');
                                    });
                                  },
                                )
                                    :Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(selectedCustomer.toString().trim(),style: TextStyle(fontFamily: 'Montserrat-SemiBold',fontSize: MediaQuery.of(context).size.width*0.045,color: Colors.white),),

                                  ],
                                ),
                              ),
                            ),

                          ],
                        ):Text('Dot Orders'),
                      ],
                    ),
                    // borderRadius: BorderRadius.only(
                    //
                    //   bottomLeft:Radius.elliptical(
                    //       MediaQuery.of(context).size.width, 65.0) ,
                    //
                    //
                    //
                    //     bottomRight: Radius.elliptical(
                    //         MediaQuery.of(context).size.width, 110.0)
                    // ),
                  ),
                ),

                SizedBox(height:  MediaQuery.of(context).size.height*0.02,),
                Container(
                  padding: EdgeInsets.only(left: 5,right: 5),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.076,
                          child: TextField(
                            onTap: (){
                              getProducts();
                            },
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*14,
                            ),
                            focusNode: nameNode,
                            controller: nameController,
                            decoration: new InputDecoration(
                                border: OutlineInputBorder(),
                                disabledBorder: OutlineInputBorder(
                                ),
                                enabledBorder: OutlineInputBorder(),
                                hintText: 'search for items'
                            ),
                            onChanged: searchOperation,
                            onSubmitted: (text){
                              barcodeEntry(text);
                              nameController.clear();
                              nameNode.requestFocus();
                            },
                          ),
                        ),),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 1,
                        child: Container(

                          height: MediaQuery.of(context).size.height*0.076,
                          child: TextField(
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*14,
                            ),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            focusNode: quantityNode,
                            controller: quantityController,
                            showCursor: enableQuantity,
                            onSubmitted: (val)async{
                              if(_selectedItem.length>0){
                                print('a:$allSalableProductuom');
                               await addFromSearch(_selectedItem, val);
                               print('cl:${cartListText.length}');
                               if(cartListText.length>5){
                                cartjump.animateTo(MediaQuery.of(context).size.height*1.2, duration: Duration(milliseconds: 30), curve: Curves.ease);
                                if(cartListText.length>9){
                                  print('10');
                                  cartjump.animateTo( MediaQuery.of(context).size.height*1.4, duration: Duration(milliseconds: 30), curve: Curves.ease);
                                }
                               }

                              }
                              setState(() {
                                quantityController.clear();
                                nameController.clear();
                                nameNode.requestFocus();
                              });
                              _selectedItem='';
                            },
                            decoration: new InputDecoration(
                                border: OutlineInputBorder(),
                                disabledBorder: OutlineInputBorder(
                                ),
                                enabledBorder: OutlineInputBorder(),
                                hintText: 'quantity'
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02,right: MediaQuery.of(context).size.width*0.02),


                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          controller: cartjump,
                          physics: AlwaysScrollableScrollPhysics(),
                           shrinkWrap: false,
                          itemCount: cartListText.length,
                          itemBuilder: (BuildContext context, int index) {
                            cartbool.add(false);


                            List a = cartListText[index].toString().trim().split(':');
                            return  GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                 margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.01 ),
                                decoration: BoxDecoration(
                                    color:Colors.white,
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.03)
                                ),

                                height: cartbool[index]==true?MediaQuery.of(context).size.height*0.17:MediaQuery.of(context).size.height*0.115,
                                width: MediaQuery.of(context).size.width,

                                child:

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('${index+1} . ${a[0]}',style: TextStyle(  fontFamily: 'FrancoisOne',)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text('${cartController[index].text}',style: TextStyle( color: carttext, fontFamily: 'FrancoisOne',)),
                                          SizedBox(width:MediaQuery.of(context).size.width*0.05),
                                          GestureDetector(
                                              onTap:(){
                                                setState(() {
                                                  salesTotalList.removeAt(index);
                                                  cartController.removeAt(index);
                                                  cartdup.removeAt(index);
                                                  cartQtyController.removeAt(index);
                                                  cartListText.removeAt(index);
                                                  salesUomList.removeAt(index);
                                                  getTotal(salesTotalList);
                                                });
                                              },
                                              child: Icon(Icons.delete_outline,color: Colors.red,size: MediaQuery.of(context).size.width*0.065,))

                                        ],
                                      ),


                                 cartbool[index]==false?  Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(a[1]),
                                        SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                                        Icon(Icons.payments,color: bottomColor,size:MediaQuery.of(context).size.width*0.042 ,),
                                        SizedBox(width: MediaQuery.of(context).size.width*0.06,),

                                        GestureDetector(
                                        onTap: (){
                                          setState(() {

                                          });
                                         cartbool[index]=true;
                                        },
                                            child: Text(cartdup[index].text)),
                                        SizedBox(width: MediaQuery.of(context).size.width*0.06,),
                                        Icon(Icons.shopping_cart_outlined,color: bottomColor,size:MediaQuery.of(context).size.width*0.042 ),
                                        SizedBox(width: MediaQuery.of(context).size.width*0.06,),
                                        GestureDetector(
                                            onTap: (){
                                              setState(() {

                                              });
                                              cartbool[index]=true;
                                            },
                                            child: Text(cartQtyController[index].text)),


                                        // Container(
                                        //
                                        //   height: MediaQuery.of(context).size.height*0.05,
                                        //   width:MediaQuery.of(context).size.width*0.19,
                                        //   child: TextFormField(
                                        //     decoration: new InputDecoration(
                                        //       // contentPadding: EdgeInsets.all(4.0),
                                        //       isDense: false,
                                        //       contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                        //       border: OutlineInputBorder(),
                                        //       disabledBorder: OutlineInputBorder(
                                        //       ),
                                        //       enabledBorder: OutlineInputBorder(),
                                        //     ),
                                        //     style: TextStyle(
                                        //         fontSize: MediaQuery.of(context).textScaleFactor*16,
                                        //         color: kBlack,
                                        //         fontWeight: FontWeight.bold
                                        //     ),
                                        //     keyboardType: TextInputType.number ,
                                        //     controller: cartdup[index],
                                        //
                                        //     onChanged: (val){
                                        //
                                        //       List showCartItems=cartListText[index].split(':');
                                        //       double ab = double.parse(val.toString())*double.parse(showCartItems[3]);
                                        //       showCartItems[2]=ab.toString();
                                        //       showCartItems[1].toString();
                                        //       String tempVal=showCartItems.toString().replaceAll(',', ':');
                                        //       tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                                        //       print(tempVal);
                                        //       setState(() {
                                        //         salesTotalList[index]=ab;
                                        //         cartController[index].text=ab.toString();
                                        //         cartListText[index]=tempVal;
                                        //       });
                                        //     },
                                        //
                                        //
                                        //   ),
                                        // ),
                                        //
                                        //
                                        //
                                        // Container(
                                        //   margin: EdgeInsets.only(top: 10,bottom: 10),
                                        //   height: MediaQuery.of(context).size.height*0.05,
                                        //   width:MediaQuery.of(context).size.width*0.1,
                                        //   child: TextFormField(
                                        //     decoration: new InputDecoration(
                                        //       // contentPadding: EdgeInsets.all(4.0),
                                        //       isDense: false,
                                        //       contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                        //       border: OutlineInputBorder(),
                                        //       disabledBorder: OutlineInputBorder(
                                        //       ),
                                        //       enabledBorder: OutlineInputBorder(),
                                        //     ),
                                        //     style: TextStyle(
                                        //         fontSize: MediaQuery.of(context).textScaleFactor*16,
                                        //         color: kBlack,
                                        //         fontWeight: FontWeight.bold
                                        //     ),
                                        //     keyboardType: TextInputType.number ,
                                        //     controller: cartQtyController[index],
                                        //     onChanged: (val){
                                        //       List showCartItems=cartListText[index].split(':');
                                        //       double tempQuantity = double.parse(val);
                                        //       // double tempRate = double.parse(getPrice(showCartItems[0], showCartItems[1]));
                                        //       print(showCartItems);
                                        //       double tempRate = double.parse(showCartItems[2])/double.parse(showCartItems[3]);
                                        //       tempRate = tempRate * double.parse(val);
                                        //       print(tempRate);
                                        //       showCartItems[2] = '$tempRate';
                                        //       showCartItems[3] = tempQuantity.toString();
                                        //       String tempVal=showCartItems.toString().replaceAll(',', ':');
                                        //       tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                                        //       print(tempVal);
                                        //       setState(() {
                                        //         salesTotalList[index] = tempRate;
                                        //         cartController[index].text = tempRate.toString();
                                        //         // cartQtyController[index].text = tempQuantity.toStringAsFixed(2);
                                        //         cartListText[index]=tempVal;
                                        //       });
                                        //
                                        //     },),
                                        // ),
                                        // Container(
                                        //
                                        //     width:MediaQuery.of(context).size.width*0.14 ,
                                        //     child: Text('${cartController[index].text}',style: TextStyle(  fontFamily: 'FrancoisOne',))),


                                      ],
                                    ):  Row(
                                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(a[1]),
                                     SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                                     Icon(Icons.payments,color: bottomColor,size:MediaQuery.of(context).size.width*0.042 ,),
                                     SizedBox(width: MediaQuery.of(context).size.width*0.06,),

                                     Container(

                                       height: MediaQuery.of(context).size.height*0.05,
                                       width:MediaQuery.of(context).size.width*0.19,
                                       child: TextFormField(
                                         decoration: new InputDecoration(
                                           // contentPadding: EdgeInsets.all(4.0),
                                           isDense: false,
                                           contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                           border: OutlineInputBorder(),
                                           disabledBorder: OutlineInputBorder(
                                           ),
                                           enabledBorder: OutlineInputBorder(),
                                         ),
                                         style: TextStyle(
                                             fontSize: MediaQuery.of(context).textScaleFactor*16,
                                             color: kBlack,
                                             fontWeight: FontWeight.bold
                                         ),
                                         keyboardType: TextInputType.number ,
                                         controller: cartdup[index],
                                         onFieldSubmitted: (T){
                                           setState(() {

                                           });
                                           cartbool[index]=false;
                                         },

                                         onChanged: (val){

                                           List showCartItems=cartListText[index].split(':');
                                           double ab = double.parse(val.toString())*double.parse(showCartItems[3]);
                                           showCartItems[2]=ab.toString();
                                           showCartItems[1].toString();
                                           String tempVal=showCartItems.toString().replaceAll(',', ':');
                                           tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                                           print(tempVal);
                                           setState(() {
                                             salesTotalList[index]=ab;
                                             cartController[index].text=ab.toString();
                                             cartListText[index]=tempVal;
                                           });
                                         },


                                       ),
                                     ),
                                     SizedBox(width: MediaQuery.of(context).size.width*0.06,),
                                     Icon(Icons.shopping_cart_outlined,color: bottomColor,size:MediaQuery.of(context).size.width*0.042 ),
                                     SizedBox(width: MediaQuery.of(context).size.width*0.06,),
                                     Container(
                                       margin: EdgeInsets.only(top: 10,bottom: 10),
                                       height: MediaQuery.of(context).size.height*0.05,
                                       width:MediaQuery.of(context).size.width*0.1,
                                       child: TextFormField(
                                         decoration: new InputDecoration(
                                           // contentPadding: EdgeInsets.all(4.0),
                                           isDense: false,
                                           contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                           border: OutlineInputBorder(),
                                           disabledBorder: OutlineInputBorder(
                                           ),
                                           enabledBorder: OutlineInputBorder(),
                                         ),
                                         style: TextStyle(
                                             fontSize: MediaQuery.of(context).textScaleFactor*16,
                                             color: kBlack,
                                             fontWeight: FontWeight.bold
                                         ),
                                         keyboardType: TextInputType.number ,
                                         controller: cartQtyController[index],
                                         onFieldSubmitted: (T){
                                           setState(() {

                                           });
                                           cartbool[index]=false;
                                         },
                                         onChanged: (val){
                                           List showCartItems=cartListText[index].split(':');
                                           double tempQuantity = double.parse(val);
                                           // double tempRate = double.parse(getPrice(showCartItems[0], showCartItems[1]));
                                           print(showCartItems);
                                           double tempRate = double.parse(showCartItems[2])/double.parse(showCartItems[3]);
                                           tempRate = tempRate * double.parse(val);
                                           print(tempRate);
                                           showCartItems[2] = '$tempRate';
                                           showCartItems[3] = tempQuantity.toString();
                                           String tempVal=showCartItems.toString().replaceAll(',', ':');
                                           tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                                           print(tempVal);
                                           setState(() {
                                             salesTotalList[index] = tempRate;
                                             cartController[index].text = tempRate.toString();
                                             // cartQtyController[index].text = tempQuantity.toStringAsFixed(2);
                                             cartListText[index]=tempVal;
                                           });

                                         },),
                                     ),



                                     // Container(
                                     //
                                     //   height: MediaQuery.of(context).size.height*0.05,
                                     //   width:MediaQuery.of(context).size.width*0.19,
                                     //   child: TextFormField(
                                     //     decoration: new InputDecoration(
                                     //       // contentPadding: EdgeInsets.all(4.0),
                                     //       isDense: false,
                                     //       contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                     //       border: OutlineInputBorder(),
                                     //       disabledBorder: OutlineInputBorder(
                                     //       ),
                                     //       enabledBorder: OutlineInputBorder(),
                                     //     ),
                                     //     style: TextStyle(
                                     //         fontSize: MediaQuery.of(context).textScaleFactor*16,
                                     //         color: kBlack,
                                     //         fontWeight: FontWeight.bold
                                     //     ),
                                     //     keyboardType: TextInputType.number ,
                                     //     controller: cartdup[index],
                                     //
                                     //     onChanged: (val){
                                     //
                                     //       List showCartItems=cartListText[index].split(':');
                                     //       double ab = double.parse(val.toString())*double.parse(showCartItems[3]);
                                     //       showCartItems[2]=ab.toString();
                                     //       showCartItems[1].toString();
                                     //       String tempVal=showCartItems.toString().replaceAll(',', ':');
                                     //       tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                                     //       print(tempVal);
                                     //       setState(() {
                                     //         salesTotalList[index]=ab;
                                     //         cartController[index].text=ab.toString();
                                     //         cartListText[index]=tempVal;
                                     //       });
                                     //     },
                                     //
                                     //
                                     //   ),
                                     // ),
                                     //
                                     //
                                     //
                                     // Container(
                                     //   margin: EdgeInsets.only(top: 10,bottom: 10),
                                     //   height: MediaQuery.of(context).size.height*0.05,
                                     //   width:MediaQuery.of(context).size.width*0.1,
                                     //   child: TextFormField(
                                     //     decoration: new InputDecoration(
                                     //       // contentPadding: EdgeInsets.all(4.0),
                                     //       isDense: false,
                                     //       contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                     //       border: OutlineInputBorder(),
                                     //       disabledBorder: OutlineInputBorder(
                                     //       ),
                                     //       enabledBorder: OutlineInputBorder(),
                                     //     ),
                                     //     style: TextStyle(
                                     //         fontSize: MediaQuery.of(context).textScaleFactor*16,
                                     //         color: kBlack,
                                     //         fontWeight: FontWeight.bold
                                     //     ),
                                     //     keyboardType: TextInputType.number ,
                                     //     controller: cartQtyController[index],
                                     //     onChanged: (val){
                                     //       List showCartItems=cartListText[index].split(':');
                                     //       double tempQuantity = double.parse(val);
                                     //       // double tempRate = double.parse(getPrice(showCartItems[0], showCartItems[1]));
                                     //       print(showCartItems);
                                     //       double tempRate = double.parse(showCartItems[2])/double.parse(showCartItems[3]);
                                     //       tempRate = tempRate * double.parse(val);
                                     //       print(tempRate);
                                     //       showCartItems[2] = '$tempRate';
                                     //       showCartItems[3] = tempQuantity.toString();
                                     //       String tempVal=showCartItems.toString().replaceAll(',', ':');
                                     //       tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                                     //       print(tempVal);
                                     //       setState(() {
                                     //         salesTotalList[index] = tempRate;
                                     //         cartController[index].text = tempRate.toString();
                                     //         // cartQtyController[index].text = tempQuantity.toStringAsFixed(2);
                                     //         cartListText[index]=tempVal;
                                     //       });
                                     //
                                     //     },),
                                     // ),
                                     // Container(
                                     //
                                     //     width:MediaQuery.of(context).size.width*0.14 ,
                                     //     child: Text('${cartController[index].text}',style: TextStyle(  fontFamily: 'FrancoisOne',))),


                                   ],
                                 )

                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          color: kItemContainer,
                          child:  Obx(()=> ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchResult.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){
                                  nameController.text=_selectedItem=searchResult[index];
                                  print('selecteddd:$_selectedItem');
                                  searchResult.clear();
                                  quantityNode.requestFocus();
                                },
                                child: new ListTile(
                                  title: new Text(searchResult[index].toString()),
                                ),
                              );
                            },
                          )
                          )
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Column(
                    children: [

                      Container(

                          decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 3.0, color: Colors.grey.shade200),
                              ),

                              color: Colors.white

                          ),
                          height: MediaQuery.of(context).size.height*0.15,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.045,right: MediaQuery.of(context).size.width*0.045,top: MediaQuery.of(context).size.height*0.015),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Items : ${cartdup.length}',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,color: Colors.grey.shade600 ),),
                                    // Text('SUB TOTAL : ${getTotal(salesTotalList).toStringAsFixed(decimals)}',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.037, fontWeight: FontWeight.bold),),
                                    // Text('TAX : 0',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.037,fontWeight: FontWeight.bold ),),
                                    Text('Total Price :  ${getTotal(salesTotalList).toStringAsFixed(decimals)}',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.bold),),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.045,left: MediaQuery.of(context).size.width*0.045,bottom: MediaQuery.of(context).size.height*0.015),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: ()async{



                                        setState(() {
                                          currentOrder='';
                                          cartController=[];
                                          cartQtyController=[];
                                          cartdup =[];

                                          print(cartdup.length);
                                          print(cartController.length);
                                          selectedCustomer = '';
                                          cntctController.clear();

                                          print(cartQtyController.length);
                                          salesTotalList=[];
                                          salesUomList=[];
                                          cartListText=[];
                                          customerName="";
                                        });
                                      },
                                      child: Container(
                                        height:MediaQuery.of(context).size.height*0.06 ,
                                        width:MediaQuery.of(context).size.width*0.33,
                                        decoration: BoxDecoration(
                                            color:Colors.white,
                                            border:Border.all(
                                     color: Colors.black,

                                   ),
                                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.022)
                                        ),
                                        child: Center(child: Text('CANCEL',style: TextStyle(color: Colors.black),)),

                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ()async{
                                        await initConnectivity();
                                        print(cartListText);
                                        print(customerName);
                                        if(selectedCustomer!=''&&cartListText.isNotEmpty&& _connectionStatus.toString().trim()!='ConnectivityResult.none'){
                                          print('true');
                                          Rx<TextEditingController> dualPayment3=TextEditingController(text:salesTotal.toStringAsFixed(decimals)).obs;
                                          Rx<TextEditingController> dualPayment1=TextEditingController(text: '0').obs;
                                          Rx<TextEditingController> dualPayment2=TextEditingController(text: '0').obs;
                                          RxString dualPaymentSelected1='Cash'.obs;
                                          RxString dualPaymentSelected2='Card'.obs;
                                          RxDouble refundAmt=0.0.obs;
                                          RxBool showDualPayment=false.obs;
                                          RxBool showCashTendered=true.obs;
                                          showDialog(
                                              context:
                                              context,
                                              builder: (BuildContext context) {
                                                return Center(
                                                  child: Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis
                                                          .vertical,
                                                      child: Dialog(
                                                          backgroundColor: Colors
                                                              .white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  12.0)),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: MediaQuery
                                                                      .of(context)
                                                                      .size
                                                                      .height *
                                                                      0.008),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                  right: 10.0,
                                                                  left: 10.0,
                                                                  bottom: 10.0,),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            'Total',
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .textScaleFactor *
                                                                                  15,
                                                                            ),),
                                                                          Text(
                                                                            salesTotal
                                                                                .toStringAsFixed(
                                                                                decimals),
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .textScaleFactor *
                                                                                  20,
                                                                            ),)
                                                                        ]
                                                                    ),
                                                                    SizedBox(
                                                                        height: MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .height *
                                                                            0.03),
                                                                    Obx(() => Row(
                                                                      children: [
                                                                        dualPaymentSelected1
                                                                            .value ==
                                                                            'Cash'
                                                                            ? IconButton(
                                                                            onPressed: () {
                                                                              dualPaymentSelected1.value = 'Cash';
                                                                              print(
                                                                                  selectedPayment);
                                                                              selectedPayment =
                                                                              'Cash';
                                                                              print(
                                                                                  selectedPayment);
                                                                              if (dualPaymentSelected1
                                                                                  .value ==
                                                                                  'Cash')
                                                                                showCashTendered
                                                                                    .value =
                                                                                true;
                                                                              else
                                                                                showCashTendered
                                                                                    .value =
                                                                                false;
                                                                            },

                                                                              icon: Icon(

                                                                                  Icons
                                                                                      .radio_button_checked,color: Colors.black),
                                                                            )
                                                                            :
                                                                        IconButton(
                                                                          onPressed: () {
                                                                            dualPaymentSelected1.value = 'Cash';
                                                                            print(
                                                                                selectedPayment);
                                                                            selectedPayment =
                                                                            'Cash';
                                                                            print(
                                                                                selectedPayment);
                                                                            if (dualPaymentSelected1
                                                                                .value ==
                                                                                'Cash')
                                                                              showCashTendered
                                                                                  .value =
                                                                              true;
                                                                            else
                                                                              showCashTendered
                                                                                  .value =
                                                                              false;
                                                                          },
                                                                          icon: Icon(
                                                                              Icons
                                                                                  .radio_button_unchecked,color: Colors.black),
                                                                        ),
                                                                        SizedBox(
                                                                            width: 10),
                                                                        Text(
                                                                          'Cash',
                                                                          style: TextStyle(
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .width *
                                                                                  0.048),),
                                                                        SizedBox(
                                                                            width: 20),
                                                                        dualPaymentSelected1
                                                                            .value ==
                                                                            'Credit'
                                                                            ?

                                                                        IconButton(
                                                                         icon: Icon(Icons
                                                                              .radio_button_checked,color: Colors.black),
                                                                        )
                                                                            : IconButton(
                                                                            onPressed: () {
                                                                              dualPaymentSelected1
                                                                                  .value =
                                                                              'Credit';

                                                                              selectedPayment =
                                                                              'Credit';

                                                                              if (dualPaymentSelected1
                                                                                  .value ==
                                                                                  'Cash')
                                                                                showCashTendered
                                                                                    .value =
                                                                                true;
                                                                              else
                                                                                showCashTendered
                                                                                    .value =
                                                                                false;
                                                                              print(
                                                                                  dualPaymentSelected1
                                                                                      .value);
                                                                            },
                                                                            icon: Icon(
                                                                              Icons
                                                                                  .radio_button_unchecked,color: Colors.black,)),
                                                                        SizedBox(
                                                                            width: 10),
                                                                        Text(
                                                                          'Credit',
                                                                          style: TextStyle(
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .width *
                                                                                  0.048),)
                                                                      ],
                                                                    ))
                                                                    ,

                                                                    // Row(
                                                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //     children:[
                                                                    //       Container(
                                                                    //         width:120,
                                                                    //         decoration: BoxDecoration(
                                                                    //           border: Border.all(
                                                                    //               color: kAppBarItems,
                                                                    //               style: BorderStyle.solid,
                                                                    //               width: 2),
                                                                    //         ),
                                                                    //         child: DropdownButtonHideUnderline(
                                                                    //           child: ButtonTheme(
                                                                    //             alignedDropdown: true,
                                                                    //             child: Obx(()=>DropdownButton(
                                                                    //               dropdownColor:Colors.white,
                                                                    //               isDense: true,
                                                                    //               value: dualPaymentSelected1.value, // Not necessary for Option 1
                                                                    //               items: pMode.map((String val) {
                                                                    //                 return DropdownMenuItem(
                                                                    //                   child: new Text(val.toString(),
                                                                    //                     style: TextStyle(
                                                                    //                         fontWeight: FontWeight.bold,
                                                                    //                         letterSpacing: 1.5,
                                                                    //                         fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                                    //                         color: kHighlight
                                                                    //                     ),
                                                                    //                   ),
                                                                    //                   value: val,
                                                                    //                 );
                                                                    //               }).toList(),
                                                                    //               onChanged: (newValue) {
                                                                    //                 dualPaymentSelected1.value=newValue;
                                                                    //                 print(selectedPayment);
                                                                    //                 selectedPayment = newValue;
                                                                    //                 print(selectedPayment);
                                                                    //                 if(dualPaymentSelected1.value=='Cash')
                                                                    //                   showCashTendered.value=true;
                                                                    //                 else
                                                                    //                   showCashTendered.value=false;
                                                                    //               },
                                                                    //             )),
                                                                    //           ),
                                                                    //         ),
                                                                    //       ),
                                                                    //       // Container(
                                                                    //       //   width:100,
                                                                    //       //   child: TextField(
                                                                    //       //     style: TextStyle(
                                                                    //       //         fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                    //       //         color: Colors.black
                                                                    //       //     ),
                                                                    //       //     inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                    //       //     keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                    //       //     controller: dualPayment3.value,
                                                                    //       //     onEditingComplete: (){
                                                                    //       //       if(double.parse(dualPayment3.value.text)<salesTotal){
                                                                    //       //         showDualPayment.value=true;
                                                                    //       //         double temp=salesTotal-double.parse(dualPayment3.value.text);
                                                                    //       //         dualPayment2.value.text=temp.toString();
                                                                    //       //       }
                                                                    //       //       else{
                                                                    //       //         showDualPayment.value=false;
                                                                    //       //       }
                                                                    //       //     },
                                                                    //       //     decoration: new InputDecoration(
                                                                    //       //       hintText: 'Amount',
                                                                    //       //       border: OutlineInputBorder(),
                                                                    //       //       disabledBorder: OutlineInputBorder(
                                                                    //       //       ),
                                                                    //       //       enabledBorder: OutlineInputBorder(),
                                                                    //       //     ),
                                                                    //       //   ),
                                                                    //       // ),
                                                                    //     ]
                                                                    // ),


                                                                    // SizedBox(height:10),
                                                                    // Obx(()=>Visibility(
                                                                    //     visible:showCashTendered.value,
                                                                    //     child:Column(
                                                                    //         children:[
                                                                    //           Row(
                                                                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //               children:[
                                                                    //                 Text('Cash Tendered', style: TextStyle(
                                                                    //                   fontWeight: FontWeight.bold,
                                                                    //                   fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                                    //                 ),),
                                                                    //                 Container(
                                                                    //                   width:100,
                                                                    //                   child: TextField(
                                                                    //                     style: TextStyle(
                                                                    //                       fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                    //                     ),
                                                                    //                     inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                    //                     keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                    //                     controller: dualPayment1.value,
                                                                    //                     onEditingComplete: (){
                                                                    //                       refundAmt.value=double.parse(dualPayment1.value.text)-double.parse(dualPayment3.value.text);
                                                                    //                     },
                                                                    //                     decoration: new InputDecoration(
                                                                    //                       hintText: 'Amount',
                                                                    //                       border: OutlineInputBorder(),
                                                                    //                       disabledBorder: OutlineInputBorder(
                                                                    //                       ),
                                                                    //                       enabledBorder: OutlineInputBorder(),
                                                                    //                     ),
                                                                    //                   ),
                                                                    //                 ),
                                                                    //               ]
                                                                    //           ),
                                                                    //           SizedBox(height:10),
                                                                    //           Row(
                                                                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //               children:[
                                                                    //                 Text('Refund Amount', style: TextStyle(
                                                                    //                   fontWeight: FontWeight.bold,
                                                                    //                   fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                                    //                 ),),
                                                                    //                 Obx(()=>Text(refundAmt.value.toStringAsFixed(decimals), style: TextStyle(
                                                                    //                   fontWeight: FontWeight.bold,
                                                                    //                   fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                    //                 ),)),
                                                                    //               ]
                                                                    //           ),
                                                                    //         ]
                                                                    //     )
                                                                    // )),
                                                                    // SizedBox(height:10),
                                                                    // Obx(()=>Visibility(
                                                                    //   visible:showDualPayment.value,
                                                                    //   child: Row(
                                                                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //       children:[
                                                                    //         Container(
                                                                    //           decoration: BoxDecoration(
                                                                    //             border: Border.all(
                                                                    //                 color: kAppBarItems,
                                                                    //                 style: BorderStyle.solid,
                                                                    //                 width: 2),
                                                                    //           ),
                                                                    //           child: DropdownButtonHideUnderline(
                                                                    //             child: ButtonTheme(
                                                                    //               alignedDropdown: true,
                                                                    //               child: DropdownButton(
                                                                    //                 dropdownColor:Colors.white,
                                                                    //                 isDense: true,
                                                                    //                 value: dualPaymentSelected2.value, // Not necessary for Option 1
                                                                    //                 items: paymentMode.map((String val) {
                                                                    //                   return DropdownMenuItem(
                                                                    //                     child: new Text(val.toString(),
                                                                    //                       style: TextStyle(
                                                                    //                           fontWeight: FontWeight.bold,
                                                                    //                           letterSpacing: 1.5,
                                                                    //                           fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                                    //                           color: kHighlight
                                                                    //                       ),
                                                                    //                     ),
                                                                    //                     value: val,
                                                                    //                   );
                                                                    //                 }).toList(),
                                                                    //                 onChanged: (newValue) {
                                                                    //                   dualPaymentSelected2.value=newValue;
                                                                    //                 },
                                                                    //               ),
                                                                    //             ),
                                                                    //           ),
                                                                    //         ),
                                                                    //         Container(
                                                                    //           width:100,
                                                                    //           child: TextField(
                                                                    //             style: TextStyle(
                                                                    //               fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                    //             ),
                                                                    //             inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                    //             keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                    //             controller: dualPayment2.value,
                                                                    //             onEditingComplete: (){
                                                                    //
                                                                    //             },
                                                                    //             decoration: new InputDecoration(
                                                                    //               hintText: 'Amount',
                                                                    //               border: OutlineInputBorder(),
                                                                    //               disabledBorder: OutlineInputBorder(
                                                                    //               ),
                                                                    //               enabledBorder: OutlineInputBorder(),
                                                                    //             ),
                                                                    //           ),
                                                                    //         ),
                                                                    //       ]
                                                                    //   ),
                                                                    // ),),
                                                                    SizedBox(
                                                                        height: MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .height *
                                                                            0.03),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                        right: 5.0,
                                                                        left: 5.0,),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              Navigator
                                                                                  .pop(
                                                                                  context);
                                                                            },
                                                                            child: Container(
                                                                              height: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  0.05,
                                                                              width: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .width *
                                                                                  0.33,
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  border: Border
                                                                                      .all(
                                                                                    color: Colors
                                                                                        .black,

                                                                                  ),
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      MediaQuery
                                                                                          .of(
                                                                                          context)
                                                                                          .size
                                                                                          .width *
                                                                                          0.022)
                                                                              ),
                                                                              child: Center(
                                                                                  child: Text(
                                                                                    'CLOSE',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black),)),

                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            height: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .height *
                                                                                0.05,
                                                                            width: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .width *
                                                                                0.33,
                                                                            decoration: BoxDecoration(
                                                                                color: bottomColor,
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .width *
                                                                                        0.022)
                                                                            ),
                                                                            child: GestureDetector(

                                                                              onTap: () async {
                                                                                await initConnectivity();
                                                                                if (cartListText
                                                                                    .isNotEmpty&&_connectionStatus.toString().trim()!='ConnectivityResult.none') {
                                                                                  double tot = 0;
                                                                                 List cart = [];
                                                                                 cart.addAll(cartListText);
                                                                                 cartListText.clear();
                                                                                  ScaffoldMessenger.of(context).showSnackBar(salesdone);


                                                                                  Navigator
                                                                                      .pop(
                                                                                      context);




                                                                                  List temp = [];
                                                                                  double total = 0;

                                                                                  for(int i = 0;i<cart.length;i++){
                                                                                    List a = cart[i].toString().trim().split(':');
                                                                                    print(a);
                                                                                    double r = double.parse(a[2].toString().trim())/
                                                                                        double.parse(a[3].toString().trim());
                                                                                    total+=double.parse(a[2].toString().trim());
                                                                                   temp.add({
                                                                                     "item_code": itemcode[allSalableProducts.indexOf(a[0].toString().trim())],
                                                                                       "qty":int.parse(a[3].toString().trim()) ,
                                                                                       "unitPrice": r,
                                                                                   });

                                                                                  }
                                                                                  print('cus:$selectedCustomer');
                                                                                  await init();
                                                                                  var response = await client.post(
                                                                                    '/api/resource/Sales Invoice',
                                                                                    data: jsonEncode({
                                                                                      "customer": "Test",
                                                                                      "series": "SINV-.YY.-",
                                                                                      "date": "2023-07-18",
                                                                                      "docstatus": 1,
                                                                                      "update_stock": 1,
                                                                                      // "is_return": 1,
                                                                                      "items": [
                                                                                        {
                                                                                          "item_code": "1001",
                                                                                          "qty": 2,
                                                                                          "unitPrice": 0,
                                                                                        },
                                                                                        {
                                                                                          "item_code": "1002",
                                                                                          "qty": 6,
                                                                                          "unitPrice": 0,
                                                                                        }
                                                                                      ]
                                                                                    }),
                                                                                  );
                                                                                  print('no issue');
                                                                                  print(response.data);



                                                                                  setState(() {
                                                                                    currentOrder =
                                                                                    '';
                                                                                    cartController =
                                                                                    [
                                                                                    ];
                                                                                    cartdup =
                                                                                    [
                                                                                    ];
                                                                                    cartQtyController =
                                                                                    [
                                                                                    ];
                                                                                    salesTotalList =
                                                                                    [
                                                                                    ];
                                                                                    salesUomList =
                                                                                    [
                                                                                    ];
                                                                                    cartListText =
                                                                                    [
                                                                                    ];
                                                                                    customerName =
                                                                                    "";
                                                                                    selectedPayment =
                                                                                    'Cash';
                                                                                    selectedCustomer =
                                                                                        cntctController
                                                                                            .text =
                                                                                    '';
                                                                                  });

                                                                                }
                                                                                else {
                                                                                  if(cartListText
                                                                                      .isEmpty) {
                                                                                    addproduct(
                                                                                        context);
                                                                                  }
                                                                                else  if(_connectionStatus.toString().trim()=='ConnectivityResult.none') {
                                                                                   nonet(
                                                                                        context);
                                                                                  }

                                                                                }
                                                                              },
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "CHECKOUT",
                                                                                  style: TextStyle(
                                                                                    color: Colors
                                                                                        .white,
                                                                                    fontSize: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .textScaleFactor *
                                                                                        16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                );

                                              });
    //                                       showDialog(
    //                                         context:
    //                                         context,
    //                                         builder: (BuildContext context) {
    //                                           return StatefulBuilder(builder: (context, StateSetter setState) {
    //                                      return Center(
    // child: Container(
    // width: MediaQuery
    //     .of(context)
    //     .size
    //     .width,
    // child: SingleChildScrollView(
    // scrollDirection: Axis
    //     .vertical,
    // child: Dialog(
    // backgroundColor: Colors
    //     .white,
    // shape: RoundedRectangleBorder(
    // borderRadius: BorderRadius
    //     .circular(
    // 12.0)),
    // child: Column(
    // children: [
    // SizedBox(
    // height: MediaQuery
    //     .of(context)
    //     .size
    //     .height *
    // 0.008),
    // Padding(
    // padding: const EdgeInsets
    //     .only(
    // right: 10.0,
    // left: 10.0,
    // bottom: 10.0,),
    // child: Column(
    // children: [
    // Row(
    // mainAxisAlignment: MainAxisAlignment
    //     .spaceBetween,
    // children: [
    // Text(
    // 'Tol',
    // style: TextStyle(
    // fontWeight: FontWeight
    //     .bold,
    // fontSize: MediaQuery
    //     .of(
    // context)
    //     .textScaleFactor *
    // 15,
    // ),),
    // Text(
    // salesTotal
    //     .toStringAsFixed(
    // decimals),
    // style: TextStyle(
    // fontWeight: FontWeight
    //     .bold,
    // fontSize: MediaQuery
    //     .of(
    // context)
    //     .textScaleFactor *
    // 20,
    // ),)
    // ]
    // ),
    // SizedBox(
    // height: MediaQuery
    //     .of(
    // context)
    //     .size
    //     .height *
    // 0.03),
    // Row(
    // children: [
    //   selectedPayment=='Cash'
    // ? IconButton(
    // onPressed: () {
    //   setState(() {
    //
    //   });
    // dualPaymentSelected1
    //     .value =
    // 'Cash';
    // print(
    // selectedPayment);
    // selectedPayment =
    // 'Cash';
    // print(
    // selectedPayment);
    // if (dualPaymentSelected1
    //     .value ==
    // 'Cash')
    // showCashTendered
    //     .value =
    // true;
    // else
    // showCashTendered
    //     .value =
    // false;
    // },
    // icon: Icon(
    // Icons
    //     .radio_button_checked))
    //     : Icon(
    // Icons
    //     .radio_button_unchecked),
    // SizedBox(
    // width: 10),
    // Text(
    // 'Cash',
    // style: TextStyle(
    // fontSize: MediaQuery
    //     .of(
    // context)
    //     .size
    //     .width *
    // 0.048),),
    // SizedBox(
    // width: 20),
    //   selectedPayment ==
    // 'Credit'
    // ?
    //
    // Icon(Icons
    //     .radio_button_checked,)
    //     : IconButton(
    // onPressed: () {
    //   setState(() {
    //
    //   });
    // dualPaymentSelected1
    //     .value =
    // 'Credit';
    //
    // selectedPayment =
    // 'Credit';
    //
    // if (dualPaymentSelected1
    //     .value ==
    // 'Cash')
    // showCashTendered
    //     .value =
    // true;
    // else
    // showCashTendered
    //     .value =
    // false;
    // print(
    // dualPaymentSelected1
    //     .value);
    // },
    // icon: Icon(
    // Icons
    //     .radio_button_unchecked,)),
    // SizedBox(
    // width: 10),
    // Text(
    // 'Credit',
    // style: TextStyle(
    // fontSize: MediaQuery
    //     .of(
    // context)
    //     .size
    //     .width *
    // 0.048),)
    // ],
    // ),
    //
    // // Row(
    // //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // //     children:[
    // //       Container(
    // //         width:120,
    // //         decoration: BoxDecoration(
    // //           border: Border.all(
    // //               color: kAppBarItems,
    // //               style: BorderStyle.solid,
    // //               width: 2),
    // //         ),
    // //         child: DropdownButtonHideUnderline(
    // //           child: ButtonTheme(
    // //             alignedDropdown: true,
    // //             child: Obx(()=>DropdownButton(
    // //               dropdownColor:Colors.white,
    // //               isDense: true,
    // //               value: dualPaymentSelected1.value, // Not necessary for Option 1
    // //               items: pMode.map((String val) {
    // //                 return DropdownMenuItem(
    // //                   child: new Text(val.toString(),
    // //                     style: TextStyle(
    // //                         fontWeight: FontWeight.bold,
    // //                         letterSpacing: 1.5,
    // //                         fontSize: MediaQuery.of(context).textScaleFactor*18,
    // //                         color: kHighlight
    // //                     ),
    // //                   ),
    // //                   value: val,
    // //                 );
    // //               }).toList(),
    // //               onChanged: (newValue) {
    // //                 dualPaymentSelected1.value=newValue;
    // //                 print(selectedPayment);
    // //                 selectedPayment = newValue;
    // //                 print(selectedPayment);
    // //                 if(dualPaymentSelected1.value=='Cash')
    // //                   showCashTendered.value=true;
    // //                 else
    // //                   showCashTendered.value=false;
    // //               },
    // //             )),
    // //           ),
    // //         ),
    // //       ),
    // //       // Container(
    // //       //   width:100,
    // //       //   child: TextField(
    // //       //     style: TextStyle(
    // //       //         fontSize: MediaQuery.of(context).textScaleFactor*14,
    // //       //         color: Colors.black
    // //       //     ),
    // //       //     inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
    // //       //     keyboardType: TextInputType.numberWithOptions(decimal: true),
    // //       //     controller: dualPayment3.value,
    // //       //     onEditingComplete: (){
    // //       //       if(double.parse(dualPayment3.value.text)<salesTotal){
    // //       //         showDualPayment.value=true;
    // //       //         double temp=salesTotal-double.parse(dualPayment3.value.text);
    // //       //         dualPayment2.value.text=temp.toString();
    // //       //       }
    // //       //       else{
    // //       //         showDualPayment.value=false;
    // //       //       }
    // //       //     },
    // //       //     decoration: new InputDecoration(
    // //       //       hintText: 'Amount',
    // //       //       border: OutlineInputBorder(),
    // //       //       disabledBorder: OutlineInputBorder(
    // //       //       ),
    // //       //       enabledBorder: OutlineInputBorder(),
    // //       //     ),
    // //       //   ),
    // //       // ),
    // //     ]
    // // ),
    //
    //
    // // SizedBox(height:10),
    // // Obx(()=>Visibility(
    // //     visible:showCashTendered.value,
    // //     child:Column(
    // //         children:[
    // //           Row(
    // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // //               children:[
    // //                 Text('Cash Tendered', style: TextStyle(
    // //                   fontWeight: FontWeight.bold,
    // //                   fontSize: MediaQuery.of(context).textScaleFactor*15,
    // //                 ),),
    // //                 Container(
    // //                   width:100,
    // //                   child: TextField(
    // //                     style: TextStyle(
    // //                       fontSize: MediaQuery.of(context).textScaleFactor*14,
    // //                     ),
    // //                     inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
    // //                     keyboardType: TextInputType.numberWithOptions(decimal: true),
    // //                     controller: dualPayment1.value,
    // //                     onEditingComplete: (){
    // //                       refundAmt.value=double.parse(dualPayment1.value.text)-double.parse(dualPayment3.value.text);
    // //                     },
    // //                     decoration: new InputDecoration(
    // //                       hintText: 'Amount',
    // //                       border: OutlineInputBorder(),
    // //                       disabledBorder: OutlineInputBorder(
    // //                       ),
    // //                       enabledBorder: OutlineInputBorder(),
    // //                     ),
    // //                   ),
    // //                 ),
    // //               ]
    // //           ),
    // //           SizedBox(height:10),
    // //           Row(
    // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // //               children:[
    // //                 Text('Refund Amount', style: TextStyle(
    // //                   fontWeight: FontWeight.bold,
    // //                   fontSize: MediaQuery.of(context).textScaleFactor*15,
    // //                 ),),
    // //                 Obx(()=>Text(refundAmt.value.toStringAsFixed(decimals), style: TextStyle(
    // //                   fontWeight: FontWeight.bold,
    // //                   fontSize: MediaQuery.of(context).textScaleFactor*20,
    // //                 ),)),
    // //               ]
    // //           ),
    // //         ]
    // //     )
    // // )),
    // // SizedBox(height:10),
    // // Obx(()=>Visibility(
    // //   visible:showDualPayment.value,
    // //   child: Row(
    // //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // //       children:[
    // //         Container(
    // //           decoration: BoxDecoration(
    // //             border: Border.all(
    // //                 color: kAppBarItems,
    // //                 style: BorderStyle.solid,
    // //                 width: 2),
    // //           ),
    // //           child: DropdownButtonHideUnderline(
    // //             child: ButtonTheme(
    // //               alignedDropdown: true,
    // //               child: DropdownButton(
    // //                 dropdownColor:Colors.white,
    // //                 isDense: true,
    // //                 value: dualPaymentSelected2.value, // Not necessary for Option 1
    // //                 items: paymentMode.map((String val) {
    // //                   return DropdownMenuItem(
    // //                     child: new Text(val.toString(),
    // //                       style: TextStyle(
    // //                           fontWeight: FontWeight.bold,
    // //                           letterSpacing: 1.5,
    // //                           fontSize: MediaQuery.of(context).textScaleFactor*18,
    // //                           color: kHighlight
    // //                       ),
    // //                     ),
    // //                     value: val,
    // //                   );
    // //                 }).toList(),
    // //                 onChanged: (newValue) {
    // //                   dualPaymentSelected2.value=newValue;
    // //                 },
    // //               ),
    // //             ),
    // //           ),
    // //         ),
    // //         Container(
    // //           width:100,
    // //           child: TextField(
    // //             style: TextStyle(
    // //               fontSize: MediaQuery.of(context).textScaleFactor*14,
    // //             ),
    // //             inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
    // //             keyboardType: TextInputType.numberWithOptions(decimal: true),
    // //             controller: dualPayment2.value,
    // //             onEditingComplete: (){
    // //
    // //             },
    // //             decoration: new InputDecoration(
    // //               hintText: 'Amount',
    // //               border: OutlineInputBorder(),
    // //               disabledBorder: OutlineInputBorder(
    // //               ),
    // //               enabledBorder: OutlineInputBorder(),
    // //             ),
    // //           ),
    // //         ),
    // //       ]
    // //   ),
    // // ),),
    // SizedBox(
    // height: MediaQuery
    //     .of(
    // context)
    //     .size
    //     .height *
    // 0.03),
    // Padding(
    // padding: const EdgeInsets
    //     .only(
    // right: 5.0,
    // left: 5.0,),
    // child: Row(
    // mainAxisAlignment: MainAxisAlignment
    //     .spaceBetween,
    // children: [
    // GestureDetector(
    // onTap: () {
    // Navigator
    //     .pop(
    // context);
    // },
    // child: Container(
    // height: MediaQuery
    //     .of(
    // context)
    //     .size
    //     .height *
    // 0.05,
    // width: MediaQuery
    //     .of(
    // context)
    //     .size
    //     .width *
    // 0.33,
    // decoration: BoxDecoration(
    // color: Colors
    //     .white,
    // border: Border
    //     .all(
    // color: Colors
    //     .black,
    //
    // ),
    // borderRadius: BorderRadius
    //     .circular(
    // MediaQuery
    //     .of(
    // context)
    //     .size
    //     .width *
    // 0.022)
    // ),
    // child: Center(
    // child: Text(
    // 'CLOSE',
    // style: TextStyle(
    // color: Colors
    //     .black),)),
    //
    // ),
    // ),
    //
    // Container(
    // height: MediaQuery
    //     .of(
    // context)
    //     .size
    //     .height *
    // 0.05,
    // width: MediaQuery
    //     .of(
    // context)
    //     .size
    //     .width *
    // 0.33,
    // decoration: BoxDecoration(
    // color: bottomColor,
    // borderRadius: BorderRadius
    //     .circular(
    // MediaQuery
    //     .of(
    // context)
    //     .size
    //     .width *
    // 0.022)
    // ),
    // child: GestureDetector(
    //
    // onTap: () async {
    // if (cartListText
    //     .isNotEmpty) {
    // double tot = 0;
    //
    // print(
    // cartListText);
    // // [BEEF PATTY BURGER:Each:352.0: 2]
    // for (int i = 0; i <
    // cartListText
    //     .length; i++) {
    // List a = cartListText[i]
    //     .toString()
    //     .trim()
    //     .split(
    // ':');
    // tot +=
    // double
    //     .parse(
    // a[2]
    // ..toString()
    //     .trim());
    // }
    // await read(
    // 'till_data');
    // await firebaseFirestore
    //     .collection(
    // 'user_data')
    //     .doc(
    // userNam
    //     .toString()
    //     .trim())
    //     .update(
    // {
    // "invoicecount": invcount +
    // 1
    // })
    //     .then((
    // _) {});
    // if (dualPaymentSelected1
    //     .value
    //     .toString()
    //     .trim() ==
    // 'Cash') {
    // await firebaseFirestore
    //     .collection(
    // 'till_data')
    //     .doc(
    // '1')
    //     .update(
    // {
    // "${dualPaymentSelected1
    //     .value
    //     .toString()
    //     .trim()
    //     .toLowerCase()}sales": cashmoney +
    // tot
    // })
    //     .then((
    // _) {});
    // await firebaseFirestore
    //     .collection(
    // 'user_data')
    //     .doc(
    // userNam
    //     .toString()
    //     .trim())
    //     .update(
    // {
    // "cashsales": cashmoney +
    // tot
    // })
    //     .then((
    // _) {});
    // }
    // else {
    // print(
    // 'credit');
    // await firebaseFirestore
    //     .collection(
    // 'till_data')
    //     .doc(
    // '1')
    //     .update(
    // {
    // "${dualPaymentSelected1
    //     .value
    //     .toString()
    //     .trim()
    //     .toLowerCase()}sales": creditmoney +
    // tot
    // })
    //     .then((
    // _) {});
    // await firebaseFirestore
    //     .collection(
    // 'user_data')
    //     .doc(
    // userNam
    //     .toString()
    //     .trim())
    //     .update(
    // {
    // "creditsales": creditmoney +
    // tot
    // })
    //     .then((
    // _) {});
    // }
    //
    // await getLastInv(
    // 'sales');
    // await firebaseFirestore
    //     .collection(
    // "invoice_data")
    //     .doc(
    // '${userSalesPrefix
    //     .toString()
    //     .trim()}${invoicenum
    //     .toString()
    //     .trim()}')
    //     .set(
    // {
    // 'orderNo': '${userSalesPrefix
    //     .toString()
    //     .trim()}${invoicenum
    //     .toString()
    //     .trim()}',
    // 'date': DateTime
    //     .now()
    //     .millisecondsSinceEpoch,
    // 'customer': selectedCustomer !=
    // ''
    // ? selectedCustomer
    //     : 'Standard',
    // 'cartList': cartListText,
    // 'salestype': selectedmenu
    //     .toString()
    //     .trim(),
    // 'paymentmode': selectedPayment,
    // 'total': tot
    //     .toString()
    //     .trim(),
    // 'user': userNam
    //     .toString()
    //     .trim()
    // // 'payment':temp[3].toString().trim(),
    // // 'total': temp[4].toString().trim(),
    // // 'transactionType': temp[5].toString().trim(),
    // // 'user': temp[6].toString().trim(),
    // // 'balance': double.parse(temp[7].toString().trim()),
    // // 'discount':'0'
    // })
    //     .then((
    // _) {});
    //
    // updateInv(
    // 'sales',
    // invoicenum +
    // 1);
    // setState(() {
    // currentOrder =
    // '';
    // cartController =
    // [
    // ];
    // cartdup =
    // [
    // ];
    // cartQtyController =
    // [
    // ];
    // salesTotalList =
    // [
    // ];
    // salesUomList =
    // [
    // ];
    // cartListText =
    // [
    // ];
    // customerName =
    // "";
    // selectedPayment =
    // 'Cash';
    // selectedCustomer =
    // cntctController
    //     .text =
    // '';
    // });
    // Navigator
    //     .pop(
    // context);
    // }
    // else {
    //
    // }
    // },
    // child: Center(
    // child: Text(
    // "CHECKOUT",
    // style: TextStyle(
    // color: Colors
    //     .white,
    // fontSize: MediaQuery
    //     .of(
    // context)
    //     .textScaleFactor *
    // 16,
    // ),
    // ),
    // ),
    // ),
    // ),
    // ],
    // ),
    // ),
    // ],
    // ),
    // ),
    //
    // ],
    // )
    // ),
    // ),
    // ),
    // );
    //
    //                                      });
    //
    //                                         }
    //                                       );
                                        }
                                        else{
                                          if(_connectionStatus.toString().trim()=='ConnectivityResult.none') {
                                            nonet(context);
                                          }
                                          else if(cartListText.isEmpty){
                                            addproduct(context);
                                          }
                                          else if(selectedCustomer==''){
                                      selectacustomer(context);
                                          }


                                          // await checkOut(currentOrder,true,0,'', '',false);
                                          // setState(() {
                                          //   currentOrder='';
                                          //   cartController=[];
                                          //   cartQtyController=[];
                                          //   cartdup =[];
                                          //
                                          //   print(cartdup.length);
                                          //   print(cartController.length);
                                          //   print(cartQtyController.length);
                                          //   salesTotalList=[];
                                          //   salesUomList=[];
                                          //   cartListText=[];
                                          //   customerName="";
                                          // });
                                          // tableSelected.value='TABLE';
                                        }
                                      },
                                      child: Container(
                                        height:MediaQuery.of(context).size.height*0.06 ,
                                        width:MediaQuery.of(context).size.width*0.33,
                                        child: Center(child: Text('PLACE ORDER',style: TextStyle(color: Colors.white),)),
                                        decoration: BoxDecoration(
                                            color:bottomColor,
                                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.022)
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ):
            (selectedmenu=='salesreturn')?
            Column(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //       color:kBoxTextColor
                //   ),
                //   height: MediaQuery.of(context).size.height/11,
                //   width: MediaQuery.of(context).size.width,
                //   child:Row(
                //       mainAxisAlignment:MainAxisAlignment.start,
                //       children:[
                //         Container(
                //           height: MediaQuery.of(context).size.height/2,
                //           width:   MediaQuery.of(context).size.width*0.37,
                //           decoration: BoxDecoration(
                //             image: DecorationImage(
                //               image: AssetImage(
                //                   'images/dot_order.png'),
                //               fit: BoxFit.fill,
                //             ),
                //             shape: BoxShape.rectangle,
                //           ),
                //         ),
                //
                //       ]),
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height*0.076,
                //   margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,right: MediaQuery.of(context).size.width*0.01),
                //   child: SimpleAutoCompleteTextField(
                //     style: TextStyle(
                //       fontSize: MediaQuery.of(context).textScaleFactor*14,
                //     ),
                //     controller: cntctController,
                //     clearOnSubmit: false,
                //     suggestions: customerList,
                //     textSubmitted: (text){
                //       setState(() {
                //
                //         selectedCustomer= cntctController.text = text;
                //         // selectedCustomer = customerList[allCustomerMobile.indexOf(text.toString().trim())];
                //         // print('sc:$selectedCustomer');
                //       });
                //
                //     },
                //     decoration: new InputDecoration(
                //         border: OutlineInputBorder(),
                //         disabledBorder: OutlineInputBorder(
                //         ),
                //         enabledBorder: OutlineInputBorder(),
                //         hintText: 'search for Customers'
                //     ),
                //
                //   ),
                // ),
                // SizedBox(height:  MediaQuery.of(context).size.height*0.02,),
                ClipPath(
                  clipper:CustomClipPath(),

                  child: Container(
                    height:MediaQuery.of(context).size.height*0.12,
                    // decoration: new BoxDecoration(
                    color: bottomColor,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => FirstScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(17),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: MediaQuery.of(context).size.width*0.04,
                              child: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: MediaQuery.of(context).size.width*0.072,),
                            ),
                          ),
                        ),
                        selectedmenu!='Receipt'?
                        GestureDetector(
                          onTap:(){
                            selectedCustomer='';
                            setState(() {

                            });

                            getCustomer();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.6,
                            height: MediaQuery.of(context).size.height*0.08,

                            child:selectedCustomer==''?SimpleAutoCompleteTextField(

                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Search Customers',labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: const Icon(Icons.search, color: Colors.white,),
                                enabledBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,width: 1.0
                                    )
                                ),
                                focusedBorder:
                                OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),

                              ),
                              style: TextStyle(
                                color: Colors.white,

                                fontSize: MediaQuery.of(context).textScaleFactor*14,
                              ),
                              controller: cntctController,
                              clearOnSubmit: false,
                              suggestions: customerList,

                              textSubmitted: (text){
                                setState(() {
                                  selectedCustomer= cntctController.text = text;
                                  // selectedCustomer = customerList[allCustomerMobile.indexOf(text.toString().trim())];
                                  // print('sc:$selectedCustomer');
                                });
                              },
                            )
                                :Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(selectedCustomer.toString().trim(),style: TextStyle(fontFamily: 'Montserrat-SemiBold',fontSize: MediaQuery.of(context).size.width*0.045,color: Colors.white),),
                              ],
                            ),
                          ),
                        ):Text('Dot Orders'),
                      ],
                    ),
                    // borderRadius: BorderRadius.only(
                    //
                    //   bottomLeft:Radius.elliptical(
                    //       MediaQuery.of(context).size.width, 65.0) ,
                    //
                    //
                    //
                    //     bottomRight: Radius.elliptical(
                    //         MediaQuery.of(context).size.width, 110.0)
                    // ),
                  ),
                ),
                SizedBox(height:  MediaQuery.of(context).size.height*0.02,),
                Container(
                  padding: EdgeInsets.only(left: 5,right: 5),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextField(
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*14,
                            ),
                            focusNode: nameNode,
                            controller: nameController,
                            decoration: new InputDecoration(
                                border: OutlineInputBorder(),
                                disabledBorder: OutlineInputBorder(
                                ),
                                enabledBorder: OutlineInputBorder(),
                                hintText: 'search for item'
                            ),
                            onChanged: searchOperation,
                            onTap: (){
                              getProducts();
                            },
                            onSubmitted: (text){
                              barcodeEntry(text);
                              nameController.clear();
                              nameNode.requestFocus();
                            },
                          ),
                        ),),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 60.0,
                          height: MediaQuery.of(context).size.height*0.076,
                          child: TextField(
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*14,
                            ),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            focusNode: quantityNode,
                            controller: quantityController,
                            showCursor: enableQuantity,
                            onSubmitted: (val){
                              if(_selectedItem.length>0){
                                addFromSearch(_selectedItem, val);
                              }
                              setState(() {
                                quantityController.clear();
                                nameController.clear();
                                nameNode.requestFocus();
                              });
                              _selectedItem='';
                            },
                            decoration: new InputDecoration(
                                border: OutlineInputBorder(),
                                disabledBorder: OutlineInputBorder(
                                ),
                                enabledBorder: OutlineInputBorder(),
                                hintText: 'quantity'
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02,right: MediaQuery.of(context).size.width*0.02),


                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          controller: cartjump,
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: false,
                          itemCount: cartListText.length,
                          itemBuilder: (BuildContext context, int index) {


                            List a = cartListText[index].toString().trim().split(':');
                            return  GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.01 ),
                                decoration: BoxDecoration(
                                    color:Colors.white,
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.03)
                                ),

                                height: MediaQuery.of(context).size.height*0.115,
                                width: MediaQuery.of(context).size.width,

                                child:

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${index+1} . ${a[0]}',style: TextStyle(  fontFamily: 'FrancoisOne',)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text('${cartController[index].text}',style: TextStyle( color: carttext, fontFamily: 'FrancoisOne',)),
                                          SizedBox(width:MediaQuery.of(context).size.width*0.05),
                                          GestureDetector(
                                              onTap:(){
                                                setState(() {
                                                  salesTotalList.removeAt(index);
                                                  cartController.removeAt(index);
                                                  cartdup.removeAt(index);
                                                  cartQtyController.removeAt(index);
                                                  cartListText.removeAt(index);
                                                  salesUomList.removeAt(index);
                                                  getTotal(salesTotalList);
                                                });
                                              },
                                              child: Icon(Icons.delete_outline,color: Colors.red,size: MediaQuery.of(context).size.width*0.065,))

                                        ],
                                      ),


                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(a[1]),
                                          SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                                          Icon(Icons.payments,color: bottomColor,size:MediaQuery.of(context).size.width*0.042 ,),
                                          SizedBox(width: MediaQuery.of(context).size.width*0.03,),

                                          Text(cartdup[index].text),
                                          SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                                          Icon(Icons.shopping_cart_outlined,color: bottomColor,size:MediaQuery.of(context).size.width*0.042 ),
                                          SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                                          Text(cartQtyController[index].text),


                                          // Container(
                                          //
                                          //   height: MediaQuery.of(context).size.height*0.05,
                                          //   width:MediaQuery.of(context).size.width*0.19,
                                          //   child: TextFormField(
                                          //     decoration: new InputDecoration(
                                          //       // contentPadding: EdgeInsets.all(4.0),
                                          //       isDense: false,
                                          //       contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                          //       border: OutlineInputBorder(),
                                          //       disabledBorder: OutlineInputBorder(
                                          //       ),
                                          //       enabledBorder: OutlineInputBorder(),
                                          //     ),
                                          //     style: TextStyle(
                                          //         fontSize: MediaQuery.of(context).textScaleFactor*16,
                                          //         color: kBlack,
                                          //         fontWeight: FontWeight.bold
                                          //     ),
                                          //     keyboardType: TextInputType.number ,
                                          //     controller: cartdup[index],
                                          //
                                          //     onChanged: (val){
                                          //
                                          //       List showCartItems=cartListText[index].split(':');
                                          //       double ab = double.parse(val.toString())*double.parse(showCartItems[3]);
                                          //       showCartItems[2]=ab.toString();
                                          //       showCartItems[1].toString();
                                          //       String tempVal=showCartItems.toString().replaceAll(',', ':');
                                          //       tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                                          //       print(tempVal);
                                          //       setState(() {
                                          //         salesTotalList[index]=ab;
                                          //         cartController[index].text=ab.toString();
                                          //         cartListText[index]=tempVal;
                                          //       });
                                          //     },
                                          //
                                          //
                                          //   ),
                                          // ),
                                          //
                                          //
                                          //
                                          // Container(
                                          //   margin: EdgeInsets.only(top: 10,bottom: 10),
                                          //   height: MediaQuery.of(context).size.height*0.05,
                                          //   width:MediaQuery.of(context).size.width*0.1,
                                          //   child: TextFormField(
                                          //     decoration: new InputDecoration(
                                          //       // contentPadding: EdgeInsets.all(4.0),
                                          //       isDense: false,
                                          //       contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                          //       border: OutlineInputBorder(),
                                          //       disabledBorder: OutlineInputBorder(
                                          //       ),
                                          //       enabledBorder: OutlineInputBorder(),
                                          //     ),
                                          //     style: TextStyle(
                                          //         fontSize: MediaQuery.of(context).textScaleFactor*16,
                                          //         color: kBlack,
                                          //         fontWeight: FontWeight.bold
                                          //     ),
                                          //     keyboardType: TextInputType.number ,
                                          //     controller: cartQtyController[index],
                                          //     onChanged: (val){
                                          //       List showCartItems=cartListText[index].split(':');
                                          //       double tempQuantity = double.parse(val);
                                          //       // double tempRate = double.parse(getPrice(showCartItems[0], showCartItems[1]));
                                          //       print(showCartItems);
                                          //       double tempRate = double.parse(showCartItems[2])/double.parse(showCartItems[3]);
                                          //       tempRate = tempRate * double.parse(val);
                                          //       print(tempRate);
                                          //       showCartItems[2] = '$tempRate';
                                          //       showCartItems[3] = tempQuantity.toString();
                                          //       String tempVal=showCartItems.toString().replaceAll(',', ':');
                                          //       tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                                          //       print(tempVal);
                                          //       setState(() {
                                          //         salesTotalList[index] = tempRate;
                                          //         cartController[index].text = tempRate.toString();
                                          //         // cartQtyController[index].text = tempQuantity.toStringAsFixed(2);
                                          //         cartListText[index]=tempVal;
                                          //       });
                                          //
                                          //     },),
                                          // ),
                                          // Container(
                                          //
                                          //     width:MediaQuery.of(context).size.width*0.14 ,
                                          //     child: Text('${cartController[index].text}',style: TextStyle(  fontFamily: 'FrancoisOne',))),


                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          color: kItemContainer,
                          child:  Obx(()=> ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchResult.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){
                                  nameController.text=_selectedItem=searchResult[index];
                                  print('selecteddd:$_selectedItem');
                                  searchResult.clear();
                                  quantityNode.requestFocus();
                                },
                                child: new ListTile(
                                  title: new Text(searchResult[index].toString()),
                                ),
                              );
                            },
                          )
                          )
                      ),
                    ],
                  ),
                ),



                Visibility(
                  visible: true,
                  child: Column(
                    children: [

                      Container(

                          decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 3.0, color: Colors.grey.shade200),
                              ),

                              color: Colors.white

                          ),
                          height: MediaQuery.of(context).size.height*0.15,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.045,right: MediaQuery.of(context).size.width*0.045,top: MediaQuery.of(context).size.height*0.015),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Items : ${cartdup.length}',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,color: Colors.grey.shade600 ),),
                                    // Text('SUB TOTAL : ${getTotal(salesTotalList).toStringAsFixed(decimals)}',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.037, fontWeight: FontWeight.bold),),
                                    // Text('TAX : 0',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.037,fontWeight: FontWeight.bold ),),
                                    Text('Total Price :  ${getTotal(salesTotalList).toStringAsFixed(decimals)}',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.bold),),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.045,right: MediaQuery.of(context).size.width*0.045,bottom: MediaQuery.of(context).size.height*0.015),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          currentOrder='';
                                          cartController=[];
                                          cartQtyController=[];
                                          cartdup =[];

                                          print(cartdup.length);
                                          print(cartController.length);
                                          print(cartQtyController.length);
                                          salesTotalList=[];
                                          salesUomList=[];
                                          cartListText=[];
                                          customerName="";
                                        });
                                      },
                                      child: Container(
                                        height:MediaQuery.of(context).size.height*0.06 ,
                                        width:MediaQuery.of(context).size.width*0.33,
                                        decoration: BoxDecoration(
                                            color:Colors.white,
                                            border: Border.all(color: Colors.black),
                                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.022)
                                        ),
                                        child: Center(child: Text('CANCEL',style: TextStyle(color: Colors.black),)),

                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ()async{
                                        await initConnectivity();
                                        if(selectedCustomer!=''&&cartListText.isNotEmpty&& _connectionStatus.toString().trim()!='ConnectivityResult.none'){



                                          print('sales return');
                                          Rx<TextEditingController> dualPayment3=TextEditingController(text:salesTotal.toStringAsFixed(decimals)).obs;
                                          Rx<TextEditingController> dualPayment1=TextEditingController(text: '0').obs;
                                          Rx<TextEditingController> dualPayment2=TextEditingController(text: '0').obs;
                                          RxString dualPaymentSelected1='Cash'.obs;
                                          RxString dualPaymentSelected2='Card'.obs;
                                          RxDouble refundAmt=0.0.obs;
                                          RxBool showDualPayment=false.obs;
                                          RxBool showCashTendered=true.obs;
                                          showDialog(
                                              context:
                                              context,
                                              builder: (BuildContext context) {
                                                return Center(
                                                  child: Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis
                                                          .vertical,
                                                      child: Dialog(
                                                          backgroundColor: Colors
                                                              .white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  12.0)),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: MediaQuery
                                                                      .of(context)
                                                                      .size
                                                                      .height *
                                                                      0.008),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                  right: 10.0,
                                                                  left: 10.0,
                                                                  bottom: 10.0,),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            'Total',
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .textScaleFactor *
                                                                                  15,
                                                                            ),),
                                                                          Text(
                                                                            salesTotal
                                                                                .toStringAsFixed(
                                                                                decimals),
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight
                                                                                  .bold,
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .textScaleFactor *
                                                                                  20,
                                                                            ),)
                                                                        ]
                                                                    ),
                                                                    SizedBox(
                                                                        height: MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .height *
                                                                            0.03),
                                                                    Obx(() => Row(
                                                                      children: [
                                                                        dualPaymentSelected1
                                                                            .value ==
                                                                            'Cash'
                                                                            ? IconButton(
                                                                          onPressed: () {
                                                                            dualPaymentSelected1.value = 'Cash';
                                                                            print(
                                                                                selectedPayment);
                                                                            selectedPayment =
                                                                            'Cash';
                                                                            print(
                                                                                selectedPayment);
                                                                            if (dualPaymentSelected1
                                                                                .value ==
                                                                                'Cash')
                                                                              showCashTendered
                                                                                  .value =
                                                                              true;
                                                                            else
                                                                              showCashTendered
                                                                                  .value =
                                                                              false;
                                                                          },

                                                                          icon: Icon(

                                                                              Icons
                                                                                  .radio_button_checked,color: Colors.black),
                                                                        )
                                                                            :
                                                                        IconButton(
                                                                          onPressed: () {
                                                                            dualPaymentSelected1.value = 'Cash';
                                                                            print(
                                                                                selectedPayment);
                                                                            selectedPayment =
                                                                            'Cash';
                                                                            print(
                                                                                selectedPayment);
                                                                            if (dualPaymentSelected1
                                                                                .value ==
                                                                                'Cash')
                                                                              showCashTendered
                                                                                  .value =
                                                                              true;
                                                                            else
                                                                              showCashTendered
                                                                                  .value =
                                                                              false;
                                                                          },
                                                                          icon: Icon(
                                                                              Icons
                                                                                  .radio_button_unchecked,color: Colors.black),
                                                                        ),
                                                                        SizedBox(
                                                                            width: 10),
                                                                        Text(
                                                                          'Cash',
                                                                          style: TextStyle(
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .width *
                                                                                  0.048),),
                                                                        SizedBox(
                                                                            width: 20),
                                                                        dualPaymentSelected1
                                                                            .value ==
                                                                            'Credit'
                                                                            ?

                                                                        IconButton(
                                                                          icon: Icon(Icons
                                                                              .radio_button_checked,color: Colors.black),
                                                                        )
                                                                            : IconButton(
                                                                            onPressed: () {
                                                                              dualPaymentSelected1
                                                                                  .value =
                                                                              'Credit';

                                                                              selectedPayment =
                                                                              'Credit';

                                                                              if (dualPaymentSelected1
                                                                                  .value ==
                                                                                  'Cash')
                                                                                showCashTendered
                                                                                    .value =
                                                                                true;
                                                                              else
                                                                                showCashTendered
                                                                                    .value =
                                                                                false;
                                                                              print(
                                                                                  dualPaymentSelected1
                                                                                      .value);
                                                                            },
                                                                            icon: Icon(
                                                                              Icons
                                                                                  .radio_button_unchecked,color: Colors.black,)),
                                                                        SizedBox(
                                                                            width: 10),
                                                                        Text(
                                                                          'Credit',
                                                                          style: TextStyle(
                                                                              fontSize: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .width *
                                                                                  0.048),)
                                                                      ],
                                                                    ))
                                                                    ,

                                                                    // Row(
                                                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //     children:[
                                                                    //       Container(
                                                                    //         width:120,
                                                                    //         decoration: BoxDecoration(
                                                                    //           border: Border.all(
                                                                    //               color: kAppBarItems,
                                                                    //               style: BorderStyle.solid,
                                                                    //               width: 2),
                                                                    //         ),
                                                                    //         child: DropdownButtonHideUnderline(
                                                                    //           child: ButtonTheme(
                                                                    //             alignedDropdown: true,
                                                                    //             child: Obx(()=>DropdownButton(
                                                                    //               dropdownColor:Colors.white,
                                                                    //               isDense: true,
                                                                    //               value: dualPaymentSelected1.value, // Not necessary for Option 1
                                                                    //               items: pMode.map((String val) {
                                                                    //                 return DropdownMenuItem(
                                                                    //                   child: new Text(val.toString(),
                                                                    //                     style: TextStyle(
                                                                    //                         fontWeight: FontWeight.bold,
                                                                    //                         letterSpacing: 1.5,
                                                                    //                         fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                                    //                         color: kHighlight
                                                                    //                     ),
                                                                    //                   ),
                                                                    //                   value: val,
                                                                    //                 );
                                                                    //               }).toList(),
                                                                    //               onChanged: (newValue) {
                                                                    //                 dualPaymentSelected1.value=newValue;
                                                                    //                 print(selectedPayment);
                                                                    //                 selectedPayment = newValue;
                                                                    //                 print(selectedPayment);
                                                                    //                 if(dualPaymentSelected1.value=='Cash')
                                                                    //                   showCashTendered.value=true;
                                                                    //                 else
                                                                    //                   showCashTendered.value=false;
                                                                    //               },
                                                                    //             )),
                                                                    //           ),
                                                                    //         ),
                                                                    //       ),
                                                                    //       // Container(
                                                                    //       //   width:100,
                                                                    //       //   child: TextField(
                                                                    //       //     style: TextStyle(
                                                                    //       //         fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                    //       //         color: Colors.black
                                                                    //       //     ),
                                                                    //       //     inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                    //       //     keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                    //       //     controller: dualPayment3.value,
                                                                    //       //     onEditingComplete: (){
                                                                    //       //       if(double.parse(dualPayment3.value.text)<salesTotal){
                                                                    //       //         showDualPayment.value=true;
                                                                    //       //         double temp=salesTotal-double.parse(dualPayment3.value.text);
                                                                    //       //         dualPayment2.value.text=temp.toString();
                                                                    //       //       }
                                                                    //       //       else{
                                                                    //       //         showDualPayment.value=false;
                                                                    //       //       }
                                                                    //       //     },
                                                                    //       //     decoration: new InputDecoration(
                                                                    //       //       hintText: 'Amount',
                                                                    //       //       border: OutlineInputBorder(),
                                                                    //       //       disabledBorder: OutlineInputBorder(
                                                                    //       //       ),
                                                                    //       //       enabledBorder: OutlineInputBorder(),
                                                                    //       //     ),
                                                                    //       //   ),
                                                                    //       // ),
                                                                    //     ]
                                                                    // ),


                                                                    // SizedBox(height:10),
                                                                    // Obx(()=>Visibility(
                                                                    //     visible:showCashTendered.value,
                                                                    //     child:Column(
                                                                    //         children:[
                                                                    //           Row(
                                                                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //               children:[
                                                                    //                 Text('Cash Tendered', style: TextStyle(
                                                                    //                   fontWeight: FontWeight.bold,
                                                                    //                   fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                                    //                 ),),
                                                                    //                 Container(
                                                                    //                   width:100,
                                                                    //                   child: TextField(
                                                                    //                     style: TextStyle(
                                                                    //                       fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                    //                     ),
                                                                    //                     inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                    //                     keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                    //                     controller: dualPayment1.value,
                                                                    //                     onEditingComplete: (){
                                                                    //                       refundAmt.value=double.parse(dualPayment1.value.text)-double.parse(dualPayment3.value.text);
                                                                    //                     },
                                                                    //                     decoration: new InputDecoration(
                                                                    //                       hintText: 'Amount',
                                                                    //                       border: OutlineInputBorder(),
                                                                    //                       disabledBorder: OutlineInputBorder(
                                                                    //                       ),
                                                                    //                       enabledBorder: OutlineInputBorder(),
                                                                    //                     ),
                                                                    //                   ),
                                                                    //                 ),
                                                                    //               ]
                                                                    //           ),
                                                                    //           SizedBox(height:10),
                                                                    //           Row(
                                                                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //               children:[
                                                                    //                 Text('Refund Amount', style: TextStyle(
                                                                    //                   fontWeight: FontWeight.bold,
                                                                    //                   fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                                    //                 ),),
                                                                    //                 Obx(()=>Text(refundAmt.value.toStringAsFixed(decimals), style: TextStyle(
                                                                    //                   fontWeight: FontWeight.bold,
                                                                    //                   fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                    //                 ),)),
                                                                    //               ]
                                                                    //           ),
                                                                    //         ]
                                                                    //     )
                                                                    // )),
                                                                    // SizedBox(height:10),
                                                                    // Obx(()=>Visibility(
                                                                    //   visible:showDualPayment.value,
                                                                    //   child: Row(
                                                                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //       children:[
                                                                    //         Container(
                                                                    //           decoration: BoxDecoration(
                                                                    //             border: Border.all(
                                                                    //                 color: kAppBarItems,
                                                                    //                 style: BorderStyle.solid,
                                                                    //                 width: 2),
                                                                    //           ),
                                                                    //           child: DropdownButtonHideUnderline(
                                                                    //             child: ButtonTheme(
                                                                    //               alignedDropdown: true,
                                                                    //               child: DropdownButton(
                                                                    //                 dropdownColor:Colors.white,
                                                                    //                 isDense: true,
                                                                    //                 value: dualPaymentSelected2.value, // Not necessary for Option 1
                                                                    //                 items: paymentMode.map((String val) {
                                                                    //                   return DropdownMenuItem(
                                                                    //                     child: new Text(val.toString(),
                                                                    //                       style: TextStyle(
                                                                    //                           fontWeight: FontWeight.bold,
                                                                    //                           letterSpacing: 1.5,
                                                                    //                           fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                                    //                           color: kHighlight
                                                                    //                       ),
                                                                    //                     ),
                                                                    //                     value: val,
                                                                    //                   );
                                                                    //                 }).toList(),
                                                                    //                 onChanged: (newValue) {
                                                                    //                   dualPaymentSelected2.value=newValue;
                                                                    //                 },
                                                                    //               ),
                                                                    //             ),
                                                                    //           ),
                                                                    //         ),
                                                                    //         Container(
                                                                    //           width:100,
                                                                    //           child: TextField(
                                                                    //             style: TextStyle(
                                                                    //               fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                    //             ),
                                                                    //             inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                    //             keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                    //             controller: dualPayment2.value,
                                                                    //             onEditingComplete: (){
                                                                    //
                                                                    //             },
                                                                    //             decoration: new InputDecoration(
                                                                    //               hintText: 'Amount',
                                                                    //               border: OutlineInputBorder(),
                                                                    //               disabledBorder: OutlineInputBorder(
                                                                    //               ),
                                                                    //               enabledBorder: OutlineInputBorder(),
                                                                    //             ),
                                                                    //           ),
                                                                    //         ),
                                                                    //       ]
                                                                    //   ),
                                                                    // ),),
                                                                    SizedBox(
                                                                        height: MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .height *
                                                                            0.03),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                        right: 5.0,
                                                                        left: 5.0,),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              Navigator
                                                                                  .pop(
                                                                                  context);
                                                                            },
                                                                            child: Container(
                                                                              height: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  0.05,
                                                                              width: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .width *
                                                                                  0.33,
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  border: Border
                                                                                      .all(
                                                                                    color: Colors
                                                                                        .black,

                                                                                  ),
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      MediaQuery
                                                                                          .of(
                                                                                          context)
                                                                                          .size
                                                                                          .width *
                                                                                          0.022)
                                                                              ),
                                                                              child: Center(
                                                                                  child: Text(
                                                                                    'CLOSE',
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .black),)),

                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            height: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .height *
                                                                                0.05,
                                                                            width: MediaQuery
                                                                                .of(
                                                                                context)
                                                                                .size
                                                                                .width *
                                                                                0.33,
                                                                            decoration: BoxDecoration(
                                                                                color: bottomColor,
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .size
                                                                                        .width *
                                                                                        0.022)
                                                                            ),
                                                                            child: GestureDetector(

                                                                              onTap: () async {
                                                                                await initConnectivity();
                                                                                if (cartListText
                                                                                    .isNotEmpty&&_connectionStatus.toString().trim()!='ConnectivityResult.none') {
                                                                                  double tot = 0;
                                                                                  List cart = [];
                                                                                  cart.addAll(cartListText);
                                                                                  cartListText.clear();
                                                                                  Navigator
                                                                                      .pop(
                                                                                      context);
                                                                                  ScaffoldMessenger.of(context).showSnackBar(salesreturndone);

                                                                                  // for (int i = 0; i <
                                                                                  //     cartListText
                                                                                  //         .length; i++) {
                                                                                  //   List a = cartListText[i]
                                                                                  //       .toString()
                                                                                  //       .trim()
                                                                                  //       .split(
                                                                                  //       ':');
                                                                                  //   tot +=
                                                                                  //       double
                                                                                  //           .parse(
                                                                                  //           a[2]
                                                                                  //             ..toString()
                                                                                  //                 .trim());
                                                                                  // }
                                                                                  // await read(
                                                                                  //     'till_data');
                                                                                  // await firebaseFirestore
                                                                                  //     .collection(
                                                                                  //     'user_data')
                                                                                  //     .doc(
                                                                                  //     userNam
                                                                                  //         .toString()
                                                                                  //         .trim())
                                                                                  //     .update(
                                                                                  //     {
                                                                                  //       "invoicecount": invcount +
                                                                                  //           1
                                                                                  //     })
                                                                                  //     .then((
                                                                                  //     _) {});
                                                                                  // if (dualPaymentSelected1
                                                                                  //     .value
                                                                                  //     .toString()
                                                                                  //     .trim() ==
                                                                                  //     'Cash') {
                                                                                  //   await firebaseFirestore
                                                                                  //       .collection(
                                                                                  //       'till_data')
                                                                                  //       .doc(
                                                                                  //       '1')
                                                                                  //       .update(
                                                                                  //       {
                                                                                  //         "${dualPaymentSelected1
                                                                                  //             .value
                                                                                  //             .toString()
                                                                                  //             .trim()
                                                                                  //             .toLowerCase()}sales": cashmoney +
                                                                                  //             tot
                                                                                  //       })
                                                                                  //       .then((
                                                                                  //       _) {});
                                                                                  //   await firebaseFirestore
                                                                                  //       .collection(
                                                                                  //       'user_data')
                                                                                  //       .doc(
                                                                                  //       userNam
                                                                                  //           .toString()
                                                                                  //           .trim())
                                                                                  //       .update(
                                                                                  //       {
                                                                                  //         "cashsales": cashmoney +
                                                                                  //             tot
                                                                                  //       })
                                                                                  //       .then((
                                                                                  //       _) {});
                                                                                  // }
                                                                                  // else {
                                                                                  //   print(
                                                                                  //       'credit');
                                                                                  //   await firebaseFirestore
                                                                                  //       .collection(
                                                                                  //       'till_data')
                                                                                  //       .doc(
                                                                                  //       '1')
                                                                                  //       .update(
                                                                                  //       {
                                                                                  //         "${dualPaymentSelected1
                                                                                  //             .value
                                                                                  //             .toString()
                                                                                  //             .trim()
                                                                                  //             .toLowerCase()}sales": creditmoney +
                                                                                  //             tot
                                                                                  //       })
                                                                                  //       .then((
                                                                                  //       _) {});
                                                                                  //   await firebaseFirestore
                                                                                  //       .collection(
                                                                                  //       'user_data')
                                                                                  //       .doc(
                                                                                  //       userNam
                                                                                  //           .toString()
                                                                                  //           .trim())
                                                                                  //       .update(
                                                                                  //       {
                                                                                  //         "creditsales": creditmoney +
                                                                                  //             tot
                                                                                  //       })
                                                                                  //       .then((
                                                                                  //       _) {});
                                                                                  // }

                                                                                  // int  invNum=await getLastInv(
                                                                                  //       'sales');



                                                                                  // if(currentPrinter=='Network'){
                                                                                  //   const PaperSize paper = PaperSize.mm80;
                                                                                  //   final profile = await CapabilityProfile.load();
                                                                                  //   final printer = NetworkPrinter(paper, profile);
                                                                                  //   try{
                                                                                  //     print("Print result:::: "+allPrinterIp[allPrinter.indexOf(currentPrinterName)]);
                                                                                  //     // final PosPrintResult res = await printer.connect(defaultIpAddress, port: int.parse(defaultPort),timeout: Duration(seconds: 10));
                                                                                  //     final PosPrintResult res = await printer.connect(allPrinterIp[allPrinter.indexOf(currentPrinterName)], port: 9100);
                                                                                  //
                                                                                  //     if (res == PosPrintResult.success) {
                                                                                  //       print('print working');
                                                                                  //       await  networkPrint('$invNum',printer );
                                                                                  //       printer.disconnect();
                                                                                  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print result: ${res.msg}')));
                                                                                  //     }
                                                                                  //     else{
                                                                                  //       print("FAILURE");
                                                                                  //       //await  networkPrint('$userSalesPrefix$invNo',printer );
                                                                                  //       //printer.disconnect();
                                                                                  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print result: ${res.msg}')));
                                                                                  //     }
                                                                                  //     print('Print result: ${res.msg}');
                                                                                  //   }
                                                                                  //   catch(e){
                                                                                  //
                                                                                  //   }
                                                                                  // }
                                                                                  // sunmiPrint(invNum.toString(),3);
                                                                                  // final PosPrintResult res = await printer.connect(defaultIpAddress, port: int.parse(defaultPort),timeout: Duration(seconds: 10));
                                                                                  // final PosPrintResult res = await printer.connect(allPrinterIp[allPrinter.indexOf(currentPrinterName)], port: 9100);

                                                                                  // await firebaseFirestore
                                                                                  //     .collection(
                                                                                  //     "invoice_data")
                                                                                  //     .doc(
                                                                                  //     '${userSalesPrefix
                                                                                  //         .toString()
                                                                                  //         .trim()}${invoicenum
                                                                                  //         .toString()
                                                                                  //         .trim()}')
                                                                                  //     .set(
                                                                                  //     {
                                                                                  //       'orderNo': '${userSalesPrefix
                                                                                  //           .toString()
                                                                                  //           .trim()}${invoicenum
                                                                                  //           .toString()
                                                                                  //           .trim()}',
                                                                                  //       'date': DateTime
                                                                                  //           .now()
                                                                                  //           .millisecondsSinceEpoch,
                                                                                  //       'customer': selectedCustomer !=
                                                                                  //           ''
                                                                                  //           ? selectedCustomer
                                                                                  //           : 'Standard',
                                                                                  //       'cartList': cartListText,
                                                                                  //       'salestype': selectedmenu
                                                                                  //           .toString()
                                                                                  //           .trim(),
                                                                                  //       'paymentmode': selectedPayment,
                                                                                  //       'total': tot
                                                                                  //           .toString()
                                                                                  //           .trim(),
                                                                                  //       'user': userNam
                                                                                  //           .toString()
                                                                                  //           .trim()
                                                                                  //       // 'payment':temp[3].toString().trim(),
                                                                                  //       // 'total': temp[4].toString().trim(),
                                                                                  //       // 'transactionType': temp[5].toString().trim(),
                                                                                  //       // 'user': temp[6].toString().trim(),
                                                                                  //       // 'balance': double.parse(temp[7].toString().trim()),
                                                                                  //       // 'discount':'0'
                                                                                  //     })
                                                                                  //     .then((
                                                                                  //     _) {});
                                                                                  List temp = [];
                                                                                  double total = 0;
                                                                                  for(int i = 0;i<cart.length;i++){



                                                                                    List a = cart[i].toString().trim().split(':');
                                                                                    print(a);
                                                                                    double r = double.parse(a[2].toString().trim())/
                                                                                        double.parse(a[3].toString().trim());
                                                                                    total+=double.parse(a[2].toString().trim());
                                                                                    temp.add({

                                                                                      "item_code": itemcode[allSalableProducts.indexOf(a[0].toString().trim())],
                                                                                      "qty":-int.parse(a[3].toString().trim()) ,
                                                                                      "unitPrice": r,



                                                                                    });
                                                                                  }


                                                                                  var url =
                                                                                  Uri.https('${link.toString().trim()}', '/api/resource/Sales Invoice');
                                                                                  List a = dateNow().toString().trim().split(' ');
                                                                                  print('teee');

                                                                                  var response = await http.post(
                                                                                    url,
                                                                                    body: jsonEncode({
                                                                                      "customer": "${selectedCustomer.toString().trim()}",
                                                                                      "series": "SINV-.YY.-",
                                                                                      "date": a[0].toString().trim().replaceAll('/', '-'),
                                                                                      "docstatus": 1,
                                                                                      "update_stock": 1,
                                                                                      "is_return": 1,
                                                                                      "items": temp
                                                                                    }),
                                                                                    headers: {'Authorization': "token $tokengeneral:$secretgeneral"},
                                                                                  );
                                                                                  dynamic data = jsonDecode(response.body);




                                                                                  setState(() {
                                                                                    currentOrder =
                                                                                    '';
                                                                                    cartController =
                                                                                    [
                                                                                    ];
                                                                                    cartdup =
                                                                                    [
                                                                                    ];
                                                                                    cartQtyController =
                                                                                    [
                                                                                    ];
                                                                                    salesTotalList =
                                                                                    [
                                                                                    ];
                                                                                    salesUomList =
                                                                                    [
                                                                                    ];
                                                                                    cartListText =
                                                                                    [
                                                                                    ];
                                                                                    customerName =
                                                                                    "";
                                                                                    selectedPayment =
                                                                                    'Cash';
                                                                                    selectedCustomer =
                                                                                        cntctController
                                                                                            .text =
                                                                                    '';
                                                                                  });

                                                                                }
                                                                                else {
                                                                                  if(_connectionStatus.toString().trim()=='ConnectivityResult.none'){
                                                                                    nonet(context);

                                                                                  }
                                                                                  else if(cartListText.isEmpty){

                                                                                  }

                                                                                }
                                                                              },
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "CHECKOUT",
                                                                                  style: TextStyle(
                                                                                    color: Colors
                                                                                        .white,
                                                                                    fontSize: MediaQuery
                                                                                        .of(
                                                                                        context)
                                                                                        .textScaleFactor *
                                                                                        16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                );

                                              });

                                        }
                                        else{
                                          if(_connectionStatus.toString().trim()=='ConnectivityResult.none') {
                                            nonet(context);
                                          }
                                          else if(cartListText.isEmpty){
                                            addproduct(context);
                                          }
                                        else if(selectedCustomer==''){
                                        selectacustomer(context);
                                        }



                                        // // await checkOut(currentOrder,true,0,'', '',false);
                                          // setState(() {
                                          //   currentOrder='';
                                          //   cartController=[];
                                          //   cartQtyController=[];
                                          //   cartdup =[];
                                          //
                                          //   print(cartdup.length);
                                          //   print(cartController.length);
                                          //   print(cartQtyController.length);
                                          //   salesTotalList=[];
                                          //   salesUomList=[];
                                          //   cartListText=[];
                                          //   customerName="";
                                          // });
                                          // tableSelected.value='TABLE';
                                        }
                                      },
                                      child: Container(
                                        height:MediaQuery.of(context).size.height*0.06 ,
                                        width:MediaQuery.of(context).size.width*0.33,
                                        child: Center(child: Text('PLACE ORDER',style: TextStyle(color: Colors.white),)),
                                        decoration: BoxDecoration(
                                            color:bottomColor,
                                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.022)
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          )
                      ),
                    ],
                  ),
                ),





              ],
            ):


            Container(
              width:MediaQuery.of(context).size.width ,

              child: Column(
                children: [
                  ClipPath(
                    clipper:CustomClipPath(),

                    child: Container(
                      height:MediaQuery.of(context).size.height*0.12,
                      // decoration: new BoxDecoration(
                      color: bottomColor,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => FirstScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(17),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: MediaQuery.of(context).size.width*0.04,
                                child: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: MediaQuery.of(context).size.width*0.072,),
                              ),
                            ),
                          ),
                          selectedmenu!='Receipt'?
                          Container(
                            width: MediaQuery.of(context).size.width*0.6,
                            height: MediaQuery.of(context).size.height*0.08,

                            child:selectedCustomer==''?SimpleAutoCompleteTextField(

                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Search Customers',labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: const Icon(Icons.search, color: Colors.white,),
                                enabledBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,width: 1.0
                                    )
                                ),
                                focusedBorder:
                                OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),

                              ),
                              style: TextStyle(
                                color: Colors.white,

                                fontSize: MediaQuery.of(context).textScaleFactor*14,
                              ),
                              controller: cntctController,
                              clearOnSubmit: false,
                              suggestions: customerList,

                              textSubmitted: (text){
                                setState(() {
                                  selectedCustomer= cntctController.text = text;
                                  // selectedCustomer = customerList[allCustomerMobile.indexOf(text.toString().trim())];
                                  // print('sc:$selectedCustomer');
                                });
                              },
                            )
                                :Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(selectedCustomer.toString().trim(),style: TextStyle(fontFamily: 'Montserrat-SemiBold',fontSize: MediaQuery.of(context).size.width*0.045,color: Colors.white),),
                                Text( allCustomerAddress[customerList.indexOf(selectedCustomer.toString().trim())],style: TextStyle(fontFamily: 'Montserrat-SemiBold',fontSize: MediaQuery.of(context).size.width*0.035,color: Colors.white),),
                              ],
                            ),
                          ):Text('Dot Orders',style: TextStyle(fontFamily: 'Montserrat-SemiBold',fontSize: MediaQuery.of(context).size.width*0.05,color: Colors.white),)
                        ],
                      ),
                      // borderRadius: BorderRadius.only(
                      //
                      //   bottomLeft:Radius.elliptical(
                      //       MediaQuery.of(context).size.width, 65.0) ,
                      //
                      //
                      //
                      //     bottomRight: Radius.elliptical(
                      //         MediaQuery.of(context).size.width, 110.0)
                      // ),
                    ),
                  ),

                  SizedBox(height:MediaQuery.of(context).size.height*0.03,),
             Container(
               margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.03,right:MediaQuery.of(context).size.width*0.03  ),
                    width:MediaQuery.of(context).size.width,

                    child:  SimpleAutoCompleteTextField(
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ),
                      // focusNode: nameNode,
                      controller: customerVendorController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            customerVendorController.clear();
                            netBalanceController.clear();
                          });
                        },
                            icon: Icon(Icons.clear)),
                        suffixIconColor: kAppBarItems,
                        label: Text('Enter Customer Name'),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:bottomColor, width: 2.0
                          ),
                          // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: bottomColor, width: 2.0),
                          //  borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                        ),
                      ),
                      suggestions: customerList,
                      clearOnSubmit: false,
                      textSubmitted: (text)async {
                        print('hhh');
                      await  getAccountsReceivable(text.toString().trim());
                      print(balfrmrepo);
                      netBalanceController.text = await balfrmrepo.toString().trim();

                        selected=customerVendorController.text=text;
                        print('sel:$selected');

                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                  Padding(
                    padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.03,right:MediaQuery.of(context).size.width*0.03  ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                            ),
                            controller: netBalanceController,
                            enabled: true,
                            // keyboardType:
                            // TextInputType.number,
                            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              label: Text('Net Balance'),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:bottomColor, width: 2.0
                                ),
                                // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                              ),
                              disabledBorder:  OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:bottomColor, width: 2.0
                                ),
                                // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: bottomColor, width: 2.0),
                                //  borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height*0.03,),
                  Padding(
                    padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.03,right:MediaQuery.of(context).size.width*0.03  ),
                    child: TextField(
                      onChanged: (value){

                      },
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                      ),
                      controller: amountController,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                      keyboardType: TextInputType.numberWithOptions(decimal: true),//
                      decoration: InputDecoration(
                        label: Text('Amount'),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:bottomColor, width: 2.0
                          ),
                          // borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: bottomColor, width: 2.0),
                          //  borderRadius:  BorderRadius.all(Radius.circular(32.0),)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height*0.04,),
                  TextButton(
                    onPressed: ()async {
                      bool allok = true;
                      await initConnectivity();
                      if(amountController.text==''||amountController.text=='0'){
                        allok=false;

                      }
                      if(customerVendorController.text==''||customerVendorController.text=='0'){
                        allok=false;

                      }
                      if(netBalanceController.text==''){
                        allok=false;

                      }
                      double minus = double.parse(netBalanceController.text.toString().trim())-double.parse(amountController.text.toString().trim());



                      if(allok==true&& _connectionStatus.toString().trim()!='ConnectivityResult.none'&&minus.toString().contains('-')==false) {
                        netBalanceController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(creditpaid);



                         var url = Uri.https('${link.toString().trim()}', '/api/resource/Payment Entry');
                         var response = await client.post(
                           '/api/resource/Payment Entry',
                             data:
                                 {
                                   "series": "ACC-PAY-.YYYY.-",
                                   "payment_type": "Receive",
                                   "docstatus": 1,
                                   "mode_of_payment": "Cash",
                                   "party_type": "Customer",
                                   "party": "${customerVendorController.text.trim()}",
                                   "party_name":"${customerVendorController.text.trim()}",
                                   "contact": "${customerVendorController.text.trim()}-${customerVendorController.text.trim()}",
                                   "paid_amount": double.parse(amountController.text.trim()),
                                   "received_amount": double.parse(amountController.text.trim()),
                                   "target_exchange_rate":  1.00,
                                   "paid_to": "Cash - SAFLSAM"

                                 }



                         );












                        setState(() {
                          amountController.clear();
                          customerVendorController.clear();
                          netBalanceController.clear();
                        });
                      }
                      else{
                        if(_connectionStatus.toString().trim()=='ConnectivityResult.none'){
                          nonet(context);
                        }
                        else{
                          fillall(context);

                        }
                      }




                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width*0.93,

                      child: Center(
                        child: Text('SUBMIT',
                          style: TextStyle(
                            color: Colors.white,

                            letterSpacing: 2.0,
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: bottomColor,
                        borderRadius:
                        BorderRadius.circular(10.0),
                      ),
                    ),
                  )


                ],

              ),
            )

        ),
      ),
    );
  }
  Container tableView(BuildContext context) {
    return Container(
      color: Colors.grey,
      // width: MediaQuery.of(context).size.width/1.5,
      // height: MediaQuery.of(context).size.height/1.5,
      child: GridView.builder(
        // physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width<600?3:6,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: 25,
          itemBuilder: (context, index) {
            final _isSelected=selectedTableList.contains(index+1);
            return RawMaterialButton(
              onPressed: (){
                    _selectedTable=index+1;
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width/3,
                height:MediaQuery.of(context).size.height/6,
                decoration: BoxDecoration(
                  color: _isSelected?Color(0xffce1212):kLightBlueColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        AutoSizeText(
                          'Table ${index+1}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*22,
                            color: kItemContainer,
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
  ScrollController _scrollController = ScrollController();


  String getItem(int index,int itemNo){
    List showCartItems=cartListText[index].split(':');
    if(itemNo==4){
      if(showCartItems.length>4){
        return showCartItems[itemNo].toString().trim();
      }
      else{
        return '';
      }
    }
    return showCartItems[itemNo].toString().trim();
  }

  DataTable dataTable(){

    return DataTable(
      columnSpacing:10,
        dataRowHeight: MediaQuery.of(context).size.height/11,
        columns: [DataColumn(label: Text('Item',
          style: TextStyle(
            fontSize: MediaQuery.of(context).textScaleFactor*20,
          ),
        )),
          DataColumn(label: Text('UOM',
            style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*20,
            ),
          ),

          ),
          DataColumn(label: Text('Qy',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*20,
            ),
          )),
          DataColumn(label: Text('U.price',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*20,
            ),
          )),
          DataColumn(label: Text('T.Price',
            style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*20,
            ),)),
          DataColumn(label: Text('',
            style: TextStyle(
              // fontSize: MediaQuery.of(context).textScaleFactor*20,
                color: kBlack
            ),)),
        ], rows: List.generate(cartListText.length, (index) => DataRow(cells: [
      DataCell(
          selectedBusiness=='Restaurant'?SizedBox(
        width: 200,
        child:  ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            onPressed: (){
              toppingModifierQtyList=[];
              flavourModifierQtyList=[];
              promotionModifierQtyList=[];
              String itemName=getItem(index, 0);
              showDialog(
                context: context, builder: (context) => StatefulBuilder(
                  builder: (context,setState) {
                    return Dialog(
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(onPressed: () {
                                Navigator.pop(context);
                              },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    color: kGreenColor,
                                    child: Text('CLOSE',style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                      color: kWhiteColor,
                                    ),),
                                  )),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Topping',style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                            color: kLightBlueColor,
                                          ),),
                                          SizedBox(height: 10,),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: StreamBuilder(
                                                stream: firebaseFirestore.collection('modifier_data').where('type',isEqualTo:'Topping').where('category',arrayContainsAny: ['${getCategory(itemName)}']).snapshots(),
                                                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot3) {
                                                  if (!snapshot3.hasData) {
                                                    return Center(
                                                      child: Text('Empty'),
                                                    );
                                                  }
                                                  for(int i=0;i<snapshot3.data.size;i++){
                                                    toppingModifierQtyList.add(0);
                                                  }
                                                  return GridView.builder(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 1,
                                                        childAspectRatio:
                                                        MediaQuery.of(context).size.width /
                                                            (MediaQuery.of(context).size.height/3),
                                                      ),
                                                      scrollDirection: Axis.vertical,
                                                      itemCount: snapshot3.data.docs.length,
                                                      itemBuilder: (context, index8) {
                                                        return   Padding(
                                                          padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
                                                          child:   Container(
                                                            padding: EdgeInsets.only(top: 4),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:kLightBlueColor,
                                                                  style: BorderStyle.solid,
                                                                  width: 0.80),

                                                            ),

                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(snapshot3.data.docs[index8]['name'],style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                                                  color: kBackgroundColor,
                                                                )),
                                                                Text('''$organisationSymbol ${snapshot3.data.docs[index8]['price']}''',style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                                                  color: kBackgroundColor,
                                                                )),
                                                                Container(
                                                                  padding: EdgeInsets.all(4.0),
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color:kLightBlueColor,
                                                                        style: BorderStyle.solid,
                                                                        width: 0.80),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:50,
                                                                        height: 30,
                                                                        child: ElevatedButton(
                                                                          style: ButtonStyle(
                                                                            elevation: MaterialStateProperty.all(3.0),
                                                                            backgroundColor: MaterialStateProperty.all(kBackgroundColor),
                                                                          ),
                                                                          child: Center(
                                                                            child: Icon(
                                                                              Icons.remove_circle_outline,color: Colors.white,),
                                                                          ),
                                                                          onPressed: () {
                                                                            removeModifier(itemName,snapshot3.data.docs[index8]['name'],snapshot3.data.docs[index8]['price'],index);
                                                                            if(toppingModifierQtyList[index8]!=0){
                                                                              setState((){
                                                                                toppingModifierQtyList[index8]-=1;
                                                                              });
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 6,right: 6),
                                                                        child: Text(toppingModifierQtyList[index8].toString(),
                                                                          textAlign: TextAlign.left,
                                                                          style: TextStyle(
                                                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: kBlack
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:50,
                                                                        height: 30,
                                                                        child: ElevatedButton(
                                                                          style: ButtonStyle(
                                                                            elevation: MaterialStateProperty.all(3.0),
                                                                            backgroundColor: MaterialStateProperty.all(kBackgroundColor),
                                                                          ),
                                                                          child: Icon(
                                                                            Icons.add_circle_outline,color: Colors.white,),
                                                                          onPressed: () {
                                                                            addModifier(itemName,snapshot3.data.docs[index8]['name'],snapshot3.data.docs[index8]['price'],index);
                                                                            setState((){
                                                                              toppingModifierQtyList[index8]+=1;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],),
                                                          ),
                                                        );
                                                      }
                                                  );
                                                }
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Flavour',style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                            color: kLightBlueColor,
                                          ),),
                                          SizedBox(height:10),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: StreamBuilder(
                                                stream: firebaseFirestore.collection('modifier_data').where('type',isEqualTo:'Flavour').snapshots(),
                                                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot3) {
                                                  if (!snapshot3.hasData) {
                                                    return Center(
                                                      child: Text('Empty'),
                                                    );
                                                  }
                                                  for(int i=0;i<snapshot3.data.size;i++){
                                                    flavourModifierQtyList.add(0);
                                                  }
                                                  print('flavourModifierQtyList $flavourModifierQtyList');
                                                  return GridView.builder(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 1,
                                                        childAspectRatio:
                                                        MediaQuery.of(context).size.width /
                                                            (MediaQuery.of(context).size.height/3 ),
                                                      ),
                                                      scrollDirection: Axis.vertical,
                                                      itemCount: snapshot3.data.docs.length,
                                                      itemBuilder: (context, index8) {
                                                        return   Padding(
                                                          padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
                                                          child:   Container(
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:kLightBlueColor,
                                                                  style: BorderStyle.solid,
                                                                  width: 0.80),

                                                            ),

                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(snapshot3.data.docs[index8]['name'],style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                                                  color: kBackgroundColor,
                                                                )),
                                                                Text('''$organisationSymbol ${snapshot3.data.docs[index8]['price']}''',style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                                                  color: kBackgroundColor,
                                                                )),
                                                                Flexible(
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:kLightBlueColor,
                                                                          style: BorderStyle.solid,
                                                                          width: 0.80),

                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                                      children: [
                                                                        SizedBox(
                                                                          height:30,
                                                                          width:50,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                              elevation: MaterialStateProperty.all(3.0),
                                                                              backgroundColor: MaterialStateProperty.all(kBackgroundColor),
                                                                            ),
                                                                            child: Icon(
                                                                                Icons.remove_circle_outline),
                                                                            onPressed: () {
                                                                              removeModifier(itemName,snapshot3.data.docs[index8]['name'],snapshot3.data.docs[index8]['price'],index);
                                                                              if(flavourModifierQtyList[index8]!=0) {
                                                                                setState(() {
                                                                                  flavourModifierQtyList[index8] -= 1;
                                                                                });
                                                                              }  },
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 6,right: 6),
                                                                          child: Text(flavourModifierQtyList[index8].toString(),
                                                                            textAlign: TextAlign.left,
                                                                            style: TextStyle(
                                                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                              color: kBlack,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:50,
                                                                          height: 30,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                              elevation: MaterialStateProperty.all(3.0),
                                                                              backgroundColor: MaterialStateProperty.all(kBackgroundColor),
                                                                            ),
                                                                            child: Icon(
                                                                                Icons.add_circle_outline),
                                                                            onPressed: () {
                                                                              addModifier(itemName,snapshot3.data.docs[index8]['name'],snapshot3.data.docs[index8]['price'],index);
                                                                              setState((){
                                                                                flavourModifierQtyList[index8]+=1;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],),



                                                          ),
                                                        );
                                                      }
                                                  );
                                                }
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Expanded(
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text('Promotion',style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                //         color: kLightBlueColor,
                                //       ),),
                                //       SingleChildScrollView(
                                //         scrollDirection: Axis.vertical,
                                //         child: StreamBuilder(
                                //             stream: firebaseFirestore.collection('modifier_data').where('type',whereIn:['Reduce','Discount']).snapshots(),
                                //             builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot3) {
                                //               if (!snapshot3.hasData) {
                                //                 return Center(
                                //                   child: Text('Empty'),
                                //                 );
                                //               }
                                //               for(int i=0;i<snapshot3.data.size;i++){
                                //                 promotionModifierQtyList.add(0);
                                //               }
                                //               return GridView.builder(
                                //                   physics: NeverScrollableScrollPhysics(),
                                //                   shrinkWrap: true,
                                //                   gridDelegate:
                                //                   SliverGridDelegateWithFixedCrossAxisCount(
                                //                     crossAxisCount: 2,
                                //                     childAspectRatio:
                                //                     MediaQuery.of(context).size.width /
                                //                         (MediaQuery.of(context).size.height ),
                                //                   ),
                                //                   scrollDirection: Axis.vertical,
                                //                   itemCount: snapshot3.data.docs.length,
                                //                   itemBuilder: (context, index8) {
                                //                     return   Padding(
                                //                       padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
                                //                       child:   Container(
                                //                         decoration: BoxDecoration(
                                //                           border: Border.all(
                                //                               color:kLightBlueColor,
                                //                               style: BorderStyle.solid,
                                //                               width: 0.80),
                                //
                                //                         ),
                                //
                                //                         child: Column(
                                //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                           children: [
                                //                             Text(snapshot3.data.docs[index8]['name']),
                                //                             Text('''Rs ${snapshot3.data.docs[index8]['price']}'''),
                                //                             Flexible(
                                //                               child: Container(
                                //                                 decoration: BoxDecoration(
                                //                                   border: Border.all(
                                //                                       color:kLightBlueColor,
                                //                                       style: BorderStyle.solid,
                                //                                       width: 0.80),
                                //
                                //                                 ),
                                //                                 child: Row(
                                //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //
                                //                                   children: [
                                //                                     GestureDetector(
                                //                                       child: Icon(
                                //                                           Icons.remove_circle_outline),
                                //                                       onTap: () {
                                //                                         //  removeModifier();
                                //                                       },
                                //                                     ),
                                //                                     Text(promotionModifierQtyList[index8].toString(),
                                //                                       textAlign: TextAlign.left,
                                //                                       style: TextStyle(
                                //                                           fontSize: MediaQuery.of(context).textScaleFactor*20,
                                //                                           color: kBlack
                                //                                       ),
                                //                                     ),
                                //                                     GestureDetector(
                                //                                       child: Icon(
                                //                                           Icons.add_circle_outline),
                                //                                       onTap: () {
                                //                                         // addModifier();
                                //                                       },
                                //                                     ),
                                //                                   ],
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ],),
                                //
                                //
                                //
                                //                       ),
                                //                     );
                                //                   }
                                //               );
                                //             }
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),
              );
            },
            child: getItem(index, 4).length>0?Text('${getItem(index, 0).replaceAll('#', '/')}\n  ${getItem(index, 4)}' , overflow: TextOverflow.ellipsis,style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*16,
              color: kBlack,
            ),maxLines: 3,):Text('${getItem(index, 0).replaceAll('#', '/')}' , overflow: TextOverflow.ellipsis,style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*16,
              color: kBlack,
            ),maxLines: 3,)
        ),
      ):
      SizedBox(
          width:200,
          height: 20,
          child:Text('${getItem(index, 0).replaceAll('#', '/')}' ,style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*16,
              color: kBlack,
              fontWeight: FontWeight.bold
          ),maxLines: 3, overflow: TextOverflow.ellipsis,))),
      DataCell(
      Container(

           height: 90,
          child: DropdownButton(
             value: salesUomList[index].trim(),// Not necessary for Option 1
            items: getUom(getItem(index, 0)).map((String val) {
              return DropdownMenuItem(
                child: new Text(val.toString().trim(),style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor*16,
                    color: kBlack,
                    fontWeight: FontWeight.bold
                ),),
                value: val.trim(),
              );
            }).toList(),
            onChanged: (newValue) {
              String tempPrice=getPrice(getItem(index, 0), newValue);
              print('tempPrice $tempPrice');
              List showCartItems=cartListText[index].split(':');
              double tempPrice1=double.parse(getItem(index, 3))*double.parse(tempPrice.trimLeft());
              showCartItems[2]=tempPrice.trimLeft();
              showCartItems[3]=getItem(index, 3);
              // showCartItems[3]='1';
              showCartItems[1]=newValue;
              String tempVal=showCartItems.toString().replaceAll(',', ':');
              tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
              print(tempVal);
              setState(() {
                salesTotalList[index]=tempPrice1;
                cartController[index].text=tempPrice1.toString();
                cartQtyController[index].text=getItem(index, 3);
                salesUomList[index] = newValue;
                cartListText[index]=tempVal;
                getTotal(salesTotalList);
              });

            },
          ),
        ),),
      DataCell(
       Container(
         margin: EdgeInsets.only(top: 10,bottom: 10),
          height: 100,
          width: 90,
          child: TextFormField(
            decoration: new InputDecoration(
              // contentPadding: EdgeInsets.all(4.0),
              isDense: false,
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              border: OutlineInputBorder(),
                disabledBorder: OutlineInputBorder(
                ),
                enabledBorder: OutlineInputBorder(),
            ),
            style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*16,
                color: kBlack,
                fontWeight: FontWeight.bold
            ),
            keyboardType: TextInputType.number ,
            controller: cartQtyController[index],
            onChanged: (val){
              List showCartItems=cartListText[index].split(':');
              double tempQuantity = double.parse(val);
              // double tempRate = double.parse(getPrice(showCartItems[0], showCartItems[1]));
              print(showCartItems);
              double tempRate = double.parse(showCartItems[2])/double.parse(showCartItems[3]);
              tempRate = tempRate * double.parse(val);
              print(tempRate);
              showCartItems[2] = '$tempRate';
              showCartItems[3] = tempQuantity.toString();
              String tempVal=showCartItems.toString().replaceAll(',', ':');
              tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
              print(tempVal);
              setState(() {
                salesTotalList[index] = tempRate;
                cartController[index].text = tempRate.toString();
                // cartQtyController[index].text = tempQuantity.toStringAsFixed(2);
                cartListText[index]=tempVal;
              });

            },),
        ),
      ),
      DataCell(
       Container(
         margin: EdgeInsets.only(top: 10,bottom: 10),
          // height: 100,
          height: 100,
          width: 90,
          child: TextFormField(
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.all(4.0),
              border: OutlineInputBorder(),
              disabledBorder: OutlineInputBorder(
              ),
              enabledBorder: OutlineInputBorder(),
            ),
            style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*16,
                color: kBlack,
                fontWeight: FontWeight.bold
            ),
            keyboardType: TextInputType.number ,
            controller: cartdup[index],
            onChanged: (val){
              List showCartItems=cartListText[index].split(':');
              double ab = double.parse(val.toString())*double.parse(showCartItems[3]);
              showCartItems[2]=ab.toString();
              showCartItems[1].toString();
              String tempVal=showCartItems.toString().replaceAll(',', ':');
              tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
              print(tempVal);
              setState(() {
                salesTotalList[index]=ab;
                cartController[index].text=ab.toString();
                cartListText[index]=tempVal;
              });
            },

          ),
        ),
        // showEditIcon: true
      ),
      DataCell(
          Container(
            margin: EdgeInsets.only(top: 10,bottom: 10),
            height: 200,
            width: 90,
            child: TextFormField(
              enabled: false,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(4.0),
                  border: OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(
                  ),
                  enabledBorder: OutlineInputBorder(),
              ),
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*16,
                  color: kBlack,
                  fontWeight: FontWeight.bold
              ),
              keyboardType: TextInputType.number ,
              controller: cartController[index],
              onChanged: (val){
                print('hi');
                List showCartItems=cartListText[index].split(':');
                showCartItems[2]=val;
                showCartItems[1].toString();
                String tempVal=showCartItems.toString().replaceAll(',', ':');
                tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                print(tempVal);
                setState(() {
                  salesTotalList[index]=double.parse(val);
                  cartListText[index]=tempVal;
                });
              },),
          ),
          // showEditIcon: true
      ),
      DataCell(
          ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(3.0),
              backgroundColor: MaterialStateProperty.all(kGreenColor),
            ),
            onPressed: (){
              setState(() {
                salesTotalList.removeAt(index);
                cartController.removeAt(index);
                cartdup.removeAt(index);
                cartQtyController.removeAt(index);
                cartListText.removeAt(index);
                salesUomList.removeAt(index);
                getTotal(salesTotalList);
              });
            },
            child: Icon(Icons.delete),
          ))
    ])));
  }
  Dialog buildDialog() {
    return Dialog(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StreamBuilder(
              stream: firebaseFirestore.collection('floor_data').snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2) {
                if (!snapshot2.hasData) {
                  return Center(
                    child: Text('Empty'),
                  );
                }
                return Column(children: [
                  Obx(()=> Visibility(
                    visible:isMerge.value,
                    child:Center(
                      child: Text('Merge Table',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).textScaleFactor * 15,
                        color: kLightBlueColor,
                      ),),
                    ),
                  )),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      // scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot2.data.docs.length,
                      itemBuilder: (context,index1){
                        String floor=snapshot2.data.docs[index1]['floorName'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(floor,style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).textScaleFactor * 15,
                              color: kLightBlueColor,
                            ),),
                            StreamBuilder(
                                stream: firebaseFirestore.collection('table_data').where('area',isEqualTo:floor).snapshots(),
                                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot3) {
                                  if (!snapshot3.hasData) {
                                    return Center(
                                      child: Text('Empty'),
                                    );
                                  }
                                  return GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio:
                                        MediaQuery.of(context).size.width /
                                            (MediaQuery.of(context).size.height/2 ),
                                      ),
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot3.data.docs.length,
                                      itemBuilder: (context, index8) {
                                        String ordersLen=snapshot3.data.docs[index8]['orders'];
                                        bool merge=snapshot3.data.docs[index8]['merged'];
                                        return   Padding(
                                          padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
                                          child:   GestureDetector(
                                            onTap: (){
                                              print('ordersLen.length ${ordersLen.length}');
                                              if(isMerge.value==true ){
                                                if( ordersLen.length==0){
                                                  print('is merge true');
                                                  tableMergeSelect.value.add(snapshot3.data.docs[index8]['tableName']);
                                                  print('tableMergeSelect $tableMergeSelect');
                                                  firebaseFirestore.collection('table_data').doc(snapshot3.data.docs[index8]['tableName']).update(
                                                      {
                                                        "merged":true,
                                                      }
                                                  );
                                                }
                                                // print('tableIndex.value ${tableIndex.value}');
                                                // tableMergeSelect.value[tableIndex.value-1]=true;
                                              }
                                              else if(snapshot3.data.docs[index8]['merged']==false){
                                                tableSelected.value=snapshot3.data.docs[index8]['tableName'];
                                                currentTableOrders.value=snapshot3.data.docs[index8]['orders'];
                                                Navigator.pop(context);
                                              }
                                            },
                                            onLongPress: (){
                                              if(isMerge.value==false){
                                                if( ordersLen.length==0){
                                                  print('is merge true');
                                                  isMerge.value=true;
                                                  tableMergeSelect.value.add(snapshot3.data.docs[index8]['tableName']);
                                                  print('tableMergeSelect ${tableMergeSelect.value}');
                                                  firebaseFirestore.collection('table_data').doc(snapshot3.data.docs[index8]['tableName']).update(
                                                      {
                                                        "merged":true,
                                                      }
                                                  );
                                                }
                                                // print('tableIndex.value ${tableIndex.value}');
                                                // print('tableMergeSelect $tableMergeSelect');
                                              }
                                              else{
                                                print('merge is already on');
                                              }
                                              },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:merge?Colors.grey.withOpacity(0.5):ordersLen.isEmpty? Colors.white:Colors.grey.withOpacity(0.5),
                                                border: Border.all(

                                                    color:kLightBlueColor,

                                                    style: BorderStyle.solid,

                                                    width: 0.80),

                                              ),
                                              child: Stack(children: [
                                                Positioned.fill(child: Align(alignment: Alignment.center,child: Text(snapshot3.data.docs[index8]['tableName'],style: TextStyle(
                                                  color: Colors.black,
                                                  letterSpacing: 1.0,
                                                  fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                ),))),
                                                Positioned.fill(right: 5.0,top: 5.0,child: Align(alignment: Alignment.topRight,child: Text('''${snapshot3.data.docs[index8]['pax']} Pax'''))),
                                                if(ordersLen.length>0)
                                                  Align(alignment: Alignment.bottomLeft,child: Text(snapshot3.data.docs[index8]['orders'].toString().replaceAll('~', '/'),style: TextStyle(
                                                    color: Colors.black,
                                                  ), maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,)),
                                              ],),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                }
                            ),
                            Divider(thickness: 1.0,color: kLightBlueColor,),
                          ],
                        );
                      }
                  ),
                  Obx(()=> Visibility(
                    visible:isMerge.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () {
                          isMerge.value=false;
                          for(int i=0;i<tableMergeSelect.value.length;i++){
                            firebaseFirestore.collection('table_data').doc(tableMergeSelect.value[i]).update(
                                {
                                  "merged":false,
                                }
                            );
                          }
                          tableMergeSelect.value=RxList<String>([]);
                        },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              color: kGreenColor,
                              child: Text('Cancel',style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                color: kWhiteColor,
                              ),),
                            )),
                        SizedBox(width:20),
                        TextButton(onPressed: () {
                          if(tableMergeSelect.value.length>1){
                            print('tableMergeSelect.value.length ${tableMergeSelect.value.length}');
                            String temp='';
                            for(int i=0;i<tableMergeSelect.value.length;i++){
                              temp+='${tableMergeSelect.value[i]}';
                              if(i!=tableMergeSelect.value.length-1)
                                temp+='~';
                            }
                            print('temp $temp');
                            tableSelected.value=temp;
                            Navigator.pop(context);
                          }
                          else{
                            print('tableMergeSelect.value.length ${tableMergeSelect.value.length}');
                            print('select more than 1 table');
                          }

                        },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              color: kGreenColor,
                              child: Text('Done',style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                color: kWhiteColor,
                              ),),
                            )),
                      ],
                    ),
                  ))
                ],);
              }
          ),
        ),
      ),
    );
  }
  Future  formatKotList(String invNo,String table)async{
    print('inside format kot $table');
    String tempValue,tempText;
    for(int k=0;k<kotList.length;k++) {
      List temp = kotList[k].split(':');
      tempValue = getKotPrinterName(getCategory(temp[0].toString().trim()));
      tempText = temp.toString().replaceAll(',', ':');
      tempText=tempText.substring(1,tempText.length-1);
      tempText += ':$tempValue';
      kotList[k] = tempText;
      print('kotList after adding category $kotList');
    }
    int i=0;
    while(i<kotList.length){
      print('i $i');
      String tempCategory;
      List<int> pos=[];
      List<String> tempPrintList=[];
      List temp=kotList[i].toString().split(':');
      tempCategory=temp[3].toString().trim();
      pos.add(i);
      tempPrintList.add(kotList[i]);
      for(int j=i+1;j<kotList.length;j++){
        List tempSplit=kotList[j].toString().split(':');
        if(tempSplit[3].toString().trim()==tempCategory)
        {
          pos.add(j);
          tempPrintList.add(kotList[j]);
        }
      }
      await  networkKotPrint(invNo, table, tempCategory, tempPrintList);
      for(int k=pos.length-1;k>=0;k--){
        print(kotList);
        kotList.removeAt(pos[k]);
      }
      print('tempPrintList $tempPrintList');
      i=0;
    }
  }
  Future kotAssign(List items,String orderNumber)async{
    print('orderNumber $orderNumber');
    kotList=[];
    int ex = 0;double tempQuantity=0;
    print('items:$items');
    if(orderNumber.length>0){
      print('currentOrder $currentOrder');
      // DocumentSnapshot documentSnapshot=await firebaseFirestore.collection('kot_order').doc('$currentOrder').get();
      // List temp111=documentSnapshot['cartList'];
      List oldItemsList=currentKotOldList;
      firebaseFirestore.collection('kot_order').doc('$currentOrder').delete();
      // for(int i=0;i<temp111.length;i++){
      //   oldItemsList.add('${documentSnapshot['cartList'][i]['name']}:${documentSnapshot['cartList'][i]['uom']}:${documentSnapshot['cartList'][i]['price']}:${documentSnapshot['cartList'][i]['qty']}');
      // }
      // await firebaseFirestore.collection('kot_order').doc('$currentOrder').update({
      //   'cartList': FieldValue.arrayRemove(currentKotOldList11),
      // }).then((_) {
      //   print('success');
      // });
      for(int i=0;i<items.length;i++)
      {
        String description;
        List tempCartListText=items[i].split(':');
        print('tempCartListText $tempCartListText');
        if(tempCartListText.length==7) {
          description = tempCartListText[6];
          //  print('inside descr');
        }
        else
          description='';
        for(int j=0;j<oldItemsList.length;j++)
        {
          List tempOldItemsList=oldItemsList[j].split(':');

          if(tempCartListText[0]==tempOldItemsList[0])
          {

            // int tempQuantity=5;
            print('kot ${tempCartListText[3]}');
            if(double.parse(tempCartListText[3])!=double.parse(tempOldItemsList[3])) {
              tempQuantity = double.parse(tempCartListText[3]) -
                  double.parse(tempOldItemsList[3]);
              String tempKotItemAdded='${tempCartListText[0]}:$tempQuantity:$description';
              kotList.add(tempKotItemAdded);

            }
            j=oldItemsList.length+1;
            ex=0;
          }
          else ex=1;
        }
        if(ex==1)
        {
          tempQuantity=double.parse(tempCartListText[3]);
          String tempKotItemAdded='${tempCartListText[0]}:$tempQuantity:$description';
          kotList.add(tempKotItemAdded);
          ex=0;
        }
      }
      from:     for(int i=0;i<oldItemsList.length;i++){
        List tempOldItemsList=oldItemsList[i].split(':');
        for(int k=0;k<items.length;k++){
          List tempCartListText=items[k].split(':');
          if(tempOldItemsList[0]==tempCartListText[0])
            continue from ;
        }
        print(tempOldItemsList[0]);
        String tempKotItemAdded='${tempOldItemsList[0]}:-${tempOldItemsList[3]}:';
        kotList.add(tempKotItemAdded);
      }
      print('kotlist: $kotList');
      print('inside if tableSelected: $tableSelected');
      if(selectedBusiness=='Restaurant'){
        print('inside if tableSelected: $tableSelected');
        await  kotOrders(tableSelected.value,true);
        await formatKotList(currentOrder,tableSelected.value);
        return;
      }
      else{
        await  kotOrders(tableSelected.value,false);
      }
    }
    else{
      kotOrders(tableSelected.value,false);
      for(int i=0;i<items.length;i++){
        String description;
        List tempList=items[i].split(':');
        print('tempList $tempList');
        if(tempList.length==5)
          description=tempList[4];
        else
          description='';
        String tempItemContent='${tempList[0]}:${tempList[3]}:$description';
        kotList.add(tempItemContent);
      }
      int invNo;
      invNo=await getLastInv('kot');
      currentOrder='${getPrefix()}$invNo';
      print('kotList $kotList');
      print('end of kot function');
      if(selectedBusiness=='Restaurant'){
        await formatKotList(currentOrder,tableSelected.value);
      }
      return;
    }
  }
  Future kotItems(List items,String orderNumber)async{
    print('orderNumber $orderNumber');

    kotList=[];
    int ex = 0;double tempQuantity=0;
    print('items:$items');
    if(orderNumber.length>0)
    {
      print('inside if ${waiterKotList.length}');
      for(int i=0;i<waiterKotList.length;i++){
        print('waiterkot ${waiterKotList[i]}');
        List temp=waiterKotList[i].split(',');
        if(temp[0].toString().trim().contains(orderNumber)){
          print('temp[0].toString().trim() ${temp[0].toString().trim()}');
          print('orderNumber ${orderNumber.length}');
          List selectedOrderItems=waiterKotList[i].split(',');
          String tempKot=selectedOrderItems[6].toString().trim();
          print('tempKot $tempKot');
          List oldItemsList=tempKot.split('-');
          print('oldItemsList $oldItemsList');
          oldItemsList.removeAt(oldItemsList.length-1);
          print('oldItemsList $oldItemsList');
          for(int i=0;i<items.length;i++)
          {
            String description;
            List tempCartListText=items[i].split(':');
            print('tempCartListText $tempCartListText');
            if(tempCartListText.length==7) {
              description = tempCartListText[6];
              //  print('inside descr');
            }
            else
              description='';
            for(int j=0;j<oldItemsList.length;j++)
            {
              List tempOldItemsList=oldItemsList[j].split(':');

              if(tempCartListText[0]==tempOldItemsList[0])
              {

                // int tempQuantity=5;
                print('kot ${tempCartListText[3]}');
                if(double.parse(tempCartListText[3])!=double.parse(tempOldItemsList[3])) {
                  tempQuantity = double.parse(tempCartListText[3]) -
                      double.parse(tempOldItemsList[3]);
                  String tempKotItemAdded='${tempCartListText[0]}:$tempQuantity:$description';
                  kotList.add(tempKotItemAdded);

                }
                j=oldItemsList.length+1;
                ex=0;
              }
              else ex=1;
            }
            if(ex==1)
            {
              tempQuantity=double.parse(tempCartListText[3]);
              String tempKotItemAdded='${tempCartListText[0]}:$tempQuantity:$description';
              kotList.add(tempKotItemAdded);
              ex=0;
            }
          }
          from:     for(int i=0;i<oldItemsList.length;i++){
            List tempOldItemsList=oldItemsList[i].split(':');
            for(int k=0;k<items.length;k++){
              List tempCartListText=items[k].split(':');
              if(tempOldItemsList[0]==tempCartListText[0])
                continue from ;
            }
            print(tempOldItemsList[0]);
            String tempKotItemAdded='${tempOldItemsList[0]}:-${tempOldItemsList[3]}:';
            kotList.add(tempKotItemAdded);
          }
          print('kotlist: $kotList');
          await  kotOrders(tableSelected.value,true);
          await formatKotList(currentOrder,tableSelected.value);
          return;
          //allOrders(salesOrderNo,_selectedTable);
        }
      }}
    else{
      print('inside else order no$orderNumber');
      await  kotOrders(tableSelected.value,false);
      print('inside for loop ');
      for(int i=0;i<items.length;i++){
        String description;
        List tempList=items[i].split(':');
        if(tempList.length==7)
          description=tempList[6];
        else
          description='';
        String tempItemContent='${tempList[0]}:${tempList[3]}:$description';
        kotList.add(tempItemContent);
      }
      // int orderNo=await getSavedOrderInvoiceNo();
      // currentOrder='${getPrefix()}$orderNo';
      print('kotList $kotList');
      print('end of kot function');
      await formatKotList(currentOrder,_selectedTable.toString());
      return;
    }

  }
  Future networkKotPrint(String invNo,String table,String tempCategory,List tempPrintList)async{
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    String tempIpAddress=getKotIpAddressPrinter(tempCategory);
    NetworkPrinter printer=NetworkPrinter(paper, profile);
    try{
      print('table $table ');
      final PosPrintResult res = await printer.connect(tempIpAddress.trim(), port:9100,timeout: Duration(seconds: 5));
      if (res == PosPrintResult.success) {
        printer.text('KOT', styles: PosStyles(align: PosAlign.center,bold: true));
        printer.text('User :$currentUser', styles: PosStyles(align: PosAlign.center,bold: true));
        printer.text('Section :$tempCategory', styles: PosStyles(align: PosAlign.center,bold: true));
        if(selectedDelivery=='Spot')
          printer.text(table.contains('~')?table.replaceAll('~', ','):table, styles: PosStyles(align: PosAlign.center,bold: true),);
        if(selectedDelivery=='Take Away')
          printer.text('TAKEAWAY', styles: PosStyles(align: PosAlign.center,bold: true),);
        printer.hr(ch: '-');
        printer.text('Order No: $invNo', styles: PosStyles(align: PosAlign.left,bold: true));
        printer.text(dateNow(), styles: PosStyles(align: PosAlign.left,bold:true));
        printer.hr(ch: '-');
        printer.row([
          PosColumn(text: 'Item   ', width: 10, styles: PosStyles(align: PosAlign.left,bold: true)),
          PosColumn(text: 'Qty  ', width: 2, styles: PosStyles(align: PosAlign.right,bold: true)),
        ]);
        printer.hr(ch: '-');
        for(int i=0;i<tempPrintList.length;i++)
        {
          List cartItemsString=tempPrintList[i].split(':');
          String temp=cartItemsString[2].toString().replaceAll(' ', '');
          String itemNameSplit=cartItemsString[0].toString();
          if(cartItemsString[0].toString().contains('#')){
            itemNameSplit=itemNameSplit.substring(0,itemNameSplit.indexOf('#'));
          }
          printer.row([
            temp.length>0?PosColumn(text:'''${cartItemsString[2].length>0?'$itemNameSplit \n ${cartItemsString[2]}':'$itemNameSplit'}''', width: 10, styles: PosStyles(align: PosAlign.left,bold: true)):
            PosColumn(text: itemNameSplit, width:10, styles: PosStyles(align: PosAlign.left,bold: true)),
            PosColumn(text: '${cartItemsString[1]}', width: 2, styles: PosStyles(align: PosAlign.right,bold: true)),
            // PosColumn(
            //     text: '${cartItemsString[2]}   ', width: 3, styles: PosStyles(align: PosAlign.right)),
          ]);
        }
        printer.cut();
        printer.disconnect();
        showDialog(
            context: context, builder: (ctx) =>
            AlertDialog(
              title: Text('Printer Success '),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ));
      }
      else{
        if(kotFailedList.isEmpty){
          kotFailedList=tempPrintList;
        }
        else{
          for(int k=0;k<tempPrintList.length;k++)
            kotFailedList.add(tempPrintList[k]);
        }
        print('kotFailedList $kotFailedList');
        showDialog(
          context:
          context,
          builder: (ctx) =>
              AlertDialog(
                title: Text('Printer Fail'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
        );
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print result: ${res.msg}')));
      }

    }
    catch(e){

    }

  }
}

String getPrefix(){
  print('inside get prefix$currentUser');
  for(int i=0;i<userList.length;i++){
    if(currentUser==userList[i]){
      return userPrefixList[i];
    }
  }
  return '';
}
Future kotOrders(String tableNumber,bool exist)async{
  print('inside kot orders table $tableNumber');
  print('inside kot orders type $selectedDelivery');
  print('inside kot orders currentUser $currentUser');
  List yourItemsList=[];
  String tempModifier='';
  String body='';
  tableNumber=tableNumber.contains('~')?tableNumber.replaceAll('~', ','):tableNumber;
  // List tempInv1=[];
  // await firebaseFirestore.collection("kot_order").get().then((querySnapshot) {
  //   querySnapshot.docs.forEach((result) {
  //     tempInv1.add(result.get('orderNo'));
  //   });
  // });
  if(exist==true){
    print('currentOrder $currentOrder');
    for(int k=0;k<cartListText.length;k++){
      List temp=cartListText[k].split(':');
      String itemName=temp[0];
      String itemQty=temp[3];
      String itemUom=temp[1];
      String itemPrice=temp[2];
      if(temp.length>4){
        tempModifier=temp[4];
      }
      yourItemsList.add({
        "name":itemName,
        "uom":itemUom,
        "qty":itemQty,
        "price":itemPrice,
        "modifier":tempModifier,
        "ready":false
      });
    }
    firebaseFirestore
        .collection("kot_order")
        .doc(currentOrder)
        .set({
      'orderNo': currentOrder,
      'date': currentKotDate,
      'tableNo': tableNumber,
      'customer': selectedCustomer,
      'priceList': selectedPriceList,
      'user': currentUser,
      'note': currentKotNote,
      'type': selectedDelivery,
      'cartList': FieldValue.arrayUnion(yourItemsList),
    }).then((_) {
      print('kot created updated');
    });
    // update('kot_order', yourItemsList, currentOrder);
    return;
  }
  print('not if inside  kot orders');
  int invNo;
  invNo=await getLastInv('kot');
  String note='';
  if(selectedDelivery=='Drive Through'){
    note=driveNoteController.text;
  }
  else if(selectedDelivery=='Take Away'){
    note=takeAwayNoteController.text;
  }
  body='${getPrefix()}$invNo~${dateNow()}~$tableNumber~$selectedCustomer~$selectedPriceList~$currentUser~$note~$selectedDelivery';
  for(int k=0;k<cartListText.length;k++){
    List temp=cartListText[k].split(':');
    String itemName=temp[0];
    String itemQty=temp[3];
    String itemUom=temp[1];
    String itemPrice=temp[2];
    if(temp.length>4){
      tempModifier=temp[4];
    }
    yourItemsList.add({
      "name":itemName,
      "uom":itemUom,
      "qty":itemQty,
      "price":itemPrice,
      "modifier":tempModifier,
      "ready":false
    });
  }
  create(body, 'kot_order', yourItemsList);
  updateInv('kot', invNo+1);
  currentOrder='${getPrefix()}$invNo';
  return;
}



String getCategory(String item){
  for(int i=0;i<productFirstSplit.length;i++){
    List temp=productFirstSplit[i].toString().split(':');
    if(item==temp[0].toString().trim())
      return temp[1].toString().trim();
  }
  return '';
}
String getKotIpAddress(String category){
  for(int i=0;i<kotCategory.length;i++){
    if(kotCategory[i]==category){
      return kotPrinterIpAddress[i];
    }
  }
  return '';
}
String getTax(String productName)
{
  //print("FIRST PRINT"+productName);
  String prod ="";

  for(int i=0;i<productFirstSplit.length;i++)
  {
    if(productFirstSplit[i].contains(productName))
    {
      List itemsL = productFirstSplit[i].split(':');
      // print("Product Name : "+productName+"Tax % = "+itemsL[5]);
      prod = itemsL[4]+"%#"+itemsL[5];
    }
  }
  return prod;
}
void sunmiPrint(String orderNo,discount)
{
  double tax5=0;
  double tax10=0;
  double tax12=0;
  double tax18=0;
  double tax28=0;
  double cess=0;
  taxCum = "";
  grandTotal=0;
  print('here111');
  SunmiPrinter.text('$organisationName', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.lg),);
  SunmiPrinter.text('$organisationAddress', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
  if(organisationMobile.length>0)
    SunmiPrinter.text('Mobile Number:$organisationMobile', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
  if(organisationGstNo.length>0) {
    SunmiPrinter.text('$organisationTaxType Number:$organisationGstNo', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
    SunmiPrinter.text('$organisationTaxTitle', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
  }
  SunmiPrinter.hr(ch:'-');
  DateTime now = DateTime.now();
  String dateS = DateFormat('dd-MM-yyyy – kk:mm').format(now);

  //String dateS = currentTime.toString().substring(0,16);
  // Text('$currentTime'),

  SunmiPrinter.text('Invoice No:$userSalesPrefix$orderNo', styles: SunmiStyles(bold: true,align: SunmiAlign.left,size: SunmiSize.md),);
  SunmiPrinter.text('Date:$dateS', styles: SunmiStyles(bold: true,align: SunmiAlign.left,size: SunmiSize.md),);
  if (appbarCustomerController.text.length>0){
    SunmiPrinter.text('Customer Name:${appbarCustomerController.text}',
      styles: SunmiStyles(align: SunmiAlign.left, size: SunmiSize.md),);
    if(allCustomerAddress[customerList.indexOf(appbarCustomerController.text)].length>0)
      SunmiPrinter.text('Customer Address:${allCustomerAddress[customerList.indexOf(appbarCustomerController.text)]}',
        styles: SunmiStyles(align: SunmiAlign.left, size: SunmiSize.md),);
  }
  SunmiPrinter.hr(ch: '-');
  SunmiPrinter.row(
      cols: [
        SunmiCol(text: 'Item', width:organisationGstNo.length>0? 5:6),
        SunmiCol(text: 'Qty', width: 1),
        SunmiCol(text: 'Rate', width: 2),
        if(organisationGstNo.length>0)
          SunmiCol(text: 'Tax', width: 1),
        SunmiCol(text: 'Amount', width:3),
      ]);
  SunmiPrinter.hr(ch: '-');
  grandTotal=0;double exclTotal =0;
  totalTax=0;
  for(int i=0;i<cartListText.length;i++) {
    List cartItemsString = cartListText[i].split(':');
    double tempTotal = double.parse(cartItemsString[2]);
    String tax = getTaxName(cartItemsString[0].toString().trim());
    double amt = double.parse(cartItemsString[2]);
    double price = double.parse(cartItemsString[2]) /
        double.parse(cartItemsString[3]);
    amt = double.parse((amt).toStringAsFixed(3));
    grandTotal += amt;
    if(organisationTaxType=='VAT'){
      if (tax.trim() == 'VAT 10') {
        //tax10 += (double.parse( getPercent(tax)) / 100) * price;
        //tax10 =  tax10 + 0.1*amt;
        tax10 =  tax10 + amt-amt/1.1;
      }
    }
    else{
      if (tax.trim() == 'GST 5') {
        tax5 += (double.parse( getPercent(tax)) / 100) * price;
        totalTax+=tax5;
      }
      if (tax.trim() == 'GST 10') {
        tax10 =  tax10 + amt-amt/1.1;
        totalTax+=tax10;
      }

      if (tax.trim() == 'GST 12') {
        tax12 += (double.parse(getPercent(tax)) / 100) * price;
        totalTax+=tax12;
      }
      if (tax.trim() == 'GST 18') {
        tax18 += (double.parse(getPercent(tax)) / 100) * price;
        totalTax+=tax18;
      }
      if (tax.trim() == 'GST 28') {
        tax28 += (double.parse(getPercent(tax)) / 100) * price;
        cess += (12 / 100) * price;
        totalTax+=tax28+cess;
      }
      print('${cartItemsString[0]} totalTax $totalTax   tax $tax');
    }
    SunmiPrinter.row(
      cols: [
        SunmiCol(text: '${cartItemsString[0]}', width: organisationGstNo.length>0?5:6),
        SunmiCol(text: '${cartItemsString[3]}', width: 1, ),
        SunmiCol(text: '$price', width: 2, ),
        if(organisationGstNo.length>0)
          SunmiCol(text:'${getPercent(tax)}', width: 1, ),
        SunmiCol(text: '${cartItemsString[2]}', width: 3, ),
      ],
    );
  }
  SunmiPrinter.hr(ch: '-');
  if(organisationTaxType=='VAT'){
    exclTotal = grandTotal - tax10;
    SunmiPrinter.row(
        cols: [
          SunmiCol(text:'Bill Amount', width: 6),
          SunmiCol(text:'${exclTotal.toStringAsFixed(decimals)}', width: 6,),
        ]);
    SunmiPrinter.row(
        cols: [
          SunmiCol(text:'Vat 10%', width: 6),
          SunmiCol(text:'${tax10.toStringAsFixed(decimals)}', width: 6,),
        ]);
    grandTotal = exclTotal + tax10;
    SunmiPrinter.row(
        cols: [
          SunmiCol(text:'Net Payable', width: 6),
          SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
        ]);
  }
  else{
    if(organisationGstNo.length>0){
      exclTotal = grandTotal - totalTax;
      SunmiPrinter.row(
          cols: [
            SunmiCol(text:'Bill Amount', width: 6),
            SunmiCol(text:'${exclTotal.toStringAsFixed(decimals)}', width: 6,),
          ]);
      SunmiPrinter.row(
          cols: [
            SunmiCol(text:'Total Tax', width: 6),
            SunmiCol(text:'${totalTax.toStringAsFixed(decimals)}', width: 6,),
          ]);
      if(double.parse(totalDiscountController.text)>0){
        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'Discount', width: 6),
              SunmiCol(text:'${double.parse(totalDiscountController.text).toStringAsFixed(decimals)}', width: 6,),
            ]);
        grandTotal = grandTotal - double.parse(totalDiscountController.text);
      }
      SunmiPrinter.row(
          cols: [
            SunmiCol(text:'Net Payable', width: 6),
            SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
          ]);
      SunmiPrinter.hr(ch: '-');
      if(tax5>0){
        SunmiPrinter.text('CGST 2.5%     ${(tax5/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
        SunmiPrinter.text('SGST 2.5%     ${(tax5/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo
      }
      if(tax12>0){
        SunmiPrinter.text('CGST 6%     ${(tax12/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
        SunmiPrinter.text('SGST 6%     ${(tax12/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo
      }
      if(tax18>0){
        SunmiPrinter.text('CGST 9%     ${(tax18/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
        SunmiPrinter.text('SGST 9%     ${(tax18/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo
      }
      if(tax28>0){
        SunmiPrinter.text('CGST 14%     ${(tax28/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
        SunmiPrinter.text('SGST 14%     ${(tax28/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo

        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'cess 12%', width: 6),
              SunmiCol(text:'${cess.toStringAsFixed(decimals)}', width: 6,),
            ]);
      }
    }
    else{
      if(double.parse(totalDiscountController.text)>0){
        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'Bill Amount', width: 6),
              SunmiCol(text:'${exclTotal.toStringAsFixed(decimals)}', width: 6,),
            ]);
        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'Discount', width: 6),
              SunmiCol(text:'${double.parse(totalDiscountController.text).toStringAsFixed(decimals)}', width: 6,),
            ]);
        grandTotal = grandTotal - double.parse(totalDiscountController.text);
        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'Net Payable', width: 6),
              SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
            ]);
      }
      else{
        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'Bill Amount', width: 6),
              SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
            ]);
      }
    }
  }
  if(organisationGstNo.length>0) SunmiPrinter.hr(ch: '-');
  SunmiPrinter.text('Thank You,Visit Again', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
  SunmiPrinter.emptyLines(2);

}

// void sunmiT1Print(String orderNo)async{
//   print('inside sunmi t111111111');
//   double tax5=0;
//   double tax10=0;
//   double tax12=0;
//   double tax18=0;
//   double tax28=0;
//   double cess=0;
//   grandTotal=0;
//   await SunmiPrinter.initPrinter();
//   await SunmiPrinter.startTransactionPrint(true);
//   await SunmiPrinter.printText('$organisationName',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//   await SunmiPrinter.printText('$organisationAddress',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//   if(organisationMobile.length>0)
//     await SunmiPrinter.printText('Mobile Number:$organisationMobile',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//   if(organisationGstNo.length>0) {
//     await SunmiPrinter.printText('$organisationTaxType Number:$organisationGstNo',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//     await SunmiPrinter.printText('$organisationTaxTitle',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//   }
//   await SunmiPrinter.line();
//   DateTime now = DateTime.now();
//   String dateS = DateFormat('dd-MM-yyyy – kk:mm').format(now);
//   await SunmiPrinter.printText('Invoice No:$userSalesPrefix$orderNo',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//   await SunmiPrinter.printText('Date:$dateS',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//   if (appbarCustomerController.text.length>0){
//     await SunmiPrinter.printText('Customer Name:${appbarCustomerController.text}',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//     if(allCustomerAddress[customerList.indexOf(appbarCustomerController.text)].length>0)
//       await SunmiPrinter.printText('Customer Address:${allCustomerAddress[customerList.indexOf(appbarCustomerController.text)]}',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//   }
//   await SunmiPrinter.line();
//   await SunmiPrinter.printRow(cols: [
//     ColumnMaker(text: 'Item', width: organisationGstNo.length>0? 9:13, align: SunmiPrintAlign.LEFT),
//     ColumnMaker(text: 'Qty', width: 4,),
//     ColumnMaker(text: 'Rate', width: 5,),
//     if(organisationGstNo.length>0)
//       ColumnMaker(text: 'Tax', width: 4,),
//     ColumnMaker(text: 'Amount', width: 6, align: SunmiPrintAlign.RIGHT),
//   ]);
//   await SunmiPrinter.line();
//   grandTotal=0;double exclTotal =0;
//   totalTax=0;
//   for(int i=0;i<cartListText.length;i++) {
//     List cartItemsString = cartListText[i].split(':');
//     double tempTotal = double.parse(cartItemsString[2]);
//     String tax = getTaxName(cartItemsString[0].toString().trim());
//     double amt = double.parse(cartItemsString[2]);
//     double price = double.parse(cartItemsString[2]) /
//         double.parse(cartItemsString[3]);
//     amt = double.parse((amt).toStringAsFixed(3));
//     grandTotal += amt;
//     if(organisationTaxType=='VAT'){
//       if (tax.trim() == 'VAT 10') {
//         //tax10 += (double.parse( getPercent(tax)) / 100) * price;
//         //tax10 =  tax10 + 0.1*amt;
//         tax10 =  tax10 + amt-amt/1.1;
//       }
//     }
//     else{
//       if (tax.trim() == 'GST 5') {
//         tax5 += (double.parse( getPercent(tax)) / 100) * price;
//         totalTax+=tax5;
//       }
//       if (tax.trim() == 'GST 10') {
//         tax10 =  tax10 + amt-amt/1.1;
//         totalTax+=tax10;
//       }
//
//       if (tax.trim() == 'GST 12') {
//         tax12 += (double.parse(getPercent(tax)) / 100) * price;
//         totalTax+=tax12;
//       }
//       if (tax.trim() == 'GST 18') {
//         tax18 += (double.parse(getPercent(tax)) / 100) * price;
//         totalTax+=tax18;
//       }
//       if (tax.trim() == 'GST 28') {
//         tax28 += (double.parse(getPercent(tax)) / 100) * price;
//         cess += (12 / 100) * price;
//         totalTax+=tax28+cess;
//       }
//       print('${cartItemsString[0]} totalTax $totalTax   tax $tax');
//     }
//     await SunmiPrinter.printRow(cols: [
//       ColumnMaker(text: cartItemsString[0], width: organisationGstNo.length>0? 9:13, align: SunmiPrintAlign.LEFT),
//       ColumnMaker(text: cartItemsString[3], width: 4,),
//       ColumnMaker(text: price.toString(), width: 5,),
//       if(organisationGstNo.length>0)
//         ColumnMaker(text: getPercent(tax), width: 4,),
//       ColumnMaker(text: cartItemsString[2], width: 6, align: SunmiPrintAlign.RIGHT),
//     ]);
//   }
//   await SunmiPrinter.line();
//   if(organisationTaxType=='VAT') {
//     exclTotal = grandTotal - tax10;
//     await SunmiPrinter.printRow(cols: [
//       ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//       ColumnMaker(text:exclTotal.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//     ]);
//     await SunmiPrinter.printRow(cols: [
//       ColumnMaker(text: 'Vat 10%', width: 14, align: SunmiPrintAlign.LEFT),
//       ColumnMaker(text:tax10.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//     ]);
//     grandTotal = exclTotal + tax10;
//     await SunmiPrinter.printRow(cols: [
//       ColumnMaker(text: 'Net Payable', width: 14, align: SunmiPrintAlign.LEFT),
//       ColumnMaker(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//     ]);
//   }
//   else{
//     if(organisationGstNo.length>0) {
//       exclTotal = grandTotal - totalTax;
//       await SunmiPrinter.printRow(cols: [
//         ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//         ColumnMaker(text:exclTotal.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//       ]);
//       await SunmiPrinter.printRow(cols: [
//         ColumnMaker(text: 'Total Tax', width: 14, align: SunmiPrintAlign.LEFT),
//         ColumnMaker(text:totalTax.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//       ]);
//       if(double.parse(totalDiscountController.text)>0){
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Discount', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:double.parse(totalDiscountController.text).toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//         grandTotal = grandTotal - double.parse(totalDiscountController.text);
//       }
//       await SunmiPrinter.printRow(cols: [
//         ColumnMaker(text: 'Net Payable', width: 14, align: SunmiPrintAlign.LEFT),
//         ColumnMaker(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//       ]);
//       await SunmiPrinter.line();
//       if(tax5>0){
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'CGST 2.5%', width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: (tax5/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: 'SGST 2.5%', width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: (tax5/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//         ]);
//       }
//       if(tax12>0){
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'CGST 6%', width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: (tax12/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: 'SGST 6%', width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: (tax12/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//         ]);
//       }
//       if(tax18>0){
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'CGST 9%', width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: (tax18/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: 'SGST 9%', width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: (tax18/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//         ]);
//       }
//       if(tax28>0){
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'CGST 14%', width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: (tax28/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: 'SGST 14%', width: 7, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: (tax28/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//         ]);
//       }
//       if(tax12>0){
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'CESS 12%', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text: cess.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.LEFT),
//         ]);
//       }
//     }
//     else{
//       if(double.parse(totalDiscountController.text)>0) {
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:exclTotal.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Discount', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:double.parse(totalDiscountController.text).toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//         grandTotal = grandTotal - double.parse(totalDiscountController.text);
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Net Payable', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//       }
//       else{
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//         await SunmiPrinter.line();
//       }
//     }
//   }
//   if(organisationGstNo.length>0)  await SunmiPrinter.line();
//   await SunmiPrinter.printText('Thank You,Visit Again',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//   await SunmiPrinter.lineWrap(2);
//   await SunmiPrinter.exitTransactionPrint(true);
// }


void sunmiV2Print(String orderNo,List carts)
{
  double tax5=0;
  double tax10=0;
  double tax12=0;
  double tax18=0;
  double tax28=0;
  double cess=0;
  taxCum = "";
  grandTotal=0;
  SunmiPrinter.text('$organisationName', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
  SunmiPrinter.text('SRM ROAD,ERANAKULAM', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
    SunmiPrinter.text('Mobile Number: 9746886263', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
  if(organisationGstNo.length>0) {
    SunmiPrinter.text('$organisationTaxType Number:$organisationGstNo', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size:SunmiSize.md),);
    SunmiPrinter.text('$organisationTaxTitle', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
  }
  SunmiPrinter.hr(ch:'-');
  DateTime now = DateTime.now();
  String dateS = DateFormat('dd-MM-yyyy – kk:mm').format(now);

  //String dateS = currentTime.toString().substring(0,16);
  // Text('$currentTime'),

  SunmiPrinter.text('Invoice No:$userSalesPrefix$orderNo', styles: SunmiStyles(bold: true,align: SunmiAlign.left,size: SunmiSize.md),);
  SunmiPrinter.text('Date:$dateS', styles: SunmiStyles(bold: true,align: SunmiAlign.left,size: SunmiSize.md),);
  if (selectedCustomer!=''){


    SunmiPrinter.text('Customer Name:${selectedCustomer}',
      styles: SunmiStyles(align: SunmiAlign.left, size: SunmiSize.md),);

  }
  SunmiPrinter.hr(ch: '-');
  if(orgMultiLine=='true'){
    SunmiPrinter.text('Item', styles: SunmiStyles(align: SunmiAlign.left,size: SunmiSize.md),);
    SunmiPrinter.row(
        cols: [
          SunmiCol(text: '  Qty', width: 3,align: SunmiAlign.center),
          SunmiCol(text: 'Rate', width: 3,align: SunmiAlign.right),
          if(organisationGstNo.length>0)
            SunmiCol(text: 'Tax', width: 2,align: SunmiAlign.right),
          SunmiCol(text: 'Amount', width:organisationGstNo.length>0?4:6,align: SunmiAlign.right),
        ]);
  }
  else{
    SunmiPrinter.row(
        cols: [
          SunmiCol(text: 'Item', width:organisationGstNo.length>0? 5:6,align: SunmiAlign.left),
          SunmiCol(text: 'Qty', width: 1,align: SunmiAlign.center),
          SunmiCol(text: 'Rate', width: 2,align: SunmiAlign.right),
          if(organisationGstNo.length>0)
            SunmiCol(text: 'Tax', width: 1,align: SunmiAlign.center),
          SunmiCol(text: 'Amount', width:3,align: SunmiAlign.right),
        ]);
  }
  SunmiPrinter.hr(ch: '-');
  grandTotal=0;double exclTotal =0;
  totalTax=0;
  for(int i=0;i<carts.length;i++) {
    List cartItemsString = carts[i].split(':');
    double tempTotal = double.parse(cartItemsString[2]);
    String tax = getTaxName(cartItemsString[0].toString().trim());
    double amt = double.parse(cartItemsString[2]);
    double price = double.parse(cartItemsString[2]) /
        double.parse(cartItemsString[3]);
    amt = double.parse((amt).toStringAsFixed(3));
    grandTotal += amt;
    if(organisationTaxType=='VAT'){
      if (tax.trim() == 'VAT 10') {
        //tax10 += (double.parse( getPercent(tax)) / 100) * price;
        //tax10 =  tax10 + 0.1*amt;
        tax10 =  tax10 + amt-amt/1.1;
      }
    }
    else{
      if (tax.trim() == 'GST 5') {
        tax5 += (double.parse( getPercent(tax)) / 100) * price;
        totalTax+=tax5;
      }
      if (tax.trim() == 'GST 10') {
        tax10 =  tax10 + amt-amt/1.1;
        totalTax+=tax10;
      }

      if (tax.trim() == 'GST 12') {
        tax12 += (double.parse(getPercent(tax)) / 100) * price;
        totalTax+=tax12;
      }
      if (tax.trim() == 'GST 18') {
        tax18 += (double.parse(getPercent(tax)) / 100) * price;
        totalTax+=tax18;
      }
      if (tax.trim() == 'GST 28') {
        tax28 += (double.parse(getPercent(tax)) / 100) * price;
        cess += (12 / 100) * price;
        totalTax+=tax28+cess;
      }
      print('${cartItemsString[0]} totalTax $totalTax   tax $tax');
    }
    if(orgMultiLine=='true'){
      SunmiPrinter.text(cartItemsString[0],
        styles: SunmiStyles(align: SunmiAlign.left, size: SunmiSize.md,),);//gr
      SunmiPrinter.row(
        cols: [
          SunmiCol(text: '  ${cartItemsString[3]}', width: 3, align: SunmiAlign.center),
          SunmiCol(text: '$price', width: 3,align: SunmiAlign.right ),
          if(organisationGstNo.length>0)
            SunmiCol(text:'${getPercent(tax)}', width: 2, align: SunmiAlign.right),
          SunmiCol(text: '${cartItemsString[2]}', width:organisationGstNo.length>0?4:6,align: SunmiAlign.right, ),
        ],
      );
    }
    else{
      SunmiPrinter.row(
        cols: [
          SunmiCol(text: '${cartItemsString[0]}', width: organisationGstNo.length>0?5:6,align: SunmiAlign.left),
          SunmiCol(text: '${cartItemsString[3]}', width: 1, align: SunmiAlign.center),
          SunmiCol(text: '$price', width: 2, align: SunmiAlign.right),
          if(organisationGstNo.length>0)
            SunmiCol(text:'${getPercent(tax)}', width: 1, align: SunmiAlign.center),
          SunmiCol(text: '${cartItemsString[2]}', width: 3, align: SunmiAlign.right),
        ],
      );
    }
  }
  SunmiPrinter.hr(ch: '-');
  if(organisationTaxType=='VAT'){
    exclTotal = grandTotal - tax10;
    SunmiPrinter.row(
        cols: [
          SunmiCol(text:'Bill Amount', width: 6),
          SunmiCol(text:'${exclTotal.toStringAsFixed(decimals)}', width: 6,),
        ]);
    SunmiPrinter.row(
        cols: [
          SunmiCol(text:'Vat 10%', width: 6),
          SunmiCol(text:'${tax10.toStringAsFixed(decimals)}', width: 6,),
        ]);
    grandTotal = exclTotal + tax10;
    SunmiPrinter.row(
        cols: [
          SunmiCol(text:'Net Payable', width: 6),
          SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
        ]);
  }
  else{
    if(organisationGstNo.length>0){
      exclTotal = grandTotal - totalTax;
      SunmiPrinter.row(
          cols: [
            SunmiCol(text:'Bill Amount', width: 6),
            SunmiCol(text:'${exclTotal.toStringAsFixed(decimals)}', width: 6,),
          ]);
      SunmiPrinter.row(
          cols: [
            SunmiCol(text:'Total Tax', width: 6),
            SunmiCol(text:'${totalTax.toStringAsFixed(decimals)}', width: 6,),
          ]);
      if(double.parse(totalDiscountController.text)>0){
        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'Discount', width: 6),
              SunmiCol(text:'${double.parse(totalDiscountController.text).toStringAsFixed(decimals)}', width: 6,),
            ]);
        grandTotal = grandTotal - double.parse(totalDiscountController.text);
      }
      SunmiPrinter.row(
          cols: [
            SunmiCol(text:'Net Payable', width: 6),
            SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
          ]);
      SunmiPrinter.hr(ch: '-');
      if(tax5>0){
        SunmiPrinter.text('CGST 2.5%     ${(tax5/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
        SunmiPrinter.text('SGST 2.5%     ${(tax5/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo
      }
      if(tax12>0){
        SunmiPrinter.text('CGST 6%     ${(tax12/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
        SunmiPrinter.text('SGST 6%     ${(tax12/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo
      }
      if(tax18>0){
        SunmiPrinter.text('CGST 9%     ${(tax18/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
        SunmiPrinter.text('SGST 9%     ${(tax18/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo
      }
      if(tax28>0){
        SunmiPrinter.text('CGST 14%     ${(tax28/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
        SunmiPrinter.text('SGST 14%     ${(tax28/2).toStringAsFixed(decimals)}',
          styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo

        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'cess 12%', width: 6),
              SunmiCol(text:'${cess.toStringAsFixed(decimals)}', width: 6,),
            ]);
      }
    }
    else{
      if(double.parse(totalDiscountController.text)>0){
        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'Bill Amount', width: 6),
              SunmiCol(text:'${exclTotal.toStringAsFixed(decimals)}', width: 6,),
            ]);
        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'Discount', width: 6),
              SunmiCol(text:'${double.parse(totalDiscountController.text).toStringAsFixed(decimals)}', width: 6,),
            ]);
        grandTotal = grandTotal - double.parse(totalDiscountController.text);
        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'Net Payable', width: 6),
              SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
            ]);
      }
      else{
        SunmiPrinter.row(
            cols: [
              SunmiCol(text:'Bill Amount', width: 6),
              SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
            ]);
        SunmiPrinter.hr(ch: '-');
      }
    }
  }
  if (selectedCustomer!='') {
    SunmiPrinter.hr(ch: '-');
    SunmiPrinter.text('Customer Balance:${balfrmrepo.toString().trim()}',
      styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md),);
  }
  if(organisationGstNo.length>0) SunmiPrinter.hr(ch: '-');
  SunmiPrinter.text('Thank You,Visit Again', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
  SunmiPrinter.emptyLines(6);


}


String dateNow(){
  final now = DateTime.now();
  final formatter = DateFormat('MM/dd/yyyy H:m');
  final String timestamp = formatter.format(now);
  return timestamp;
}
class DeliverySelect extends StatefulWidget {
  @override
  _DeliverySelectState createState() => _DeliverySelectState();
}

class _DeliverySelectState extends State<DeliverySelect> {
  int selectedMode=0;
  List<bool> isSelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedCustomer='';
    selectedmenu = 'sales';
    isSelected = [true, false,false];
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  }
  @override
  Widget build(BuildContext context) {

    Container tableView(BuildContext context) {
      return Container(
        color: Colors.grey,
        // width: MediaQuery.of(context).size.width/1.5,
        // height: MediaQuery.of(context).size.height/1.5,
        child: GridView.builder(
          // physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width<600?3:6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: 25,
            itemBuilder: (context, index) {
              final _isSelected=selectedTableList.contains(index+1);
              return RawMaterialButton(
                onPressed: (){
                  _selectedTable=index+1;
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  height:MediaQuery.of(context).size.height/6,
                  decoration: BoxDecoration(
                    color: _isSelected?Color(0xffce1212):kLightBlueColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          AutoSizeText(
                            'Table ${index+1}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*22,
                              color: kItemContainer,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 4.0),
      child: Row(
        mainAxisAlignment: selectedBusiness=='Restaurant'?MainAxisAlignment.spaceAround:MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: selectedBusiness=='Restaurant'?true:false,
            child: ToggleButtons(
              isSelected: isSelected,
              color:kGreenColor ,
              borderColor: kGreenColor,
              fillColor:kGreenColor,
              borderWidth: 2,
              selectedColor: kFont1Color,
              selectedBorderColor: kFont3Color,
              borderRadius: BorderRadius.circular(0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Dine In',
                    style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Drive Through',
                    style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*15,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Take Away11',
                    style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20, ),
                  ),
                )
              ],
              onPressed: (int index) {
                selectedMode=index+1;
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                  selectedDelivery=deliveryMode[index];
                });
                 if(selectedDelivery=='Drive Through'){
                  driveNoteController.text='';
                  showDialog(context: context,
                      builder: (BuildContext context){
                        return Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          child: Container(
                            padding: EdgeInsets.all(6.0),
                            width: MediaQuery.of(context).size.width/3,
                            //height: MediaQuery.of(context).size.height/3,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  TextField(
                                    maxLines: 4,
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                    ),
                                    controller: driveNoteController,
                                    keyboardType: TextInputType.streetAddress,
                                    decoration:InputDecoration(
                                      hintText: 'Enter customer details',
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
                                      //labelText: 'Username',
                                      labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                    ),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () => Navigator.pop(context),
                                    fillColor: kHighlight,
                                    //splashColor: Colors.greenAccent,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Done",
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.white,
                                          //letterSpacing: 1.0,
                                          fontSize: MediaQuery.of(context).textScaleFactor*18,
                                        ),
                                      ),
                                    ),
                                    shape: const StadiumBorder(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
                else if(selectedDelivery=='Take Away'){
                  takeAwayNoteController.text='';
                  showDialog(context: context,
                      builder: (BuildContext context){
                        return Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          child: Container(
                            padding: EdgeInsets.all(6.0),
                            width: MediaQuery.of(context).size.width/3,
                            //height: MediaQuery.of(context).size.height/3,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  TextField(
                                    maxLines: 4,
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                    ),
                                    controller: takeAwayNoteController,
                                    keyboardType: TextInputType.streetAddress,
                                    decoration:InputDecoration(
                                      hintText: 'Enter customer details',
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
                                      //labelText: 'Username',
                                      labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                    ),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () => Navigator.pop(context),
                                    fillColor: kHighlight,
                                    //splashColor: Colors.greenAccent,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Done",
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.white,
                                          //letterSpacing: 1.0,
                                          fontSize: MediaQuery.of(context).textScaleFactor*18,
                                        ),
                                      ),
                                    ),
                                    shape: const StadiumBorder(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
                print('selectedDelivery $selectedDelivery');
              },
            ),
          ),

        ],
      ),
    );
  }
}
class CustomerSelect extends StatefulWidget {
  @override
  _CustomerSelectState createState() => _CustomerSelectState();
}

class _CustomerSelectState extends State<CustomerSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.only(top: 3.0),
      child: Row(
        children:[
          Text('Customer : ',style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).textScaleFactor*20,
          ),
          ),
          // SizedBox(
          //   width:MediaQuery.of(context).size.width/2,
          //   height: 45,
          //   child: SimpleAutoCompleteTextField(
          //     style: TextStyle(
          //       fontSize: MediaQuery.of(context).textScaleFactor*14,
          //     ),
          //     // focusNode: nameNode,
          //     controller: appbarCustomerController,
          //     decoration: new InputDecoration(
          //       border: OutlineInputBorder(),
          //       disabledBorder: OutlineInputBorder(
          //       ),
          //       enabledBorder: OutlineInputBorder(),
          //     ),
          //     suggestions: customerList,
          //     clearOnSubmit: false,
          //     textSubmitted: (text) {
          //       // print(customerList);
          //       if(customerList.contains(text)) {
          //         setState(() {
          //           selectedCustomer=appbarCustomerController.text=text;
          //           print(appbarCustomerController.text.toString().trim());
          //           customerUserMobile= allCustomerMobile[customerList.indexOf(appbarCustomerController.text.toString().trim())];
          //           print('cm:$customerUserMobile');
          //         });
          //       }
          //       else
          //       {
          //         print('nothingggg');
          //       }
          //     },
          //   ),
          // ),

          SizedBox(
            width:MediaQuery.of(context).size.width/2,
            height: 45,
            child: SimpleAutoCompleteTextField(
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*14,
              ),
              // focusNode: nameNode,
              controller: appbarCustomerController2,
              decoration: new InputDecoration(
                border: OutlineInputBorder(),
                disabledBorder: OutlineInputBorder(
                ),
                enabledBorder: OutlineInputBorder(),
              ),
              suggestions: allCustomerMobile,
              clearOnSubmit: false,
              textSubmitted: (text) {
                // print(customerList);
                if(allCustomerMobile.contains(text)) {
                  setState(() {
                    customerUserMobile=appbarCustomerController2.text=text;
                    print(appbarCustomerController.text.toString().trim());
                    selectedCustomer= customerList[allCustomerMobile.indexOf(appbarCustomerController2.text.toString().trim())];
                    print('cm:$customerUserMobile');
                  });
                }
                else
                {
                  print('nothingggg');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}