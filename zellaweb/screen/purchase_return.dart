import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/drawer.dart';
import 'package:restaurant_app/components/drawer2.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/screen/add_customer.dart';
import 'package:restaurant_app/screen/add_product.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:restaurant_app/screen/add_vendor.dart';
import 'package:restaurant_app/screen/login_page.dart';
import 'package:restaurant_app/screen/purchase_report.dart';
import 'package:restaurant_app/screen/sequence_manager.dart';
import 'package:restaurant_app/screen/stream_reports.dart';
import 'package:restaurant_app/screen/stream_vat.dart';
import 'menu_screen.dart';
import 'organisation_screen.dart';
import 'printer_settings.dart';
import 'package:badges/badges.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/components/all_file.dart';
import 'report_screen.dart';
List<String> vrInv=[];
RxList searchResult=[].obs;
RxBool invEdit=false.obs;
RxString invEditNumber=''.obs;
RxString invEditPaymentMethod=''.obs;
RxString invEditTotal=''.obs;
RxInt invDate=0.obs;
RxString invEditVendorName=''.obs;
Rx<List<String>> invEditCartList=RxList<String>([]).obs;
List<int> vrDate=[];
List<String> vrPayment=[];
List<double> vrTotal=[];
List<String> vrTransaction=[];
bool checkoutFlag=true;
var datePicked;
int toDate1=0;
int fromDate1=0;
DateTime  fromDate;
DateTime toDate ;
List<TextEditingController> purchaseCartController=[];
double purchaseReturnTotal=0;
List<double> purchaseReturnTotalList=[];
List<String> purchaseReturnUomList=[];
String selectedPurchasePayment='Cash';
List<String> purchasePaymentMode=[];
int badgeContent=0;
TextEditingController quantityController=TextEditingController();
TextEditingController nameController=TextEditingController();
TextEditingController appbarVendorController=TextEditingController();
FocusNode quantityNode;
FocusNode nameNode;
int categoryPressed;
List<bool> isSelected;
bool show = false;
bool enableQuantity=false;
bool _showOrderList=false;
String _orderDetails='';
List<int> purchaseReturnOrderNoList=[];
int purchaseReturnOrderNo;
List <String> purchaseCartListText=[];
List<bool> selected = List<bool>();
List<String> _orderDetailsList=[];
String _selectedItem='';
class PurchaseReturn extends StatefulWidget {
    static const String  id='purchase_return';
    @override
    _PurchaseReturnState createState() => _PurchaseReturnState();
}

