import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'dart:async';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/screen/add_customer.dart';
import 'package:restaurant_app/screen/add_product.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:restaurant_app/screen/menu_screen.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
import 'package:restaurant_app/screen/receipt_payment_screen.dart';
import 'package:restaurant_app/screen/receivable_payable.dart';
import 'package:restaurant_app/screen/sequence_manager.dart';
import 'package:restaurant_app/screen/splash_screen.dart';
import 'package:restaurant_app/screen/stream_reports.dart';
import 'package:restaurant_app/screen/warehouse_report.dart';
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
import 'package:get/get.dart';
// import 'package:flutter_sunmi_printer_t2/flutter_sunmi_printer_t2.dart';
import 'package:restaurant_app/components/database_con.dart';
List<TextEditingController> cartController=[];String taxCum = "";String customerName="";
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
String currentOrder='';
int badgeContent=0;
TextEditingController quantityController=TextEditingController();
TextEditingController nameController=TextEditingController();
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
List<bool> selected = List<bool>();
List<String> _orderDetailsList=[];
String _selectedItem='';
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
      tempRate=double.parse(qty)*tempRate;
      cartController.add(TextEditingController());
      cartQtyController.add(TextEditingController());
      tempText='$name:$uom:$tempRate:$qty';
      setState(() {
        salesTotalList.add(tempRate);
        cartController[0].text=tempRate.toStringAsFixed(decimals);
        cartQtyController[0].text=qty;
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
            tempRate=double.parse(qty)*tempRate;
            tempText='$name:$uom:$tempRate:$qty';
            setState(() {
              salesTotalList[i] = tempRate;
              cartController[i].text = tempRate.toString();
              cartQtyController[i].text = qty;
              cartListText[i] = tempText.trim();
            });
            return;
          }
        }
      }
      setState(() {
        double tempRate=double.parse(price);
        tempRate=double.parse(qty)*tempRate;
        tempText='$name:$uom:$tempRate:$qty';
        cartController.add(TextEditingController(text: tempRate.toString()));
        cartQtyController.add(TextEditingController(text: qty));
        salesTotalList.add(tempRate);
        salesUomList.add(uom);
        cartListText.add(tempText.trim());
      });
    }
  }
  void addFromSearch(String name,String quantityValue){
    String tempText='';
    if(cartListText.isEmpty){
      String uom=getBaseUom(name);
      String tempr=getPrice(name,getBaseUom(name));
      double tempRate=double.parse(tempr);
      cartController.add(TextEditingController());
      cartQtyController.add(TextEditingController());
      tempRate=double.parse(quantityValue)*tempRate;
      tempText='$name:$uom:$tempRate: $quantityValue';
      setState(() {
        salesTotalList.add(tempRate);
        cartController[0].text=tempRate.toString();
        cartQtyController[0].text=quantityValue;
        salesUomList.add(getBaseUom(name));
        cartListText.add(tempText.trim());
      });
      _selectedItem='';
    }
    else {
      for (int i = 0; i < cartListText.length; i++) {
        if (cartListText[i].contains(
            name)) {
          List tempList = cartListText[i].split(
              ':');
          if (tempList[1].toString().trim() ==
              getBaseUom(name).toString().trim()) {
            String tempr = getPrice(tempList[0], tempList[1]);
            double tempRate = double.parse(tempr);
            int qty = int.parse(tempList[3]) + int.parse(quantityValue);
            tempRate = qty * tempRate;
            tempList[2] = tempRate.toString();
            tempList[3] = qty.toString();
            tempText = tempList.toString();
            tempText =  tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
            tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
            setState(() {
              salesTotalList[i] = tempRate;
              cartController[i].text = tempRate.toString();
              cartQtyController[i].text = qty.toString();
              cartListText[i] = tempText.trim();
            });
            _selectedItem='';
            return;
          }
        }
      }
      setState(() {
        String uom=getBaseUom(name);
        String tempr=getPrice(name,getBaseUom(name));
        double tempRate=double.parse(tempr);
        tempRate=double.parse(quantityValue)*tempRate;
        tempText='$name:$uom:$tempRate: $quantityValue';
        cartController.add(TextEditingController(text: tempRate.toString()));
        cartQtyController.add(TextEditingController(text:quantityValue));
        salesTotalList.add(tempRate);
        salesUomList.add(getBaseUom(name));
        cartListText.add(tempText.trim());
      });
      _selectedItem='';
    }

  }
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
        List tempPrice=temp[4].split('``');
        List tempUomSplit=tempPrice[0].toString().split('*');
        List tempPriceSplit=tempPrice[1].toString().split('*');
        print('split');
        for(int j=0;j<tempUomSplit.length;j++) {
          print(tempUomSplit[j]);
          print(tempPriceSplit[j]);
          if(tempUomSplit[j].contains(uomName.trim())) {
            print('inside if');
            String basePrice;
            if(tempPriceSplit[j].toString().trimLeft().contains('>')){
              List tempPriceListSplit=tempPriceSplit[j].toString().split('>');
              print(tempPriceListSplit);
              int pos=int.parse(selectedPriceList.substring(6));
              pos=pos-1;
              basePrice=tempPriceListSplit[pos];
            }
            else
              basePrice=tempPriceSplit[j].toString().trimLeft();
            return basePrice;
            // print(tempPriceSplit[j]);
            // return tempPriceSplit[j].toString().trimLeft();
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
  String getBaseUom(String productName){
    for(int i=0;i<productFirstSplit.length;i++){
      if(productFirstSplit[i].contains(productName)){
        List temp=productFirstSplit[i].split(':');
        List tempUom=temp[4].split('``');
        List tempUomSplit=tempUom[0].toString().split('*');
        print('base uom ${tempUomSplit[0].toString().trim()}');
        return tempUomSplit[0].toString().trim();
      }
    }

  }
  // ignore: missing_return
  List<String> getUom(String productName){
    for(int i=0;i<productFirstSplit.length;i++){
      if(productFirstSplit[i].contains(productName)){
        List temp=productFirstSplit[i].split(':');
        List tempUom=temp[4].split('``');
        List tempUomSplit=tempUom[0].toString().split('*');
        tempUomSplit.removeLast();
        print('tempUomSplit $tempUomSplit');
        return tempUomSplit;
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
  Future checkOut(String currentOrderNo,bool checkoutPrint,int pMode,String dPaymentS,String dTotalS) async {
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
      String body = '$userSalesPrefix$invNo~${dateNow()}~$selectedCustomer~$dPaymentS~$selectedDelivery~$dTotalS~Sales~$currentUser~$currentOrderNo~$createdBy~$balance~~$tempDiscount';
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
        // sunmiT1Print('$invNo');
      }
      else if(currentPrinter=='V2PRO'){
        //sunmiV2Print('$invNo');
      }
      create(body, 'invoice_data', yourItemsList);
      updateInv('sales',invNo+1);
      create(selectedCustomer, 'customer_report', yourItemsList1);
      if(selectedPayment=='Credit'){
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
              String stockDetails=await readStock(tempBomItem[i]);
              List itemStockDetailsSplit=stockDetails.split('~');
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
          String stockDetails=await readStock(itemName);
          List itemStockDetailsSplit=stockDetails.split('~');
          String stockQuantity=itemStockDetailsSplit[1].toString().trim();
          String costPrice=itemStockDetailsSplit[2].toString().trim();
          String stockValue=itemStockDetailsSplit[3].toString().trim();
          double newStockQuantity=double.parse(stockQuantity)-double.parse(itemQty);
          double newSockValue=newStockQuantity*double.parse(costPrice);
          String stockBody='$itemName~${newStockQuantity.toString()}~$costPrice~${newSockValue.toStringAsFixed(3)}';

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
    //ipAddress1="192.168.5.80";

    /*final profile1 = await CapabilityProfile.load();
  final generator1 = Generator(PaperSize.mm80, profile1);
  final ByteData data1 = await rootBundle.load('images/logo.png');
  final Uint8List bytes = data1.buffer.asUint8List();
  final eos.Image image9 = eos.decodeImage(bytes);*/

    print('inside network ip ${appbarCustomerController.text}');
    // PaperSize paperNetwork = PaperSize.mm80;
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()),
                    (Route<dynamic> route) => false,
              );
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
    read('customer_details');
    selectedCategory='All';
    lastSelectedCategory='All';
    paymentMode=mainPaymentList;
    // getKotOrders(currentUser);
    // getData('sequence_manager');
    // getData('customer_data');
    // getData('uom_data');
    // getData('kot_data');
    // getData('printer_data');
    // getOrganisationData();
    print('screen $selectedScreen');

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
            ),Padding(
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
            print('selectedDelivery $selectedDelivery');
          },
        ),
      );
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body:Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 0.75)
                        )
                      ],
                      color:kGreenColor
                  ),
                  height: MediaQuery.of(context).size.height/12,
                  width: MediaQuery.of(context).size.width,
                  child:Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children:[
                    Visibility(
                      visible: selectedBusiness=='Restaurant'?true:false,
                      child: Visibility(
                        visible: selectedDelivery=='Spot'?true:false,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                              elevation: MaterialStateProperty.all(3.0),
                              backgroundColor: MaterialStateProperty.all(kGreenColor),
                            ),
                            onPressed: (){
                              print('inside if false');
                              tableMergeSelect.value=RxList<String>([]);
                              isMerge.value=false;
                              mergeCount.value=0;
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return  buildDialog();
                                  }
                              );
                              tableClicked.value=false;
                            },
                            child: Obx(()=>Text(tableSelected.value.contains('~')?getFirstTable(tableSelected.value):tableSelected.value,style: TextStyle(
                              color: kFont1Color,
                            ),
                            ),)
                          ),
                        ),
                      ),
                      replacement: Row(
                        children: [
                          IconButton(
                              constraints: BoxConstraints(),
                              tooltip: 'Sales Report',
                              icon: SvgPicture.asset('images/salesReport.svg'), onPressed: (){
                            print('selectedCustomer $selectedCustomer');
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>StreamReports(transactionType: "invoice_data",)));
                          }),
                          IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceivablePayable(type: 'RECEIVABLE')));
                              }, icon: Icon(Icons.account_circle_rounded,color: kItemContainer,)),
                          IconButton(
                              tooltip: 'Receipt/Payment',
                              icon: SvgPicture.asset('images/receipt2.svg'), onPressed: (){
                            print('selectedCustomer $selectedCustomer');
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptPayment(customer: selectedCustomer,)));
                          }),
                          IconButton(
                              tooltip: 'Warehouse Report',
                              icon: SvgPicture.asset('images/warehouse.svg'), onPressed: (){
                            print('selectedCustomer $selectedCustomer');
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>WarehouseReport()));
                          }),
                        ],
                      ),
                    ),
                    StreamBuilder(
                        stream: firebaseFirestore.collection('kot_order').where('user',isEqualTo: currentUser).snapshots(),
                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Badge(
                            position: BadgePosition(top: 1, end: 1),
                            badgeColor: kAppBarItems,
                            badgeContent:Text('${snapshot.data.docs.length}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            child: IconButton(
                                tooltip: 'Order List',
                                // icon: Icon(Icons.add_circle_outline),
                                icon: SvgPicture.asset('images/order.svg'),
                                onPressed: ()  async {
                                  showDialog(context: context, builder: (context){
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return Dialog(
                                      child: Container(
                                        padding: EdgeInsets.all(6.0),
                                        child: Stack(
                                          children: [
                                            GridView.builder(
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 1,

                                                ),
                                                scrollDirection: Axis.vertical,
                                                itemCount: snapshot.data.docs.length,
                                                itemBuilder: (context, index2) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: GestureDetector(
                                                      onLongPress: ()async{
                                                        if(selectedBusiness=='Restaurant'){
                                                          DocumentSnapshot orderData=await firebaseFirestore.collection('kot_order').doc(snapshot.data.docs[index2].get('orderNo')).getSavy();
                                                          List items=orderData['cartList'];
                                                          for(int i=0;i<items.length;i++)
                                                          {
                                                            kotList.add('${orderData['cartList'][i]['name']}:${orderData['cartList'][i]['qty']}:');
                                                          }
                                                          formatKotList(orderData['orderNo'], orderData['tableNo']);
                                                          Navigator.pop(context);
                                                        }
                                                      },
                                                      onTap: ()async{
                                                        DocumentSnapshot orderData=await firebaseFirestore.collection('kot_order').doc(snapshot.data.docs[index2].get('orderNo')).getSavy();
                                                        List items=orderData['cartList'];
                                                        selectedCustomer=orderData['customer'];
                                                        selectedPriceList=orderData['priceList'];
                                                        isSelected=[false,false,false];
                                                        if(selectedBusiness=='Restaurant'){
                                                          tableSelected.value=orderData.get('tableNo').contains(',')?orderData.get('tableNo').toString().replaceAll(',', '~'):orderData.get('tableNo');
                                                          selectedDelivery=orderData.get('type');
                                                          int pos=deliveryMode.indexOf(selectedDelivery);
                                                          isSelected[pos]=true;
                                                        }
                                                        setState(() {
                                                          salesTotalList=[];
                                                          salesUomList=[];
                                                          cartController=[];
                                                          cartQtyController=[];
                                                          cartListText=[];
                                                          currentOrder=orderData['orderNo'];
                                                          currentKotDate=orderData['date'];
                                                          currentKotNote=orderData['note'];
                                                          tableSelected.value=orderData['tableNo'];
                                                        });
                                                        currentKotOldList11=orderData['cartList'];
                                                        currentKotOldList=[];
                                                        for(int i=0;i<items.length;i++)
                                                        {
                                                          currentKotOldList.add('${orderData['cartList'][i]['name']}:${orderData['cartList'][i]['uom']}:${orderData['cartList'][i]['price']}:${orderData['cartList'][i]['qty']}');
                                                            salesTotalList.add(double.parse(orderData['cartList'][i]['price']));
                                                            salesUomList.add(orderData['cartList'][i]['uom']);
                                                            cartController.add(TextEditingController(text: orderData['cartList'][i]['price']));
                                                            cartQtyController.add(TextEditingController(text: orderData['cartList'][i]['qty']));
                                                          if(orderData['cartList'][i]['modifier'].length>0){
                                                            modifierKotList.add('${orderData['cartList'][i]['name']};${orderData['cartList'][i]['modifier']}');
                                                            cartListText.add('${orderData['cartList'][i]['name']}:${orderData['cartList'][i]['uom']}:${orderData['cartList'][i]['price']}:${orderData['cartList'][i]['qty']}:${orderData['cartList'][i]['modifier']}');
                                                          }
                                                          else{
                                                            cartListText.add('${orderData['cartList'][i]['name']}:${orderData['cartList'][i]['uom']}:${orderData['cartList'][i]['price']}:${orderData['cartList'][i]['qty']}');
                                                          }
                                                        }
                                                        Navigator.pop(context);
                                                        // Navigator.pushReplacement(
                                                        //   context,
                                                        //   MaterialPageRoute(builder: (context) => WaiterScreen()),
                                                        // );
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.all(4.0),
                                                            decoration:  BoxDecoration(
                                                              color:kGreenColor,
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
                                                            ),
                                                            child: selectedBusiness=='Restaurant'?Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(snapshot.data.docs[index2].get('orderNo'),style: TextStyle(
                                                                        //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                                        fontWeight: FontWeight.bold,
                                                                        color:  Colors.white,
                                                                      ),),
                                                                      SizedBox(width: 10,),
                                                                      snapshot.data.docs[index2].get('type').toString()=='Spot'?Text('Dine In',style: TextStyle(
                                                                        // fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                                        fontWeight: FontWeight.bold,
                                                                        color:  Colors.white,
                                                                      )):Text(snapshot.data.docs[index2].get('type'),style: TextStyle(
                                                                        // fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                                        fontWeight: FontWeight.bold,
                                                                        color:  Colors.white,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                snapshot.data.docs[index2].get('type').toString()=='Spot'? Text(snapshot.data.docs[index2].get('tableNo').contains(',')?'''${getFirstTable(snapshot.data.docs[index2].get('tableNo').toString().replaceAll(',', '~'))}..''':snapshot.data.docs[index2].get('tableNo'),
                                                                  overflow: TextOverflow.ellipsis
                                                                  ,style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    color:  Colors.white,
                                                                  ),):Text(''),
                                                              ],
                                                            ):
                                                            Text(snapshot.data.docs[index2].get('orderNo'),style: TextStyle(
                                                              //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                              fontWeight: FontWeight.bold,
                                                              color:  Colors.white,
                                                            ),),),
                                                          Expanded(
                                                            child: Container(
                                                                width: double.maxFinite,
                                                                decoration:  BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.zero),
                                                                    border: Border.all(color: kGreenColor)
                                                                ),
                                                                //padding: EdgeInsets.only(left: 3.0,right: 3.0),
                                                                child: ListView.builder(
                                                                    scrollDirection: Axis.vertical,
                                                                    itemCount:snapshot.data.docs[index2]['cartList'].length ,
                                                                    itemBuilder: (context,index3){
                                                                      return Padding(
                                                                        padding: const EdgeInsets.only(top: 2.0,left: 2.0),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                Text('${snapshot.data.docs[index2]['cartList'][index3]['qty']}x'),
                                                                                Text(snapshot.data.docs[index2]['cartList'][index3]['uom'].toString()),
                                                                              ],
                                                                            ),
                                                                            Flexible(child: Text(snapshot.data.docs[index2]['cartList'][index3]['name'].toString(),maxLines: 2,)),
                                                                            selectedBusiness=='Restaurant'?Icon(Icons.circle,
                                                                              color: snapshot.data.docs[index2]['cartList'][index3]['ready']==true?kKitchenGreenColor:kAppBarItems,
                                                                            ):Text(snapshot.data.docs[index2]['cartList'][index3]['price']),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    })
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.bottomRight,
                                                child: TextButton(onPressed: () => Navigator.pop(context),
                                                    child: Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      color: kLightBlueColor,
                                                      child: Text('CLOSE',style: TextStyle(
                                                        letterSpacing: 1.5,
                                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                        color: kWhiteColor,
                                                      ),),
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                }
                            ),
                          );
                        }),
                    if(selectedBusiness!='Restaurant')
                      SizedBox(width: 20,),
                    if(selectedBusiness!='Restaurant')
                      SizedBox(
                        height:30,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                            elevation: MaterialStateProperty.all(3.0),
                            backgroundColor: MaterialStateProperty.all(kGreenColor),
                          ),
                          onPressed: ()  async {
                            print('clickeddddddddddddd');
                            setState(() {
                              tillCloseFlag=true;
                            });
                            cashWithdrawnController.text='0';
                            from:
                            double opening=0;
                            List<double> salesAmount=[];
                            double cashSales=0;
                            double cardSales=0;
                            double cashPurchase=0;
                            double cashSalesReturn=0;
                            double cashPurchaseReturn=0;
                            double expense=0;
                            double cashAvailable=0;
                            double creditSales=0;
                            double upiSales=0;
                            double eftSales=0;
                            double receiptAmt=0;
                            double paymentAmt=0;
                            QuerySnapshot doc1;
                            QuerySnapshot doc2;
                            QuerySnapshot doc3;
                            QuerySnapshot doc4;
                            QuerySnapshot doc5;
                            QuerySnapshot doc6;
                            QuerySnapshot doc7;
                            QuerySnapshot doc8;
                            QuerySnapshot doc9;
                            QuerySnapshot doc10;
                            doc1 = await firebaseFirestore
                                .collection('user_data')
                                .where(
                                'userName', isEqualTo: currentUser)
                                .get();
                            doc2 = await firebaseFirestore
                                .collection('invoice_data').where(
                                'user', isEqualTo: currentUser).where('date',
                                isGreaterThanOrEqualTo: tillCloseTime).orderBy('date',descending: true)
                                .get();
                            // doc4 = await firebaseFirestore
                            //     .collection('invoice_data').where(
                            //     'user', isEqualTo: currentUser).where(
                            //     'payment',isEqualTo : 'Credit')
                            //     .where('date',
                            //     isGreaterThanOrEqualTo: tillCloseTime).orderBy('date',descending: true)
                            //     .get();
                            // doc5 = await firebaseFirestore
                            //     .collection('invoice_data').where(
                            //     'user', isEqualTo: currentUser).where(
                            //     'payment', isEqualTo: 'UPI')
                            //     .where('date',
                            //     isGreaterThanOrEqualTo: tillCloseTime).orderBy('date',descending: true)
                            //     .get();
                            doc3 = await firebaseFirestore
                                .collection('expense_transaction')
                                .where('user', isEqualTo: currentUser)
                                .where('date',
                                isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash').orderBy('date',descending: true)
                                .get();
                            doc6 = await firebaseFirestore
                                .collection('receipt_data').where('user', isEqualTo: currentUser).where('date',
                                isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash').orderBy('date',descending: true)
                                .get();
                            doc7 = await firebaseFirestore
                                .collection('payment_data')
                                .where('user', isEqualTo: currentUser)
                                .where('date',
                                isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash').orderBy('date',descending: true)
                                .get();
                            doc8= await firebaseFirestore
                                .collection('purchase')
                                .where('user', isEqualTo: currentUser)
                                .where('date',
                                isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash').orderBy('date',descending: true)
                                .get();
                            doc9= await firebaseFirestore
                                .collection('sales_return')
                                .where('user', isEqualTo: currentUser)
                                .where('date',
                                isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash').orderBy('date',descending: true)
                                .get();
                            doc10= await firebaseFirestore
                                .collection('purchase_return')
                                .where('user', isEqualTo: currentUser)
                                .where('date',
                                isGreaterThanOrEqualTo: tillCloseTime).where('payment',isEqualTo:'Cash').orderBy('date',descending: true)
                                .get();
                            opening= double.parse(doc1.docs[0].get('tillClose').toString());
                            for(int k=0;k<paymentMode.length;k++){
                              salesAmount.add(0.0);
                            }
                            for(int i=0;i<doc2.size;i++){
                              if(doc2.docs[i]['total'].contains('*')){
                                List tempDPayment=doc2.docs[i]['payment'].split('*');
                                List tempDTotal=doc2.docs[i]['total'].split('*');
                                for(int k=0;k<paymentMode.length;k++){
                                  if(tempDPayment.contains(paymentMode[k])){
                                    int pos=tempDPayment.indexOf(paymentMode[k]);
                                    salesAmount[k]+=double.parse(tempDTotal[pos].toString().trim());
                                  }
                                }
                                //   if(tempDPayment.contains('Cash')){
                                //     int pos=tempDPayment.indexOf('Cash');
                                //     cashSales+=double.parse(tempDTotal[pos].toString().trim());
                                //   }
                                // if(tempDPayment.contains('Credit')){
                                //     int pos=tempDPayment.indexOf('Credit');
                                //     creditSales+=double.parse(tempDTotal[pos].toString().trim());
                                //   }
                                //   if(tempDPayment.contains('Card')){
                                //     int pos=tempDPayment.indexOf('Card');
                                //     cardSales+=double.parse(tempDTotal[pos].toString().trim());
                                //   }
                                //    if(tempDPayment.contains('UPI')){
                                //     int pos=tempDPayment.indexOf('UPI');
                                //     upiSales+=double.parse(tempDTotal[pos].toString().trim());
                                //   }
                                //   if(tempDPayment.contains('EFT')){
                                //     int pos=tempDPayment.indexOf('EFT');
                                //     eftSales+=double.parse(tempDTotal[pos].toString().trim());
                                //   }
                              }
                              else{
                                for(int k=0;k<paymentMode.length;k++){
                                  if(doc2.docs[i]['payment']==paymentMode[k]){
                                    salesAmount[k]+=double.parse(doc2.docs[i].get('total'));
                                    break;
                                  }
                                }
                                //  if(doc2.docs[i]['payment']=='Cash')
                                //    cashSales+=double.parse(doc2.docs[i].get('total'));
                                // else if(doc2.docs[i]['payment']=='Credit')
                                //    creditSales+=double.parse(doc2.docs[i].get('total'));
                                //  else if(doc2.docs[i]['payment']=='Card')
                                //    cardSales+=double.parse(doc2.docs[i].get('total'));
                                // else if(doc2.docs[i]['payment']=='UPI')
                                //    upiSales+=double.parse(doc2.docs[i].get('total'));
                                //  else if(doc2.docs[i]['payment']=='EFT')
                                //    eftSales+=double.parse(doc2.docs[i].get('total'));
                              }
                            }
                            // for(int i=0;i<doc4.size;i++){
                            //   creditSales+=double.parse(doc4.docs[i].get('total'));
                            // }
                            // for(int i=0;i<doc5.size;i++){
                            //   upiSales+=double.parse(doc5.docs[i].get('total'));
                            // }
                            for(int i=0;i<doc3.size;i++){
                              expense+=double.parse(doc3.docs[i].get('total'));
                            }
                            for(int i=0;i<doc6.size;i++){
                              receiptAmt+=double.parse(doc6.docs[i].get('total'));
                            }
                            for(int i=0;i<doc7.size;i++){
                              paymentAmt+=double.parse(doc7.docs[i].get('total'));
                            }
                            for(int i=0;i<doc8.size;i++){
                              cashPurchase+=double.parse(doc8.docs[i].get('total'));
                            }
                            for(int i=0;i<doc9.size;i++){
                              cashSalesReturn+=double.parse(doc9.docs[i].get('total'));
                            }
                            for(int i=0;i<doc10.size;i++){
                              cashPurchaseReturn+=double.parse(doc10.docs[i].get('total'));
                            }
                            double getCashAvailable(double open,double cash,double exp){
                              cashAvailable=(open+cash+receiptAmt+cashPurchaseReturn)-(exp+paymentAmt+cashPurchase+cashSalesReturn);
                              return cashAvailable;
                            }

                            TextEditingController openingCashController=TextEditingController();

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  openingCashController.text=opening.toStringAsFixed(decimals);
                                  return MaterialApp(
                                    // scrollBehavior: MaterialScrollBehavior().copyWith(
                                    //   dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
                                    // ),
                                    builder:(context,widget)=>Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                      child: Container(
                                        padding: EdgeInsets.all(6.0),
                                        width: MediaQuery.of(context).size.width/3,
                                        //height: MediaQuery.of(context).size.height/2,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // scrollDirection: Axis.vertical,
                                            // shrinkWrap: true,
                                            children: [
                                              Center(
                                                child: Text(
                                                  'Till details',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Opening cash',
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Expanded(
                                                        flex:3,
                                                        child: TextField(
                                                          controller: openingCashController,
                                                          onChanged: (value) {
                                                          },
                                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                          maxLines: 1,
                                                          decoration:InputDecoration(
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
                                                            // labelText: 'Enter the amount',
                                                            labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: RawMaterialButton(
                                                            fillColor: kLightBlueColor,
                                                            child: Text('Save',  style: TextStyle(
                                                              color: kItemContainer,
                                                              fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                            ),),
                                                            onPressed: (){
                                                              firebaseFirestore.collection('user_data').doc(currentUser).update(
                                                                  {
                                                                    "tillClose":double.parse(openingCashController.text),
                                                                  }
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      'Sales',
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                      ),
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection: Axis.vertical,
                                                      itemCount:paymentMode.length,
                                                      itemBuilder: (BuildContext context,index){
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(paymentMode[index],
                                                              style: TextStyle(
                                                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                              ),
                                                            ),
                                                            Text(salesAmount[index].toStringAsFixed(decimals) ,
                                                              style: TextStyle(
                                                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                              ),),
                                                          ],);
                                                      })
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //   children: [
                                                  //     Text(
                                                  //       'Cash ',
                                                  //       style: TextStyle(
                                                  //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  //       ),
                                                  //     ),
                                                  //     Text(cashSales.toStringAsFixed(decimals) ,
                                                  //       style: TextStyle(
                                                  //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  //       ),),
                                                  //   ],),
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //   children: [
                                                  //     Text(
                                                  //       'Credit',
                                                  //       style: TextStyle(
                                                  //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  //       ),
                                                  //     ),
                                                  //     Text(creditSales.toStringAsFixed(decimals) ,
                                                  //       style: TextStyle(
                                                  //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  //       ),),
                                                  //   ],
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //   children: [
                                                  //     Text(
                                                  //       'Card',
                                                  //       style: TextStyle(
                                                  //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  //       ),
                                                  //     ),
                                                  //     Text(cardSales.toStringAsFixed(decimals) ,
                                                  //       style: TextStyle(
                                                  //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  //       ),),
                                                  //   ],
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //   children: [
                                                  //     Text(
                                                  //       'UPI',
                                                  //       style: TextStyle(
                                                  //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  //       ),
                                                  //     ),
                                                  //     Text(upiSales.toStringAsFixed(decimals),
                                                  //       style: TextStyle(
                                                  //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  //       ),),
                                                  //   ],
                                                  // ),
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //   children: [
                                                  //     Text(
                                                  //       'EFT',
                                                  //       style: TextStyle(
                                                  //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  //       ),
                                                  //     ),
                                                  //     Text(eftSales.toStringAsFixed(decimals),
                                                  //       style: TextStyle(
                                                  //         fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                  //       ),),
                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                              SizedBox(height: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      'Sales Return',
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Cash ',
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                        ),
                                                      ),
                                                      Text(cashSalesReturn.toStringAsFixed(decimals),
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                        ),),
                                                    ],),
                                                ],
                                              ),
                                              SizedBox(height: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      'Purchase',
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Cash',
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                        ),
                                                      ),
                                                      Text(cashPurchase.toStringAsFixed(decimals),
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                        ),),
                                                    ],),
                                                ],
                                              ),
                                              SizedBox(height: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      'Purchase Return',
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Cash',
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                        ),
                                                      ),
                                                      Text(cashPurchaseReturn.toStringAsFixed(decimals) ,
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                        ),),
                                                    ],),
                                                ],
                                              ),
                                              SizedBox(height: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Total Receipts',
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                    ),
                                                  ),
                                                  Text(receiptAmt.toStringAsFixed(decimals),
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                    ),),
                                                ],
                                              ),
                                              SizedBox(height: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Total Payments',
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                    ),
                                                  ),
                                                  Text(paymentAmt.toStringAsFixed(decimals),
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                    ),),
                                                ],
                                              ),
                                              SizedBox(height: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Expense',
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                    ),
                                                  ),
                                                  Text(expense.toStringAsFixed(decimals),
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                    ),),
                                                ],
                                              ),
                                              SizedBox(height: 20.0,),
                                              Text(
                                                'Cash available',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),
                                              ),
                                              Text(
                                                getCashAvailable(opening, salesAmount[0], expense)==null?0:getCashAvailable(opening, salesAmount[0], expense).toStringAsFixed(decimals),
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),
                                              ),
                                              SizedBox(height: 20.0,),
                                              Text(
                                                'Cash withdrawn',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),
                                              ),
                                              TextField(
                                                controller: cashWithdrawnController,
                                                onChanged: (value) {
                                                },
                                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                maxLines: 1,
                                                decoration:InputDecoration(
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
                                                  labelText: 'Enter the amount',
                                                  labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                ),
                                              ),
                                              Center(
                                                child: RawMaterialButton(
                                                  onPressed: () {
                                                    firebaseFirestore.collection('user_data').doc(currentUser).update({
                                                      "orderFrom":1
                                                    });
                                                    print('tillCloseFlag $tillCloseFlag');
                                                    if(tillCloseFlag=true){
                                                      setState(() {
                                                        tillCloseFlag=false;
                                                      });
                                                      int tempDate=DateTime.now().millisecondsSinceEpoch;
                                                      double tempCash=cashAvailable-double.parse(cashWithdrawnController.text);
                                                      cashSales=salesAmount[0];
                                                      upiSales=salesAmount[3];
                                                      creditSales=salesAmount[2];
                                                      String body='${openingCashController.text}~$cashSales~$creditSales~$upiSales~$expense~$cashAvailable~${cashWithdrawnController.text}~$currentUser~$tempDate~$tempCash~$cardSales~$eftSales';
                                                      create(body, 'till_close', []);
                                                      firebaseFirestore.collection('user_data').doc(currentUser).update({
                                                        "tillClose":tempCash,
                                                        "tillCloseDate":tempDate
                                                      });
                                                      tillCloseTime=tempDate;
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  fillColor: kHighlight,
                                                  //splashColor: Colors.greenAccent,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text("Till Close",
                                                      maxLines: 1,
                                                      style: TextStyle(color: Colors.white,
                                                        //letterSpacing: 1.0,
                                                        fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                      ),
                                                    ),
                                                  ),
                                                  shape: const StadiumBorder(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ) ,
                                  );
                                });
                          },
                          child: Text('Till Close',style: TextStyle(
                            color: kFont1Color,
                            //fontWeight: FontWeight.bold,
                            //  letterSpacing: 1.0,
                            // fontSize: MediaQuery.of(context).textScaleFactor*16,
                          ),
                          ),
                        ),
                      ),
                  ]),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (value)  async {
                      if(value==1){
                        if(lastSelectedCategory=='All'){
                          await displayAllProducts('Salable');
                          setState(() {

                          });
                        }
                      else{
                          displayProducts(lastSelectedCategory);
                      }
                      }
                    },
                    children: [
                      Container(
                        child:  Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: selectedBusiness=='Restaurant'?true:false,
                                  child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: buildDelivery(context)),
                                  replacement: Padding(
                                    padding: const EdgeInsets.only(left: 2,right: 2),
                                    child: CustomerSelect(),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  padding: EdgeInsets.only(left: 5,right: 5),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          // child: SimpleAutoCompleteTextField(
                                          //   style: TextStyle(
                                          //     fontSize: MediaQuery.of(context).textScaleFactor*14,
                                          //   ),
                                          //   focusNode: nameNode,
                                          //   decoration: new InputDecoration(
                                          //       border: OutlineInputBorder(),
                                          //       disabledBorder: OutlineInputBorder(
                                          //       ),
                                          //       enabledBorder: OutlineInputBorder(),
                                          //       hintText: 'search for items'
                                          //   ),
                                          //   controller: nameController,
                                          //   suggestions: allSalableProducts,
                                          //   clearOnSubmit: false,
                                          //   textSubmitted: (text) {
                                          //     _selectedItem=text;
                                          //     if(allSalableProducts.contains(_selectedItem)) {
                                          //       setState(() {
                                          //         nameController.text=_selectedItem;
                                          //       });
                                          //       print('inside all products $_selectedItem');
                                          //       quantityNode.requestFocus();
                                          //     }
                                          //     else
                                          //     {
                                          //       print('inside else');
                                          //       barcodeEntry(_selectedItem);
                                          //       nameController.clear();
                                          //       nameNode.requestFocus();
                                          //     }
                                          //   },
                                          // ),
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
                                                hintText: 'search for items'
                                            ),
                                            onChanged: searchOperation,
                                            onSubmitted: (text){
                                              barcodeEntry(text);
                                              nameController.clear();
                                              nameNode.requestFocus();
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: 60.0,
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

                              ],
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  SingleChildScrollView(
                                    controller:_scrollController,
                                    scrollDirection: Axis.vertical,
                                    child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: dataTable()),
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
                                              searchResult.clear();
                                              quantityNode.requestFocus();
                                            },
                                            child: new ListTile(
                                              title: new Text(searchResult[index].toString()),
                                            ),
                                          );
                                        },
                                      ))
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.all(8.0),
                                alignment: Alignment.bottomCenter,
                                child:Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        ),),
                                        Text(getTotal(salesTotalList).toStringAsFixed(decimals), style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        ),),
                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                              elevation: MaterialStateProperty.all(3.0),
                                              backgroundColor: MaterialStateProperty.all(kGreenColor),
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                currentOrder='';
                                                cartListText=[];
                                                cartController=[];
                                                cartQtyController=[];
                                                salesUomList=[];
                                                salesTotalList=[];
                                                tableSelected.value='TABLE';
                                                // print(salesOrderNoList);
                                              });
                                            },
                                            child: Text('New Order',
                                              style: TextStyle(
                                                color: kFont1Color,
                                              ),
                                            )),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                              elevation: MaterialStateProperty.all(3.0),
                                              backgroundColor: MaterialStateProperty.all(kGreenColor),
                                            ),
                                            onPressed: () async {
                                              if(cartListText.isEmpty){
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add Items')));
                                                return;
                                              }
                                              else if(selectedBusiness!='Restaurant'){
                                                await kotAssign(cartListText,currentOrder);
                                              }
                                              else  if(selectedDelivery=='Spot' && tableSelected=='TABLE'){
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Table not selected')));
                                                return;
                                              }
                                              else{
                                                await kotAssign(cartListText,currentOrder);
                                                print('kot order $currentOrder');
                                                print('kot selectedDelivery $selectedDelivery');
                                                if(selectedDelivery=='Spot'){
                                                   addTable(tableSelected.value,currentTableOrders.value,currentOrder);
                                                }
                                              }
                                              setState(() {
                                                currentOrder='';
                                                cartListText=[];
                                                cartController=[];
                                                cartQtyController=[];
                                                salesUomList=[];
                                                salesTotalList=[];
                                                tableSelected.value='TABLE';
                                                // print(salesOrderNoList);
                                              });
                                            },
                                            child: Text(selectedBusiness=='Restaurant'?'KOT':'SAVE',
                                              style: TextStyle(
                                                color: kFont1Color,
                                              ),
                                            )),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                              elevation: MaterialStateProperty.all(3.0),
                                              backgroundColor: MaterialStateProperty.all(kGreenColor),
                                            ),
                                            onPressed: ()async{
                                              if(orgWaiterIs=='true'){
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
                                                  builder: (ctx) =>
                                                      Center(
                                                        child: Container(
                                                          width:MediaQuery.of(context).size.width,
                                                          child: SingleChildScrollView(
                                                            scrollDirection: Axis.vertical,
                                                            child: Dialog(
                                                                backgroundColor: Colors.white,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12.0)),
                                                                child:Column(
                                                                  children: [
                                                                    Align(
                                                                      // These values are based on trial & error method
                                                                      alignment: Alignment.topRight,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color:kBackgroundColor,
                                                                              borderRadius: BorderRadius.circular(12),
                                                                            ),
                                                                            child: Icon(
                                                                              Icons.close,
                                                                              size: 20,
                                                                              color: kFont1Color,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right:10.0,left:10.0,bottom:10.0),
                                                                      child: Column(
                                                                        children: [
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children:[
                                                                                Text('Total', style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                                                ),),
                                                                                Text(salesTotal.toStringAsFixed(decimals), style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                                ),)
                                                                              ]
                                                                          ),
                                                                          SizedBox(height:10),
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children:[
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                        color: kAppBarItems,
                                                                                        style: BorderStyle.solid,
                                                                                        width: 2),
                                                                                  ),
                                                                                  child: DropdownButtonHideUnderline(
                                                                                    child: ButtonTheme(
                                                                                      alignedDropdown: true,
                                                                                      child: Obx(()=>DropdownButton(
                                                                                        dropdownColor:Colors.white,
                                                                                        isDense: true,
                                                                                        value: dualPaymentSelected1.value, // Not necessary for Option 1
                                                                                        items: paymentMode.map((String val) {
                                                                                          return DropdownMenuItem(
                                                                                            child: new Text(val.toString(),
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  letterSpacing: 1.5,
                                                                                                  fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                                                                  color: kHighlight
                                                                                              ),
                                                                                            ),
                                                                                            value: val,
                                                                                          );
                                                                                        }).toList(),
                                                                                        onChanged: (newValue) {
                                                                                          dualPaymentSelected1.value=newValue;
                                                                                          if(dualPaymentSelected1.value=='Cash')
                                                                                            showCashTendered.value=true;
                                                                                          else
                                                                                            showCashTendered.value=false;
                                                                                        },
                                                                                      )),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width:100,
                                                                                  child: TextField(
                                                                                    style: TextStyle(
                                                                                        fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                    controller: dualPayment3.value,
                                                                                    onEditingComplete: (){
                                                                                      if(double.parse(dualPayment3.value.text)<salesTotal){
                                                                                        showDualPayment.value=true;
                                                                                        double temp=salesTotal-double.parse(dualPayment3.value.text);
                                                                                        dualPayment2.value.text=temp.toString();
                                                                                      }
                                                                                      else{
                                                                                        showDualPayment.value=false;
                                                                                      }
                                                                                    },
                                                                                    decoration: new InputDecoration(
                                                                                      hintText: 'Amount',
                                                                                      border: OutlineInputBorder(),
                                                                                      disabledBorder: OutlineInputBorder(
                                                                                      ),
                                                                                      enabledBorder: OutlineInputBorder(),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ]
                                                                          ),
                                                                          SizedBox(height:10),
                                                                          Obx(()=>Visibility(
                                                                              visible:showCashTendered.value,
                                                                              child:Column(
                                                                                  children:[
                                                                                    Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children:[
                                                                                          Text('Cash Tendered', style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                                                          ),),
                                                                                          Container(
                                                                                            width:100,
                                                                                            child: TextField(
                                                                                              style: TextStyle(
                                                                                                fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                                              ),
                                                                                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                              controller: dualPayment1.value,
                                                                                              onEditingComplete: (){
                                                                                                refundAmt.value=double.parse(dualPayment1.value.text)-double.parse(dualPayment3.value.text);
                                                                                              },
                                                                                              decoration: new InputDecoration(
                                                                                                hintText: 'Amount',
                                                                                                border: OutlineInputBorder(),
                                                                                                disabledBorder: OutlineInputBorder(
                                                                                                ),
                                                                                                enabledBorder: OutlineInputBorder(),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ]
                                                                                    ),
                                                                                    SizedBox(height:10),
                                                                                    Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children:[
                                                                                          Text('Refund Amount', style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                                                          ),),
                                                                                          Obx(()=>Text(refundAmt.value.toStringAsFixed(decimals), style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                                          ),)),
                                                                                        ]
                                                                                    ),
                                                                                  ]
                                                                              )
                                                                          )),
                                                                          SizedBox(height:10),
                                                                          Obx(()=>Visibility(
                                                                            visible:showDualPayment.value,
                                                                            child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children:[
                                                                                  Container(
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
                                                                                          dropdownColor:Colors.white,
                                                                                          isDense: true,
                                                                                          value: dualPaymentSelected2.value, // Not necessary for Option 1
                                                                                          items: paymentMode.map((String val) {
                                                                                            return DropdownMenuItem(
                                                                                              child: new Text(val.toString(),
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    letterSpacing: 1.5,
                                                                                                    fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                                                                    color: kHighlight
                                                                                                ),
                                                                                              ),
                                                                                              value: val,
                                                                                            );
                                                                                          }).toList(),
                                                                                          onChanged: (newValue) {
                                                                                            dualPaymentSelected2.value=newValue;
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    width:100,
                                                                                    child: TextField(
                                                                                      style: TextStyle(
                                                                                        fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                                      ),
                                                                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                      controller: dualPayment2.value,
                                                                                      onEditingComplete: (){

                                                                                      },
                                                                                      decoration: new InputDecoration(
                                                                                        hintText: 'Amount',
                                                                                        border: OutlineInputBorder(),
                                                                                        disabledBorder: OutlineInputBorder(
                                                                                        ),
                                                                                        enabledBorder: OutlineInputBorder(),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ]
                                                                            ),
                                                                          ),),
                                                                          SizedBox(height:10),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                  side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                                                                  elevation: MaterialStateProperty.all(3.0),
                                                                                  backgroundColor: MaterialStateProperty.all(checkoutFlag==true?kGreenColor:kHighlight.withOpacity(0.4),),
                                                                                ),
                                                                                onPressed: ()async{
                                                                                  // printerManager.selectPrinter(selectedPrinter);
                                                                                  if(checkoutFlag==true){
                                                                                    if(!((double.parse(dualPayment3.value.text)+double.parse(dualPayment2.value.text))==double.parse(salesTotal.toStringAsFixed(decimals)))){
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => AlertDialog(
                                                                                            title: Text("Error"),
                                                                                            content: Text("Enter Total Amount"),
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
                                                                                    else if((dualPaymentSelected1.value==dualPaymentSelected2.value) && (double.parse(dualPayment2.value.text)>0)){
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => AlertDialog(
                                                                                            title: Text("Error"),
                                                                                            content: Text("Both Payment modes are same"),
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
                                                                                    else  if((dualPaymentSelected1.value=='Credit' || dualPaymentSelected2.value=='Credit') && selectedCustomer.isEmpty){
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => AlertDialog(
                                                                                            title: Text("Error"),
                                                                                            content: Text("Select a Customer name"),
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
                                                                                    else if(double.parse(dualPayment2.value.text)>0){
                                                                                      Navigator.pop(context);
                                                                                      await checkOut(currentOrder,false,2,'${dualPaymentSelected1.value}*${dualPaymentSelected2.value}', '${double.parse(dualPayment3.value.text).toStringAsFixed(decimals)}*${double.parse(dualPayment2.value.text).toStringAsFixed(decimals)}');
                                                                                      setState(() {
                                                                                        currentOrder='';
                                                                                        cartController=[];
                                                                                        cartQtyController=[];
                                                                                        salesTotalList=[];
                                                                                        salesUomList=[];
                                                                                        cartListText=[];
                                                                                        customerName="";
                                                                                      });
                                                                                      tableSelected.value='TABLE';
                                                                                    }
                                                                                    else{
                                                                                      Navigator.pop(context);
                                                                                      await checkOut(currentOrder,false,1,'${dualPaymentSelected1.value}', '${double.parse(dualPayment3.value.text).toStringAsFixed(decimals)}');
                                                                                      setState(() {
                                                                                        currentOrder='';
                                                                                        cartController=[];
                                                                                        cartQtyController=[];
                                                                                        salesTotalList=[];
                                                                                        salesUomList=[];
                                                                                        cartListText=[];
                                                                                        customerName="";
                                                                                      });
                                                                                      tableSelected.value='TABLE';
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child: Text("Save",style: TextStyle(
                                                                                  color: kFont1Color,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                ),
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                  side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                                                                  elevation: MaterialStateProperty.all(3.0),
                                                                                  backgroundColor: MaterialStateProperty.all(checkoutFlag==true?kGreenColor:kHighlight.withOpacity(0.4),),
                                                                                ),
                                                                                onPressed: ()async{

                                                                                  if(checkoutFlag==true){
                                                                                    if(!((double.parse(dualPayment3.value.text)+double.parse(dualPayment2.value.text))==double.parse(salesTotal.toStringAsFixed(decimals)))){
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => AlertDialog(
                                                                                            title: Text("Error"),
                                                                                            content: Text("Enter Total Amount"),
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
                                                                                    else if(dualPaymentSelected1.value==dualPaymentSelected2.value && (double.parse(dualPayment2.value.text)>0)){
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => AlertDialog(
                                                                                            title: Text("Error"),
                                                                                            content: Text("Both Payment modes are same"),
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
                                                                                    else  if((dualPaymentSelected1.value=='Credit' || dualPaymentSelected2.value=='Credit') && selectedCustomer.isEmpty){
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => AlertDialog(
                                                                                            title: Text("Error"),
                                                                                            content: Text("Select a Customer name"),
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
                                                                                    else  if(double.parse(dualPayment2.value.text)>0){
                                                                                      Navigator.pop(context);
                                                                                      await checkOut(currentOrder,true,2,'${dualPaymentSelected1.value}*${dualPaymentSelected2.value}', '${double.parse(dualPayment3.value.text)}*${double.parse(dualPayment2.value.text)}');
                                                                                      setState(() {
                                                                                        currentOrder='';
                                                                                        cartController=[];
                                                                                        cartQtyController=[];
                                                                                        salesTotalList=[];
                                                                                        salesUomList=[];
                                                                                        cartListText=[];
                                                                                        customerName="";
                                                                                      });
                                                                                      tableSelected.value='TABLE';
                                                                                    }
                                                                                    else{
                                                                                      Navigator.pop(context);
                                                                                      await checkOut(currentOrder,true,1,'${dualPaymentSelected1.value}', '${double.parse(dualPayment3.value.text)}');
                                                                                      setState(() {
                                                                                        currentOrder='';
                                                                                        cartController=[];
                                                                                        cartQtyController=[];
                                                                                        salesTotalList=[];
                                                                                        salesUomList=[];
                                                                                        cartListText=[];
                                                                                        customerName="";
                                                                                      });
                                                                                      tableSelected.value='TABLE';

                                                                                    }
                                                                                  }
                                                                                },
                                                                                child: Text("Print",style: TextStyle(
                                                                                  color: kFont1Color,
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                                                ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ) ,
                                                                        ],
                                                                      ),
                                                                    ),

                                                                  ],
                                                                )
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                );
                                              }
                                              else{
                                                await checkOut(currentOrder,true,0,'', '');
                                                setState(() {
                                                  currentOrder='';
                                                  cartController=[];
                                                  cartQtyController=[];
                                                  salesTotalList=[];
                                                  salesUomList=[];
                                                  cartListText=[];
                                                  customerName="";
                                                });
                                                tableSelected.value='TABLE';
                                              }
                                            },
                                            child: Text('CheckOut',
                                              style: TextStyle(
                                                color: kFont1Color,
                                              ),)),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ],
                        )
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              height:MediaQuery.of(context).size.height/18,
                              margin: EdgeInsets.only(top: 8.0),
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 4.0, right: 4.0),
                                    child: RawMaterialButton(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: selectedCategory=='All'?kFont3Color:kGreenColor, width: 0.5),
                                      ),
                                      fillColor:selectedCategory=='All'?kGreenColor:kItemContainer,
                                      onPressed: () async{
                                        await displayAllProducts('Salable');
                                        lastSelectedCategory='All';
                                        selectedCategory='All';
                                        setState(() {

                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'All',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: selectedCategory=='All'?kFont1Color:kGreenColor,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productCategoryF.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                                          child: RawMaterialButton(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(color: selectedCategory==productCategoryF[index]?kFont3Color:kGreenColor, width:0.5),
                                            ),
                                            fillColor:selectedCategory==productCategoryF[index]?kGreenColor:kItemContainer,
                                            onPressed: () async{
                                              lastSelectedCategory=productCategoryF[index];
                                              selectedCategory=productCategoryF[index];
                                              await displayProducts(productCategoryF[index]);
                                              setState(() {

                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                productCategoryF[index],
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: selectedCategory==productCategoryF[index]?kFont1Color:kGreenColor,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Container(
                                child: productNameF.isEmpty ? Center(child: Text('Empty')) : GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio:selectedScreen=='withImage'? MediaQuery.of(context).size.width/
                                          (MediaQuery.of(context).size.height/1.7 ):MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height/2.5),
                                    ),
                                    scrollDirection: Axis.vertical,
                                    itemCount: productNameF.length,
                                    itemBuilder: (context, index) {
                                      return selectedScreen=='withImage'?GestureDetector(
                                        onTap: (){
                                          bottomSheetQtyController.text='';
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(20.0),
                                              ),
                                              context: context,
                                              builder: (context) {
                                                print('nameeeee ${productNameF[index]}');
                                                // RxString uom1=getBaseUom(productNameF[index]).obs;
                                                  List tempUomList=getUom(productNameF[index]);
                                                  // RxString tempPrice=getBasePrice(productNameF[index], selectedPriceList).obs;
                                                return StatefulBuilder(
                                                    builder: (context,
                                                        setState) {
                                                      return Padding(
                                                        padding:
                                                        MediaQuery.of(
                                                            context)
                                                            .viewInsets,
                                                        child:
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                          Axis.vertical,
                                                          child: Container(
                                                            padding: EdgeInsets.only(bottom: 15.0),
                                                            height: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height /
                                                                2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                SizedBox(
                                                                  width: MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                      2,
                                                                  height:
                                                                  MediaQuery.of(context).size.height /
                                                                      6,
                                                                  child: productImages[index].length>0?Image.network(productImages[index],
                                                                    fit: BoxFit.cover,
                                                                  ):Text(productNameF[index]),
                                                                ),
                                                                AutoSizeText(
                                                                  productNameF[index],
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  maxLines:
                                                                  1,
                                                                  style: TextStyle(
                                                                      fontSize: MediaQuery.of(context).textScaleFactor *
                                                                          20,
                                                                      color:
                                                                      kBlack,
                                                                      fontWeight:
                                                                      FontWeight.bold),
                                                                ),
                                                                Obx(()=> Text(
                                                                  'BD ${price123.value[index]}',
                                                                  style: TextStyle(
                                                                      fontSize: MediaQuery.of(context).textScaleFactor *
                                                                          20,
                                                                      color:
                                                                      kBlack,
                                                                      fontWeight:
                                                                      FontWeight.bold),
                                                                ),),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Expanded  (
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(left: 15),
                                                                        child: Container(
                                                                          width:
                                                                          MediaQuery.of(context).size.width / 4,
                                                                          height:60,
                                                                          decoration:
                                                                          BoxDecoration(
                                                                            border: Border.all(
                                                                                color: kLightBlueColor,
                                                                                style: BorderStyle.solid,
                                                                                width: 1.5),
                                                                          ),
                                                                          child:
                                                                          ButtonTheme(
                                                                            alignedDropdown:
                                                                            true,
                                                                            child:
                                                                            DropdownButtonHideUnderline(
                                                                              child: Obx(()=>DropdownButton(
                                                                                //hint: Text('  Uom List'),
                                                                                value: uom123.value[index],
                                                                                items: tempUomList.map((value) {
                                                                                  return DropdownMenuItem(value: value, child: Text(value,style: TextStyle(
                                                                                      fontSize: MediaQuery.of(context).textScaleFactor*20
                                                                                  ),));
                                                                                }).toList(),
                                                                                onChanged: (newValue) {
                                                                                  uom123.value[index]=newValue;
                                                                                  price123.value[index]=getPrice(productNameF[index], newValue);
                                                                                },
                                                                              )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                      35,
                                                                    ),
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(right: 15),
                                                                        child: Container(
                                                                          width:
                                                                          MediaQuery.of(context).size.width / 5,
                                                                          height:60,
                                                                          color:
                                                                          Colors.white,
                                                                          child:
                                                                          TextField(
                                                                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                            style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).textScaleFactor*20
                                                                            ),
                                                                            controller:
                                                                            bottomSheetQtyController,
                                                                            decoration: InputDecoration(
                                                                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kLightBlueColor, width: 2.0)),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(color: kLightBlueColor, width: 2.0),
                                                                                ),
                                                                                labelText: 'Qty',
                                                                                labelStyle: TextStyle(
                                                                                  color: Colors.black38,
                                                                                )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                      7,
                                                                  width: MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                      4,
                                                                  child: GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      if (bottomSheetQtyController
                                                                          .text
                                                                          .isEmpty) {
                                                                        showDialog(
                                                                          context:
                                                                          context,
                                                                          builder: (ctx) =>
                                                                              AlertDialog(
                                                                                title: Text("Alert Dialog Box"),
                                                                                content: Text("Enter Quantity"),
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
                                                                      } else {
                                                                        Navigator.pop(
                                                                            context);
                                                                        print('bottomSheetQtyController ${bottomSheetQtyController.text}');
                                                                        addFromBottomSheet(productNameF[index],uom123.value[index],price123.value[index],bottomSheetQtyController.text);
                                                                      }
                                                                    },
                                                                    child:
                                                                    Card(
                                                                      elevation:
                                                                      5.0,
                                                                      color:
                                                                      kLightBlueColor,
                                                                      shadowColor:
                                                                      kBlack,
                                                                      child:
                                                                      Padding(
                                                                        padding:
                                                                        const EdgeInsets.all(4.0),
                                                                        child:
                                                                        Center(
                                                                          child: Text(
                                                                            'Add',
                                                                            style: TextStyle(
                                                                                fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                                                color: Colors.white,
                                                                                //letterSpacing: 2.0
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              });
                                          // setState(() {
                                          //   addToCart(index);
                                          // });

                                          print(cartListText);
                                        },
                                        child: Card(
                                          elevation: 4.0,
                                          child: Column(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              productImages[index].length>0?SizedBox(
                                                height: MediaQuery.of(context).size.height/4.5,
                                                child: Image.network(productImages[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ):Text(productNameF[index]),
                                              AutoSizeText(
                                                productNameF[index],
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ):
                                      GestureDetector(
                                        onTap: (){
                                          bottomSheetQtyController.text='';
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(20.0),
                                              ),
                                              context: context,
                                              builder: (context) {
                                                print('nameeeee ${productNameF[index]}');
                                                String uom1=getBaseUom(productNameF[index]);
                                                List tempUomList=getUom(productNameF[index]);
                                                String tempPrice=getBasePrice(productNameF[index], selectedPriceList);
                                                      return Padding(
                                                        padding:
                                                        MediaQuery.of(
                                                            context)
                                                            .viewInsets,
                                                        child:
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                          Axis.vertical,
                                                          child: Container(
                                                            padding: EdgeInsets.only(bottom: 15.0),
                                                            height: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height /
                                                                2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                AutoSizeText(
                                                                  productNameF[index],
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  maxLines:
                                                                  1,
                                                                  style: TextStyle(
                                                                      fontSize: MediaQuery.of(context).textScaleFactor *
                                                                          20,
                                                                      color:
                                                                      kBlack,
                                                                      fontWeight:
                                                                      FontWeight.bold),
                                                                ),
                                                                Text(
                                                                  '\u{20B9} $tempPrice',
                                                                  style: TextStyle(
                                                                      fontSize: MediaQuery.of(context).textScaleFactor *
                                                                          20,
                                                                      color:
                                                                      kBlack,
                                                                      fontWeight:
                                                                      FontWeight.bold),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Expanded  (
                                                                      child: Padding(
                                                                        padding: EdgeInsets.only(left: 15),
                                                                        child: Container(
                                                                          width:
                                                                          MediaQuery.of(context).size.width / 4,
                                                                          height:60,
                                                                          decoration:
                                                                          BoxDecoration(
                                                                            border: Border.all(
                                                                                color: kLightBlueColor,
                                                                                style: BorderStyle.solid,
                                                                                width: 1.5),
                                                                          ),
                                                                          child:
                                                                          ButtonTheme(
                                                                            alignedDropdown:
                                                                            true,
                                                                            child:
                                                                            DropdownButtonHideUnderline(
                                                                              child: DropdownButton(
                                                                                //hint: Text('  Uom List'),
                                                                                value: uom1,
                                                                                items: tempUomList.map((value) {
                                                                                  return DropdownMenuItem(value: value, child: Flexible(
                                                                                    child: Text(value,  overflow: TextOverflow.ellipsis,style: TextStyle(
                                                                                        //fontSize: MediaQuery.of(context).textScaleFactor*20
                                                                                    ),),
                                                                                  ));
                                                                                }).toList(),
                                                                                onChanged: (newValue) {
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                      35,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(right: 15),
                                                                      child: Container(
                                                                        width:80,
                                                                        height:60,
                                                                        color:
                                                                        Colors.white,
                                                                        child:
                                                                        TextField(
                                                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                          style: TextStyle(
                                                                              fontSize: MediaQuery.of(context).textScaleFactor*20
                                                                          ),
                                                                          controller:
                                                                          bottomSheetQtyController,
                                                                          decoration: InputDecoration(
                                                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kLightBlueColor, width: 2.0)),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: kLightBlueColor, width: 2.0),
                                                                              ),
                                                                              labelText: 'Qty',
                                                                              labelStyle: TextStyle(
                                                                                color: Colors.black38,
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                      7,
                                                                  width: MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                      4,
                                                                  child: GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      if (bottomSheetQtyController
                                                                          .text
                                                                          .isEmpty) {
                                                                        showDialog(
                                                                          context:
                                                                          context,
                                                                          builder: (ctx) =>
                                                                              AlertDialog(
                                                                                title: Text("Alert Dialog Box"),
                                                                                content: Text("Enter Quantity"),
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
                                                                      } else {
                                                                        Navigator.pop(
                                                                            context);
                                                                        print('bottomSheetQtyController ${bottomSheetQtyController.text}');
                                                                        addFromSearch(productNameF[index], bottomSheetQtyController.text);
                                                                      }
                                                                    },
                                                                    child:
                                                                    Card(
                                                                      elevation:
                                                                      5.0,
                                                                      color:
                                                                      kLightBlueColor,
                                                                      shadowColor:
                                                                      kBlack,
                                                                      child:
                                                                      Padding(
                                                                        padding:
                                                                        const EdgeInsets.all(4.0),
                                                                        child:
                                                                        Center(
                                                                          child: Text(
                                                                            'Add',
                                                                            style: TextStyle(
                                                                              fontSize: MediaQuery.of(context).textScaleFactor * 18,
                                                                              color: Colors.white,
                                                                              //letterSpacing: 2.0
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );

                                              });
                                        },
                                        child: Card(
                                          elevation: 3,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: AutoSizeText(
                                                productNameF[index],
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                //overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  // fontFamily: 'Lato',
                                                  // fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                    color: kGreenColor,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
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
      columnSpacing: 30,
        dataRowHeight: MediaQuery.of(context).size.height/7,
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
          DataColumn(label: Text('Qty',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*20,
            ),
          )),
          DataColumn(label: Text('Price',
            style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*20,
            ),)),
          DataColumn(label: Text('',
            style: TextStyle(
              // fontSize: MediaQuery.of(context).textScaleFactor*20,
                color: kBlack
            ),)),
        ], rows: List.generate(cartListText.length, (index) => DataRow(cells: [
      DataCell(selectedBusiness=='Restaurant'?SizedBox(
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
      ):  SizedBox(
          width:200,
          child:Text('${getItem(index, 0).replaceAll('#', '/')}' ,style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor*16,
              color: kBlack,
              fontWeight: FontWeight.bold
          ),maxLines: 3, overflow: TextOverflow.ellipsis,))),
      DataCell( DropdownButton(
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
      ),),
      DataCell(
        SizedBox(
          height: 40,
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
            onFieldSubmitted: (val){
              List showCartItems=cartListText[index].split(':');
              double tempQuantity = double.parse(val);
              double tempRate = double.parse(getPrice(showCartItems[0], showCartItems[1]));
              tempRate = tempRate * tempQuantity;
              showCartItems[2] = '$tempRate';
              showCartItems[3] = tempQuantity.toString();
              String tempVal=showCartItems.toString().replaceAll(',', ':');
              tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
              print(tempVal);
              setState(() {
                salesTotalList[index] = tempRate;
                cartController[index].text = tempRate.toString();
                cartQtyController[index].text = tempQuantity.toString();
                cartListText[index]=tempVal;
              });
            },),
        ),
      ),
      DataCell(
          SizedBox(
            height: 40,
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
              controller: cartController[index],
              onChanged: (val){
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
      int orderNo=await getSavedOrderInvoiceNo();
      currentOrder='${getPrefix()}$orderNo';
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
// void sunmiV2Print(String orderNo)
// {
//   double tax5=0;
//   double tax10=0;
//   double tax12=0;
//   double tax18=0;
//   double tax28=0;
//   double cess=0;
//   taxCum = "";
//   grandTotal=0;
//   SunmiPrinter.text('$organisationName', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.lg),);
//   SunmiPrinter.text('$organisationAddress', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
//   if(organisationMobile.length>0)
//     SunmiPrinter.text('Mobile Number:$organisationMobile', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
//   if(organisationGstNo.length>0) {
//     SunmiPrinter.text('$organisationTaxType Number:$organisationGstNo', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size:SunmiSize.md),);
//     SunmiPrinter.text('$organisationTaxTitle', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
//   }
//   SunmiPrinter.hr(ch:'-');
//   DateTime now = DateTime.now();
//   String dateS = DateFormat('dd-MM-yyyy – kk:mm').format(now);
//
//   //String dateS = currentTime.toString().substring(0,16);
//   // Text('$currentTime'),
//
//   SunmiPrinter.text('Invoice No:$userSalesPrefix$orderNo', styles: SunmiStyles(bold: true,align: SunmiAlign.left,size: SunmiSize.md),);
//   SunmiPrinter.text('Date:$dateS', styles: SunmiStyles(bold: true,align: SunmiAlign.left,size: SunmiSize.md),);
//   if (appbarCustomerController.text.length>0){
//     SunmiPrinter.text('Customer Name:${appbarCustomerController.text}',
//       styles: SunmiStyles(align: SunmiAlign.left, size: SunmiSize.md),);
//     if(allCustomerAddress[customerList.indexOf(appbarCustomerController.text)].length>0)
//       SunmiPrinter.text('Customer Address:${allCustomerAddress[customerList.indexOf(appbarCustomerController.text)]}',
//         styles: SunmiStyles(align: SunmiAlign.left, size: SunmiSize.md),);
//   }
//   SunmiPrinter.hr(ch: '-');
//   if(orgMultiLine=='true'){
//     SunmiPrinter.text('Item', styles: SunmiStyles(align: SunmiAlign.left,size: SunmiSize.md),);
//     SunmiPrinter.row(
//         cols: [
//           SunmiCol(text: '  Qty', width: 3,align: SunmiAlign.center),
//           SunmiCol(text: 'Rate', width: 3,align: SunmiAlign.right),
//           if(organisationGstNo.length>0)
//             SunmiCol(text: 'Tax', width: 2,align: SunmiAlign.right),
//           SunmiCol(text: 'Amount', width:organisationGstNo.length>0?4:6,align: SunmiAlign.right),
//         ]);
//   }
//   else{
//     SunmiPrinter.row(
//         cols: [
//           SunmiCol(text: 'Item', width:organisationGstNo.length>0? 5:6,align: SunmiAlign.left),
//           SunmiCol(text: 'Qty', width: 1,align: SunmiAlign.center),
//           SunmiCol(text: 'Rate', width: 2,align: SunmiAlign.right),
//           if(organisationGstNo.length>0)
//             SunmiCol(text: 'Tax', width: 1,align: SunmiAlign.center),
//           SunmiCol(text: 'Amount', width:3,align: SunmiAlign.right),
//         ]);
//   }
//   SunmiPrinter.hr(ch: '-');
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
//     if(orgMultiLine=='true'){
//       SunmiPrinter.text(cartItemsString[0],
//         styles: SunmiStyles(align: SunmiAlign.left, size: SunmiSize.md,),);//gr
//       SunmiPrinter.row(
//         cols: [
//           SunmiCol(text: '  ${cartItemsString[3]}', width: 3, align: SunmiAlign.center),
//           SunmiCol(text: '$price', width: 3,align: SunmiAlign.right ),
//           if(organisationGstNo.length>0)
//             SunmiCol(text:'${getPercent(tax)}', width: 2, align: SunmiAlign.right),
//           SunmiCol(text: '${cartItemsString[2]}', width:organisationGstNo.length>0?4:6,align: SunmiAlign.right, ),
//         ],
//       );
//     }
//     else{
//       SunmiPrinter.row(
//         cols: [
//           SunmiCol(text: '${cartItemsString[0]}', width: organisationGstNo.length>0?5:6,align: SunmiAlign.left),
//           SunmiCol(text: '${cartItemsString[3]}', width: 1, align: SunmiAlign.center),
//           SunmiCol(text: '$price', width: 2, align: SunmiAlign.right),
//           if(organisationGstNo.length>0)
//             SunmiCol(text:'${getPercent(tax)}', width: 1, align: SunmiAlign.center),
//           SunmiCol(text: '${cartItemsString[2]}', width: 3, align: SunmiAlign.right),
//         ],
//       );
//     }
//   }
//   SunmiPrinter.hr(ch: '-');
//   if(organisationTaxType=='VAT'){
//     exclTotal = grandTotal - tax10;
//     SunmiPrinter.row(
//         cols: [
//           SunmiCol(text:'Bill Amount', width: 6),
//           SunmiCol(text:'${exclTotal.toStringAsFixed(decimals)}', width: 6,),
//         ]);
//     SunmiPrinter.row(
//         cols: [
//           SunmiCol(text:'Vat 10%', width: 6),
//           SunmiCol(text:'${tax10.toStringAsFixed(decimals)}', width: 6,),
//         ]);
//     grandTotal = exclTotal + tax10;
//     SunmiPrinter.row(
//         cols: [
//           SunmiCol(text:'Net Payable', width: 6),
//           SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
//         ]);
//   }
//   else{
//     if(organisationGstNo.length>0){
//       exclTotal = grandTotal - totalTax;
//       SunmiPrinter.row(
//           cols: [
//             SunmiCol(text:'Bill Amount', width: 6),
//             SunmiCol(text:'${exclTotal.toStringAsFixed(decimals)}', width: 6,),
//           ]);
//       SunmiPrinter.row(
//           cols: [
//             SunmiCol(text:'Total Tax', width: 6),
//             SunmiCol(text:'${totalTax.toStringAsFixed(decimals)}', width: 6,),
//           ]);
//       if(double.parse(totalDiscountController.text)>0){
//         SunmiPrinter.row(
//             cols: [
//               SunmiCol(text:'Discount', width: 6),
//               SunmiCol(text:'${double.parse(totalDiscountController.text).toStringAsFixed(decimals)}', width: 6,),
//             ]);
//         grandTotal = grandTotal - double.parse(totalDiscountController.text);
//       }
//       SunmiPrinter.row(
//           cols: [
//             SunmiCol(text:'Net Payable', width: 6),
//             SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
//           ]);
//       SunmiPrinter.hr(ch: '-');
//       if(tax5>0){
//         SunmiPrinter.text('CGST 2.5%     ${(tax5/2).toStringAsFixed(decimals)}',
//           styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
//         SunmiPrinter.text('SGST 2.5%     ${(tax5/2).toStringAsFixed(decimals)}',
//           styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo
//       }
//       if(tax12>0){
//         SunmiPrinter.text('CGST 6%     ${(tax12/2).toStringAsFixed(decimals)}',
//           styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
//         SunmiPrinter.text('SGST 6%     ${(tax12/2).toStringAsFixed(decimals)}',
//           styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo
//       }
//       if(tax18>0){
//         SunmiPrinter.text('CGST 9%     ${(tax18/2).toStringAsFixed(decimals)}',
//           styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
//         SunmiPrinter.text('SGST 9%     ${(tax18/2).toStringAsFixed(decimals)}',
//           styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo
//       }
//       if(tax28>0){
//         SunmiPrinter.text('CGST 14%     ${(tax28/2).toStringAsFixed(decimals)}',
//           styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTotal +=taxASplit;
//         SunmiPrinter.text('SGST 14%     ${(tax28/2).toStringAsFixed(decimals)}',
//           styles: SunmiStyles(align: SunmiAlign.center, size: SunmiSize.md,),);//grandTo
//
//         SunmiPrinter.row(
//             cols: [
//               SunmiCol(text:'cess 12%', width: 6),
//               SunmiCol(text:'${cess.toStringAsFixed(decimals)}', width: 6,),
//             ]);
//       }
//     }
//     else{
//       if(double.parse(totalDiscountController.text)>0){
//         SunmiPrinter.row(
//             cols: [
//               SunmiCol(text:'Bill Amount', width: 6),
//               SunmiCol(text:'${exclTotal.toStringAsFixed(decimals)}', width: 6,),
//             ]);
//         SunmiPrinter.row(
//             cols: [
//               SunmiCol(text:'Discount', width: 6),
//               SunmiCol(text:'${double.parse(totalDiscountController.text).toStringAsFixed(decimals)}', width: 6,),
//             ]);
//         grandTotal = grandTotal - double.parse(totalDiscountController.text);
//         SunmiPrinter.row(
//             cols: [
//               SunmiCol(text:'Net Payable', width: 6),
//               SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
//             ]);
//       }
//       else{
//         SunmiPrinter.row(
//             cols: [
//               SunmiCol(text:'Bill Amount', width: 6),
//               SunmiCol(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,),
//             ]);
//         SunmiPrinter.hr(ch: '-');
//       }
//     }
//   }
//   if(organisationGstNo.length>0) SunmiPrinter.hr(ch: '-');
//   SunmiPrinter.text('Thank You,Visit Again', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
//   SunmiPrinter.emptyLines(6);
// }
///////////

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
    isSelected = [true, false,false];
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
          SizedBox(
            width:MediaQuery.of(context).size.width/2,
            height: 45,
            child: SimpleAutoCompleteTextField(
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*14,
              ),
              // focusNode: nameNode,
              controller: appbarCustomerController,
              decoration: new InputDecoration(
                border: OutlineInputBorder(),
                disabledBorder: OutlineInputBorder(
                ),
                enabledBorder: OutlineInputBorder(),
              ),
              suggestions: customerList,
              clearOnSubmit: false,
              textSubmitted: (text) {
                if(customerList.contains(text)) {
                  setState(() {
                    selectedCustomer=appbarCustomerController.text=text;
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