class _PurchaseReturnState extends State<PurchaseReturn> {
    double getTotal(List total){
        double tempRate=0;
        for(int i=0;i<total.length;i++){
            tempRate+=total[i];
        }
        purchaseReturnTotal=tempRate;
        return tempRate;
    }
    void addToCart(int index){
        String tempText='';
        if(purchaseCartListText.isEmpty){
            String priceList=getBasePrice(productNameF[index], selectedVendorPriceList);
            String uom=getBaseUom(productNameF[index]);
            purchaseCartController.add(TextEditingController());
            tempText='${productNameF[index]}:$uom:$priceList: 1';
            setState(() {
                purchaseReturnTotalList.add(double.parse(priceList.trimLeft()));
                purchaseCartController[0].text=priceList;
                purchaseReturnUomList.add(uom);
                purchaseCartListText.add(tempText.trim());
            });
        }
        else {
            for(int i=0;i<purchaseCartListText.length;i++) {
                if (purchaseCartListText[i].contains(
                    productNameF[index])) {
                    List tempList = purchaseCartListText[i].split(':');
                    if (tempList[1].toString().trim() ==
                        getBaseUom(productNameF[index]).toString().trim()) {
                        int tempQuantity = int.parse(
                            tempList[3]);
                        print(tempQuantity);
                        tempQuantity = tempQuantity + 1;
                        print('${tempList[0]},${tempList[1].toString().trimLeft()}');
                        String tempr = getPrice(tempList[0], tempList[1]);
                        print('tempr $tempr');
                        double tempRate = double.parse(tempr);
                        tempRate = tempRate * tempQuantity;
                        print(tempRate);
                        tempList[2] = '$tempRate';
                        tempList[3] = tempQuantity.toString();
                        tempText = tempList.toString();
                        tempText =
                            tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
                        print(tempText);
                        tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
                        setState(() {
                            purchaseReturnTotalList[i] = double.parse(tempRate.toString());
                            purchaseCartController[i].text = tempRate.toString();
                            purchaseCartListText[i] = tempText.trim();
                        });
                        return;
                    }
                }
            }
            setState(() {
                String uom=getBaseUom(productNameF[index]);
                purchaseReturnUomList.add(uom);
                String priceList=getBasePrice(productNameF[index], selectedVendorPriceList);
                tempText='${productNameF[index]}:$uom:$priceList: 1';
                purchaseCartController.add(TextEditingController(
                    text: priceList
                ));
                purchaseReturnTotalList.add(double.parse(priceList.trimLeft()));
                purchaseCartListText.add(tempText.trim());
            });
        }
    }
    void addFromSearch(String name,String quantityValue){
        String tempText='';
        if(purchaseCartListText.isEmpty){
            String uom=getBaseUom(name);
            String tempr=getPrice(name,getBaseUom(name));
            double tempRate=double.parse(tempr);
            purchaseCartController.add(TextEditingController());
            tempRate=double.parse(quantityValue)*tempRate;
            tempText='$name:$uom:$tempRate: $quantityValue';
            setState(() {
                purchaseReturnTotalList.add(tempRate);
                purchaseCartController[0].text=tempRate.toString();
                purchaseReturnUomList.add(getBaseUom(name));
                purchaseCartListText.add(tempText.trim());
            });
        }
        else {
            for (int i = 0; i < purchaseCartListText.length; i++) {
                if (purchaseCartListText[i].contains(
                    name)) {
                    List tempList = purchaseCartListText[i].split(
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
                        tempText =
                            tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
                        tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
                        setState(() {
                            purchaseReturnTotalList[i] = tempRate;
                            purchaseCartController[i].text = tempRate.toString();
                            purchaseCartListText[i] = tempText.trim();
                        });
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
                purchaseCartController.add(TextEditingController(
                    text: tempRate.toString()
                ));
                purchaseReturnTotalList.add(tempRate);
                purchaseReturnUomList.add(getBaseUom(name));
                purchaseCartListText.add(tempText.trim());
            });
        }

    }
    void removeFromCart(String text,String uom){
        String tempText='';
        for(int i=0;i<purchaseCartListText.length;i++) {
            if (purchaseCartListText[i].contains(
                text)) {
                List tempList = purchaseCartListText[i].split(
                    ':');
                if (tempList[1].toString().trim() ==
                    uom.toString().trim()) {
                    double tempQuantity = double.parse(
                        tempList[3]);
                    tempQuantity = tempQuantity - 1;
                    if (tempQuantity == 0 || tempQuantity.isNegative) {
                        setState(() {
                            purchaseReturnTotalList.removeAt(i);
                            purchaseCartController.removeAt(i);
                            purchaseCartListText.removeAt(i);
                            purchaseReturnUomList.removeAt(i);
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
                            purchaseReturnTotalList[i] = tempRate;
                            purchaseCartController[i].text = tempRate.toString();
                            purchaseCartListText[i] = tempText.trim();
                        });
                        return;
                    }
                }

            }
        }
    }

    void addQuantity(String text,String uom){
        String tempText='';
        for(int i=0;i<purchaseCartListText.length;i++) {
            if (purchaseCartListText[i].contains(
                text)) {
                List tempList = purchaseCartListText[i].split(
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
                        purchaseReturnTotalList[i] = tempRate;
                        purchaseCartController[i].text = tempRate.toString();
                        purchaseCartListText[i] = tempText.trim();
                        print(purchaseCartListText[i]);
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
                    print('barcode type $barcodeType');
                    List tempSplit = tempFirstSplit[4].split('``');

                    List tempUomSplit = tempSplit[0].split('*');
                    List tempPriceSplit = tempSplit[1].split('*');
                    List tempBarcodeSplit = tempSplit[3].split('*');
                    tempBarcodeSplit.removeLast();
                    tempPriceSplit.removeLast();
                    tempUomSplit.removeLast();
                    print(tempBarcodeSplit);
                    for (int j = 0; j < tempBarcodeSplit.length; j++) {
                        if (tempBarcodeSplit[j] == barcodeVal) {
                            String name = tempFirstSplit[0];
                            String tempPrice;
                            if(tempPriceSplit[j].toString().trimLeft().contains('>')){
                                List tempPriceListSplit=tempPriceSplit[j].toString().split('>');
                                print(tempPriceListSplit);
                                int pos=int.parse(selectedVendorPriceList.substring(6));
                                pos=pos-1;
                                tempPrice=tempPriceListSplit[pos];
                            }
                            else
                                tempPrice=tempPriceSplit[j].toString().trimLeft();
                            for (int i = 0; i < purchaseCartListText.length; i++) {
                                if (purchaseCartListText[i].contains(name.trim())) {
                                    print('contains name');
                                    List tempList = purchaseCartListText[i].split(':');
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
                                            purchaseReturnTotalList[i] = tempRate;
                                            purchaseCartController[i].text = tempRate.toString();
                                            purchaseCartListText[i] = tempText;
                                        });
                                        print(tempText);
                                        return;
                                    }
                                }
                            }

                            setState(() {
                                tempText = '$name:${tempUomSplit[j]}:$tempPrice: 1';
                                purchaseReturnTotalList.add(double.parse(tempPrice));
                                purchaseCartController.add(TextEditingController(
                                    text: tempPrice
                                ));
                                purchaseReturnUomList.add(tempUomSplit[j]);
                                purchaseCartListText.add(tempText.trim());
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
                            int pos=int.parse(selectedVendorPriceList.substring(6));
                            pos=pos-1;
                            price=double.parse(tempAmountSplit[pos].toString().trimLeft());
                        }
                        else
                            price=double.parse(amount[0].toString().trimLeft());
                        String weight = barcodeVal.substring(7,12);
                        double tempWeight = (int.parse(weight) / 1000);
                        double tempPrice = tempWeight * price;
                        tempText = '$name:${uom[0]}:$tempPrice:$tempWeight';
                        setState(() {
                            purchaseCartController.add(TextEditingController(
                                text: tempPrice.toString()
                            ));
                            purchaseReturnTotalList.add(tempPrice);
                            purchaseReturnUomList.add(uom[0]);
                            purchaseCartListText.add(tempText.trim());
                        });
                        print(tempText);
                        return;
                    }
                }
            }}
    }
    // ignore: missing_return
    String getPrice(String productName,String uomName){
        for(int i=0;i<productFirstSplit.length;i++){
            List temp111=productFirstSplit[i].toString().split(':');
            if(temp111[0].toString().trim()==productName){
                List temp=productFirstSplit[i].split(':');
                List tempPrice=temp[4].split('``');
                List tempUomSplit=tempPrice[0].toString().split('*');
                List tempPriceSplit=tempPrice[2].toString().split('*');
                for(int j=0;j<tempUomSplit.length;j++) {
                    print(tempUomSplit[j]);
                    print(tempPriceSplit[j]);
                    if(tempUomSplit[j].contains(uomName.trim())) {
                        String basePrice;
                        if(tempPriceSplit[j].toString().trimLeft().contains('>')){
                            List tempPriceListSplit=tempPriceSplit[j].toString().split('>');
                            int pos=int.parse(selectedVendorPriceList.substring(6));
                            pos=pos-1;
                            basePrice=tempPriceListSplit[pos];
                        }
                        else{
                            basePrice = tempPriceSplit[j].toString().trim().length>0?tempPriceSplit[0].toString().trim():'0';
                        }
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
            List temp111=productFirstSplit[i].toString().split(':');
            if(temp111[0].toString().trim()==productName){
                List temp=productFirstSplit[i].split(':');
                List tempUom=temp[4].split('``');
                List tempPriceSplit=tempUom[2].toString().split('*');
                String basePrice;
                if(tempPriceSplit[0].toString().contains('>')){
                    List tempPriceListSplit=tempPriceSplit[0].toString().split('>');
                    int pos=int.parse(selectedVendorPriceList.substring(6));
                    pos=pos-1;
                    basePrice=tempPriceListSplit[pos];
                }
                else{
                    basePrice = tempPriceSplit[0].toString().trim().length>0?tempPriceSplit[0].toString().trim():'0';
                }

                return basePrice;
            }
        }
    }
    String getBaseUom(String productName){
        for(int i=0;i<productFirstSplit.length;i++){
            List temp111=productFirstSplit[i].toString().split(':');
            if(temp111[0].toString().trim()==productName){
                List temp=productFirstSplit[i].split(':');
                List tempUom=temp[4].split('``');
                List tempUomSplit=tempUom[0].toString().split('*');
                return tempUomSplit[0];
            }
        }

    }
    // ignore: missing_return
    List<String> getUom(String productName){
        for(int i=0;i<productFirstSplit.length;i++){
            List temp111=productFirstSplit[i].toString().split(':');
            if(temp111[0].toString().trim()==productName){
                List temp=productFirstSplit[i].split(':');
                List tempUom=temp[4].split('``');
                List tempUomSplit=tempUom[0].toString().split('*');
                tempUomSplit.removeLast();
                print(tempUomSplit);
                return tempUomSplit;
            }
        }
    }


    // void showOrderList(String order){
    //
    //   List showOrder=order.split(',');
    //   String currentTable=showOrder[2].toString().substring(7);
    //   String orderNo=showOrder[0].toString().substring(9);
    //   print(orderNo);
    //   selectedCustomer=showOrder[3].toString().substring(9);
    //   selectedPriceList=showOrder[4].toString().substring(10);
    //   String itemsTemp=showOrder[5].toString().substring(6);
    //   List showItems=itemsTemp.split('-');
    //   showItems.removeAt(showItems.length-1);
    //   setState(() {
    //     cartListText=[];
    //     tempOrderNo=int.parse(orderNo);
    //     _selectedTable=int.parse(currentTable);
    //   });
    //   for(int i=0;i<showItems.length;i++)
    //   {
    //     List tempCart=showItems[i].toString().split(':');
    //     setState(() {
    //       tempTotalList.add(double.parse(tempCart[2].toString().trim()));
    //       cartUomList.add(tempCart[1].toString().trim());
    //       cartController.add(TextEditingController(text: tempCart[2].toString().trim()));
    //       cartListText.add(showItems[i].toString().trim());
    //     });
    //   }
    //   print(cartListText);
    // }
    Future checkOut() async {
        if(purchaseCartListText.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add Items')));
            return;
        }
        setState(() {
            checkoutFlag=false;
        });
        if(invEdit.value){
            QuerySnapshot<Map<String, dynamic>> querySnapshot=await firebaseFirestore.collection('item_report').where('orderNo',isEqualTo: invEditNumber.value).get();
            int len1=querySnapshot.docs.length;
            for(int i=0;i<len1;i++){
                await firebaseFirestore.collection('item_report').doc(querySnapshot.docs[i].id).delete();
            }
            if(invEditVendorName.value.length>0){
                DocumentSnapshot documentSnapshot=await firebaseFirestore.collection('customer_report').doc(invEditVendorName.value).get();
                if(documentSnapshot.exists){
                    List tempData=documentSnapshot.get('data');
                    print('dataaa $tempData');
                    int len=documentSnapshot.get('data').length;
                    for(int i=0;i<len;i++){
                        if(tempData[i].toString().contains(invEditNumber.value)){
                            List tempRemove=[];
                            tempRemove.add(tempData[i]);
                            print('containsss  ');
                            firebaseFirestore.collection('vendor_report').doc(invEditVendorName.value).update(
                                {"data": FieldValue.arrayRemove(tempRemove)});
                            break;
                        }
                    }
                }
            }

            await firebaseFirestore.collection('vat_report').doc(invEditNumber.value).delete();
            if(invEditPaymentMethod.value=='Cash' && invDate.value<tillCloseTime){
                print('inv before till close');
                await firebaseFirestore.collection('user_data').doc(currentUser).update(
                    {
                        "tillClose":FieldValue.increment(-(double.parse(invEditTotal.value))),
                    }
                );
            }
            if(invEditPaymentMethod.value=='Credit'){
                String bal=getVendorBalance(invEditVendorName.value);
                double tempBalance=double.parse(bal.isNotEmpty?bal:'0')-double.parse(invEditTotal.value);
                int pos = vendorList.indexOf(invEditVendorName.value);
                vendorBalanceList[pos]=tempBalance.toString();
                await firebaseFirestore.collection('vendor_data').doc(invEditVendorName.value).update({
                    "balance":tempBalance.toString(),
                }).then((_) {
                    print('customer balance updated');
                });
            }

            for(int k=0;k<invEditCartList.value.length;k++){
                List temp=invEditCartList.value[k].split(':');
                String itemName=temp[0];
                String itemQty=temp[3];
                String itemPrice=temp[2];
                String itemUom=temp[1];
                String itemConversion=getConversion(itemName, itemUom);
                double tempQty=double.parse(itemQty)*double.parse(itemConversion);
                itemQty=tempQty.toString();
                String stockDetails=await readStock(itemName);
                List itemStockDetailsSplit=stockDetails.split('~');
                String stockQuantity=itemStockDetailsSplit[1].toString().trim();
                String costPrice=itemStockDetailsSplit[2].toString().trim();
                String stockValue=itemStockDetailsSplit[3].toString().trim();
                double newStockQuantity=double.parse(stockQuantity)+double.parse(itemQty);
                double newSockValue=newStockQuantity*double.parse(costPrice);
                String stockBody='$itemName~${newStockQuantity.toString()}~$costPrice~${newSockValue.toStringAsFixed(3)}';
                print('stockBody $stockBody');
                await updateStock(stockBody);
                updateWarehouse(itemName,itemQty,'purchase');
            }
        }
        int invNo;
        invNo=await getLastInv('purchaseReturn');
        String tempEditInv='';
        if(invEdit.value){
            tempEditInv=invEditNumber.value;
        }
        else{
            tempEditInv='$purchaseReturnPrefix$invNo';
        }
        List yourItemsList1=[];
        selectedVendor=selectedVendor.length>0?selectedVendor:'Standard';
        String body='$tempEditInv~${dateNow()}~$selectedVendor~$selectedPurchasePayment~$purchaseReturnTotal~PurchaseReturn~$currentUser';
        yourItemsList1.add({
            "invNo":"$tempEditInv",
            "date":DateTime.now().millisecondsSinceEpoch,
            "payment":selectedPurchasePayment,
            "total":purchaseReturnTotal,
            "type":'Purchase Return'
        });
        // const PaperSize paper = PaperSize.mm80;
        // final profile = await CapabilityProfile.load();
        // final printer = NetworkPrinter(paper, profile);
        // try{
        //   final PosPrintResult res = await printer.connect(defaultIpAddress, port: int.parse(defaultPort),timeout: Duration(seconds: 5));
        //   if (res == PosPrintResult.success) {
        //     await  networkPrint('$salesPrefix$invNo',printer );
        //     printer.disconnect();
        //   }
        //   print('Print result: ${res.msg}');
        // }
        // catch(e){
        //
        // }
        // await insertData(body,'purchase_return');
        String vat5Body='';
        double taxable5=0;
        double tax5=0;
        double total5=0;
        double total0=0;
        List yourItemsList=[];
        for(int k=0;k<purchaseCartListText.length;k++){
            List temp=purchaseCartListText[k].split(':');
            String itemName=temp[0];
            String itemQty=temp[3];
            String itemUom=temp[1];
            String itemPrice=temp[2];
            String itemTax=getTaxName(itemName);
            print('itemUom $itemUom');
            String taxPercent=getPercent(itemTax);
            if(taxPercent.trim()=='5'){
                print('inside tax percent 5');
                taxable5+=double.parse(itemPrice)*100/105;
                tax5+=5*double.parse(itemPrice)/105;
                total5+=double.parse(itemPrice);
            }
            else{
                print('inside 0 tax');
                total0+=double.parse(itemPrice);
            }
            print('taxPercent $taxPercent');
            double taxAmt=(double.parse(taxPercent)/100)*double.parse(itemPrice);
            double lineTotal=double.parse(itemPrice);
            yourItemsList.add({
                "name":itemName,
                "uom":itemUom,
                "qty":itemQty,
                "price":itemPrice,
                "category":getCategory(itemName),
                "taxName":itemTax,
                "taxRate":taxPercent,
                "taxAmt":taxAmt
            });
        }
        if(invEdit.value){
            print('inside inv edit');
            print('doc ${invEditNumber.value}');
            firebaseFirestore
                .collection("purchase_return")
                .doc(invEditNumber.value)
                .set({
                'orderNo': invEditNumber.value,
                'date': DateTime.now().millisecondsSinceEpoch,
                'vendor': selectedVendor,
                'cartList': yourItemsList,
                'payment':selectedPurchasePayment,
                'total': purchaseReturnTotal.toString(),
                'transactionType':'PurchaseReturn',
                'user': currentUser,
                'discount':'0'
            }).then((_) {
                print('success');
            });
        }
        else{
            create(body, 'purchase_return', yourItemsList);
            updateInv('purchaseReturn', invNo+1);
        }
        create(selectedVendor, 'vendor_report', yourItemsList1);
        String getVat(String name){
            if(name!='Standard'){
                int pos=vendorList.indexOf(name);
                return vendorVatNo[pos];
            }
            return '';
        }
         String vatBody='$tempEditInv~${dateNow()}~$selectedVendor~${getVat(selectedVendor)}~$purchaseReturnTotal~${taxable5.toStringAsFixed(decimals)}~${tax5.toStringAsFixed(decimals)}~$total5~$total0~purchaseReturn';
        create(vatBody, 'vat_report', []);
        if(selectedPurchasePayment=='Credit'){
            updateReport(selectedVendor, purchaseReturnTotal.toStringAsFixed(3), 'vendor_data','',getVendorBalance(selectedVendor),'purchase_return');
        }
        for(int k=0;k<purchaseCartListText.length;k++){
            List temp=purchaseCartListText[k].split(':');
            String itemName=temp[0];
            String itemQty=temp[3];
            String itemPrice=temp[2];
            String itemUom=temp[1];
            String itemConversion=getConversion(itemName, itemUom);
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
            print('stockBody $stockBody');
            await updateStock(stockBody);
            updateWarehouse(itemName,itemQty,'purchaseReturn');
        }
        setState(() {
            selectedVendor='';
            appbarVendorController.clear();
            checkoutFlag=true;
        });
        showDialog(
            context:
            context,
            builder: (ctx) =>
                AlertDialog(
                    title: Text("Checkout complete"),
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
        return;
    }
    void searchOperation(String text) {
        searchResult.clear();
        if(text.length>0){
            print('inside ifffffff $text');
            for (int i = 0; i < allPurchasableProducts.length; i++) {
                String data = allPurchasableProducts[i];
                if (data.toLowerCase().contains(text.toLowerCase().replaceAll('/', '#'))) {
                    searchResult.add(data);
                    print('searchResult ${searchResult}');
                }
            }
        }
        else{
            print('inside elseeeeeeeeee $text');
            searchResult.clear();
        }
    }
    @override
    void initState() {
        // TODO: implement initState
        getPurchaseReturnInvoiceNo();
        super.initState();
        selectedCategory='All';
        quantityNode=FocusNode();
        nameNode=FocusNode();
        purchasePaymentMode=mainPaymentList;
        // productImage = breadImage;
        // productRate=breadRate;
    }
    @override
    void dispose() {
        // TODO: implement dispose
        nameNode.dispose();
        quantityNode.dispose();
        super.dispose();
    }
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    @override
    Widget build(BuildContext context) {

        return MaterialApp(
            scrollBehavior: MaterialScrollBehavior().copyWith(
                dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
            ),
            builder: (context,widget)=>SafeArea(
                child: Scaffold(
                    drawerEnableOpenDragGesture: currentTerminal!='Call Center'?true:false,
                    endDrawerEnableOpenDragGesture:currentTerminal=='Admin-POS'?true:false,
                    key: _scaffoldKey,
                    drawer: MyDrawer(),
                    endDrawer: Drawer2(),
                    resizeToAvoidBottomInset: false,
                    body:Flex(
                        direction: Axis.vertical,
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
                                    color: Colors.white
                                ),
                                child: Container(
                                    color: kGreenColor,
                                    height: MediaQuery.of(context).size.height/12,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Expanded(
                                                child: Container(
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            IconButton(onPressed: (){
                                                                _scaffoldKey.currentState.openDrawer();
                                                            }, icon: Icon(Icons.menu),color: kItemContainer,),
                                                            VendorSelect(),
                                                            IconButton(onPressed: () {
                                                                if(selectedVendor.isEmpty){
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (context) => AlertDialog(
                                                                            title: Text("Error"),
                                                                            content: Text("Select a Vendor name"),
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
                                                                    vrInv=[];
                                                                    vrDate=[];
                                                                    vrPayment=[];
                                                                    vrTotal=[];
                                                                    vrTransaction=[];
                                                                    toDate =DateTime.now();
                                                                    toDate1=DateTime.now().millisecondsSinceEpoch;
                                                                    showDialog(context: context, builder: (BuildContext context){
                                                                        return StreamBuilder(
                                                                            stream: firebaseFirestore.collection('vendor_report').doc(selectedVendor).snapshots(),
                                                                            builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot2) {
                                                                                print('selectedVendor $selectedVendor');
                                                                                if (!snapshot2.hasData) {
                                                                                    return Center(
                                                                                        child: CircularProgressIndicator(),
                                                                                    );
                                                                                }
                                                                                if (!snapshot2.data.exists) {
                                                                                    return Dialog(
                                                                                        shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(12.0)),
                                                                                        child: Center(child: Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Text('No data'),
                                                                                        )));
                                                                                }
                                                                                return Dialog(
                                                                                    shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(12.0)),
                                                                                    child: StatefulBuilder(
                                                                                        builder: (context,setState){

                                                                                            return Container(
                                                                                                padding: EdgeInsets.all(6.0),
                                                                                                //width: MediaQuery.of(context).size.width/3,
                                                                                                child: SingleChildScrollView(
                                                                                                    scrollDirection: Axis.vertical,
                                                                                                    child: Column(
                                                                                                        children: [
                                                                                                            Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                                children: [
                                                                                                                    TextButton(
                                                                                                                        onPressed: () async {
                                                                                                                            datePicked = await showDatePicker(
                                                                                                                                context: context,
                                                                                                                                initialDate: new DateTime.now(),
                                                                                                                                firstDate:
                                                                                                                                new DateTime.now().subtract(new Duration(days: 300)),
                                                                                                                                lastDate:
                                                                                                                                new DateTime.now().add(new Duration(days: 300)),
                                                                                                                            );
                                                                                                                            fromDate = datePicked;
                                                                                                                            setState(() {
                                                                                                                                fromDate1=fromDate.millisecondsSinceEpoch;
                                                                                                                            });
                                                                                                                        },
                                                                                                                        child: Container(
                                                                                                                            padding: EdgeInsets.all(8.0),
                                                                                                                            decoration: BoxDecoration(
                                                                                                                                // color: kCardColor,
                                                                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                                                            ),

                                                                                                                            child: Row(
                                                                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                                                children: [
                                                                                                                                    Text(
                                                                                                                                        'From :',
                                                                                                                                        style: TextStyle(
                                                                                                                                            letterSpacing: 1,
                                                                                                                                            color: kGreenColor,
                                                                                                                                            fontWeight: FontWeight.bold
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                    Text(fromDate!=null?fromDate.toString():"",style: TextStyle(color: kGreenColor),)
                                                                                                                                ],
                                                                                                                            ),
                                                                                                                        )),
                                                                                                                    TextButton(
                                                                                                                        onPressed: () async {
                                                                                                                            datePicked = await showDatePicker(
                                                                                                                                context: context,
                                                                                                                                initialDate: new DateTime.now(),
                                                                                                                                firstDate:
                                                                                                                                new DateTime.now().subtract(new Duration(days: 300)),
                                                                                                                                lastDate: new DateTime.now().add(new Duration(days: 300)),
                                                                                                                            );
                                                                                                                            toDate = datePicked;
                                                                                                                            setState(() {
                                                                                                                                toDate1=toDate.millisecondsSinceEpoch;
                                                                                                                            });
                                                                                                                        },
                                                                                                                        child: Container(
                                                                                                                            padding: EdgeInsets.all(8.0),
                                                                                                                            decoration: BoxDecoration(
                                                                                                                                //color: kCardColor,
                                                                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                                                            ),
                                                                                                                            child: Row(
                                                                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                                                children: [
                                                                                                                                    Text(
                                                                                                                                        'To :',
                                                                                                                                        style: TextStyle(
                                                                                                                                            letterSpacing: 1,
                                                                                                                                            color: kGreenColor,
                                                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                    Text(toDate.toString(),style: TextStyle(color: kGreenColor),),
                                                                                                                                ],
                                                                                                                            ),
                                                                                                                        ),
                                                                                                                    ),
                                                                                                                    TextButton(onPressed: () async {
                                                                                                                        print('presss');
                                                                                                                        vrInv=[];
                                                                                                                        vrDate=[];
                                                                                                                        vrPayment=[];
                                                                                                                        vrTotal=[];
                                                                                                                        vrTransaction=[];
                                                                                                                        for(int i=0;i<snapshot2.data['data'].length;i++){
                                                                                                                            print('presss $toDate1');
                                                                                                                            print('presss ${snapshot2.data['data'][i]['date']}');
                                                                                                                            if(snapshot2.data['data'][i]['date']>=fromDate1 && snapshot2.data['data'][i]['date']<=toDate1) {
                                                                                                                                print('inside $fromDate1');
                                                                                                                                vrInv.add(snapshot2.data['data'][i]['invNo']);
                                                                                                                                print(vrInv);
                                                                                                                                vrDate.add(snapshot2.data['data'][i]['date']);
                                                                                                                                vrPayment.add(snapshot2.data['data'][i]['payment']);
                                                                                                                                vrTotal.add(double.parse(snapshot2.data['data'][i]['total'].toString()));
                                                                                                                                vrTransaction.add(snapshot2.data['data'][i]['type']);
                                                                                                                            }
                                                                                                                        }

                                                                                                                        setState(()  {

                                                                                                                        });
                                                                                                                    },
                                                                                                                        child: Container(
                                                                                                                            decoration: BoxDecoration(
                                                                                                                                color: Colors.black,
                                                                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                                                            ),
                                                                                                                            padding: EdgeInsets.all(10.0),
                                                                                                                            child: Text(
                                                                                                                                'Search',
                                                                                                                                style: TextStyle(
                                                                                                                                    letterSpacing: 1.0,
                                                                                                                                    color: kItemContainer
                                                                                                                                ),
                                                                                                                            ),
                                                                                                                        )),
                                                                                                                ],
                                                                                                            ),
                                                                                                            DataTable(columns: [
                                                                                                                DataColumn(label: Text('InvoiceNo', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                                                                                DataColumn(label: Text('Date', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                                                                                DataColumn(label: Text('Payment Mode', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                                                                                DataColumn(label: Text('Total', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                                                                                DataColumn(label: Text('Type', style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 16,))),
                                                                                                            ],
                                                                                                                rows: List.generate(
                                                                                                                    vrInv.length, (index) =>
                                                                                                                    DataRow(cells: [
                                                                                                                        DataCell(Text(vrInv[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                                                                        DataCell(Text(convertEpox(vrDate[index]).substring(0,16), style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                                                                        DataCell(Text(vrPayment[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                                                                        DataCell(Text(vrTotal[index].toString(), style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                                                                        DataCell(Text(vrTransaction[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),]))),
                                                                                                            Container(
                                                                                                                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/6),
                                                                                                                height:  MediaQuery.of(context).size.height/12,
                                                                                                                width: MediaQuery.of(context).size.width,
                                                                                                                child: Row(
                                                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                                                    children: [
                                                                                                                        Text('Net Balance',
                                                                                                                            style: TextStyle(
                                                                                                                                fontSize: 30.0,
                                                                                                                                letterSpacing: 2.0,
                                                                                                                                fontWeight: FontWeight.bold,
                                                                                                                            ),
                                                                                                                        ),
                                                                                                                        SizedBox(
                                                                                                                            width: 50.0,
                                                                                                                        ),
                                                                                                                        StreamBuilder(stream: firebaseFirestore.collection('vendor_report').doc(selectedVendor).snapshots(),
                                                                                                                            builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
                                                                                                                                if (!snapshot.hasData) {
                                                                                                                                    return Text(
                                                                                                                                        '0'
                                                                                                                                    );
                                                                                                                                }
                                                                                                                                var ds = snapshot.data['data'];
                                                                                                                                double totalCredit = 0.0;
                                                                                                                                double totalReturnsCredit = 0.0;
                                                                                                                                double payments = 0.0;
                                                                                                                                double balance = 0.0;
                                                                                                                                for(int i=0; i<ds.length;i++){
                                                                                                                                    if(ds[i]['payment']=='Credit'){
                                                                                                                                        if(ds[i]['type']=='Purchase') {
                                                                                                                                            totalCredit += ds[i]['total'];
                                                                                                                                        } else {
                                                                                                                                            totalReturnsCredit += ds[i]['total'];
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    else if(ds[i]['type']=='Payment'){
                                                                                                                                        payments+=ds[i]['total'];
                                                                                                                                    }
                                                                                                                                }
                                                                                                                                balance=totalCredit-(payments+totalReturnsCredit);
                                                                                                                                return Text(balance.toStringAsFixed(decimals),
                                                                                                                                    style: TextStyle(
                                                                                                                                        fontSize: 30.0,
                                                                                                                                        fontWeight: FontWeight.bold,
                                                                                                                                    ),
                                                                                                                                );
                                                                                                                            }),
                                                                                                                    ],
                                                                                                                )
                                                                                                            )
                                                                                                        ],
                                                                                                    ),
                                                                                                ),
                                                                                            );
                                                                                        }
                                                                                    ),
                                                                                );
                                                                            }
                                                                        );
                                                                    });
                                                                }
                                                            }, icon: Icon(Icons.account_circle_rounded,color: kItemContainer,)),
                                                        ],
                                                    ),
                                                ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [

                                                            Padding(
                                                                padding: const EdgeInsets.only(left: 8),
                                                                child: Text('Purchase Return',style: TextStyle(
                                                                    color: kFont1Color,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: MediaQuery.of(context).textScaleFactor*17,
                                                                    fontFamily: 'BebasNeue',
                                                                    letterSpacing: 2.0
                                                                ),),
                                                            ),
                                                            if(currentTerminal=='Admin-POS')
                                                                IconButton(onPressed: (){
                                                                    _scaffoldKey.currentState.openEndDrawer();
                                                                }, icon: Icon(Icons.menu),color: kItemContainer,),
                                                            // SingleChildScrollView(
                                                            //     scrollDirection: Axis.horizontal,
                                                            //     child: Container(
                                                            //         child: Row(
                                                            //             children: [
                                                            //                 Visibility(
                                                            //                     visible: currentTerminal=='POS'?false:true,
                                                            //                     child: IconButton(
                                                            //                         tooltip: 'Purchase Return Report',
                                                            //                         icon: SvgPicture.asset('images/sales.svg'), onPressed: ()async{
                                                            //                         Navigator.push(context, MaterialPageRoute(builder: (context)=>PurchaseReport(transactionType: 'purchase_return')));
                                                            //                     }),
                                                            //                 ),
                                                            //             ],
                                                            //         ),
                                                            //     ),
                                                            // ),
                                                        ],
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                            Expanded(
                                child: Row(
                                    children: [
                                        Expanded(
                                            flex:1,
                                            child: Card(
                                                elevation: 5.0,
                                                child: Flex(
                                                    direction: Axis.vertical,
                                                    children: [
                                                        Container(
                                                            height:MediaQuery.of(context).size.height/16,
                                                            margin: EdgeInsets.only(top: 5.0),
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
                                                                            onPressed: () async {
                                                                                await displayAllProducts('Purchasable');
                                                                                selectedCategory='All';
                                                                                setState(() {

                                                                                });
                                                                            },
                                                                            fillColor:selectedCategory=='All'?kGreenColor:kItemContainer,
                                                                            child: Padding(
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: Text(
                                                                                    'All',
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: selectedCategory=='All'?kFont1Color:kGreenColor,
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
                                                                                padding: const EdgeInsets.only(left: 4.0,right: 4.0),
                                                                                child: RawMaterialButton(
                                                                                    onPressed: () async{
                                                                                        await displayProducts(productCategoryF[index]);
                                                                                        selectedCategory=productCategoryF[index];
                                                                                        setState(() {
                                                                                        });
                                                                                    },
                                                                                    fillColor:selectedCategory==productCategoryF[index]?kGreenColor:kItemContainer,
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                            productCategoryF[index],
                                                                                            textAlign: TextAlign.center,
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.bold,
                                                                                                color: selectedCategory==productCategoryF[index]?kFont1Color:kGreenColor,
                                                                                            ),
                                                                                        ),
                                                                                    ),
                                                                                    shape: RoundedRectangleBorder(
                                                                                        side: BorderSide(color: selectedCategory==productCategoryF[index]?kFont3Color:kGreenColor, width:0.5),
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
                                                                        crossAxisCount: 4,
                                                                        childAspectRatio:selectedScreen=='withImage'? MediaQuery.of(context).size.width/1.5 /
                                                                            (MediaQuery.of(context).size.height ):MediaQuery.of(context).size.width /
                                                                            (MediaQuery.of(context).size.height ),
                                                                    ),
                                                                    scrollDirection: Axis.vertical,
                                                                    itemCount: productNameF.length,
                                                                    itemBuilder: (context, index) {
                                                                        return selectedScreen=='withImage'? Padding(
                                                                            padding: const EdgeInsets.all(4),
                                                                            child: GestureDetector(
                                                                                onTap: (){
                                                                                    setState(() {
                                                                                        addToCart(index);
                                                                                    });

                                                                                    print(purchaseCartListText);
                                                                                },
                                                                                child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        color: kWhiteColor,
                                                                                        border: Border.all(
                                                                                            color:kGreenColor,
                                                                                        ),
                                                                                    ),
                                                                                    child: Column(
                                                                                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                                        children: <Widget>[
                                                                                            Container(
                                                                                                width: MediaQuery.of(context).size.width,
                                                                                                height: MediaQuery.of(context).size.height/10,
                                                                                                child: productImages[index].length>0?Image.network(productImages[index],
                                                                                                    fit: BoxFit.cover,
                                                                                                ):Text(productNameF[index].replaceAll('#', '/')),
                                                                                            ),
                                                                                            AutoSizeText(
                                                                                                productNameF[index].replaceAll('#', '/'),
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 2,
                                                                                                style: TextStyle(
                                                                                                    fontFamily: 'Lato',
                                                                                                    color:kGreenColor,
                                                                                                    fontWeight: FontWeight.bold
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                            ),
                                                                        ):
                                                                        Padding(
                                                                            padding: const EdgeInsets.all(4.0),
                                                                            child: Card(
                                                                                //color: kGreenColor,
                                                                                elevation: 3,
                                                                                // shape: RoundedRectangleBorder(
                                                                                //   side: BorderSide(color: kGreenColor, width: 0.5),
                                                                                //   borderRadius: BorderRadius.circular(15.0),
                                                                                // ),
                                                                                child: GestureDetector(
                                                                                    onTap: (){
                                                                                        setState(() {
                                                                                            addToCart(index);
                                                                                        });
                                                                                    },
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
                                                                            ),
                                                                        );
                                                                    }),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ),
                                        Expanded(
                                            flex:1,
                                            child: Card(
                                                elevation: 5.0,
                                                child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Flex(
                                                        direction: Axis.vertical,
                                                        children: [
                                                            Column(
                                                                children: [
                                                                    Container(
                                                                        child:Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                                Expanded(
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
                                                                                SizedBox(width: 20,),
                                                                                Expanded(
                                                                                    child: Container(
                                                                                        child: TextField(
                                                                                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                            focusNode: quantityNode,
                                                                                            controller: quantityController,
                                                                                            showCursor: enableQuantity,
                                                                                            onSubmitted: (val){
                                                                                                addFromSearch(_selectedItem, val);
                                                                                                quantityController.clear();
                                                                                                nameController.clear();
                                                                                                nameNode.requestFocus();
                                                                                            },
                                                                                            decoration: new InputDecoration(
                                                                                                hintText: 'quantity',
                                                                                                border: OutlineInputBorder(),
                                                                                                disabledBorder: OutlineInputBorder(
                                                                                                ),
                                                                                                enabledBorder: OutlineInputBorder(),
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
                                                                                child: dataTable(
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        Container(
                                                                            width: MediaQuery.of(context).size.width/3,
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
                                                                                            title: new Text(searchResult[index].toString().replaceAll('#', '/')),
                                                                                        ),
                                                                                    );
                                                                                },
                                                                            ))
                                                                        ),
                                                                    ],
                                                                ),
                                                            ),
                                                            Container(
                                                                height: MediaQuery.of(context).size.height/7,
                                                                alignment: Alignment.bottomCenter,
                                                                child:Flex(
                                                                    direction: Axis.vertical,
                                                                    children: [
                                                                        Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                                Text('Total', style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                                ),),
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
                                                                                                value: selectedPurchasePayment, // Not necessary for Option 1
                                                                                                items: purchasePaymentMode.map((String val) {
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
                                                                                                    setState(() {
                                                                                                        selectedPurchasePayment = newValue;
                                                                                                    });
                                                                                                },
                                                                                            ),
                                                                                        ),
                                                                                    ),
                                                                                ),
                                                                                Text(getTotal(purchaseReturnTotalList).toStringAsFixed(decimals), style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                                ),),
                                                                            ],
                                                                        ),
                                                                        SizedBox(height: 10,),
                                                                        Expanded(
                                                                            child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                    ElevatedButton(
                                                                                        style: ButtonStyle(
                                                                                            side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                                                                            elevation: MaterialStateProperty.all(3.0),
                                                                                            backgroundColor: MaterialStateProperty.all(kGreenColor),
                                                                                        ),
                                                                                        onPressed: (){
                                                                                            setState(() {
                                                                                                checkoutFlag=true;
                                                                                                purchaseCartListText=[];
                                                                                                //  purchaseReturnOrderNo=purchaseReturnOrderNoList[purchaseReturnOrderNoList.length-1]+1;
                                                                                                purchaseCartController=[];
                                                                                                purchaseReturnUomList=[];
                                                                                                purchaseReturnTotalList=[];
                                                                                                print(purchaseReturnOrderNoList);
                                                                                            });
                                                                                            invEdit.value=false;
                                                                                        },
                                                                                        child: Text('New',
                                                                                            style: TextStyle(
                                                                                                fontSize: MediaQuery.of(context).textScaleFactor*16,
                                                                                                color: kFont1Color,
                                                                                            ),
                                                                                        ),),
                                                                                    ElevatedButton(
                                                                                        style: ButtonStyle(
                                                                                            side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                                                                            elevation: MaterialStateProperty.all(3.0),
                                                                                            backgroundColor: MaterialStateProperty.all(checkoutFlag==true?kGreenColor:kHighlight.withOpacity(0.4)),
                                                                                        ),
                                                                                        onPressed: () async {
                                                                                            if(checkoutFlag==true){
                                                                                                if(selectedPurchasePayment=='Credit' && selectedVendor.isEmpty){
                                                                                                    showDialog(
                                                                                                        context: context,
                                                                                                        builder: (context) => AlertDialog(
                                                                                                            title: Text("Error"),
                                                                                                            content: Text("Select a Vendor name"),
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
                                                                                                    await  checkOut();
                                                                                                    setState(() {
                                                                                                        purchaseCartController=[];
                                                                                                        purchaseReturnTotalList=[];
                                                                                                        purchaseReturnUomList=[];
                                                                                                        purchaseCartListText=[];
                                                                                                    });
                                                                                                    invEdit.value=false;
                                                                                                }
                                                                                            }
                                                                                        },
                                                                                        child: Padding(
                                                                                            padding: const EdgeInsets.all(10.0),
                                                                                            child: Text('CheckOut',
                                                                                                style: TextStyle(
                                                                                                    fontSize: MediaQuery.of(context).textScaleFactor*16,
                                                                                                    color: kFont1Color,
                                                                                                ),),
                                                                                        ), ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                    ],
                                                                )
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                            ),),

                                    ],
                                ),
                            ),
                        ],
                    )
                ),
            ),
        );
    }
    ScrollController _scrollController = ScrollController();


    String getItem(int index,int itemNo){
        // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        List showCartItems=purchaseCartListText[index].split(':');
        return showCartItems[itemNo];
    }
    DataTable dataTable(){

        return DataTable(
            columns: [DataColumn(label: Text('Item',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                    color: kBlack
                ),
            )),
                DataColumn(label: Text('UOM',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                        color: kBlack
                    ),
                ),

                ),
                DataColumn(label: Text('Qty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                        color: kBlack
                    ),
                )),
                DataColumn(label: Text('Price',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                        color: kBlack
                    ),)), DataColumn(label: Text('',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                        color: kBlack
                    ),)),
            ], rows: List.generate(purchaseCartListText.length, (index) => DataRow(cells: [
            DataCell(GestureDetector(
                onTap: (){
                    showDialog(
                        context: context, builder: (context) => Dialog(
                        child: Container(
                            width: MediaQuery.of(context).size.width/4,
                            height: MediaQuery.of(context).size.height/3,
                            padding: EdgeInsets.all(10.0),
                            child:ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: modifier.length,
                                itemBuilder: (context,index1){
                                    return TextButton(onPressed:(){
                                        purchaseCartListText[index]=purchaseCartListText[index]+':${modifier[index1]}';
                                        print('${purchaseCartListText[index]}');
                                        Navigator.pop(context);
                                    }, child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(modifier[index1],style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                            color: kBlack
                                        ),),
                                    ));
                                },
                            ),
                        ),
                    ),
                    );
                },
                child: Text(getItem(index, 0).replaceAll('#', '/'),style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                    color: kBlack
                ),))),
            DataCell( DropdownButton(
                value: purchaseReturnUomList[index].trim(),// Not necessary for Option 1
                items: getUom(getItem(index, 0)).map((String val) {
                    return DropdownMenuItem(
                        child: new Text(val.toString().trim(),style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                            color: kBlack
                        ),),
                        value: val.trim(),
                    );
                }).toList(),
                onChanged: (newValue) {
                    String tempPrice=getPrice(getItem(index, 0), newValue);
                    print('tempPrice $tempPrice');
                    double tempPrice1=double.parse(getItem(index, 3))*double.parse(tempPrice.trimLeft());
                    List showCartItems=purchaseCartListText[index].split(':');
                    showCartItems[2]=tempPrice1.toString();
                    showCartItems[3]=getItem(index, 3);
                    showCartItems[1]=newValue;
                    String tempVal=showCartItems.toString().replaceAll(',', ':');
                    tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                    print(tempVal);
                    setState(() {
                        purchaseReturnTotalList[index]=tempPrice1;
                        purchaseCartController[index].text=tempPrice1.toString();
                        purchaseReturnUomList[index] = newValue;
                        purchaseCartListText[index]=tempVal;
                    });

                },
            ),),
            DataCell(Row(
                children: <Widget>[
                    GestureDetector(
                        child: Icon(
                            Icons.remove_circle_outline),
                        onTap: () {
                            setState(() {
                                removeFromCart(getItem(index, 0),getItem(index, 1));
                            });

                        },
                    ),
                    Text(getItem(index, 3),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                            color: kBlack
                        ),
                    ),
                    GestureDetector(
                        child: Icon(
                            Icons.add_circle_outline),
                        onTap: () {
                            setState(() {
                                addQuantity(getItem(index, 0),getItem(index, 1));
                            });
                        },
                    ),
                ],
            ),),
            DataCell(
                TextFormField(
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                        color: kBlack
                    ),
                    keyboardType: TextInputType.number ,
                    controller: purchaseCartController[index],
                    onChanged: (val){
                        List showCartItems=purchaseCartListText[index].split(':');
                        showCartItems[2]=val;
                        showCartItems[1].toString();
                        String tempVal=showCartItems.toString().replaceAll(',', ':');
                        tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                        print(tempVal);
                        setState(() {
                            purchaseReturnTotalList[index]=double.parse(val);
                            purchaseCartListText[index]=tempVal;
                        });
                    },),
                showEditIcon: true
            ),
            DataCell(IconButton(
                onPressed: (){
                    setState(() {
                        purchaseReturnTotalList.removeAt(index);
                        purchaseCartController.removeAt(index);
                        purchaseCartListText.removeAt(index);
                        purchaseReturnUomList.removeAt(index);
                    });
                },
                icon: Icon(Icons.delete),
            ))
        ])));
    }

}


// void kotItems(List items,int orderNumber){
//   kotList=[];
//   int ex = 0;int tempQuantity=0;
//   print('items:$items');
//   if(orderNo.contains(orderNumber)){
//     for(int i=0;i<_orderDetailsList.length;i++){
//       if(_orderDetailsList[i].contains(orderNumber.toString())){
//         List selectedOrderItems=_orderDetailsList[i].split(',');
//         String tempKot=selectedOrderItems[5].toString().substring(6);
//         List oldItemsList=tempKot.split('-');
//         oldItemsList.removeAt(oldItemsList.length-1);
//         print('oldItemsList $oldItemsList');
//         for(int i=0;i<items.length;i++)
//         {
//           String description;
//           List tempCartListText=items[i].split(':');
//           if(tempCartListText.length==7) {
//             description = tempCartListText[6];
//             print('inside descr');
//           }
//           else
//             description='';
//           for(int j=0;j<oldItemsList.length;j++)
//           {
//             List tempOldItemsList=oldItemsList[j].split(':');
//
//             if(tempCartListText[0]==tempOldItemsList[0])
//             {
//
//               // int tempQuantity=5;
//
//               if(int.parse(tempCartListText[3])!=int.parse(tempOldItemsList[3])) {
//                 tempQuantity = int.parse(tempCartListText[3]) -
//                     int.parse(tempOldItemsList[3]);
//                 String tempKotItemAdded='${tempCartListText[0]}:$tempQuantity:$description';
//                 kotList.add(tempKotItemAdded);
//
//               }
//               j=oldItemsList.length+1;
//               ex=0;
//             }
//             else ex=1;
//           }
//           if(ex==1)
//           {
//             tempQuantity=int.parse(tempCartListText[3]);
//             String tempKotItemAdded='${tempCartListText[0]}:$tempQuantity:$description';
//             kotList.add(tempKotItemAdded);
//             ex=0;
//           }
//         }
//         from:     for(int i=0;i<oldItemsList.length;i++){
//           List tempOldItemsList=oldItemsList[i].split(':');
//           for(int k=0;k<items.length;k++){
//             List tempCartListText=items[k].split(':');
//             if(tempOldItemsList[0]==tempCartListText[0])
//               continue from ;
//           }
//           print(tempOldItemsList[0]);
//           String tempKotItemAdded='${tempOldItemsList[0]}:-${tempOldItemsList[3]}:';
//           kotList.add(tempKotItemAdded);
//         }
//         print('kotlist: $kotList');
//         allOrders(tempOrderNo);
//       }
//     }
//     print(orderNumber);
//   }
//   else{
//     allOrders(tempOrderNo);
//     for(int i=0;i<items.length;i++){
//       String description;
//       List tempList=items[i].split(':');
//       if(tempList.length==7)
//         description=tempList[6];
//       else
//         description='';
//       String tempItemContent='${tempList[0]}:${tempList[3]}:$description';
//       kotList.add(tempItemContent);
//       print(kotList);
//     }
//   }
// }
// void allOrders(int orderN){
//   if(orderNo.contains(orderN)){
//
//     for(int i=0;i<_orderDetailsList.length;i++){
//       if(_orderDetailsList[i].contains(orderN.toString())){
//         String tempOrder=_orderDetailsList[i].toString().substring(0,60);
//         for (int n = 0;  n < purchaseCartListText.length; n++)
//           tempOrder += '${purchaseCartListText[n]}-';
//         _orderDetailsList[i]=tempOrder;
//         print(_orderDetailsList);
//         break;
//       }
//     }
//
//   }
//   else {
//     orderNo.add(orderN);
//
//     DateTime date = DateTime.now();
//     _orderDetails = 'Order No>$orderN,Date>$date,Table >$tableNumber,Customer>$selectedCustomer,PriceList>$selectedPriceList,Items>';
//     for (int n = 0; n < purchaseCartListText.length; n++){
//       _orderDetails +='${purchaseCartListText[n]}-';
//     }
//     _orderDetailsList.add(_orderDetails);
//     print(_orderDetailsList);
//     _orderDetails='';
//   }
// }
// void networkPrint()async{
//   PaperSize paperNetwork = PaperSize.mm58;
//   final Ticket ticket = Ticket(paperNetwork);
//   ticket.text('POSIMATE',
//       styles: PosStyles(
//         align: PosTextAlign.center,
//       ),
//       linesAfter: 1);
//   ticket.text('POSIMATE',
//       styles: PosStyles(
//         align: PosTextAlign.center,
//         height: PosTextSize.size2,
//         width: PosTextSize.size2,
//       ),
//       linesAfter: 1);
//
//   ticket.text('NEAR METRO STATION', styles: PosStyles(align: PosTextAlign.center));
//   ticket.text('Kochi,India', styles: PosStyles(align: PosTextAlign.center));
//   ticket.text('Ph :8877112233', styles: PosStyles(align: PosTextAlign.center));
//   ticket.text('GSTIN :7788899ABCD1ZF',
//       styles: PosStyles(align: PosTextAlign.center));
//   ticket.text('Tax Invoice', styles: PosStyles(align: PosTextAlign.center,
//     bold: true,
//   ), linesAfter: 2);
//
//   ticket.text('Invoice No: RPA32457',
//       styles: PosStyles(align: PosTextAlign.left,bold: true));
//   ticket.text(dateNow(),
//       styles: PosStyles(align: PosTextAlign.left,bold:true), linesAfter: 1);
//
//   ticket.row([
//     PosColumn(text: 'Item   ', width: 4),
//     PosColumn(text: 'Price  ', width: 4),
//     PosColumn(
//         text: 'Qty  ', width: 4, styles: PosStyles(align: PosTextAlign.right)),
//   ]);
//   for(int i=0;i<purchaseCartListText.length;i++)
//   {
//     print(purchaseCartListText);
//     List cartItemsString=purchaseCartListText[i].split(':');
//     double tempTotal=double.parse(cartItemsString[3]);
//     grandTotal+=tempTotal;
//     ticket.row([
//       PosColumn(text:'${cartItemsString[0]}   ', width: 4),
//       PosColumn(text: '${cartItemsString[2]}   ', width: 4),
//       PosColumn(
//           text: '${cartItemsString[3]}   ', width: 4, styles: PosStyles(align: PosTextAlign.right)),
//     ]);
//   }
//   ticket.emptyLines(1);
//   ticket.text('GRAND TOTAL                  $grandTotal', styles: PosStyles(align: PosTextAlign.left,height: PosTextSize.size1,
//       width: PosTextSize.size1),linesAfter: 1);
//   ticket.row([PosColumn(text: 'CGST 2.5%',width: 4),
//     PosColumn(text: 'SGST 2.5%',width: 4),
//     PosColumn(text: 'GST 5%',width: 4),
//   ]);
//   ticket.row([PosColumn(text: '${((2.5/grandTotal)*100).toStringAsPrecision(3)}',width: 4),
//     PosColumn(text: '${((2.5/grandTotal)*100).toStringAsPrecision(3)}',width: 4),
//     PosColumn(text: '${((5/grandTotal)*100).toStringAsPrecision(3)}',width: 4)
//   ]);
//   ticket.cut();
//   printerNetworkManager.selectPrinter('192.168.5.200',port: 9100,timeout: Duration(seconds: 5));
//   printerNetworkManager.printTicket(ticket);
//
//
// }

String dateNow(){
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    return timestamp;
}
class PaymentSelect extends StatefulWidget {
    @override
    _PaymentSelectState createState() => _PaymentSelectState();
}

class _PaymentSelectState extends State<PaymentSelect> {
    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8.0),
            child: DropdownButton(
                value: selectedPurchasePayment, // Not necessary for Option 1
                items: purchasePaymentMode.map((String val) {
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
                        selectedPurchasePayment = newValue;
                    });
                },
            ),
        );
    }
}

class VendorSelect extends StatefulWidget {
    @override
    _VendorSelectState createState() => _VendorSelectState();
}

class _VendorSelectState extends State<VendorSelect> {
    @override
    Widget build(BuildContext context) {
        return Container(
            padding:EdgeInsets.only(right: 8.0),
            child: Row(
                children:[
                    Text('Vendor : ',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).textScaleFactor*16,
                        color: kFont1Color
                    ),
                    ),
                    SizedBox(
                        width:MediaQuery.of(context).size.width/5.5,
                        height: 30,
                        child: SimpleAutoCompleteTextField(
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).textScaleFactor*14,
                                color: kFont1Color
                            ),
                            // focusNode: nameNode,
                            controller: appbarVendorController,
                            decoration: new InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: kFont3Color)
                                ),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kFont3Color)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kFont3Color)
                                ),
                            ),
                            suggestions: vendorList,
                            clearOnSubmit: false,
                            textSubmitted: (text) {
                                if(vendorList.contains(text)) {
                                    setState(() {
                                        selectedVendor=appbarVendorController.text=text;
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

String convertEpox(int val){
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
    return date.toString();
}
