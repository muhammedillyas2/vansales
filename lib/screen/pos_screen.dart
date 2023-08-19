import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr/qr.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'dart:ui';
import 'dart:ui';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart' as ep;
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart' as pb;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:image/image.dart' as eos;
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
 import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/components/database_con.dart';

import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/constants.dart';
// import 'package:restaurant_app/screen/add_customer.dart';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:restaurant_app/screen/expense_report.dart';
import 'package:restaurant_app/screen/new_dashBoard.dart';


import 'package:restaurant_app/screen/receipt_payment_screen.dart';
// import 'package:sunmi_printer_plus/column_maker.dart';
// import 'package:sunmi_printer_plus/enums.dart';
// import 'package:sunmi_printer_plus/sunmi_style.dart';
import 'login_page.dart';
import 'printer_settings.dart';
import 'package:badges/badges.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter_sunmi_printer_t2/flutter_sunmi_printer_t2.dart';
import 'package:intl/intl.dart';

import 'sequence_manager.dart';
import 'report_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'organisation_screen.dart';
import 'package:get/get.dart';
import 'dart:async';
// import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
double totalTax=0;
// pb.PrinterBluetoothManager printerManager = pb.PrinterBluetoothManager();
// pb.PrinterBluetooth selectedPrinter;
List kotOrderList=[].obs;
List currentKotOldList=[];
List currentKotOldList11=[];
String currentKotDate='';
String currentKotNote='';
double height=0;
double width=0;
RxBool isMerge=false.obs;
RxBool isEstimate=false.obs;
RxBool tableClicked=false.obs;
RxInt mergeCount=0.obs;
Rx<List<String>> tableMergeSelect=RxList<String>([]).obs;
Rx<List<String>> invEditCartList=RxList<String>([]).obs;
List<String> checkoutModifierList=[];
List<String> cartComboList=[];
RxInt tableIndex=0.obs;
RxBool invEdit=false.obs;
RxString invEditNumber=''.obs;
RxInt invEditDate=0.obs;
RxString invEditPaymentMethod=''.obs;
RxString invEditTotal=''.obs;
RxString invEditKotNumber=''.obs;
RxString invEditCreatedBy=''.obs;
RxString invEditUser=''.obs;
RxString invEditDeliveryBoy=''.obs;
RxString invEditCustomerName=''.obs;
RxString discountTypeSelected='VAL'.obs;
RxString selectedBranch='BRANCH'.obs;
enum discountType { VAL, PER }
Rx<discountType> _discountType = discountType.VAL.obs;
String selectedCategory='';
List<String> crInv=[];
List<int> crDate=[];
List<String> crPayment=[];
List<String> crTotal=[];
List<String> crTransaction=[];
RxString currentTableOrders=''.obs;
var datePicked;
int toDate1=0;
int fromDate1=0;
DateTime  fromDate;
DateTime toDate ;
List<bool>  isSelected = [false, false,false,true,false];
bool checkoutFlag=true;
bool tillCloseFlag=false;
bool deliveryKotFlag=false;
bool deliveryCheckoutFlag=false;
String createdBy='';
String customerUserUid='';
String customerOrderUid='';
String customerOrderDeliveryBoy='';
String customerUserName='';
String customerUserMobile='';
String customerUserAddress='';
String customerUserFlatNo='';
String customerUserBldNo='';
String customerUserRoadNo='';
String customerUserBlockNo='';
String customerUserArea='';
String customerUserLandmark='';
List<TextEditingController> cartController=[];String taxCum = "";String customerName="";
TextEditingController totalDiscountController=TextEditingController(text: '0');
TextEditingController appbarCustomerController=TextEditingController();
TextEditingController appbarCustomerController2=TextEditingController();
TextEditingController branchNameController=TextEditingController();
RxList searchResult=[].obs;
RxList searchCustomerResult=[].obs;
RxList branchResult=[].obs;
double salesTotal=0;
List<double> salesTotalList=[];
List<int> toppingModifierQtyList=[];
List<int> flavourModifierQtyList=[];
List<int> promotionModifierQtyList=[];
List<String> salesUomList=[];
List<String> modifierKotList=[];
List kotFailedList=[];
String selectedDelivery='QSR';
RxInt deliveryModePos=3.obs;
String selectedDeliveryKot='Spot';
String selectedPayment='Cash';
List<String> deliveryMode=['Spot','Take Away','Drive Through','QSR','Delivery'];
List<String> deliveryModeKot=['Spot','Take Away','Drive Through'];
List<String> paymentMode=[];
List<String> customerOrdersList=[];
TextEditingController quantityController=TextEditingController();
TextEditingController nameController=TextEditingController();
TextEditingController allCustomerMobileController=TextEditingController();
TextEditingController allCustomerMobileNameController=TextEditingController();
TextEditingController allCustomerMobileAddressController=TextEditingController();
TextEditingController flatNoController=TextEditingController();
TextEditingController buildNoController=TextEditingController();
TextEditingController roadNoController=TextEditingController();
TextEditingController blockNoController=TextEditingController();
TextEditingController areaNoController=TextEditingController();
TextEditingController landmarkNoController=TextEditingController();
TextEditingController deliveryNoteController=TextEditingController();
TextEditingController driveNoteController=TextEditingController();
TextEditingController takeAwayNoteController=TextEditingController();
TextEditingController cashWithdrawnController=TextEditingController();
FocusNode quantityNode=FocusNode();
FocusNode nameNode=FocusNode();
int categoryPressed;
List<bool> isSelectedKot= [];
String kotPrint='yes';
bool show = false;
bool customerKotFlag=false;
bool enableQuantity=false;
bool _showCheckoutList=false;
bool _showOrderList=false;
String _orderDetails='';
List<int> salesOrderNoList=[];
List<int> selectedTableList=[];
String currentOrder='';
int salesOrderNo;
int _selectedTable=1;
RxString tableSelected='TABLE'.obs;
List <String> cartListText=[];
List<bool> selected = List<bool>();
List<String> _orderDetailsList=[];
String _selectedItem='';
class PosScreen extends StatefulWidget {
  static const String id = 'pos';
  @override
  _PosScreenState createState() => _PosScreenState();
}
class _PosScreenState extends State<PosScreen> {
  List<String> categoryListDash=[];
  List<double> categoryCountListDash=[];
  List<double> categoryValueListDash=[];
  List<String> itemListDash=[];
  List<double> itemCountListDash=[];
  List<double> itemValueListDash=[];
  final _drawerController = ZoomDrawerController();
  double getTotal(List total){
    double tempRate=0;
    for(int i=0;i<total.length;i++){
      tempRate+=total[i];
    }
    setState(() {
      if(discountTypeSelected=='VAL')
      salesTotal=tempRate-double.parse(totalDiscountController.text.length>0?totalDiscountController.text:'0');
      else{
        if(totalDiscountController.text.length>0){
          double val=double.parse(totalDiscountController.text);
          if(val>0){
            val=val/100;
            val=val*tempRate;
            salesTotal=tempRate-val;
          }
          else{
            salesTotal=tempRate;
          }
        }
        else{
          salesTotal=tempRate;
        }
      }
    });
    return tempRate;
  }
  StreamController _countValueOrderStream = StreamController();
  StreamController _countValueCheckoutStream = StreamController();
  //StreamController _countValueCustomerStream = StreamController();
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
  List<TextEditingController> cartController2 = [];
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
      double tempPrice;
      tempPrice=double.parse(priceList);
      String uom=getBaseUom(productNameF[index]);
      cartController.add(TextEditingController());
      cartController2.add(TextEditingController());
      tempText='${productNameF[index]}:$uom:${tempPrice.toStringAsFixed(decimals)}: 1';
      setState(() {
        salesTotalList.add(double.parse(priceList.trimLeft()));
        cartController[0].text=tempPrice.toStringAsFixed(decimals);
        cartController2[0].text=tempPrice.toStringAsFixed(decimals);
        salesUomList.add(uom);
        cartListText.add(tempText.trim());
        getTotal(salesTotalList);
      });
      print(salesTotalList);
      print(cartListText);
    }
    else {
      for(int i=0;i<cartListText.length;i++) {
        List tempCart=cartListText[i].split(':');
        if (tempCart[0].toString().trim()==productNameF[index].trim()) {
          List tempList = cartListText[i].split(':');
          if (tempList[1].toString().trim() ==
              getBaseUom(productNameF[index]).toString().trim()) {
            double tempQuantity = double.parse(
                tempList[3]);
            tempQuantity = tempQuantity + 1;
            String tempr = getPrice(tempList[0], tempList[1]);
            double tempRate = double.parse(tempr);
            tempRate = tempRate * tempQuantity;
            tempList[2] = tempRate.toStringAsFixed(decimals);
            tempList[3] = tempQuantity.toString();
            //tempList[4] = "HK";
            tempText = tempList.toString();
            tempText =
                tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
            tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
            setState(() {
              salesTotalList[i] = double.parse(tempRate.toString());
              cartController[i].text = tempRate.toStringAsFixed(decimals);
              cartListText[i] = tempText.trim();
              getTotal(salesTotalList);
            });
            return;
          }
        }
      }
      setState(() {
        String uom=getBaseUom(productNameF[index]);
        salesUomList.add(uom);
        String priceList=getBasePrice(productNameF[index], selectedPriceList);
        double tempPrice;
        tempPrice=double.parse(priceList);
        tempText='${productNameF[index]}:$uom:${tempPrice.toStringAsFixed(decimals)}: 1';
        cartController.add(TextEditingController(
            text: tempPrice.toStringAsFixed(decimals)
        ));
        salesTotalList.add(double.parse(priceList.trimLeft()));
        cartListText.add(tempText.trim());
        getTotal(salesTotalList);
      });
    }
  }
  void addComboItems(String name,int index,String type){
    String val=comboData(name);
    List temp2=val.split('``');
    List tempCategory=[];
    List tempItems=[];
    List tempCatItem=temp2[0].toString().split('*');
    List tempUomCombo=temp2[1].toString().split('*');
    List tempQty=temp2[2].toString().split('*');
    tempCatItem.removeLast();
    tempUomCombo.removeLast();
    tempQty.removeLast();
    for(int w=0;w<tempCatItem.length;w++){
      List temp33=tempCatItem[w].toString().split('>');
      tempCategory.add(temp33[0].toString().trim());
      tempItems.add(temp33[1].toString().trim());
    }
    List<int> len=[];
    RxList searchCombo=[].obs;
    int mainLen=tempQty.length;
    int totalItems=0;
    int pointerIndex=0;
    int totalItemsIndex=0;
    RxInt visibleIndex=0.obs;
    for(int j=0;j<tempQty.length;j++){
      len.add(int.parse(tempQty[j]));
      totalItems+=int.parse(tempQty[j]);
    }
    List<TextEditingController> tempComboItems=[];
    for(int k=0;k<totalItems;k++)
      tempComboItems.add(TextEditingController(text:''));
    void searchComboItems(String text,String category,int index9) {
      int pos=tempCategory.indexOf(category);
      visibleIndex.value=0;
      for(int p=0;p<=pos;p++){
        if(p==pos)
          visibleIndex.value+=index9;
        else
          visibleIndex.value+=int.parse(tempQty[p]);
      }
      pointerIndex=visibleIndex.value;
      searchCombo.clear();
      List tempProducts=tempItems[pos].toString().split(';');
      if(text.length>0){
        for (int i = 0; i < tempProducts.length; i++) {
          String data = tempProducts[i].toString().trim();
          if (data.toLowerCase().contains(text.toLowerCase().replaceAll('/', '#'))) {
            searchCombo.add(data);
          }
        }
      }
      else{
        searchCombo.clear();
      }
    }
    showDialog(
      context:
      context,
      builder: (ctx) =>
          Center(
            child: Container(
              width:MediaQuery.of(context).size.width/2,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Dialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              Center(child:Text('Select Combo Items',style:TextStyle(fontSize:20, fontWeight:FontWeight.bold,)),),
                              Stack(
                                children: [

                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: mainLen,
                                    itemBuilder: (context, indexCombo1) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(tempCategory[indexCombo1],
                                              style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
                                          SizedBox(height:10),
                                          ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: len[indexCombo1],
                                              itemBuilder:(context,indexCombo2){
                                                String uom=tempUomCombo[indexCombo1];
                                                totalItemsIndex++;
                                                return Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(width: 200,
                                                              child: TextField(
                                                                style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 14,),
                                                                controller: tempComboItems[totalItemsIndex-1],
                                                                onChanged: (value){
                                                                  searchComboItems(value,tempCategory[indexCombo1],indexCombo2);
                                                                },
                                                                decoration: new InputDecoration(
                                                                  hintText: 'search for items',
                                                                  border: OutlineInputBorder(),
                                                                  disabledBorder: OutlineInputBorder(
                                                                  ),
                                                                  enabledBorder: OutlineInputBorder(),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(uom, style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
                                                            Text('1', style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
                                                          ]),

                                                    ],
                                                  ),
                                                );
                                              }
                                          ),
                                        ],
                                      );
                                    }, ),
                                  Obx(()=>
                                      Visibility(
                                    visible:searchCombo.length>0?true:false,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child:
                                      Container(
                                          width: MediaQuery.of(context).size.width/4,
                                          decoration: BoxDecoration(
                                              color: kItemContainer,
                                              border: Border.all(color: kBackgroundColor)
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: searchCombo.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return GestureDetector(
                                                onTap: (){
                                                  tempComboItems[visibleIndex.value].text=searchCombo[index];
                                                  searchCombo.clear();
                                                },
                                                child: new ListTile(
                                                  title: new Text(searchCombo[index].toString().replaceAll('#', '/')),
                                                ),
                                              );
                                            },
                                          )
                                      ),
                                    ),
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          // These values are based on trial & error method
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                elevation: MaterialStateProperty.all(3.0),
                                backgroundColor: MaterialStateProperty.all(checkoutFlag==true?kGreenColor:kHighlight.withOpacity(0.4),),
                              ),
                              onPressed: () {
                                String proceed='yes';
                                for(int i=0;i<tempComboItems.length;i++){
                                  if(!(allProducts.contains(tempComboItems[i].text))){
                                    proceed='no';
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Error"),
                                          content: Text("select all Items"),
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
                                    break;
                                  }
                                }
                                if(proceed=='yes'){
                                  print('inside proceed yes');
                                  String body='$name;';
                                  List tempCartComboList=[];
                                  int j=0;
                                  for(int k=0;k<tempQty.length;k++){
                                    String uom=tempUomCombo[k];
                                    for(int l=0;l<int.parse(tempQty[k]);l++){
                                      String tempBody='';
                                      if(j==0){
                                        tempBody+='${tempComboItems[j].text.trim()}:$uom:1';
                                        tempCartComboList.add(tempBody);
                                        j++;
                                      }
                                      else{
                                        int pos1=tempCartComboList.length;
                                        pos1=pos1-1;
                                        List temp123=tempCartComboList[pos1].toString().split(':');
                                        if(temp123[0].toString().trim()==tempComboItems[j].text.trim()){
                                          int tQty=int.parse(temp123[2].toString().trim());
                                          tQty+=1;
                                          tempCartComboList[pos1]='${temp123[0].toString().trim()}:${temp123[1].toString().trim()}:$tQty';
                                          j++;
                                        }
                                        else{
                                          tempBody+='${tempComboItems[j].text.trim()}:$uom:1';
                                          tempCartComboList.add(tempBody);
                                          j++;
                                        }
                                      }
                                    }
                                  }
                                  String tempBody1=tempCartComboList.toString();
                                  tempBody1=tempBody1.replaceAll(',','~');
                                  tempBody1=tempBody1.substring(1,tempBody1.length-1);
                                  body+=tempBody1;
                                  body+=';false';
                                  cartComboList.add(body);
                                  if(type=='grid'){
                                    setState(() {
                                      addToCart(index);
                                    });
                                    Navigator.pop(context);
                                  }
                                  else if(type=='plus'){
                                    setState(() {
                                      addQuantity(getItem(index, 0),getItem(index, 1));
                                    });
                                    Navigator.pop(context);
                                  }
                                  else{
                                    addFromSearch(name,'1');
                                    quantityController.clear();
                                    nameController.clear();
                                    _selectedItem='';
                                    nameNode.requestFocus();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => PosScreen()),
                                    );
                                  }
                                }
                              },
                              child: Text('Done',style: TextStyle(
                                color: kFont1Color,
                                fontSize: MediaQuery.of(context).textScaleFactor * 16,
                              ),),
                            ),
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
  bool checkCombo(String name){
    int pos=allProducts.indexOf(name.trim());
    List docLen=productFirstSplit[pos].toString().split(':');
    String val=docLen[docLen.length-2].toString().trim();
    return val=='true'?true:false;
  }
  String showComboItems(String name){
String body='';
    for(int i=0;i<cartComboList.length;i++){
      List temp=cartComboList[i].toString().split(';');
      if(temp[0].toString().trim()==name){
        print('inside if ${cartComboList[i]}');
        List temp11=temp[1].toString().split('~');
       for(int j=0;j<temp11.length;j++){
         body+=temp11[j];
         if(j!=temp11.length-1)
         body+='\n';
       }
        return body;
      }
    }
    return '';
  }
  String comboData(String name){
    int pos=allProducts.indexOf(name.trim());
    List docLen=productFirstSplit[pos].toString().split(':');
    String val=docLen[docLen.length-1].toString().trim();
    return val;
  }
  void addFromSearch(String name,String quantityValue){
    String tempText='';
    if(cartListText.isEmpty){
      String uom=getBaseUom(name);
      String tempr=getPrice(name,getBaseUom(name));
      double tempRate=double.parse(tempr);
      cartController.add(TextEditingController());
      tempRate=double.parse(quantityValue)*tempRate;
      tempText='$name:$uom:${tempRate.toStringAsFixed(decimals)}: $quantityValue';
      setState(() {
        salesTotalList.add(tempRate);
        cartController[0].text=tempRate.toStringAsFixed(decimals);
        salesUomList.add(getBaseUom(name));
        cartListText.add(tempText.trim());
        getTotal(salesTotalList);
      });
      _selectedItem='';
      // return ;
      setState(() {

      });
    }
    else {
      for (int i = 0; i < cartListText.length; i++) {

        List tempCart=cartListText[i].split(':');
        if (tempCart[0].toString().trim()==name.trim()) {
          List tempList = cartListText[i].split(
              ':');
          if (tempList[1].toString().trim() ==
              getBaseUom(name).toString().trim()) {
            String tempr = getPrice(tempList[0], tempList[1]);
            double tempRate = double.parse(tempr);
            double qty = double.parse(tempList[3]) + double.parse(quantityValue);
            tempRate = qty * tempRate;
            tempList[2] = tempRate.toStringAsFixed(decimals);
            tempList[3] = qty.toString();
            tempText = tempList.toString();
            tempText =  tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
            tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
            setState(() {
              salesTotalList[i] = tempRate;
              cartController[i].text = tempRate.toStringAsFixed(decimals);
              cartListText[i] = tempText.trim();
              getTotal(salesTotalList);
              _selectedItem='';
            });
            setState(() {

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
        tempText='$name:$uom:${tempRate.toStringAsFixed(decimals)}: $quantityValue';
        cartController.add(TextEditingController(
            text: tempRate.toStringAsFixed(decimals)
        ));
        salesTotalList.add(tempRate);
        salesUomList.add(getBaseUom(name));
        cartListText.add(tempText.trim());
        getTotal(salesTotalList);
        _selectedItem='';
      });
    }
    setState(() {

    });
  }
  void removeFromCart(String text,String uom){
    String tempText='';
    for(int i=0;i<cartListText.length;i++) {
      List tempCart=cartListText[i].split(':');

      if (tempCart[0].toString().trim()==text.trim()) {
        List tempList = cartListText[i].split(
            ':');
        double acd = double.parse(tempList[2])/double.parse(tempList[3]);
        if (tempList[1].toString().trim() ==
            uom.toString().trim()) {
          double tempQuantity = double.parse(
              tempList[3]);
          tempQuantity = tempQuantity - 1;
          if (tempQuantity == 0 || tempQuantity.isNegative) {
            setState(() {
              salesTotalList.removeAt(i);
              cartController.removeAt(i);
              cartListText.removeAt(i);
              salesUomList.removeAt(i);
              getTotal(salesTotalList);
            });
            return;
          }
          else {
            double tempRate = acd;
            print(tempRate);
            print(tempQuantity);
            tempRate = tempRate * tempQuantity;
            tempList[2] = tempRate.toStringAsFixed(decimals);
            tempList[3] = tempQuantity.toString();
            tempText = tempList.toString();
            tempText =
                tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
            tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
            setState(() {
              salesTotalList[i] = tempRate;
              double aj = acd/tempQuantity;
              cartController[i].text = acd.toStringAsFixed(decimals);
              cartListText[i] = tempText.trim();
              getTotal(salesTotalList);
            });
            print(cartListText);
            return;
          }
        }

      }
    }
  }
  void addQuantity(String text,String uom){
    String tempText='';
    for(int i=0;i<cartListText.length;i++) {
      List tempCart=cartListText[i].split(':');
      if (tempCart[0].toString().trim()==text.trim()) {
        List tempList = cartListText[i].split(
            ':');
        print('templist:$tempList');
        if (tempList[1].toString().trim() ==
            uom.toString().trim()) {
          double acd = double.parse(tempList[2])/double.parse(tempList[3]);
          print(acd);
          double tempQuantity = double.parse(
              tempList[3]);
          tempQuantity = tempQuantity + 1;
           // double tempRate = double.parse(getPrice(tempList[0], tempList[1]));

         double tempRate = acd * tempQuantity;
          tempList[2] = tempRate.toStringAsFixed(decimals);
          tempList[3] = tempQuantity.toString();
          tempText = tempList.toString();
          tempText =
              tempText.substring(1, tempText.length - 1).replaceAll(',', ':');
          tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
          setState(() {
            salesTotalList[i] = tempRate;
            double aj = tempRate/tempQuantity;
            cartController[i].text = acd.toStringAsFixed(decimals);
            cartListText[i] = tempText.trim();
            print(cartListText[i]);
            getTotal(salesTotalList);
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
          for (int j = 0; j < tempBarcodeSplit.length; j++) {
            if (tempBarcodeSplit[j] == barcodeVal) {
              String name = tempFirstSplit[0];
              String tempPrice;
              if(tempPriceSplit[j].toString().trimLeft().contains('>')){
                List tempPriceListSplit=tempPriceSplit[j].toString().split('>');
                int pos=int.parse(selectedPriceList.substring(6));
                pos=pos-1;
                tempPrice=tempPriceListSplit[pos];
              }
              else
                tempPrice=tempPriceSplit[j].toString().trimLeft();
              for (int i = 0; i < cartListText.length; i++) {
                if (cartListText[i].contains(name.trim())) {
                  List tempList = cartListText[i].split(':');
                  if(tempList[1].toString().trim()==tempUomSplit[j].toString().trim()) {
                    int tempQuantity = int.parse(tempList[3]);
                    tempQuantity = tempQuantity + 1;
                    double tempRate =
                    double.parse(getPrice(tempList[0], tempList[1]));
                    tempRate = tempRate * tempQuantity;
                    tempList[2] = tempRate.toStringAsFixed(decimals);
                    tempList[3] = tempQuantity.toString();
                    tempText = tempList.toString();
                    tempText = tempText
                        .substring(1, tempText.length - 1)
                        .replaceAll(',', ':');
                    tempText = tempText.replaceAll(new RegExp(r"\s+"), " ");
                    setState(() {
                      salesTotalList[i] = tempRate;
                      cartController[i].text = tempRate.toStringAsFixed(decimals);
                      cartListText[i] = tempText;
                      getTotal(salesTotalList);
                    });
                    return;
                  }
                }
              }
              double tempPrice1=double.parse(tempPrice);
              setState(() {
                tempText = '$name:${tempUomSplit[j]}:${tempPrice1.toStringAsFixed(decimals)}: 1';
                salesTotalList.add(double.parse(tempPrice));
                cartController.add(TextEditingController(
                    text: tempPrice1.toStringAsFixed(decimals)
                ));
                salesUomList.add(tempUomSplit[j]);
                cartListText.add(tempText.trim());
                getTotal(salesTotalList);
              });
              return;
            }
          }

        }
      }
    }
    else{
      String tempBarcode=barcodeVal.substring(0,7);
      for (int i = 0; i < productFirstSplit.length; i++) {
        if (productFirstSplit[i].toString().contains(tempBarcode)){
          List tempFirstSplit = productFirstSplit[i].toString().split(':');
          String barcodeType = tempFirstSplit[3].toString().trim();
          List tempSplit = tempFirstSplit[4].split('``');
          if (barcodeType == 'selectedMode.Weighted') {
            String name = tempFirstSplit[0];
            List uom = tempSplit[0].toString().split('*');
            uom.removeLast();
            List amount = tempSplit[1].toString().split('*');
            amount.removeLast();
            double price=0;
            if(amount[0].contains('>')){
              print(amount);
              List tempAmountSplit=amount[0].toString().split('>');
              int pos=int.parse(selectedPriceList.substring(6));
              pos=pos-1;
              price=double.parse(tempAmountSplit[pos].toString().trimLeft());
            }
            else
              price=double.parse(amount[0].toString().trimLeft());
            String weight = barcodeVal.substring(7,12);
            double tempWeight = (int.parse(weight) / 1000);
            double tempPrice = tempWeight * price;
            tempText = '$name:${uom[0]}:${tempPrice.toStringAsFixed(decimals)}:$tempWeight';
            setState(() {
              cartController.add(TextEditingController(
                  text: tempPrice.toStringAsFixed(decimals)
              ));
              salesTotalList.add(tempPrice);
              salesUomList.add(uom[0]);
              cartListText.add(tempText.trim());
              getTotal(salesTotalList);
            });
            return;
          }
        }
      }}
  }
  // ignore: missing_return
  String getPrice(String productName,String uomName){
    print(productFirstSplit);
    for(int i=0;i<productFirstSplit.length;i++){
      List temp111=productFirstSplit[i].toString().split(':');
      if(temp111[0].toString().trim()==productName.trim()){
        List temp=productFirstSplit[i].split(':');
        List tempPrice=temp[4].split('``');
        List tempUomSplit=tempPrice[0].toString().split('*');
        List tempPriceSplit=tempPrice[1].toString().split('*');
        for(int j=0;j<tempUomSplit.length;j++) {
          if(tempUomSplit[j].contains(uomName.trim())) {
            String basePrice;
            if(tempPriceSplit[j].toString().trimLeft().contains('>')){
              List tempPriceListSplit=tempPriceSplit[j].toString().split('>');
              int pos=int.parse(selectedPriceList.substring(6));
              pos=pos-1;
              basePrice=tempPriceListSplit[pos];
            }
            else
              basePrice=tempPriceSplit[j].toString().trimLeft();
            return basePrice;
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
      if(temp111[0].toString().trim()==productName.trim()){
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
      List temp111=productFirstSplit[i].toString().split(':');
      if(temp111[0].toString().trim()==productName.trim()){
        List temp=productFirstSplit[i].split(':');
        List tempUom=temp[4].split('``');
        List tempUomSplit=tempUom[0].toString().split('*');
        return tempUomSplit[0].toString().trim();
      }
    }

  }

  // ignore: missing_return
  List<String> getUom(String productName){
    for(int i=0;i<productFirstSplit.length;i++){
      List temp=productFirstSplit[i].toString().split(':');
      String name=temp[0].toString().trim();
      if(name==productName){
        List tempUom=temp[4].split('``');
        List tempUomSplit=tempUom[0].toString().split('*');
        tempUomSplit.removeLast();
        return tempUomSplit;
      }
    }
  }
  void showCustomerCheckoutList(List order){
    List showOrder=order;
    String orderNo=showOrder[1].toString().trim();
    print(orderNo);
    selectedCustomer=showOrder[3].toString().trim();
    // print('selectedPriceList ${showOrder[4].toString().substring(10)}');
    // selectedPriceList=showOrder[4].toString().substring(10);
    String itemsTemp;
    itemsTemp=showOrder[4].toString().trim();
    itemsTemp=itemsTemp.substring(1,itemsTemp.length-1);
    List showItems=[];
    if(itemsTemp.contains('>')){
      showItems=itemsTemp.split('>');
    }
    else
      showItems.add(itemsTemp);
    setState(() {
      salesTotalList=[];
      salesUomList=[];
      cartController=[];
      cartListText=[];
      salesOrderNo=int.parse(orderNo.trim().replaceAll(RegExp('[^0-9]'), ''));
    });
    for(int i=0;i<showItems.length;i++)
    {
      List tempCart=showItems[i].toString().split(':');
      setState(() {
        salesTotalList.add(double.parse(tempCart[2].toString().trim()));
        salesUomList.add(tempCart[1].toString().trim());
        cartController.add(TextEditingController(text: tempCart[2].toString().trim()));
        cartListText.add(showItems[i].toString().trim());
      });
    }
  }
  void showCheckoutList(List order){
    List showOrder=order;
    String currentTable=showOrder[10].toString().trim();
    String orderNo=showOrder[1].toString().trim();
    selectedCustomer=showOrder[3].toString().trim();
    _selectedTable=int.parse(showOrder[10].toString().trim());
    // print('selectedPriceList ${showOrder[4].toString().substring(10)}');
    // selectedPriceList=showOrder[4].toString().substring(10);
    String itemsTemp;
    itemsTemp=showOrder[4].toString().trim();
    itemsTemp=itemsTemp.substring(1,itemsTemp.length-1);
    List showItems=[];
    if(itemsTemp.contains('~')){
      showItems=itemsTemp.split('~');
    }
    else
      showItems.add(itemsTemp);
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
      setState(() {
        salesTotalList.add(double.parse(tempCart[2].toString().trim()));
        salesUomList.add(tempCart[1].toString().trim());
        cartController.add(TextEditingController(text: tempCart[2].toString().trim()));
        cartListText.add(showItems[i].toString().trim());
      });
    }
  }
  String getUser(String tempOrder){
    if(tempOrder.length==0){
      return currentUser;
    }
    for(int i=0;i<userList.length;i++){
      if(userPrefixList[i]==tempOrder){
        return userList[i];
      }
    }
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
  String getVat(String name){
   if(name.isNotEmpty) {
     int pos = customerList.indexOf(name);
     return customerVatNo[pos];
   }
   return '';
  }
  double getDiff(double a,double b){
    return a-b;
  }
  Future<Uint8List> retailEstimate(List items,double total){
    final pdf = pw.Document(version: PdfVersion.pdf_1_5,);
    final doc = pw.Document();
    final rows = <pw.TableRow>[];
    rows.add(pw.TableRow(
        children: [
          pw.SizedBox(width:20,
            child:pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text('SN.',textScaleFactor: 0.8,textAlign: pw.TextAlign.center),
            ),),
          pw.SizedBox(
            width:80,
            child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text('Particulars',textScaleFactor:0.8,textAlign: pw.TextAlign.center),
            ),),
          pw.SizedBox(
            width:20,
            child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:               pw.Text('Qty',textScaleFactor:0.8,textAlign: pw.TextAlign.center),
            ),),
          pw.SizedBox(
            width:20,
            child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:               pw.Text('UOM',textScaleFactor:0.8,textAlign: pw.TextAlign.center),
            ),),
          pw.SizedBox(
            width:30,
            child:pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:               pw.Text('Unit Price',textScaleFactor: 0.8,textAlign: pw.TextAlign.center),
            ),
          ),
          pw.SizedBox(width:20,
            child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:               pw.Text('Tax',textScaleFactor: 0.8,textAlign: pw.TextAlign.center),
            ),
          ),
          pw.SizedBox(
            width:40,
            child:pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:                pw.Text('Amount',textScaleFactor: 0.8,textAlign: pw.TextAlign.center),
            ),),
        ]
    ));
    for(int i=0;i<cartListText.length;i++){
      print('cartListText ${cartListText[i]}');
      List cartItemsString = cartListText[i].split(':');
      double price = double.parse(cartItemsString[2]) /
          double.parse(cartItemsString[3]);
      String tax = getTaxName(cartItemsString[0].toString().trim());
      rows.add(pw.TableRow(
          children: [
            pw.SizedBox(width:20,child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text((i+1).toString(),textScaleFactor: 0.8,),
            )),
            pw.SizedBox(
              width:80,
              child:pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child:pw.Text(cartItemsString[0].toString().replaceAll('#', '/'),textScaleFactor: 0.8,),
              ),),
            pw.SizedBox(
              width:20,
              child: pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child: pw.Text(cartItemsString[3],textScaleFactor: 0.8,textAlign: pw.TextAlign.center),
              ),),
            pw.SizedBox(
              width:20,
              child: pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child: pw.Text(cartItemsString[1],textScaleFactor: 0.8,textAlign: pw.TextAlign.center),
              ),),
            pw.SizedBox(width:30,
              child:  pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child:pw.Text(price.toStringAsFixed(decimals),textScaleFactor: 0.8,textAlign: pw.TextAlign.right),
              ),
            ),
            pw.SizedBox(
              width:20,
              child: pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child: pw.Text(getPercent(tax),textScaleFactor: 0.8,textAlign: pw.TextAlign.center),
              ),
            ),
            pw.SizedBox(
              width:40,
              child:  pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child: pw.Text(double.parse(cartItemsString[2]).toStringAsFixed(
                    decimals),textScaleFactor: 0.8,textAlign: pw.TextAlign.right),
              ),),
          ]
      ));
    }
    Printing.layoutPdf(
        onLayout: (format) async {
          top()  {
            return pw.Container(child:pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children:[
                  pw.Container(
                      width:double.infinity,
                    padding:pw.EdgeInsets.all(4.0),
                    decoration: pw.BoxDecoration(
                        border: pw.Border(left:pw.BorderSide(width: 0.9),right:pw.BorderSide(width: 0.9),top:pw.BorderSide(width: 0.9))
                    ),
                    child:pw.Column(
                      mainAxisAlignment:pw.MainAxisAlignment.center,
                        children:[
                        pw.Text('$organisationName',textScaleFactor: 1,style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold
                        )),
                        pw.Text('$organisationAddress',textScaleFactor: 0.8,style: pw.TextStyle(
                          // fontWeight: pw.FontWeight.bold
                        )),
                        if(organisationMobile.length>0)
                          pw.Text('Mobile Number:$organisationMobile',textScaleFactor: 0.8,style: pw.TextStyle(
                            // fontWeight: pw.FontWeight.bold
                          )),
                        if(organisationGstNo.length>0)
                          pw.Text('$organisationTaxType Number:$organisationGstNo',textScaleFactor: 0.8,style: pw.TextStyle(
                            // fontWeight: pw.FontWeight.bold
                          )),
                        // if(organisationGstNo.length>0)
                        //   pw.Text('$organisationTaxTitle',textScaleFactor: 0.8,style: pw.TextStyle(
                        //     // fontWeight: pw.FontWeight.bold
                        //   )),
                        pw.Text('ESTIMATE',textScaleFactor: 1.0,style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold
                          )),
                      ]
                    )
                  ),
                  pw.Container(
                    width:double.infinity,
                    padding:pw.EdgeInsets.all(4.0),
                    decoration: pw.BoxDecoration(
                        border: pw.Border(left:pw.BorderSide(width: 0.9),right:pw.BorderSide(width: 0.9),top:pw.BorderSide(width: 0.9))
                    ),
                    child:pw.Text('Date : ${dateNow()}',textScaleFactor:0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                      // fontWeight: pw.FontWeight.bold
                    )),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(

                        border: pw.Border.all(width: 0.9,
                        )
                    ),
                    child:pw.Column(
                      children:[
                        pw.Container(color: PdfColors.black,height: 0.5),
                        pw.Table(
                            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                            // textDirection: pw.TextDirection.ltr,
                            border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                            children: rows),
                        if(items.length<4)
                          pw.Container(height:(100.0-(items.length*20))),
                        pw.Row(
                            mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
                            children:[
                              pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                                child:pw.Text('Sub Total',textScaleFactor: 1.0),
                              ),
                              pw.Padding(padding:pw.EdgeInsets.only(left:50,right:2,top:2,bottom: 2),
                                child:pw.Text(total.toStringAsFixed(decimals),textScaleFactor: 1.0),
                              ),
                            ]),
                      ]
                    )
                  ),
                ]
            ));
          }
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) => top(),
              pageFormat: PdfPageFormat.a4,
              // margin: pw.EdgeInsets.only(left: 5, top: 5, right: 25, bottom: 5),
            ),
          );
          List<int> bytes = await pdf.save();
          // html.AnchorElement(
          //     href:
          //     "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
          //   ..setAttribute("download", "Estimate${dateNow()}.pdf")
          //   ..click();
          return doc.save();
    });
  }
  Future<Uint8List> retailPdf(String title,List items,String inv,String customer,double total,double discount,double tempTax,double billAmount,String taxDetails,int len,String tempPayment,String tempTotal) async {
    print('reached generatePdf $tempTax');
    final pdf = pw.Document(version: PdfVersion.pdf_1_5,);
    final fontNo = await PdfGoogleFonts.oswaldBold();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final fontArabic = await PdfGoogleFonts.notoSansArabicBlack();
    double a=0;
    double b=0;
    double c=0;
    double tax5=0;
    double tax10=0;
    double tax12=0;
    double tax18=0;
    double tax28=0;
    double cess=0;
    bool gst1=false;
    bool gst2=false;

    if(organisationTaxType=='GST'){
      gst1=true;
      if(organisationGstNo.length>0){
        print('1 and 2 true');
        gst2=true;
        gst1=false;
      }
    }
    List taxDetailsList=[];
    if(taxDetails.isNotEmpty){
      taxDetailsList=taxDetails.split('~');
    }

    Printing.layoutPdf(
      onLayout: (format) async {
        final doc = pw.Document();
        final rows = <pw.TableRow>[];
        final rows1 = <pw.TableRow>[];
        final rows2 = <pw.TableRow>[];
        final rows3 = <pw.TableRow>[];
        if(tempPayment.contains('*')){
          List tempP=tempPayment.split('*');
          List tempT=tempTotal.split('*');
          rows3.add(pw.TableRow(
              children:[
                pw.Padding(
                    padding:pw.EdgeInsets.only(left:4),
                  child:pw.Text('${tempP[0].toString().trim()}  ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
                ),
                pw.Padding(
                    padding:pw.EdgeInsets.only(right:2),
                    child:  pw.Text(tempT[0].toString().trim(),textScaleFactor: 0.8,textAlign:pw.TextAlign.right,style: pw.TextStyle(
                        font:fontNo
                    )),
                ),
              ]
          ));
          rows3.add(pw.TableRow(
              children:[
                pw.Padding(
                    padding:pw.EdgeInsets.only(left:4),
                    child: pw.Text('${tempP[1].toString().trim()}  ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                      // fontWeight: pw.FontWeight.bold
                    )),
                ),
                pw.Padding(
                    padding:pw.EdgeInsets.only(right:2),
                    child:  pw.Text(tempT[1].toString().trim(),textAlign:pw.TextAlign.right,textScaleFactor: 0.8,style: pw.TextStyle(
                        font:fontNo
                    )),
                ),
              ]
          ));
        }
        else{
          rows3.add(pw.TableRow(
              children:[
                pw.Padding(
                    padding:pw.EdgeInsets.only(left:4),
                    child: pw.Text('$tempPayment  ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                      // fontWeight: pw.FontWeight.bold
                    )),
                ),
                pw.Padding(
                    padding:pw.EdgeInsets.only(right:2),
                    child: pw.Text(tempTotal,textScaleFactor: 0.8,textAlign:pw.TextAlign.right,style: pw.TextStyle(
                        font:fontNo
                    )),
                ),
              ]
          ));
        }
        rows.add(pw.TableRow(
            children: [
              pw.SizedBox(width:20,
                child:pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child:pw.Text('SN.',textScaleFactor: 0.6,),
              ),),
              pw.SizedBox(
                width:orgComposite=='true'?70:80,
                child: pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child:pw.Text('Particulars',textScaleFactor:0.6,),
              ),),
              if(orgComposite=='true')
                pw.SizedBox(width:30,
                  child: pw.Padding(
                    padding:pw.EdgeInsets.all(3.0),
                    child:               pw.Text('HSN',textScaleFactor: 0.6,),
                  ),
                ),
              pw.SizedBox(
                width:20,
                child: pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child:               pw.Text('Qty',textScaleFactor:0.6,),
              ),),
              pw.SizedBox(
                width:30,
                child:pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child:               pw.Text('Rate',textScaleFactor: 0.6,),
                ),
              ),
              if(orgComposite=='false')
              pw.SizedBox(width:20,
              child: pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child:               pw.Text('Tax',textScaleFactor: 0.6,),
              ),
              ),
              pw.SizedBox(
                width:40,
                child:pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child:                pw.Text('Amount',textScaleFactor: 0.6,),
              ),),
            ]
        ));
        for(int i=0;i<items.length;i++){
          List cartItemsString = items[i].split(':');
          double price = double.parse(cartItemsString[2]) /
              double.parse(cartItemsString[3]);
          String tax = getTaxName(cartItemsString[0].toString().trim());
          rows.add(pw.TableRow(
              children: [
                pw.SizedBox(width:20,child: pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child:pw.Text((i+1).toString(),textScaleFactor: 0.6,),
                )),
                pw.SizedBox(
                  width:orgComposite=='true'?70:80,
                  child:pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child:pw.Text(cartItemsString[0].toString().replaceAll('#', '/'),textScaleFactor: 0.6,),
                ),),
               if(orgComposite=='true')
                 pw.SizedBox(
                   width:30,
                   child:pw.Padding(
                     padding:pw.EdgeInsets.all(3.0),
                     child:pw.Text(getHSNCode(cartItemsString[0].toString()),textScaleFactor: 0.6,),
                   ),),
                pw.SizedBox(
                  width:20,
                  child: pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child: pw.Text(cartItemsString[3],textAlign: pw.TextAlign.center,textScaleFactor: 0.6),
                ),),
                pw.SizedBox(width:30,
                  child:  pw.Padding(
                    padding:pw.EdgeInsets.all(3.0),
                    child:pw.Text(price.toStringAsFixed(decimals),textAlign: pw.TextAlign.right,textScaleFactor: 0.6),
                  ),
                  ),
                if(orgComposite=='false')
                pw.SizedBox(
                  width:20,
                child: pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child: pw.Text(getPercent(tax),textScaleFactor: 0.6),
                ),
                ),
                pw.SizedBox(
                  width:40,
                  child:  pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child: pw.Text(double.parse(cartItemsString[2]).toStringAsFixed(
                      decimals),textAlign: pw.TextAlign.right,textScaleFactor: 0.6),
                ),),
              ]
          ));
        }
        if(gst2==true && orgComposite=='false'){
          if(tempTax>0){
            for(int j=0;j<taxDetailsList.length-1;j++){
              if(double.parse(taxDetailsList[j])>0){
                rows1.add(pw.TableRow(
                    children: [
                      pw.Padding(padding:pw.EdgeInsets.all(2),
                        child:pw.Text(j==0?'CGST 2.5%':j==1?'CGST 6%':j==2?'CGST 9%':'CGST 14%',textScaleFactor: 0.8),
                      ),
                      pw.Padding(padding:pw.EdgeInsets.all(2),
                        child:pw.Text( (double.parse(taxDetailsList[j].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8),
                      ),
                      pw.Padding(padding:pw.EdgeInsets.all(2),
                        child:pw.Text(j==0?'SGST 2.5%':j==1?'SGST 6%':j==2?'SGST 9%':'SGST 14%',textScaleFactor: 0.8),
                      ),
                      pw.Padding(padding:pw.EdgeInsets.all(2),
                        child:pw.Text( (double.parse(taxDetailsList[j].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8),
                      ),
                    ]
                ));
              }
            }
            if(double.parse(taxDetailsList[4])>0)
              rows1.add(pw.TableRow(
                  children: [
                    pw.Padding(padding:pw.EdgeInsets.all(2),
                      child:pw.Text('CESS 12%',textScaleFactor: 0.8),
                    ),
                    pw.Padding(padding:pw.EdgeInsets.all(2),
                      child:pw.Text( (double.parse(taxDetailsList[4].toString())).toStringAsFixed(decimals),textScaleFactor: 0.8),
                    ),
                  ]
              ));
            rows2.add(pw.TableRow(
                children: [
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('Bill Amount',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text(billAmount.toStringAsFixed(decimals),textScaleFactor: 0.8),
                  ),
                ]
            ));
            if(tempTax>0)
              rows2.add(pw.TableRow(
                  children: [
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child: pw.Text('Total Tax',textScaleFactor: 0.8),
                    ),
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text(tempTax.toStringAsFixed(decimals),textScaleFactor: 0.8),
                    ),
                  ]
              ));
            if(discount>0)
              rows2.add(pw.TableRow(
                  children: [
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text('Discount',textScaleFactor: 0.8),
                    ),
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text(discount.toStringAsFixed(decimals),textScaleFactor: 0.8),
                    ),
                  ]
              ));
            rows2.add(pw.TableRow(
                children: [
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('Net Payable',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('$organisationSymbol ${total.toStringAsFixed(decimals)}',textScaleFactor: 0.8),
                  ),
                ]
            ));
          }
          else{
            if(tempTax>0 && discount>0)
            rows2.add(pw.TableRow(
                children: [
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('Bill Amount',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text(billAmount.toStringAsFixed(decimals),textScaleFactor: 0.8),
                  ),
                ]
            ));
            if(tempTax>0)
              rows2.add(pw.TableRow(
                  children: [
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child: pw.Text('Total Tax',textScaleFactor: 0.8),
                    ),
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text(tempTax.toStringAsFixed(decimals),textScaleFactor: 0.8),
                    ),
                  ]
              ));
            if(discount>0)
              rows2.add(pw.TableRow(
                  children: [
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text('Discount',textScaleFactor: 0.8),
                    ),
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text(discount.toStringAsFixed(decimals),textScaleFactor: 0.8),
                    ),
                  ]
              ));
            rows2.add(pw.TableRow(
                children: [
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,top:2,bottom: 2),
                    child:pw.Text('Grand Total',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.only(right:4,top:2,bottom: 2),
                    child:pw.Text('$organisationSymbol ${total.toStringAsFixed(decimals)}',textScaleFactor: 0.8),
                  ),
                ]
            ));
          }
        }

        top()  {
          print('reached top begin');
          print(allCustomerAddress);
          print(customerList);
          print('name $customer');

          return new pw.Container(
            //   defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
            //   // textDirection: pw.TextDirection.ltr,
            //   border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
            // children: [
            //   pw.TableRow(
            //     children: [
            //       pw.Column(
            //         children:[
            //           pw.Text('$organisationName',textScaleFactor: 1.2,style: pw.TextStyle(
            //               fontWeight: pw.FontWeight.bold
            //           )),
            //           pw.Text('$organisationAddress',textScaleFactor: 1,style: pw.TextStyle(
            //             // fontWeight: pw.FontWeight.bold
            //           )),
            //           if(organisationMobile.length>0)
            //             pw.Text('Mobile Number:$organisationMobile',textScaleFactor: 1,style: pw.TextStyle(
            //               // fontWeight: pw.FontWeight.bold
            //             )),
            //           if(organisationGstNo.length>0)
            //             pw.Text('$organisationTaxType Number:$organisationGstNo',textScaleFactor: 1,style: pw.TextStyle(
            //               // fontWeight: pw.FontWeight.bold
            //             )),
            //           if(organisationGstNo.length>0)
            //             pw.Text('$organisationTaxTitle',textScaleFactor: 1,style: pw.TextStyle(
            //               // fontWeight: pw.FontWeight.bold
            //             )),
            //         ]
            //       ),
            //     ]
            //   ),
            //   pw.TableRow(
            //     children: [
            //       pw.Column(
            //         children: [
            //                    if (customer.length>0)
            //                      pw.Column(
            //                          crossAxisAlignment: pw.CrossAxisAlignment.start,
            //                          children: [
            //                            pw.Text('Customer Name: $customer',textScaleFactor: 1,style: pw.TextStyle(
            //                                fontWeight: pw.FontWeight.bold
            //                            )),
            //                            if(allCustomerAddress[customerList.indexOf(customer)].length>0)
            //                            pw.Text('Address: ${allCustomerAddress[customerList.indexOf(customer)]}',textScaleFactor: 1,maxLines: 3,style: pw.TextStyle(
            //                                // fontWeight: pw.FontWeight.bold
            //                            )),
            //                            pw.Text('Mobile Number: ${allCustomerMobile[customerList.indexOf(customer)]}',maxLines: 3,textScaleFactor: 1,style: pw.TextStyle(
            //                                // fontWeight: pw.FontWeight.bold
            //                            )),
            //         ]
            //       ),
            //
            //     ]
            //   ),
            //       pw.Column(children: [
            //         pw.Text('Date : ${dateNow()}',textScaleFactor: 1.0,style: pw.TextStyle(
            //           // fontWeight: pw.FontWeight.bold
            //         )),
            //         pw.Text('Invoice No : $inv',textScaleFactor: 1.0,style: pw.TextStyle(
            //           // fontWeight: pw.FontWeight.bold
            //         )),
            //       ])
            // ],),
              child: pw.ListView(
                children: [
                  pw.Container(
                    padding:pw.EdgeInsets.all(4.0),
                    decoration: pw.BoxDecoration(

                        border: pw.Border(left:pw.BorderSide(width: 0.9),right:pw.BorderSide(width: 0.9),top:pw.BorderSide(width: 0.9))
                    ),
                    child:   pw.Center(
                        child: pw.Column(
                            children:[
                              pw.Text('$organisationName',textScaleFactor: 1,style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold
                              )),
                              pw.Text('$organisationAddress',textScaleFactor: 0.8,style: pw.TextStyle(
                                // fontWeight: pw.FontWeight.bold
                              )),
                              if(organisationMobile.length>0)
                                pw.Text('Mobile Number:$organisationMobile',textScaleFactor: 0.8,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                                )),
                              if(organisationGstNo.length>0)
                                pw.Text('${organisationTaxType=='GST'?'GSTIN':'VAT Number'} : $organisationGstNo',textScaleFactor: 0.6,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                                )),
                              if(orgComposite=='true')
                                pw.Text('COMPOSITION DEALER NOT ELIGIBLE TO COLLECT TAX', textAlign: pw.TextAlign.center,textScaleFactor: 0.6,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                                )),
                              if(organisationGstNo.length>0)
                                pw.Text('$organisationTaxTitle',textScaleFactor: 0.6,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                                )),

                            ]
                        )
                    ),
                  ),
                  pw.Container(
                    //height: 20,
                    padding:pw.EdgeInsets.all(4.0),
                    decoration: pw.BoxDecoration(

                        border: pw.Border(left:pw.BorderSide(width: 0.9),right:pw.BorderSide(width: 0.9),top:pw.BorderSide(width: 0.9))
                    ),
                    child:
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children:[
                          if (customer.length>0)
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Customer Name: $customer',textScaleFactor: 0.6,style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold
                                  )),
                                  if(allCustomerAddress[customerList.indexOf(customer)].length>0)
                                    pw.Text('Address: ${allCustomerAddress[customerList.indexOf(customer)]}',textScaleFactor: 0.6,maxLines: 3,style: pw.TextStyle(
                                      // fontWeight: pw.FontWeight.bold
                                    )),
                                  pw.Text('Mobile Number: ${allCustomerMobile[customerList.indexOf(customer)]}',maxLines: 3,textScaleFactor: 0.6,style: pw.TextStyle(
                                    // fontWeight: pw.FontWeight.bold
                                  )),
                                ]
                            ),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Date : ${dateNow()}',textScaleFactor:0.6,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                                )),
                                pw.Text('${orgComposite=='true'?'No : ' : 'Invoice No : '} $inv',textScaleFactor:0.6,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                                )),
                              ]
                          ),

                        ]
                    ),
                  ),
          pw.Container(

          decoration: pw.BoxDecoration(

          border: pw.Border.all(width: 0.9,
          )
          ),
          child: pw.Column(
          children:[
          pw.Container(color: PdfColors.black,height: 0.5),
          pw.Table(
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          // textDirection: pw.TextDirection.ltr,
          border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
          children: rows),
          if(items.length<4)
            pw.Container(height:(100.0-(items.length*20))),
          if(tempTax>0)
          pw.Table(
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          // textDirection: pw.TextDirection.ltr,
          //   border: pw.TableBorder.symmetric(inside: pw.BorderSide(width: 1, color: PdfColors.black)),

          border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
          children:rows1),
            if(tempTax>0 || discount>0)
              pw.Row(
                  mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
                  children:[
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text('Bill Amount',textScaleFactor: 0.8),
                    ),
                    pw.Padding(padding:pw.EdgeInsets.only(left:50,right:2,top:2,bottom: 2),
                      child:pw.Text(billAmount.toStringAsFixed(decimals),textScaleFactor: 0.8),
                    ),
                  ]),
            if(tempTax>0)
              pw.Row(
                  mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
                  children:[
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text('Total Tax',textScaleFactor: 0.8),
                    ),
                    pw.Padding(padding:pw.EdgeInsets.only(left:50,right:2,top:2,bottom: 2),
                      child:pw.Text(tempTax.toStringAsFixed(decimals),textScaleFactor: 0.8),
                    ),
                  ]),
            if(discount>0)
            pw.Row(
                mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
                children:[
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('Discount',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.only(left:50,right:2,top:2,bottom: 2),
                    child:pw.Text(discount.toStringAsFixed(decimals),textScaleFactor: 0.8),
                  ),
                ]),
           pw.Row(
               mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,
               children:[
                 pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                   child:pw.Text('Grand Total',textScaleFactor: 0.8),
                 ),
                 pw.Padding(padding:pw.EdgeInsets.only(left:50,right:2,top:2,bottom: 2),
                   child:pw.Text('$organisationSymbol ${total.toStringAsFixed(decimals)}',textScaleFactor: 0.8,style:pw.TextStyle(
                     font:fontNo,
                   )),
                 ),

           ]),
            pw.Align(
              alignment:pw.Alignment.topLeft,
            child:  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
              child:pw.Text('Payment Details :',textScaleFactor: 0.8),
            ),
            ),
            pw.Table(
              // defaultVerticalAlignment: pw.TableCellVerticalAlignment..left,
                children: rows3),
            pw.SizedBox(height:10),
            pw.Center(
              child:  pw.Text('Thank You Visit Again',textScaleFactor: 0.8,style: pw.TextStyle(
              )),),
          ]
          )
          )
                ],
              )
          );
        }
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) => top(),
              pageFormat: PdfPageFormat.roll80,
              margin: pw.EdgeInsets.only(left: 5, top: 5, right: 25, bottom: 5),
            ),
          );
          List<int> bytes = await pdf.save();
          // html.AnchorElement(
          //     href:
          //     "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
          //   ..setAttribute("download", "PSlipasd.pdf")
          //   ..click();
        return doc.save();
      },
    );
  }
  Future<Uint8List> generatePdf( String title,List items,String inv,String customer,double total,double discount,double tempTax,double billAmount,String taxDetails,int len) async {
    print('reached generatePdf $tempTax');
    final pdf = pw.Document(version: PdfVersion.pdf_1_5,);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final fontArabic = await PdfGoogleFonts.notoSansArabicBlack();
    double a=0;
    double b=0;
    double c=0;
    double tax5=0;
    double tax10=0;
    double tax12=0;
    double tax18=0;
    double tax28=0;
    double cess=0;
    bool gst1=false;
    bool gst2=false;
    if(organisationTaxType=='GST'){
      gst1=true;
      if(organisationGstNo.length>0){
        gst2=true;
        gst1=false;
      }
    }
    List taxDetailsList=[];
    print('111111111111111111111 $taxDetails');
    if(taxDetails.isNotEmpty){
      taxDetailsList=taxDetails.split('~');
    }
    Printing.layoutPdf(
      onLayout: (format) async {
        final doc = pw.Document();
        top()  {
          print('reached top begin');
          print(allCustomerAddress);
          print(customerList);
          print('name $customer');

          return new pw.Container(
              //   defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
              //   // textDirection: pw.TextDirection.ltr,
              //   border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
              // children: [
              //   pw.TableRow(
              //     children: [
              //       pw.Column(
              //         children:[
              //           pw.Text('$organisationName',textScaleFactor: 1.2,style: pw.TextStyle(
              //               fontWeight: pw.FontWeight.bold
              //           )),
              //           pw.Text('$organisationAddress',textScaleFactor: 1,style: pw.TextStyle(
              //             // fontWeight: pw.FontWeight.bold
              //           )),
              //           if(organisationMobile.length>0)
              //             pw.Text('Mobile Number:$organisationMobile',textScaleFactor: 1,style: pw.TextStyle(
              //               // fontWeight: pw.FontWeight.bold
              //             )),
              //           if(organisationGstNo.length>0)
              //             pw.Text('$organisationTaxType Number:$organisationGstNo',textScaleFactor: 1,style: pw.TextStyle(
              //               // fontWeight: pw.FontWeight.bold
              //             )),
              //           if(organisationGstNo.length>0)
              //             pw.Text('$organisationTaxTitle',textScaleFactor: 1,style: pw.TextStyle(
              //               // fontWeight: pw.FontWeight.bold
              //             )),
              //         ]
              //       ),
              //     ]
              //   ),
              //   pw.TableRow(
              //     children: [
              //       pw.Column(
              //         children: [
              //                    if (customer.length>0)
              //                      pw.Column(
              //                          crossAxisAlignment: pw.CrossAxisAlignment.start,
              //                          children: [
              //                            pw.Text('Customer Name: $customer',textScaleFactor: 1,style: pw.TextStyle(
              //                                fontWeight: pw.FontWeight.bold
              //                            )),
              //                            if(allCustomerAddress[customerList.indexOf(customer)].length>0)
              //                            pw.Text('Address: ${allCustomerAddress[customerList.indexOf(customer)]}',textScaleFactor: 1,maxLines: 3,style: pw.TextStyle(
              //                                // fontWeight: pw.FontWeight.bold
              //                            )),
              //                            pw.Text('Mobile Number: ${allCustomerMobile[customerList.indexOf(customer)]}',maxLines: 3,textScaleFactor: 1,style: pw.TextStyle(
              //                                // fontWeight: pw.FontWeight.bold
              //                            )),
              //         ]
              //       ),
              //
              //     ]
              //   ),
              //       pw.Column(children: [
              //         pw.Text('Date : ${dateNow()}',textScaleFactor: 1.0,style: pw.TextStyle(
              //           // fontWeight: pw.FontWeight.bold
              //         )),
              //         pw.Text('Invoice No : $inv',textScaleFactor: 1.0,style: pw.TextStyle(
              //           // fontWeight: pw.FontWeight.bold
              //         )),
              //       ])
              // ],),
             child: pw.ListView(
               children: [
                 pw.Container(
                   padding:pw.EdgeInsets.all(4.0),
                   decoration: pw.BoxDecoration(

                       border: pw.Border(left:pw.BorderSide(width: 0.9),right:pw.BorderSide(width: 0.9),top:pw.BorderSide(width: 0.9))
                   ),
                     child:   pw.Center(
                         child: pw.Column(
                             children:[
                               pw.Text('$organisationName',textScaleFactor: 1.2,style: pw.TextStyle(
                                   fontWeight: pw.FontWeight.bold
                               )),
                               pw.Text('$organisationAddress',textScaleFactor: 1,style: pw.TextStyle(
                                 // fontWeight: pw.FontWeight.bold
                               )),
                               if(organisationMobile.length>0)
                                 pw.Text('Mobile Number:$organisationMobile',textScaleFactor: 1,style: pw.TextStyle(
                                   // fontWeight: pw.FontWeight.bold
                                 )),
                               if(organisationGstNo.length>0)
                                 pw.Text('$organisationTaxType Number:$organisationGstNo',textScaleFactor: 1,style: pw.TextStyle(
                                   // fontWeight: pw.FontWeight.bold
                                 )),
                               if(organisationGstNo.length>0)
                               pw.Text('$organisationTaxTitle',textScaleFactor: 1,style: pw.TextStyle(
          // fontWeight: pw.FontWeight.bold
          )),

                             ]
                         )
                     ),
                 ),
                 pw.Container(
                   //height: 20,
                   padding:pw.EdgeInsets.all(4.0),
                   decoration: pw.BoxDecoration(

                       border: pw.Border(left:pw.BorderSide(width: 0.9),right:pw.BorderSide(width: 0.9),top:pw.BorderSide(width: 0.9))
                   ),
                   child:
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children:[
                      if (customer.length>0)
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Customer Name: $customer',textScaleFactor: 1,style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold
                              )),
                              if(allCustomerAddress[customerList.indexOf(customer)].length>0)
                              pw.Text('Address: ${allCustomerAddress[customerList.indexOf(customer)]}',textScaleFactor: 1,maxLines: 3,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                              )),
                              pw.Text('Mobile Number: ${allCustomerMobile[customerList.indexOf(customer)]}',maxLines: 3,textScaleFactor: 1,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                              )),
                            ]
                        ),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Date : ${dateNow()}',textScaleFactor: 1.0,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                              )),
                              pw.Text('Invoice No : $inv',textScaleFactor: 1.0,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                              )),
                            ]
                        ),

                      ]
                    ),
                  ),
               ],
             )
         );
        }
        final pdf = pw.Document();
        final rows = <pw.TableRow>[];
        final rows1 = <pw.TableRow>[];
        final rows2 = <pw.TableRow>[];
        rows.add(pw.TableRow(
            children: [
            pw.SizedBox(width:20,child:pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text('S.No',textScaleFactor: 0.8,),
            ),),
              pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child:               pw.Text('Particulars',textScaleFactor:0.8,),
              ),
              pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child:               pw.Text('Qty',textScaleFactor:0.8,),
              ),
              pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child:               pw.Text('Rate',textScaleFactor: 0.8,),
              ),
              pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child:               pw.Text('Tax%',textScaleFactor: 0.8,),
              ),
              pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child:                pw.Text('Amount',textScaleFactor: 0.8,),
              ),
            ]
        ));
        for(int i=0;i<items.length;i++){
          List cartItemsString = items[i].split(':');
          double price = double.parse(cartItemsString[2]) /
              double.parse(cartItemsString[3]);
          String tax = getTaxName(cartItemsString[0].toString().trim());
          rows.add(pw.TableRow(
              children: [
               pw.SizedBox(width:20,child: pw.Padding(
                 padding:pw.EdgeInsets.all(3.0),
                 child:pw.Text((i+1).toString(),textScaleFactor: 0.8,),
               )),
                pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child:pw.Text(cartItemsString[0],textScaleFactor: 0.8,),
                ),pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child: pw.Text(cartItemsString[3],textScaleFactor: 0.8),
                ),
                pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child:pw.Text(price.toStringAsFixed(decimals),textScaleFactor: 0.8),
                ),
                pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child: pw.Text(getPercent(tax),textScaleFactor: 0.8),
                ),
                pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child: pw.Text(double.parse(cartItemsString[2]).toStringAsFixed(
                      decimals),textScaleFactor: 0.8),
                ),

              ]
          ));
        }
        if(gst2==true){
          if(tempTax>0){
            for(int j=0;j<taxDetailsList.length-1;j++){
              if(double.parse(taxDetailsList[j])>0){
                rows1.add(pw.TableRow(
                    children: [
                      pw.Padding(padding:pw.EdgeInsets.all(2),
                        child:pw.Text(j==0?'CGST 2.5%':j==1?'CGST 6%':j==2?'CGST 9%':'CGST 14%',textScaleFactor: 0.8),
                      ),
                      pw.Padding(padding:pw.EdgeInsets.all(2),
                        child:pw.Text( (double.parse(taxDetailsList[j].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8),
                      ),
                      pw.Padding(padding:pw.EdgeInsets.all(2),
                        child:pw.Text(j==0?'SGST 2.5%':j==1?'SGST 6%':j==2?'SGST 9%':'SGST 14%',textScaleFactor: 0.8),
                      ),
                      pw.Padding(padding:pw.EdgeInsets.all(2),
                        child:pw.Text( (double.parse(taxDetailsList[j].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8),
                      ),
                    ]
                ));
              }
            }
            if(double.parse(taxDetailsList[4])>0)
            rows1.add(pw.TableRow(
                children: [
                  pw.Padding(padding:pw.EdgeInsets.all(2),
                    child:pw.Text('CESS 12%',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.all(2),
                    child:pw.Text( (double.parse(taxDetailsList[4].toString())).toStringAsFixed(decimals),textScaleFactor: 0.8),
                  ),
                ]
            ));
            rows2.add(pw.TableRow(
                children: [
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('Bill Amount',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text(billAmount.toStringAsFixed(decimals),textScaleFactor: 0.8),
                  ),
                ]
            ));
            if(tempTax>0)
              rows2.add(pw.TableRow(
                  children: [
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child: pw.Text('Total Tax',textScaleFactor: 0.8),
                    ),
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text(tempTax.toStringAsFixed(decimals),textScaleFactor: 0.8),
                    ),
                  ]
              ));
            if(discount>0)
              rows2.add(pw.TableRow(
                  children: [
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text('Discount',textScaleFactor: 0.8),
                    ),
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text(discount.toStringAsFixed(decimals),textScaleFactor: 0.8),
                    ),
                  ]
              ));
            rows2.add(pw.TableRow(
                children: [
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('Net Payable',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('$organisationSymbol ${total.toStringAsFixed(decimals)}',textScaleFactor: 0.8),
                  ),
                ]
            ));
          }
          else{
            rows2.add(pw.TableRow(
                children: [
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('Bill Amount',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text(billAmount.toStringAsFixed(decimals),textScaleFactor: 0.8),
                  ),
                ]
            ));
            if(tempTax>0)
            rows2.add(pw.TableRow(
                children: [
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child: pw.Text('Total Tax',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text(tempTax.toStringAsFixed(decimals),textScaleFactor: 0.8),
                  ),
                ]
            ));
            if(discount>0)
              rows2.add(pw.TableRow(
                  children: [
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text('Discount',textScaleFactor: 0.8),
                    ),
                    pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                      child:pw.Text(discount.toStringAsFixed(decimals),textScaleFactor: 0.8),
                    ),
                  ]
              ));
            rows2.add(pw.TableRow(
                children: [
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('Net Payable',textScaleFactor: 0.8),
                  ),
                  pw.Padding(padding:pw.EdgeInsets.only(left:4,right:2,top:2,bottom: 2),
                    child:pw.Text('$organisationSymbol ${total.toStringAsFixed(decimals)}',textScaleFactor: 0.8),
                  ),
                ]
            ));
          }
        }

        center(){

         return pw.Container(

             decoration: pw.BoxDecoration(

                 border: pw.Border.all(width: 0.9,
                 )
             ),
         child: pw.Column(
           children:[
         //     pw.Padding(
         //       padding:pw.EdgeInsets.all(4.0),
         //       child: pw.Row(
         //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
         //           children: [
         //             pw.SizedBox(
         //               width:100,
         //               child: pw.Text('Particulars',style: pw.TextStyle(
         //                   fontSize: 6,fontWeight: pw.FontWeight.bold
         //               )),
         //             ),
         //             pw.Text('Qty',style: pw.TextStyle(
         //                 fontSize: 6,fontWeight: pw.FontWeight.bold
         //             )),
         //             pw.Text('Rate',style: pw.TextStyle(
         //                 fontSize: 6,fontWeight: pw.FontWeight.bold
         //             )),
         //             pw.Text('Tax%',style: pw.TextStyle(
         //                 fontSize: 6,fontWeight: pw.FontWeight.bold
         //             )),
         //             pw.Text('Amount',style: pw.TextStyle(
         //                 fontSize: 6,fontWeight: pw.FontWeight.bold
         //             )),
         //           ]
         //       ),
         //     ),
         //     pw.Container(color: PdfColors.black,height: 0.5),
         // pw.ListView.builder(
         //        direction: pw.Axis.vertical,
         //         itemCount: items.length,
         //           itemBuilder: (context,index){
         //             print('reached product column');
         //             List cartItemsString = items[index].split(':');
         //             String tax = getTaxName(cartItemsString[0].toString().trim());
         //             print('tax $tax');
         //             print('grandTotal $grandTotal');
         //             double amt = double.parse(cartItemsString[2]);
         //
         //             double price = double.parse(cartItemsString[2]) /
         //                 double.parse(cartItemsString[3]);
         //             print('price $price');
         //             amt = double.parse((amt).toStringAsFixed(3));
         //             print('amt $amt');
         //             grandTotal += amt;
         //
         //             //if (tax.trim() == 'VAT 10')
         //             //  exclTotal+=amt;
         //             print('grandTotal $grandTotal');
         //             if (tax.trim() == 'Tax 5%') {
         //               print('inside tax 5555555555555');
         //               tax5 += (double.parse( getPercent(tax)) / 100) * price;
         //               print('5 $tax5');
         //             }
         //             if (tax.trim() == 'Tax 10') {
         //               print('inside tax 5555555555555');
         //               // tax10 += (double.parse( getPercent(tax)) / 100) * price;
         //               //tax10 +=  price - price / 1.1;
         //               tax10 =  tax10 + amt-amt/1.1;
         //               print('10 $tax10');
         //             }
         //             if (tax.trim() == 'VAT 10') {
         //
         //               print('inside tax 5555555555555');
         //               //tax10 += (double.parse( getPercent(tax)) / 100) * price;
         //               //tax10 =  tax10 + 0.1*amt;
         //               tax10 =  tax10 + amt-amt/1.1;
         //               totalTax+=tax10;
         //               print('10 $tax10');
         //             }
         //             if (tax.trim() == 'Tax 12%') {
         //               tax12 += (double.parse(getPercent(tax))/100) * price;
         //               print('12 $tax12');
         //             }
         //             if (tax.trim() == 'Tax 18%') {
         //               tax18 += (double.parse(getPercent(tax)) / 100) * price;
         //               print('18 $tax18');
         //             }
         //             if (tax.trim() == 'Tax 28%') {
         //               tax28 += (double.parse(getPercent(tax)) / 100) * price;
         //               cess += (12 / 100) * price;
         //               print('28 $tax28');
         //               print('2cess $cess');
         //             }
         //             print('lasttttttttttt grandTotal $grandTotal');
         //             print('lasttttttttttt totalTax $totalTax');
         //           return pw.Container(
         //             padding:pw.EdgeInsets.only(left:4,right:4),
         //             height:20,
         //              child: pw.Row(
         //                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
         //                   children:[
         //                     pw.SizedBox(
         //                       width:100,
         //                       child: pw.Text(cartItemsString[0],style: pw.TextStyle(
         //                           fontSize: 6,fontWeight: pw.FontWeight.bold
         //                       )),
         //                     ),
         //                     pw.Text(cartItemsString[3],style: pw.TextStyle(
         //                         fontSize: 6,fontWeight: pw.FontWeight.bold
         //                     )),
         //                     pw.Text(price.toStringAsFixed(decimals),style: pw.TextStyle(
         //                         fontSize: 6,fontWeight: pw.FontWeight.bold
         //                     )),
         //                     pw.Text(getPercent(tax),style: pw.TextStyle(
         //                         fontSize: 6,fontWeight: pw.FontWeight.bold
         //                     )),
         //                     pw.Text(double.parse(cartItemsString[2]).toStringAsFixed(
         //                         decimals),style: pw.TextStyle(
         //                         fontSize: 6,fontWeight: pw.FontWeight.bold
         //                     )),
         //                   ]
         //               ),
         //           );
         //           },
         //       ),
             pw.Container(color: PdfColors.black,height: 0.5),
             pw.Table(
                 defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
               // textDirection: pw.TextDirection.ltr,
                 border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                 children: rows),
           pw.Container(height: (450-len*15).toDouble()),
             if(organisationTaxType=='VAT')
               pw.Column(
                 children:[
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                       children:[
                         pw.Text('Bill Amount',style: pw.TextStyle(
                             fontSize: 6,fontWeight: pw.FontWeight.bold
                         )),
                         pw.Text( billAmount.toStringAsFixed(decimals),style: pw.TextStyle(
                             fontSize: 6,fontWeight: pw.FontWeight.bold
                         )),
                       ]
                   ),
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                       children:[
                         pw.Text('Vat 10%',style: pw.TextStyle(
                             fontSize: 6,fontWeight: pw.FontWeight.bold
                         )),
                         pw.Text(tax10.toStringAsFixed(decimals),style: pw.TextStyle(
                             fontSize: 6,fontWeight: pw.FontWeight.bold
                         )),
                       ]
                   ),
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                       children:[
                         pw.Text('Net Payable',style: pw.TextStyle(
                             fontSize: 6,fontWeight: pw.FontWeight.bold
                         )),
                         pw.Text(grandTotal.toStringAsFixed(decimals),style: pw.TextStyle(
                             fontSize: 6,fontWeight: pw.FontWeight.bold
                         )),
                       ]
                   )
                   ]
               ),
             pw.Row(
                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                 children:[
               if(tempTax>0)
                 pw.Expanded(
                   flex:2,
                   child:pw.Table(
                       defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                     // textDirection: pw.TextDirection.ltr,
                     //   border: pw.TableBorder.symmetric(inside: pw.BorderSide(width: 1, color: PdfColors.black)),

          border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
            children:rows1),),
                   pw.Expanded(
                      child: pw.Padding(
                        padding:pw.EdgeInsets.only(left:tempTax>0?1:350),
                          child:pw.Table(
                              border: pw.TableBorder(left: pw.BorderSide(color: PdfColors.black, width: 1 ),top:pw.BorderSide(color: PdfColors.black, width: 1 ) ),
                              //   border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                              // border: pw.TableBorder.symmetric(outside: pw.BorderSide(width: 1, color: PdfColors.black)),
                              children:rows2)
                      ),
                   ),
             ]),
             // if(gst2==true)
             //   pw.Padding(
             //     padding:pw.EdgeInsets.all(4.0),
             //     child:pw.Row(
             //         crossAxisAlignment: pw.CrossAxisAlignment.start,
             //         children:[
             //           if(tempTax>0)
             //             pw.Expanded(
             //               child:pw.Container(
             //                 padding:pw.EdgeInsets.only(right:8),
             //                 child:  pw.Column(
             //                   children:[
             //                     if(double.parse(taxDetailsList[0])>0)
             //
             //                       pw.Row(
             //                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
             //                           children:[
             //                             pw.Text('CGST 2.5%',textScaleFactor: 0.8),
             //                             pw.Text( (double.parse(taxDetailsList[0].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8),
             //                             pw.Text('SGST 2.5%',textScaleFactor: 0.8),
             //                             pw.Text( (double.parse(taxDetailsList[0].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8),
             //                           ]
             //                       ),
             //                     if(double.parse(taxDetailsList[1])>0)
             //                       pw.Row(
             //                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
             //                           children:[
             //                             pw.Text('CGST 6%',textScaleFactor: 0.8,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                             pw.Text( (double.parse(taxDetailsList[1].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8,textAlign: pw.TextAlign.right,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                             pw.Text('SGST 6%',textScaleFactor: 0.8,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                             pw.Text( (double.parse(taxDetailsList[1].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8,textAlign: pw.TextAlign.right,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                           ]
             //                       ),
             //                     if(double.parse(taxDetailsList[2])>0)
             //                       pw.Row(
             //                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
             //                           children:[
             //                             pw.Text('CGST 9%',style: pw.TextStyle(
             //                               fontSize: 6,
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                             pw.Text( (double.parse(taxDetailsList[2].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8,textAlign: pw.TextAlign.right,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                             pw.Text('SGST 9%',textScaleFactor: 0.8,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                             pw.Text( (double.parse(taxDetailsList[2].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8,textAlign: pw.TextAlign.right,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                           ]
             //                       ),
             //                     if(double.parse(taxDetailsList[3])>0)
             //                       pw.Row(
             //                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
             //                           children:[
             //                             pw.Text('CGST 14%',textScaleFactor: 0.8,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                             pw.Text( (double.parse(taxDetailsList[3].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                             pw.Text('SGST 14%',textScaleFactor: 0.8,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                             pw.Text( (double.parse(taxDetailsList[3].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                           ]
             //                       ),
             //                     if(double.parse(taxDetailsList[4])>0)
             //                       pw.Row(
             //                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
             //                           children:[
             //                             pw.Text('CESS 12%',textScaleFactor: 0.8,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                             pw.Text( (double.parse(taxDetailsList[4].toString())/2).toStringAsFixed(decimals),textScaleFactor: 0.8,style: pw.TextStyle(
             //                               // fontWeight: pw.FontWeight.bold
             //                             )),
             //                           ]
             //                       ),
             //                   ],
             //                 ),
             //               ),
             //             ),
             //           pw.Expanded(child:pw.Container(
             //             padding:pw.EdgeInsets.only(left: 4),
             //             child:   pw.Column(
             //                 mainAxisAlignment: pw.MainAxisAlignment.start,
             //                 children:[
             //                   pw.Row(
             //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
             //                       children:[
             //                         pw.Text('Bill Amount',textScaleFactor: 0.8,style: pw.TextStyle(
             //                             fontWeight: pw.FontWeight.bold
             //                         )),
             //                         pw.Text( billAmount.toStringAsFixed(decimals),textScaleFactor: 0.8,style: pw.TextStyle(
             //                             fontWeight: pw.FontWeight.bold
             //                         )),
             //                       ]
             //                   ),
             //                   if(tempTax>0)
             //                     pw.Row(
             //                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
             //                         children:[
             //                           pw.Text('Total Tax',textScaleFactor: 0.8,style: pw.TextStyle(
             //                               fontWeight: pw.FontWeight.bold
             //                           )),
             //                           pw.Text(tempTax.toStringAsFixed(decimals),textScaleFactor: 0.8,style: pw.TextStyle(
             //                               fontWeight: pw.FontWeight.bold
             //                           )),
             //                         ]
             //                     ),
             //                   if(discount>0)
             //                     pw.Row(
             //                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
             //                         children:[
             //                           pw.Text('Discount',textScaleFactor: 0.8,style: pw.TextStyle(
             //                               fontWeight: pw.FontWeight.bold
             //                           )),
             //                           pw.Text(discount.toStringAsFixed(decimals),textScaleFactor: 0.8,style: pw.TextStyle(
             //                               fontWeight: pw.FontWeight.bold
             //                           )),
             //                         ]
             //                     ),
             //                   pw.Row(
             //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
             //                       children:[
             //                         pw.Text('Net Payable',textScaleFactor: 0.8,style: pw.TextStyle(
             //                             fontWeight: pw.FontWeight.bold
             //                         )),
             //                         pw.Text('    $organisationSymbol ${total.toStringAsFixed(decimals)}',textScaleFactor: 0.8,style: pw.TextStyle(
             //                             fontWeight: pw.FontWeight.bold
             //                         )),
             //                       ]
             //                   )
             //                 ]
             //             ),
             //           )),
             //         ]
             //     ),
             //   )
           ]
         )
         );
        }
        if(currentPrinter=='PDF Thermal'){
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) => top(),
              pageFormat: PdfPageFormat.roll80,
            ),
          );
          List<int> bytes = await pdf.save();
          // html.AnchorElement(
          //     href:
          //     "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
          //   ..setAttribute("download", "${allPrinterIp[allPrinter.indexOf(currentPrinterName)]}#${dateNow()}.pdf")
          //   ..click();
          return doc.save();
        }
        else{
          doc.addPage(

            pw.MultiPage(
                pageFormat: PdfPageFormat.a4,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                build: (pw.Context context) => <pw.Widget>[
                  top(),
                  center()
                ]
            ),
          );
        }


        final Uint8List bytes = await doc.save();
        final img.Image image = img.decodeImage(bytes);
        return doc.save();
      },
      // name: 'order_id_#' + order.id.toString(),
    );




    // return pdf.save();
  }
  Future<Uint8List> arabicPdf( String title,List items,String inv,String customer,double total,double discount,double tempTax,double billAmount,String taxDetails,int len,String tempPayment,String tempTotal)async{
    print('inside arabic pdf');
    final pdf = pw.Document(version: PdfVersion.pdf_1_5,);
    final fontNo = await PdfGoogleFonts.oswaldBold();
    final fontArabic = await PdfGoogleFonts.cairoBlack();
    final fontArabic1 = await PdfGoogleFonts.tajawalLight();
    double a=0;
    double b=0;
    double c=0;
    double tax5=0;
    double tax10=0;
    double tax12=0;
    double tax18=0;
    double tax28=0;
    double cess=0;
    bool gst1=false;
    bool gst2=false;
    if(organisationTaxType=='GST'){
      gst1=true;
      if(organisationGstNo.length>0){
        gst2=true;
        gst1=false;
      }
    }
    List taxDetailsList=[];
    if(taxDetails.isNotEmpty){
      taxDetailsList=taxDetails.split('~');
    }
    final img2=getQrCode(total, tempTax);

    final img1 =  pw.MemoryImage(
      (await rootBundle.load('images/tazaj_logo.jpg')).buffer.asUint8List(),
    );
pw.SizedBox space1=pw.SizedBox(height:10);
pw.SizedBox space2=pw.SizedBox(height:5);
pw.SizedBox space3=pw.SizedBox(height:3);

    final rows = <pw.TableRow>[];
    final rows1 = <pw.TableRow>[];
    final rows2 = <pw.TableRow>[];
    final dashWidth = 1.0;
    final dashHeight = 0.5;
    final dashCount = 200;
    if(tempPayment.contains('*')){
      List tempP=tempPayment.split('*');
      List tempT=tempTotal.split('*');
      rows2.add(pw.TableRow(
          children:[
            pw.Text('${tempP[0].toString().trim()} : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.Text(tempT[0].toString().trim(),textScaleFactor: 0.8,textAlign:pw.TextAlign.right,style: pw.TextStyle(
                font:fontNo
            )),
          ]
      ));
      rows2.add(pw.TableRow(
          children:[
            pw.Text('${tempP[1].toString().trim()} : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.Text(tempT[1].toString().trim(),textAlign:pw.TextAlign.right,textScaleFactor: 0.8,style: pw.TextStyle(
                font:fontNo
            )),
          ]
      ));
    }
    else{
      rows2.add(pw.TableRow(
          children:[
            pw.Text('$tempPayment : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.Text(tempTotal,textScaleFactor: 0.8,textAlign:pw.TextAlign.right,style: pw.TextStyle(
                font:fontNo
            )),
          ]
      ));
    }
    rows.add(pw.TableRow(
        children: [
          pw.SizedBox(
            width:25,
              child:pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Column(children:[
                pw.Text('SN.',textScaleFactor: 0.6,textAlign:pw.TextAlign.center,style:pw.TextStyle(
                    fontWeight: pw.FontWeight.bold
                )),
                space3,
                pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: pw.Center(
                      child:  pw.Text('رقم',textScaleFactor: 0.6,textAlign:pw.TextAlign.center,style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold
                          font:fontArabic)),)),
              ])
          )),
          pw.SizedBox(
            width:80,
              child:pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Column(children:[
                pw.Text('Item',textScaleFactor: 0.6,textAlign:pw.TextAlign.center,style:pw.TextStyle(
                    fontWeight: pw.FontWeight.bold
                )),
                space3,
                pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: pw.Center(
                      child:  pw.Text('بذد',textScaleFactor: 0.6,textAlign:pw.TextAlign.center,style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold
                          font:fontArabic)),)),
              ])
          )),

          pw.SizedBox(width:30,
          child: pw.Padding(
            padding:pw.EdgeInsets.all(3.0),
            child:pw.Column(children:[
              pw.Text('Qty',textScaleFactor: 0.6,textAlign:pw.TextAlign.center,style:pw.TextStyle(
                  fontWeight: pw.FontWeight.bold
              )),
              space3,
              pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Center(
                    child:  pw.Text('كمية',textScaleFactor: 0.6,textAlign:pw.TextAlign.center,style: pw.TextStyle(
                      // fontWeight: pw.FontWeight.bold
                        font:fontArabic)),)),
            ]),
          ),
          ),
          pw.SizedBox(width:40,
          child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
      child:pw.Column(
          children:[
            pw.Text('U.Price',textScaleFactor: 0.6,textAlign:pw.TextAlign.right,style:pw.TextStyle(
                fontWeight: pw.FontWeight.bold
            )),
            space3,
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Center(
                  child:  pw.Text('السعر',textScaleFactor: 0.6,textAlign:pw.TextAlign.right,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                      font:fontArabic)),)),
          ]
      ),
    ),
          ),
          pw.SizedBox(width:50,
          child:pw.Padding(
            padding:pw.EdgeInsets.all(3.0),
            child:pw.Column(
                children:[
                  pw.Text('Amount',textScaleFactor: 0.6,textAlign:pw.TextAlign.right,style:pw.TextStyle(
                      fontWeight: pw.FontWeight.bold
                  )),
                  space3,
                  pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Center(
                        child:  pw.Text('المبلغ',textAlign:pw.TextAlign.right,textScaleFactor: 0.6,style: pw.TextStyle(
                          // fontWeight: pw.FontWeight.bold
                            font:fontArabic)),)),
                ]
            ),
          ),
          ),
        ]
    ));
    for(int i=0;i<items.length;i++){
      List cartItemsString = items[i].split(':');
      print('itemnameeeee ${cartItemsString[0]}');
      List itemNameSplit=[];
      if(cartItemsString[0].toString().contains('#'))
       itemNameSplit=cartItemsString[0].toString().split('#');
      else{
        itemNameSplit.add(cartItemsString[0].toString());
        itemNameSplit.add('');
      }
      double price = double.parse(cartItemsString[2]) /
          double.parse(cartItemsString[3]);
      String tax = getTaxName(cartItemsString[0].toString().trim());
      rows1.add(pw.TableRow(
          children: [
            pw.SizedBox(width:25,child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text((i+1).toString(),textScaleFactor: 0.6,style:pw.TextStyle(font:fontNo)),
            )),
            pw.SizedBox(
    width:80,
    child:pw.Padding(
    padding:pw.EdgeInsets.all(3.0),
    child:pw.Column(
      children:[
        pw.Text(itemNameSplit[0].toString().trim(),textAlign:pw.TextAlign.left,textScaleFactor: 0.6,style:pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
        )),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Center(
              child:  pw.Text(itemNameSplit[1].toString().trim(),textAlign:pw.TextAlign.right,textScaleFactor: 0.6,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
                  font:fontArabic)),)),
      ]
    ),
    ),),
    pw.SizedBox(width:30,
    child: pw.Padding(
    padding:pw.EdgeInsets.all(3.0),
    child: pw.Text(cartItemsString[3],textScaleFactor: 0.6,style:pw.TextStyle(font:fontNo),textAlign:pw.TextAlign.center),
    ),
    ),
    pw.SizedBox(width:40,
    child:pw.Padding(
    padding:pw.EdgeInsets.all(3.0),
    child:pw.Text(price.toStringAsFixed(decimals),textScaleFactor: 0.6,style:pw.TextStyle(font:fontNo),textAlign:pw.TextAlign.right),
    ),
    ),
            pw.SizedBox(width:50,
            child:  pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child: pw.Text(double.parse(cartItemsString[2]).toStringAsFixed(
                  decimals),textScaleFactor: 0.6,style:pw.TextStyle(font:fontNo,),textAlign:pw.TextAlign.right),
            ),
            ),
          ]
      ));

    }


    top(){
      return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SizedBox(
              width:80,
              height:80,
              child:pw.Image(img1),),

            space1,
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Center(
                  child:  pw.Text('فرش الطـزاخ',textScaleFactor: 1,style: pw.TextStyle(
                      font:fontArabic)),)),
            space2,
                        pw.Text('$organisationName',textScaleFactor: 1.2,style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                        )),
            space2,
                        pw.Text('$organisationAddress',textScaleFactor: 0.8,textAlign: pw.TextAlign.center,style: pw.TextStyle(
                          // fontWeight: pw.FontWeight.bold
                        )),

                        if(organisationMobile.length>0)
                          space2,
                          pw.Text('Tel : $organisationMobile',textScaleFactor: 0.8,style: pw.TextStyle(
                            // fontWeight: pw.FontWeight.bold
                          )),
            space2,
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children:[
                              pw.Text('$organisationTaxType No/',textScaleFactor: 0.8,style: pw.TextStyle(
                                // fontWeight: pw.FontWeight.bold
                              )),
                                pw.Directionality(
                                    textDirection: pw.TextDirection.rtl,
                                    child: pw.Center(
                                      child:  pw.Text('الرقم الضريبي',textScaleFactor: 0.8,style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                          font:fontArabic
                                      )),
                                    )
                                ),
                                pw.Text(' : $organisationGstNo',textScaleFactor: 0.8,style: pw.TextStyle(
                                  // fontWeight: pw.FontWeight.bold
                                )),
                            ]
                          ),
            space1,
                                pw.Text('SIMPLIFIED TAX INVOICE',textScaleFactor: 1,style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                )),
            // space2,
                                pw.Directionality(
                                    textDirection: pw.TextDirection.rtl,
                                    child: pw.Center(
                                        child:  pw.Text('فاتورة ضريبية مبسطة',textScaleFactor: 1,style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                            font:fontArabic
                                        )),
                                    )
                                ),
                          space2,
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children:[
                            pw.Text('Invoice No/',textScaleFactor: 0.8,style: pw.TextStyle(
                              // fontWeight: pw.FontWeight.bold
                            )),
                            pw.Directionality(
                                textDirection: pw.TextDirection.rtl,
                                child: pw.Center(
                                  child:  pw.Text('رقم الفاتورة',textScaleFactor: 0.8,style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                      font:fontArabic
                                  )),
                                )
                            ),
                            pw.Text(' : $inv',textScaleFactor:0.8,style: pw.TextStyle(
                              // fontWeight: pw.FontWeight.bold
                            )),
                          ]),
                          space2,
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children:[
                            pw.Text('Created on/',textScaleFactor: 0.8,style: pw.TextStyle(
                              // fontWeight: pw.FontWeight.bold
                            )),
                            pw.Directionality(
                                textDirection: pw.TextDirection.rtl,
                                child: pw.Center(
                                  child:  pw.Text('تاريخ',textScaleFactor: 0.8,style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                      font:fontArabic
                                  )),
                                )
                            ),
                            pw.Text(' : ${dateNow()}',textScaleFactor: 0.8,style: pw.TextStyle(
                              // fontWeight: pw.FontWeight.bold
                            )),
                          ]),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children:[
              pw.Text('Sales person/',textScaleFactor: 0.8,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
              pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Center(
                    child:  pw.Text('مندوب مبيعات',textScaleFactor: 0.8,style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                        font:fontArabic
                    )),
                  )
              ),
              pw.Text(' : $currentUser',textScaleFactor: 0.8,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
            ]),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children:[
              pw.Text('Customer/',textScaleFactor: 0.8,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
              pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Center(
                    child:  pw.Text('اسم العميل',textScaleFactor: 0.8,style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                        font:fontArabic
                    )),
                  )
              ),
              pw.Text(' : ${customer.length>0?customer:'Standard' }',textScaleFactor:0.8,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
            ]),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children:[
                  pw.Column(children:[
                    pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child:pw.Text('Cust. Vat No/',textAlign:pw.TextAlign.right,textScaleFactor: 0.8,style: pw.TextStyle(
                          // fontWeight: pw.FontWeight.bold
                        ))),
                    pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Text('الرقم الضريبي للعميل',textAlign:pw.TextAlign.right,textScaleFactor: 0.8,style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font:fontArabic
                      )),

                    ),
                  ]),
                  pw.Text(' : ${customer.length>0?customerVatNo[customerList.indexOf(customer)]:'' }',textScaleFactor:0.8,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
                ]),
            space1,
            // pw.Container(height:0.5,color:PdfColors.black),
            pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                border: pw.TableBorder(top: pw.BorderSide(color: PdfColors.black, width: 0.5), bottom: pw.BorderSide(color: PdfColors.black, width: 0.5)),
                // textDirection: pw.TextDirection.ltr,
                // border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                children: rows),
            pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                border: pw.TableBorder( bottom: pw.BorderSide(color: PdfColors.black, width: 0.5)),
                // textDirection: pw.TextDirection.ltr,
                // border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                children: rows1),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children:[
                  pw.Text('Total Excl. VAT/ ',textScaleFactor: 0.6,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
                  pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Center(
                        child:  pw.Text('الاجمالي قبل الضريبة',textScaleFactor: 0.8,style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font:fontArabic
                        )),
                      )
                  ),
                  pw.Text(' :    ${billAmount.toStringAsFixed(decimals)}',textScaleFactor: 0.8,style: pw.TextStyle(
                    font:fontNo                    // fontWeight: pw.FontWeight.bold
                  )),
                ]),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children:[
                  pw.Text('Discount/ ',textScaleFactor: 0.8,style: pw.TextStyle(
                  )),
                  pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Center(
                        child:  pw.Text('خصم',textScaleFactor: 0.8,style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font:fontArabic
                        )),
                      )
                  ),
                  pw.Text(' :    ${discount.toStringAsFixed(decimals)}',textScaleFactor: 0.8,style: pw.TextStyle(
                      font:fontNo
                  )),
                ]),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children:[
                  pw.Text('Total VAT 15%/ ',textScaleFactor: 0.8,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
                  pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Center(
                        child:  pw.Text('مجموع الضريبة',textScaleFactor: 0.8,style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font:fontArabic
                        )),
                      )
                  ),
                  pw.Text(' :    ${tempTax.toStringAsFixed(decimals)}',textScaleFactor: 0.8,style: pw.TextStyle(
                      font:fontNo
                  )),
                ]),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children:[
                  pw.Text('Grand Total/ ',textScaleFactor: 0.8,style: pw.TextStyle(
                  )),
                  pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Center(
                        child:  pw.Text('الاجمالي شامل الضريبة',textScaleFactor: 0.8,style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font:fontArabic
                        )),
                      )
                  ),
                  pw.Text(' :    ${total.toStringAsFixed(decimals)}',textAlign:pw.TextAlign.right,textScaleFactor: 0.8,style: pw.TextStyle(
                      font:fontNo

                  )),
                ]),
            space2,
            pw.Align(
              alignment:pw.Alignment.centerLeft,
              child:pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children:[
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children:[
                        pw.Text('Paymode/ ',textScaleFactor: 0.8,style: pw.TextStyle(
                          // fontWeight: pw.FontWeight.bold
                        )),
                        pw.Directionality(
                            textDirection: pw.TextDirection.rtl,
                            child: pw.Center(
                              child:  pw.Text('الدفع',textScaleFactor: 0.8,style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font:fontArabic
                              )),
                            )
                        ),
                      ]),
                  pw.SizedBox(
                    width:70,
                    child:pw.Table(
                      // defaultVerticalAlignment: pw.TableCellVerticalAlignment..left,
                        children: rows2),
                  ),
                ]
              ),
            ),
            space2,
            space2,
            pw.SizedBox(
              width:60,
            height:60,
              child:pw.BarcodeWidget(
                  color: PdfColors.black,
                  barcode:pw.Barcode.qrCode(), data: getQrCode(total,tempTax)
              ),
            ),
            space2,
            pw.Container(height:0.5,color:PdfColors.black),
            space2,
            space2,
            pw.Center(
              child:  pw.Text('Thank You Visit Again',textScaleFactor: 0.8,style: pw.TextStyle(
              )),),
            space2,
              pw.Center(
                child:  pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                      child:  pw.Text('شكرا لك الزيارة مرة أخرى',textScaleFactor: 0.8,style: pw.TextStyle(
                          font:fontArabic1
                      )),
                ),
            ),
          ]
      );
    }
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => top(),
        pageFormat: PdfPageFormat.roll80,
        margin: pw.EdgeInsets.only(left: 5, top: 5, right: 25, bottom: 5),
      ),
    );
    List<int> bytes = await pdf.save();

    // html.AnchorElement(
    //     href:
    //     "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    //   ..setAttribute("download", "PSlipasdf.pdf")
    //   ..click();

  }
  Future<Uint8List> restaurantPdf( String title,List items,String inv,String customer,double total,double discount,double tempTax,double billAmount,String taxDetails,int len,String tempPayment,String tempTotal)async{
    String tempUserId=customerUserUid;
    final pdf = pw.Document(version: PdfVersion.pdf_1_5,);
    final fontNo = await PdfGoogleFonts.oswaldBold();
    final fontArabic = await PdfGoogleFonts.cairoBlack();
    final fontArabic1 = await PdfGoogleFonts.tajawalLight();
    double a=0;
    double b=0;
    double c=0;
    double tax5=0;
    double tax10=0;
    double tax12=0;
    double tax18=0;
    double tax28=0;
    double cess=0;
    bool gst1=false;
    bool gst2=false;
    if(organisationTaxType=='GST'){
      gst1=true;
      if(organisationGstNo.length>0){
        gst2=true;
        gst1=false;
      }
    }
    List taxDetailsList=[];
    if(taxDetails.isNotEmpty){
      taxDetailsList=taxDetails.split('~');
    }
    final img2=getQrCode(total, tempTax);

    final img1 =  pw.MemoryImage(
      (await rootBundle.load('images/spin_logo.jpg')).buffer.asUint8List(),
    );
    pw.SizedBox space1=pw.SizedBox(height:10);
    pw.SizedBox space2=pw.SizedBox(height:5);
    pw.SizedBox space3=pw.SizedBox(height:3);

    final rows = <pw.TableRow>[];
    final rows1 = <pw.TableRow>[];
    final rows2 = <pw.TableRow>[];
    final rows3 = <pw.TableRow>[];
    final dashWidth = 1.0;
    final dashHeight = 0.5;
    final dashCount = 200;
    if(tempUserId.length>0){

      if(customerUserMobile.length>0)
      rows3.add(pw.TableRow(
          children:[
            pw.Text('Mobile No : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.SizedBox(width:100,
            child: pw.Text(customerUserMobile,textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                font:fontNo
            )),
            ),
          ]
      ));
      if(customerUserAddress.length>0)
        rows3.add(pw.TableRow(
            children:[
              pw.Text('Address : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
              pw.Text(customerUserAddress,textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ]
        ));
      if(customerUserFlatNo.length>0)
        rows3.add(pw.TableRow(
            children:[
              pw.Text('Flat No : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
              pw.Text(customerUserFlatNo,textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ]
        ));
      if(customerUserBldNo.length>0)
        rows3.add(pw.TableRow(
            children:[
              pw.Text('Build No : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
              pw.Text(customerUserBldNo,textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ]
        ));
      if(customerUserRoadNo.length>0)
        rows3.add(pw.TableRow(
            children:[
              pw.Text('Road No : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
              pw.Text(customerUserRoadNo,textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ]
        ));
      if(customerUserBlockNo.length>0)
        rows3.add(pw.TableRow(
            children:[
              pw.Text('Block No : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
              pw.Text(customerUserBlockNo,textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ]
        ));
      if(customerUserArea.length>0)
        rows3.add(pw.TableRow(
            children:[
              pw.Text('Area : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
              pw.Text(customerUserArea,textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ]
        ));
      if(customerUserLandmark.length>0)
        rows3.add(pw.TableRow(
            children:[
              pw.Text('Landmark : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                // fontWeight: pw.FontWeight.bold
              )),
              pw.Text(customerUserLandmark,textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ]
        ));
    }
    if(tempPayment.contains('*')){
      List tempP=tempPayment.split('*');
      List tempT=tempTotal.split('*');
      rows2.add(pw.TableRow(
        children:[
          pw.Text('${tempP[0].toString().trim()} : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
            // fontWeight: pw.FontWeight.bold
          )),
          pw.Text(tempT[0].toString().trim(),textScaleFactor: 0.8,textAlign:pw.TextAlign.right,style: pw.TextStyle(
              font:fontNo
          )),
        ]
      ));
      rows2.add(pw.TableRow(
          children:[
            pw.Text('${tempP[1].toString().trim()} : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
       pw.Text(tempT[1].toString().trim(),textAlign:pw.TextAlign.right,textScaleFactor: 0.8,style: pw.TextStyle(
           font:fontNo
       )),
          ]
      ));
    }
    else{
      rows2.add(pw.TableRow(
          children:[
            pw.Text('$tempPayment : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
         pw.Text(tempTotal,textScaleFactor: 0.8,textAlign:pw.TextAlign.right,style: pw.TextStyle(
             font:fontNo
         )),
          ]
      ));
    }
    rows.add(pw.TableRow(
        children: [
          pw.SizedBox(
              width:25,
              child:pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child: pw.Text('SN.',textScaleFactor: 0.6,textAlign:pw.TextAlign.center,style:pw.TextStyle(
                        fontWeight: pw.FontWeight.bold
                    )),
              )),
          pw.SizedBox(
              width:80,
              child:pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child: pw.Text('Item',textScaleFactor: 0.6,textAlign:pw.TextAlign.center,style:pw.TextStyle(
                        fontWeight: pw.FontWeight.bold
                    )),
              )),

          pw.SizedBox(width:30,
            child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child: pw.Text('Qty',textScaleFactor: 0.6,textAlign:pw.TextAlign.center,style:pw.TextStyle(
                    fontWeight: pw.FontWeight.bold
                )),
            ),
          ),
          pw.SizedBox(width:40,
            child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child: pw.Text('U.Price',textScaleFactor: 0.6,textAlign:pw.TextAlign.right,style:pw.TextStyle(
                        fontWeight: pw.FontWeight.bold
                    )),
            ),
          ),
          pw.SizedBox(width:50,
            child:pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child: pw.Text('Amount',textScaleFactor: 0.6,textAlign:pw.TextAlign.right,style:pw.TextStyle(
                        fontWeight: pw.FontWeight.bold
                    )),
            ),
          ),
        ]
    ));
    for(int i=0;i<items.length;i++){
      List cartItemsString = items[i].split(':');
      List itemNameSplit=cartItemsString[0].toString().split('#');
      String item='${itemNameSplit[0].toString().trim()}[${cartItemsString[1].toString().trim()}]';
      if(checkoutModifierList.length==items.length){
        item+='${checkoutModifierList[i].toString()==''?'':'\n ${checkoutModifierList[i].toString()}'}';
      }
      if(cartComboList.length>0){
        item+='\n';
        List selectedItems=[];
        for(int m=0;m<cartComboList.length;m++) {
          List temp123 = cartComboList[m].toString().split(';');
          if (temp123[0].toString().trim() == cartItemsString[0].toString().trim()) {
            selectedItems.add(cartComboList[m]);
            // cartComboList.removeAt(m);
          }
        }
        if(selectedItems.length>0){
          String tempVal='';
          for(int m=0;m<selectedItems.length;m++) {
            List temp123 = selectedItems[m].toString().split(';');
            tempVal+=temp123[1].toString().trim();
            tempVal+='~';
          }
          tempVal=tempVal.substring(0,tempVal.length-1);
          List tempValList=tempVal.split('~');
          int j=0;
          while(j<tempValList.length){
            List<int> pos=[];
            String tempItem;
            List<String> tempItemList=[];
            List tempValList11=tempValList[j].toString().split(':');
            tempItem=tempValList11[0].toString().trim();
            pos.add(j);
            tempItemList.add(tempValList[j]);
            for(int k=j+1;k<tempValList.length;k++){
              List tempValList22=tempValList[k].toString().split(':');
              if(tempValList22[0].toString().trim()==tempItem){
                pos.add(k);
                tempItemList.add(tempValList[j]);
              }
            }
            String txt223='';
            int tempQty=0;
            for(int k=0;k<tempItemList.length;k++){
              List temp443=tempItemList[0].toString().split(':');
              tempQty+=int.parse(temp443[2].toString().trim());
            }
            txt223+='-';
            List temp443=tempItemList[0].toString().split(':');
            txt223+=temp443[0].toString().trim();
            txt223+='\t';
            txt223+=temp443[1];
            txt223+='\t';
            txt223+='*';
            txt223+=tempQty.toString();
            txt223+='\n';

            item+=txt223;
            for(int k=pos.length-1;k>=0;k--){
              tempValList.removeAt(pos[k]);
            }
            j=0;
          }
        }
          // if(temp123[0].toString().trim()==cartItemsString[0].toString().trim()) {
          //
          //   List temp223=temp123[1].toString().split('~');
          //   String txt223='';
          //   for(int n=0;n<temp223.length;n++){
          //     txt223+='-';
          //     List temp443=temp223[n].toString().split(':');
          //     txt223+=temp443[0].toString().trim();
          //     txt223+='\t';
          //     txt223+=temp443[1];
          //     txt223+='\t';
          //     txt223+='*';
          //     txt223+=temp443[2];
          //     txt223+='\n';
          //   }
          //   item+=txt223;
          // }
        // }
      }
      double price = double.parse(cartItemsString[2]) /
          double.parse(cartItemsString[3]);
      String tax = getTaxName(cartItemsString[0].toString().trim());
      rows1.add(pw.TableRow(
          children: [
            pw.SizedBox(width:25,child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text((i+1).toString(),textScaleFactor: 0.6,style:pw.TextStyle(font:fontNo)),
            )),
            pw.SizedBox(
              width:80,
              child:pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child:
                pw.Text(item ,textAlign:pw.TextAlign.left,textScaleFactor: 0.6,style:pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      )),
              ),),
            pw.SizedBox(width:30,
              child: pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child: pw.Text(cartItemsString[3],textScaleFactor: 0.6,style:pw.TextStyle(font:fontNo),textAlign:pw.TextAlign.center),
              ),
            ),
            pw.SizedBox(width:40,
              child:pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child:pw.Text(price.toStringAsFixed(decimals),textScaleFactor: 0.6,style:pw.TextStyle(font:fontNo),textAlign:pw.TextAlign.right),
              ),
            ),
            pw.SizedBox(width:50,
              child:  pw.Padding(
                padding:pw.EdgeInsets.all(3.0),
                child: pw.Text(double.parse(cartItemsString[2]).toStringAsFixed(
                    decimals),textScaleFactor: 0.6,style:pw.TextStyle(font:fontNo,),textAlign:pw.TextAlign.right),
              ),
            ),
          ]
      ));
    }


    top(){
      return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SizedBox(
              width:80,
              height:80,
              child:pw.Image(img1),),
            space2,
            pw.Text('$organisationName',textScaleFactor: 1.2,textAlign: pw.TextAlign.center,style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            )),
            space2,
            pw.Text('$organisationAddress',textScaleFactor: 0.8,textAlign: pw.TextAlign.center,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),

            if(organisationMobile.length>0)
            pw.Text('Tel : $organisationMobile',textScaleFactor: 0.8,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            space2,
            if(organisationGstNo.length>0)
            pw.Text('$organisationTaxType No : $organisationGstNo',textScaleFactor: 0.8,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
            space1,
            pw.Text('SIMPLIFIED TAX INVOICE',textScaleFactor: 1,style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            )),
            // space2,
            space2,

                  pw.Text('Invoice No : $inv',textScaleFactor: 0.8,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
            space2,
                  pw.Text('Created on : ${dateNow()}',textScaleFactor: 0.8,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
            space2,
                  pw.Text('Sales person : $currentUser',textScaleFactor: 0.8,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
            space2,
                  pw.Text('Customer : ${customer.length>0?customer:'Standard' }',textScaleFactor: 0.8,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children:[
                    pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child:pw.Text('Cust. Vat No',textAlign:pw.TextAlign.right,textScaleFactor: 0.8,style: pw.TextStyle(
                          // fontWeight: pw.FontWeight.bold
                        ))),
                  pw.Text(' : ${customer.length>0?customerVatNo[customerList.indexOf(customer)]:'' }',textScaleFactor:0.8,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
                ]),
            space2,
            if(selectedBusiness=='Restaurant')
            pw.Text('Order Mode : ${selectedDelivery=='Spot'?'Dine In':selectedDelivery}',textScaleFactor: 0.8,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            space1,
      if(tempUserId.length>0)
            pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                border: pw.TableBorder(top: pw.BorderSide(color: PdfColors.black, width: 0.5), bottom: pw.BorderSide(color: PdfColors.black, width: 0.5)),
                // textDirection: pw.TextDirection.ltr,
                // border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                children: rows3),
      if(tempUserId.length>0)
            space1,

            // pw.Container(height:0.5,color:PdfColors.black),
            pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                border: pw.TableBorder(top: pw.BorderSide(color: PdfColors.black, width: 0.5), bottom: pw.BorderSide(color: PdfColors.black, width: 0.5)),
                // textDirection: pw.TextDirection.ltr,
                // border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                children: rows),
            pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                border: pw.TableBorder( bottom: pw.BorderSide(color: PdfColors.black, width: 0.5)),
                // textDirection: pw.TextDirection.ltr,
                // border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                children: rows1),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children:[
                  pw.Text('Total Excl. VAT ',textScaleFactor: 0.6,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
                  pw.Text(' :    ${billAmount.toStringAsFixed(decimals)}',textScaleFactor: 0.8,style: pw.TextStyle(
                      font:fontNo                    // fontWeight: pw.FontWeight.bold
                  )),
                ]),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children:[
                  pw.Text('Discount ',textScaleFactor: 0.8,style: pw.TextStyle(
                  )),

                  pw.Text(' :    ${discount.toStringAsFixed(decimals)}',textScaleFactor: 0.8,style: pw.TextStyle(
                      font:fontNo
                  )),
                ]),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children:[
                  pw.Text('Total VAT 10%',textScaleFactor: 0.8,style: pw.TextStyle(
                    // fontWeight: pw.FontWeight.bold
                  )),
                  pw.Text(' :    ${tempTax.toStringAsFixed(decimals)}',textScaleFactor: 0.8,style: pw.TextStyle(
                      font:fontNo
                  )),
                ]),
            space2,
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children:[
                  pw.Text('Grand Total ',textScaleFactor: 0.8,style: pw.TextStyle(
                  )),
                  pw.Text(' :    ${total.toStringAsFixed(decimals)}',textAlign:pw.TextAlign.right,textScaleFactor: 0.8,style: pw.TextStyle(
                      font:fontNo

                  )),
                ]),
            space2,
            // pw.Row(
            //     mainAxisAlignment: pw.MainAxisAlignment.start,
            //     children:[
            //       pw.Text('Paymode ',textScaleFactor: 0.8,style: pw.TextStyle(
            //         // fontWeight: pw.FontWeight.bold
            //       )),
            //
            //       pw.Text(' : ${tempPayment.contains('*')?tempPayment.replaceAll('*','/'):tempPayment}',textScaleFactor: 0.8,style: pw.TextStyle(
            //         // fontWeight: pw.FontWeight.bold
            //       )),
            //     ]),
            pw.Align(
              alignment:pw.Alignment.centerLeft,
              child:pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children:[
                    pw.Text('Paymode ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                      // fontWeight: pw.FontWeight.bold
                    )),
                    pw.SizedBox(
                      width:100,
                      child:pw.Table(
                        // defaultVerticalAlignment: pw.TableCellVerticalAlignment..left,
                          children: rows2),
                    ),
                  ]
              ),
            ),
            space2,
            pw.Container(height:0.5,color:PdfColors.black),
            space2,
            space2,
            pw.Center(
              child:  pw.Text('Thank You Visit Again',textScaleFactor: 0.8,style: pw.TextStyle(
              )),),
            space2,
          ]
      );
    }
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => top(),
        pageFormat: PdfPageFormat.roll80,
        margin: pw.EdgeInsets.only(left: 5, top: 5, right: 25, bottom: 5),
      ),
    );
    List<int> bytes = await pdf.save();
    // html.AnchorElement(
    //     href:
    //     "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    //   ..setAttribute("download", "PSlipasdf.pdf")
    //   ..click();
  }
  Future<Uint8List> tillPdf(double cashAvailable,double expense,double paymentAmt,double receiptAmt,double cashPurchaseReturn,double cashPurchase,double cashSalesReturn,List<double> salesAmount,String tillClose,String type) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5,);
    final font = await PdfGoogleFonts.oswaldBold();
    final rows = <pw.TableRow>[];
    final rows1 = <pw.TableRow>[];
    final rows2 = <pw.TableRow>[];
    for(int i=0;i<paymentMode.length;i++){
      rows2.add(pw.TableRow(
          children: [
            pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text(paymentMode[i],style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(width:30,child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text(salesAmount[i].toStringAsFixed(decimals),textAlign: pw.TextAlign.right,style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),
            ),),
          ]
      ));
    }
    if(type=='with'){
      rows.add(pw.TableRow(
          children: [
            pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text('Category',textScaleFactor: 0.8,),
            ),
            pw.SizedBox(width:20,child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text('Qty',textScaleFactor:0.8,),
            ),),
            pw.SizedBox(width:30,child:pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text('Value',textScaleFactor:0.8,),
            ),),
          ]
      ));
    }

    rows1.add(pw.TableRow(
        children: [
          pw.Padding(
            padding:pw.EdgeInsets.all(3.0),
            child:pw.Text('Item',textScaleFactor: 0.8,),
          ),
          pw.SizedBox(width:20,child: pw.Padding(
            padding:pw.EdgeInsets.all(3.0),
            child:pw.Text('Qty',textScaleFactor:0.8,),
          ),),
          pw.SizedBox(width:30,child:  pw.Padding(
            padding:pw.EdgeInsets.all(3.0),
            child:pw.Text('Value',textScaleFactor:0.8,),
          ),),
        ]
    ));
    for(int i=0;i<categoryListDash.length;i++){
      rows.add(pw.TableRow(
          children: [
            pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text(categoryListDash[i],textScaleFactor: 0.8,),
            ),
            pw.SizedBox(width:20,child:pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text(categoryCountListDash[i].toString(),textScaleFactor:0.8,),
            ),),
            pw.SizedBox(width:30,child:   pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text(categoryValueListDash[i].toStringAsFixed(decimals),textScaleFactor:0.8,),
            ),),
          ]
      ));
    }
    for(int i=0;i<itemListDash.length;i++){
      rows1.add(pw.TableRow(
          children: [
            pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text(itemListDash[i],textScaleFactor: 0.8,),
            ),
            pw.SizedBox(width:20,child: pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text(itemCountListDash[i].toString(),textScaleFactor:0.8,),
            ),),
            pw.SizedBox(width:30,child:  pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:pw.Text(itemValueListDash[i].toStringAsFixed(decimals),textScaleFactor:0.8,),
            ),),
          ]
      ));
    }
    top(){
      return pw.Column(
          children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Till Report', style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),
                  pw.Text(dateNow(), style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
                ]),
            pw.Container(height:0.5, color: PdfColors.black,),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children:[
                  pw.Text('Opening Cash', style: pw.TextStyle(font: font,)),
                  pw.Text(tillClose, style: pw.TextStyle(font: font, )),
                ]),
            pw.Container(height:0.5, color: PdfColors.black,),
            pw.Center(child: pw.Text('Sales Summary', style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),),
            pw.Container(height:0.5, color: PdfColors.black,),
            pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                // textDirection: pw.TextDirection.ltr,
                // border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                children: rows2),
            pw.Container(height:0.5, color: PdfColors.black,),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children:[
                  pw.Text('Sales Return', style: pw.TextStyle(font: font,)),
                  pw.Text(cashSalesReturn.toStringAsFixed(decimals), style: pw.TextStyle(font: font, )),
                ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children:[
                  pw.Text('Purchase', style: pw.TextStyle(font: font,)),
                  pw.Text(cashPurchase.toStringAsFixed(decimals), style: pw.TextStyle(font: font, )),
                ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children:[
                  pw.Text('Purchase Return', style: pw.TextStyle(font: font,)),
                  pw.Text(cashPurchaseReturn.toStringAsFixed(decimals), style: pw.TextStyle(font: font, )),
                ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children:[
                  pw.Text('Total Receipts', style: pw.TextStyle(font: font,)),
                  pw.Text(receiptAmt.toStringAsFixed(decimals), style: pw.TextStyle(font: font, )),
                ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children:[
                  pw.Text('Total Payments', style: pw.TextStyle(font: font,)),
                  pw.Text(paymentAmt.toStringAsFixed(decimals), style: pw.TextStyle(font: font, )),
                ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children:[
                  pw.Text('Expense', style: pw.TextStyle(font: font,)),
                  pw.Text(expense.toStringAsFixed(decimals), style: pw.TextStyle(font: font, )),
                ]),
            pw.Container(height:0.5, color: PdfColors.black,),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children:[
                  pw.Text('Cash Available', style: pw.TextStyle(font: font,)),
                  pw.Text(cashAvailable.toStringAsFixed(decimals), style: pw.TextStyle(font: font, )),
                ]),
            pw.Container(height:0.5, color: PdfColors.black,),
            if(type=='with')
              pw.Column(
                children:[
                  pw.Center(child: pw.Text('Category Wise', style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),),
                  pw.Container(height:0.5, color: PdfColors.black,),
                  pw.Table(
                      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                      // textDirection: pw.TextDirection.ltr,
                      border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                      children: rows),
                  pw.Container(height:0.5, color: PdfColors.black,),
                  pw.Container(height:0.5, color: PdfColors.black,),
                  pw.Center(child: pw.Text('Item Wise', style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),),
                  pw.Container(height:0.5, color: PdfColors.black,),
                  pw.Table(
                      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                      // textDirection: pw.TextDirection.ltr,
                      border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                      children: rows1),
                ]
              ),

          ]
      );
    }
    // pdf.addPage(pw.Page(
    //     pageFormat: PdfPageFormat.a5,
    //     build: (pw.Context context) {
    //       return pw.Column(
    //           children: [
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   pw.Text('Till Report', style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),
    //                   pw.Text(dateNow(), style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
    //                 ]),
    //             pw.Container(height:0.5, color: PdfColors.black,),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('Opening Cash', style: pw.TextStyle(font: font,)),
    //                   pw.Text(tillClose, style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Container(height:0.5, color: PdfColors.black,),
    //             pw.Center(child: pw.Text('Sales Summary', style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),),
    //             pw.Container(height:0.5, color: PdfColors.black,),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('Cash', style: pw.TextStyle(font: font,)),
    //                   pw.Text(cashSales.toString(), style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('Credit', style: pw.TextStyle(font: font,)),
    //                   pw.Text(creditSales.toString(), style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('UPI', style: pw.TextStyle(font: font,)),
    //                   pw.Text(upiSales.toString(), style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Container(height:0.5, color: PdfColors.black,),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('Sales Return', style: pw.TextStyle(font: font,)),
    //                   pw.Text(cashSalesReturn.toString(), style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('Purchase', style: pw.TextStyle(font: font,)),
    //                   pw.Text(cashPurchase.toString(), style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('Purchase Return', style: pw.TextStyle(font: font,)),
    //                   pw.Text(cashPurchaseReturn.toString(), style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('Total Receipts', style: pw.TextStyle(font: font,)),
    //                   pw.Text(receiptAmt.toString(), style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('Total Payments', style: pw.TextStyle(font: font,)),
    //                   pw.Text(paymentAmt.toString(), style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('Expense', style: pw.TextStyle(font: font,)),
    //                   pw.Text(expense.toString(), style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Container(height:0.5, color: PdfColors.black,),
    //             pw.Row(
    //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //                 children:[
    //                   pw.Text('Cash Available', style: pw.TextStyle(font: font,)),
    //                   pw.Text(cashAvailable.toString(), style: pw.TextStyle(font: font, )),
    //                 ]),
    //             pw.Container(height:0.5, color: PdfColors.black,),
    //             pw.Center(child: pw.Text('Category Wise', style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),),
    //             pw.Container(height:0.5, color: PdfColors.black,),
    //             pw.Table(
    //                 defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    //                 // textDirection: pw.TextDirection.ltr,
    //                 border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
    //                 children: rows),
    //             pw.Container(height:0.5, color: PdfColors.black,),
    //             pw.Container(height:0.5, color: PdfColors.black,),
    //             pw.Center(child: pw.Text('Item Wise', style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),),
    //             pw.Container(height:0.5, color: PdfColors.black,),
    //             pw.Table(
    //                 defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    //                 // textDirection: pw.TextDirection.ltr,
    //                 border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
    //                 children: rows1),
    //           ]
    //       ); // Center
    //     }));
    print('saved');
    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a6,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          build: (pw.Context context) => <pw.Widget>[
            top(),
          ]
      ),
    );
    List<int> bytes = await pdf.save();
    // html.AnchorElement(
    //     href:
    //     "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    //   ..setAttribute("download", "till_report.pdf")
    //   ..click();
    // await Printing.sharePdf(bytes: await pdf.save(), filename: 'till.pdf');
    // PdfPreview(
    //   build: (format) => pdf.save(),
    // );
    return pdf.save();
  }
  double getExclTotal(){
    double tempTotal=0;
    for(int i=0;i<cartListText.length;i++){
      List temp = cartListText[i].split(':');
      tempTotal+=double.parse(temp[2].toString().trim());
    }
    return tempTotal;
  }
  double getGrandTotal(double total,double tax){
    return total+tax;
  }
  Future<List<int>> demoReceipt(
      ep.PaperSize paper, ep.CapabilityProfile profile,String invNo) async {
    List<int> bytes = [];
    final ep.Generator ticket = ep.Generator(paper,profile);
    bytes += ticket.reset();
    double tax5=0;
    double tax10=0;
    double tax12=0;
    double tax18=0;
    double tax28=0;
    double cess=0;
    // Print image
    // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
    // final Uint8List imageBytes = data.buffer.asUint8List();
    // final Image? image = decodeImage(imageBytes);
    // bytes += ticket.image(image);

    bytes += ticket.text('$organisationName',
        styles: ep.PosStyles(
          align: ep.PosAlign.center,
          height: ep.PosTextSize.size2,
          width: ep.PosTextSize.size2,
        ));

    bytes += ticket.text('$organisationAddress',
        styles: ep.PosStyles(align: ep.PosAlign.center));
    if(organisationMobile.length>0)
      bytes += ticket.text('Mobile Number:$organisationMobile',
          styles: ep.PosStyles(align: ep.PosAlign.center));
    if(organisationGstNo.length>0){
      bytes += ticket.text('$organisationTaxType Number:$organisationGstNo',
          styles: ep.PosStyles(align: ep.PosAlign.center));
      bytes += ticket.text('$organisationTaxTitle',
          styles: ep.PosStyles(align: ep.PosAlign.center));
    }
    bytes += ticket.hr();
    bytes += ticket.text('Invoice No: $invNo',
        styles: ep.PosStyles(align: ep.PosAlign.left));
    bytes += ticket.text(dateNow(),
        styles: ep.PosStyles(align: ep.PosAlign.left));
    if (appbarCustomerController.text.length>0){
      bytes += ticket.text('Customer Name: ${appbarCustomerController.text}',
          styles: ep.PosStyles(align: ep.PosAlign.left));
      if(allCustomerAddress[customerList.indexOf(appbarCustomerController.text)].length>0)
        bytes += ticket.text('Customer Address: ${allCustomerAddress[customerList.indexOf(appbarCustomerController.text)]}',
            styles: ep.PosStyles(align: ep.PosAlign.left));
    }
    bytes += ticket.hr();
    if(orgMultiLine=='true'){
      bytes += ticket.text('Particulars',
          styles: ep.PosStyles(align: ep.PosAlign.left,bold: true));
      bytes += ticket.row([
        ep.PosColumn(text: '     Qty', width: 4,  styles: ep.PosStyles(bold: true,align: ep.PosAlign.right)),
        ep.PosColumn(text: '   Rate', width: 4, styles: ep.PosStyles(bold: true,align: ep.PosAlign.right) ),
        // if(organisationGstNo.length>0)
        //   ep.PosColumn(text: 'Tax%', width: 1,  styles: ep.PosStyles(bold: true)),
        ep.PosColumn(text: '    Amount', width: 4,  styles: ep.PosStyles(bold: true,align: ep.PosAlign.right)),
      ]);
    }
   else{
      bytes += ticket.row([
        ep.PosColumn(text: 'Particulars', width: 6,styles: ep.PosStyles(bold: true)),
        ep.PosColumn(text: '     Qty', width: 2,  styles: ep.PosStyles(bold: true,align: ep.PosAlign.right)),
        ep.PosColumn(text: '   Rate', width: 2, styles: ep.PosStyles(bold: true,align: ep.PosAlign.right) ),
        // if(organisationGstNo.length>0)
        //   ep.PosColumn(text: 'Tax%', width: 1,  styles: ep.PosStyles(bold: true)),
        ep.PosColumn(text: '    Amount', width: 2,  styles: ep.PosStyles(bold: true,align: ep.PosAlign.right)),
      ]);
    }
    bytes += ticket.hr();
    grandTotal=0;double exclTotal =0;
    totalTax=0;
    for(int i=0;i<cartListText.length;i++)
    {
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
      bytes += ticket.text('${cartItemsString[0]}',
          styles: ep.PosStyles(align: ep.PosAlign.left,bold: true));
      bytes += ticket.row([
        // ep.PosColumn(text: '${cartItemsString[0]}', width: organisationGstNo.length>0?7:8,styles: ep.PosStyles(bold: true)),
        ep.PosColumn(text: '${cartItemsString[3]}', width: 4,  styles: ep.PosStyles(bold: true,align: ep.PosAlign.right)),
        ep.PosColumn(text: '${price.toStringAsFixed(decimals)}', width: 4, styles: ep.PosStyles(bold: true,align: ep.PosAlign.right) ),
        // if(organisationGstNo.length>0)
        //   ep.PosColumn(text: '${getPercent(tax)}', width: 1,  styles: ep.PosStyles(bold: true)),
        ep.PosColumn(text: '${double.parse(cartItemsString[2].toString()).toStringAsFixed(
            decimals)}', width: 4,  styles: ep.PosStyles(bold: true,align: ep.PosAlign.right)),
      ]);

    }
    bytes += ticket.hr();
    if(organisationTaxType=='VAT'){
      exclTotal = grandTotal - tax10;
      bytes += ticket.row([
        ep.PosColumn(text: 'Bill Amount', width: 6, styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
        ep.PosColumn(text: '${exclTotal.toStringAsFixed(decimals)}', width: 6, styles: ep.PosStyles(bold:true,align: ep.PosAlign.right,)),
      ]);
      bytes += ticket.row([
        ep.PosColumn(text: 'Vat 10%', width: 6, styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
        ep.PosColumn(text: '${tax10.toStringAsFixed(decimals)}', width: 6, styles: ep.PosStyles(bold:true,align: ep.PosAlign.right,)),
      ]);
      grandTotal = exclTotal + tax10;
      bytes += ticket.row([
        ep.PosColumn(text: 'Net Payable', width: 6, styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
        ep.PosColumn(text: '$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6, styles: ep.PosStyles(bold:true,align: ep.PosAlign.right,)),
      ]);
    }
    else{

      if(organisationGstNo.length>0){
        exclTotal = grandTotal - totalTax;
        bytes += ticket.row([
          ep.PosColumn(text: 'Bill Amount', width: 6, styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
          ep.PosColumn(text: '${exclTotal.toStringAsFixed(decimals)}', width: 6, styles: ep.PosStyles(bold:true,align: ep.PosAlign.right,)),
        ]);

        bytes += ticket.row([
          ep.PosColumn(text: 'Total Tax', width: 5, styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
          ep.PosColumn(text: '${totalTax.toStringAsFixed(decimals)}', width: 7, styles: ep.PosStyles(bold:true,align: ep.PosAlign.right,)),
        ]);
        if(double.parse(totalDiscountController.text)>0){
          double tempDiscount=0;
          if(discountTypeSelected=='VAL'){
            grandTotal=grandTotal-double.parse(totalDiscountController.text);
            tempDiscount=double.parse(totalDiscountController.text);
          }
          else{
              double val=double.parse(totalDiscountController.text);
                val=val/100;
                val=val*grandTotal;
                tempDiscount=val;
                grandTotal=grandTotal-val;
          }
          bytes += ticket.row([
            ep.PosColumn(text: 'Discount', width: 5,styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
            ep.PosColumn(text: tempDiscount.toStringAsFixed(decimals), width: 7,styles: ep.PosStyles(bold:true,align: ep.PosAlign.right)),
          ]);
          // grandTotal = grandTotal - double.parse(totalDiscountController.text);
        }
        bytes += ticket.row([
          ep.PosColumn(text: 'Net Payable', width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
          ep.PosColumn(text: '$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.right)),
        ]);
        bytes += ticket.hr();
        if(tax5>0){
          bytes += ticket.row( [
            ep.PosColumn(text: 'CGST 2.5%', width: 6,styles: ep.PosStyles(align: ep.PosAlign.left)),
            ep.PosColumn(text: '${(tax5/2).toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(align: ep.PosAlign.right)),
          ]);
          bytes += ticket.row( [
            ep.PosColumn(text: 'SGST 2.5%', width: 6,styles: ep.PosStyles(align: ep.PosAlign.left)),
            ep.PosColumn(text: '${(tax5/2).toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(align: ep.PosAlign.right)),
          ]);
        }
        if(tax12>0){
          bytes += ticket.row([
            ep.PosColumn(text: 'CGST 6%', width: 6 ,styles: ep.PosStyles(align: ep.PosAlign.left)),
            ep.PosColumn(text: '${(tax12/2).toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(align: ep.PosAlign.right)),
          ]);
          bytes += ticket.row([
            ep.PosColumn(text: 'SGST 6%', width: 6,styles: ep.PosStyles(align: ep.PosAlign.left)),
            ep.PosColumn(text: '${(tax12/2).toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(align: ep.PosAlign.right)),
          ]);
        }
        if(tax18>0){
          bytes += ticket.row([
            ep.PosColumn(text: 'CGST 9%', width: 6,styles: ep.PosStyles(align: ep.PosAlign.left)),
            ep.PosColumn(text: '${(tax18/2).toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(align: ep.PosAlign.right)),
          ]);
          bytes += ticket.row([
            ep.PosColumn(text: 'SGST 9%', width:6 ,styles: ep.PosStyles(align: ep.PosAlign.left)),
            ep.PosColumn(text: '${(tax18/2).toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(align: ep.PosAlign.right)),
          ]);
        }
        if(tax28>0){
          bytes += ticket.row([
            ep.PosColumn(text: 'CGST 14%', width: 6 ,styles: ep.PosStyles(align: ep.PosAlign.left)),
            ep.PosColumn(text: '${(tax28/2).toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(align: ep.PosAlign.right)),
          ]);
          bytes += ticket.row([
            ep.PosColumn(text: 'SGST 14%', width: 6,styles: ep.PosStyles(align: ep.PosAlign.left)),
            ep.PosColumn(text: '${(tax28/2).toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(align: ep.PosAlign.right)),
          ]);

          bytes += ticket.row([
            ep.PosColumn(text: 'cess 12%', width: 6 ,styles: ep.PosStyles(align: ep.PosAlign.left)),
            ep.PosColumn(text: '${cess.toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.right)),
          ]);
        }
      }
      else{
        if(double.parse(totalDiscountController.text)>0){
          bytes += ticket.row([
            ep.PosColumn(text: 'Bill Amount', width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
            ep.PosColumn(text: '${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.right)),
          ]);
          double tempDiscount=0;
          if(discountTypeSelected=='VAL'){
            grandTotal=grandTotal-double.parse(totalDiscountController.text);
            tempDiscount=double.parse(totalDiscountController.text);
          }
          else{
            double val=double.parse(totalDiscountController.text);
            val=val/100;
            val=val*grandTotal;
            tempDiscount=val;
            grandTotal=grandTotal-val;
          }
          bytes += ticket.row([
            ep.PosColumn(text: 'Discount', width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
            ep.PosColumn(text: tempDiscount.toStringAsFixed(decimals), width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.right)),
          ]);
          // grandTotal = grandTotal - double.parse(totalDiscountController.text);
          bytes += ticket.row([
            ep.PosColumn(text: 'Net Payable', width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
            ep.PosColumn(text: '$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.right)),
          ]);
        }
        else{
          bytes += ticket.row([
            ep.PosColumn(text: 'Total', width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.left,)),
            ep.PosColumn(text: '$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: ep.PosStyles(bold:true,align: ep.PosAlign.right)),
          ]);
          bytes += ticket.hr(ch: '-');
        }
      }
    }
    if(organisationGstNo.length>0) bytes += ticket.hr(ch: '-');
    bytes += ticket.text('Thank You,Visit Again',
        styles: ep.PosStyles(align: ep.PosAlign.center, bold: true),linesAfter: 2);

    // Print QR Code from image
    // try {
    //   const String qrData = 'example.com';
    //   const double qrSize = 200;
    //   final uiImg = await QrPainter(
    //     data: qrData,
    //     version: QrVersions.auto,
    //     gapless: false,
    //   ).toImageData(qrSize);
    //   final dir = await getTemporaryDirectory();
    //   final pathName = '${dir.path}/qr_tmp.png';
    //   final qrFile = File(pathName);
    //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
    //   final img = decodeImage(imgFile.readAsBytesSync());

    //   bytes += ticket.image(img);
    // } catch (e) {
    //   print(e);
    // }

    // Print QR Code using native function
    // bytes += ticket.qrcode('example.com');

    ticket.feed(2);
    ticket.cut();
    return bytes;
  }

  Future<List<int>> bluetoothKot(
      ep.PaperSize paper, ep.CapabilityProfile profile,String invNo,String table,List tempPrintList,String tempCategory) async{
    List<int> bytes = [];
    final ep.Generator ticket = ep.Generator(paper,profile);
    bytes += ticket.reset();
    bytes += ticket.text('KOT', styles: ep.PosStyles(align: ep.PosAlign.center,));
    bytes += ticket.text('User :$currentUser', styles: ep.PosStyles(align: ep.PosAlign.center,));
    bytes += ticket.text('Section :$tempCategory', styles: ep.PosStyles(align: ep.PosAlign.center,));
    bytes += ticket.text(table, styles: ep.PosStyles(align: ep.PosAlign.center,));
    bytes +=ticket.hr();
    bytes += ticket.text('Order No: $invNo', styles: ep.PosStyles(align: ep.PosAlign.left,));
    bytes += ticket.text(dateNow(), styles: ep.PosStyles(align: ep.PosAlign.left,));
    bytes +=ticket.hr();
    bytes += ticket.row([
      ep.PosColumn(text: 'Item', width: 10,  styles: ep.PosStyles(bold: true)),
      ep.PosColumn(text: 'Qty', width: 2, styles: ep.PosStyles(bold: true) ),
    ]);
    bytes +=ticket.hr();
    for(int i=0;i<tempPrintList.length;i++)
    {
      List cartItemsString=tempPrintList[i].split(':');
      String temp=cartItemsString[2].toString().replaceAll(' ', '');
      bytes += ticket.row([
      temp.length>0?ep.PosColumn(text:'''${cartItemsString[2].length>0?'${cartItemsString[0]} \n ${cartItemsString[2]}':'${cartItemsString[0]}'}''', width: 10, styles: ep.PosStyles(align: ep.PosAlign.left,bold: true)):
    ep.PosColumn(text: '${cartItemsString[0]}', width:10, styles: ep.PosStyles(align: ep.PosAlign.left,bold: true)),
    ep.PosColumn(text: '${cartItemsString[1]}', width: 2, styles: ep.PosStyles(align: ep.PosAlign.left,bold: true)),
  ]);
  }
    bytes += ticket.text('',
        styles: ep.PosStyles(align: ep.PosAlign.center, bold: true),linesAfter: 2);
    ticket.feed(2);
    ticket.cut();
    return bytes;
  }

  // void _testPrint(pb.PrinterBluetooth printer) async {
  //   print('inside test print');
  //   printerManager.selectPrinter(printer);
  //
  //   // TODO Don't forget to choose printer's paper
  //   const PaperSize paper = PaperSize.mm58;
  //   final profile = await CapabilityProfile.load();
  //
  //   // TEST PRINT
  //   // final PosPrintResult res =
  //   // await printerManager.printTicket(await testTicket(paper));
  //
  //   // DEMO RECEIPT
  //   final pb.PosPrintResult res =
  //   await printerManager.printTicket((await demoReceipt(paper, profile)));
  //   print('resulttttttt ${res.msg}');
  // }

  Future checkOut(String currentOrderNo,bool checkoutPrint,int pMode,String dPaymentS,String dTotalS) async {
    String tempDeliveryBoy='';
    double balance=0;
    // bool isOnline = await hasNetwork();
    // print('resulttttttt $isOnline');
    // if(!isOnline){
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Interne
    //   t is not available')));
    //   return;
    // }
    if(cartListText.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add Items')));
      return;
    }
    else    if(selectedDelivery=='Delivery' && deliveryCheckoutFlag==true){
      showDialog(
        context:
        context,
        builder: (ctx) =>
            AlertDialog(
              title: Text("checkout already given"),
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
    setState(() {
      checkoutFlag=false;
    });
    // print('current order inside checkout $currentOrderNo');
    String tempBody;
    double tot = getTotal(salesTotalList);
    String tempOrder='';
    checkoutModifierList=[];
if(invEdit.value){
  QuerySnapshot<Map<String, dynamic>> querySnapshot=await firebaseFirestore.collection('item_report').where('orderNo',isEqualTo: invEditNumber.value).get();
  int len1=querySnapshot.docs.length;
  for(int i=0;i<len1;i++){
    await firebaseFirestore.collection('item_report').doc(querySnapshot.docs[i].id).delete();
  }
if(invEditCustomerName.value.length>0){
  DocumentSnapshot documentSnapshot=await firebaseFirestore.collection('customer_report').doc(invEditCustomerName.value).get();
  if(documentSnapshot.exists){
    List tempData=documentSnapshot.get('data');
    int len=documentSnapshot.get('data').length;
    for(int i=0;i<len;i++){
      if(tempData[i].toString().contains(invEditNumber.value)){

        List tempRemove=[];
        tempData.removeAt(i);
        // tempRemove.add(tempData[i]);
        firebaseFirestore.collection('customer_report').doc(invEditCustomerName.value).update(
            {"data": tempData});
        break;
      }
    }
  }
  }

  await firebaseFirestore.collection('vat_report').doc(invEditNumber.value).delete();
if(invEditPaymentMethod.value.contains('*')){
  List tempInvEditPayment=invEditPaymentMethod.value.split('*');
  for(int j=0;j<2;j++){
    if(tempInvEditPayment[j].toString().trim()=='Credit'){
      List tempT=invEditTotal.value.split('*');
      double tempTotal12=double.parse(tempT[j].toString().trim());
      String bal=getCustomerBalance(invEditCustomerName.value);
      String uidVal=getCustomerUid(invEditCustomerName.value);
      double tempBalance=double.parse(bal.isNotEmpty?bal:'0')-tempTotal12;
      int pos = customerList.indexOf(invEditCustomerName.value);
      customerBalanceList[pos]=tempBalance.toString();
      await firebaseFirestore.collection('customer_details').doc(uidVal).update({
        "balance":tempBalance.toString(),
      }).then((_) {
      });
    }
    if(tempInvEditPayment[j].toString().trim()=='Cash' && invEditDate.value<tillCloseTime){
      await firebaseFirestore.collection('user_data').doc(currentUser).update(
          {
            "tillClose":FieldValue.increment(-(double.parse(invEditTotal.value))),
          }
      );
    }
  }
}
else{
  if(invEditPaymentMethod.value=='Credit'){
    String bal=getCustomerBalance(invEditCustomerName.value);
    String uidVal=getCustomerUid(invEditCustomerName.value);
    double tempBalance=double.parse(bal.isNotEmpty?bal:'0')-double.parse(invEditTotal.value);
    int pos = customerList.indexOf(invEditCustomerName.value);
    customerBalanceList[pos]=tempBalance.toString();
    await firebaseFirestore.collection('customer_details').doc(uidVal).update({
      "balance":tempBalance.toString(),
    }).then((_) {
    });
  }
  if(invEditPaymentMethod.value=='Cash' && invEditDate.value<tillCloseTime){
    await firebaseFirestore.collection('user_data').doc(currentUser).update(
        {
          "tillClose":FieldValue.increment(-(double.parse(invEditTotal.value))),
        }
    );
  }
}
  for(int k=0;k<invEditCartList.value.length;k++){
    List temp=invEditCartList.value[k].split(':');
    String itemName=temp[0];
    String itemQty=temp[3].toString().trim();
    String itemPrice=temp[2];
    String itemUom=temp[1];

    String tempBom=checkIfBomExist(itemName);
    if(tempBom.isNotEmpty){
      String itemConversion00=getConversion(itemName, itemUom);
      itemConversion00=itemConversion00=='0'?'1':itemConversion00;
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
        tempQty=tempQty*double.parse(itemQty)*double.parse(itemConversion00);
        tempBomQty[i]=tempQty.toString();
        String stockDetails=await readStock(tempBomItem[i]);
        List itemStockDetailsSplit=stockDetails.split('~');
        String stockQuantity=itemStockDetailsSplit[1].toString().trim();
        String costPrice=itemStockDetailsSplit[2].toString().trim();
        String stockValue=itemStockDetailsSplit[3].toString().trim();
        double newStockQuantity=double.parse(stockQuantity)+double.parse(tempBomQty[i]);
        double newSockValue=newStockQuantity*double.parse(costPrice);
        String stockBody='${tempBomItem[i]}~${newStockQuantity.toString()}~$costPrice~${newSockValue.toStringAsFixed(3)}';
        await updateStock(stockBody);
        updateWarehouse(tempBomItem[i],tempBomQty[i],'purchase');
        String tempBom2=checkIfBomExist(tempBomItem[i]);
        String bomName=tempBomItem[i];
        if(tempBom2.isNotEmpty){
          List tempBom3=tempBom2.split('``');
          List tempBomItem3=tempBom3[0].toString().split('*');
          List tempBomUom3=tempBom3[1].toString().split('*');
          List tempBomQty3=tempBom3[2].toString().split('*');
          tempBomItem3.removeLast();
          tempBomUom3.removeLast();
          tempBomQty3.removeLast();
          for(int i=0;i<tempBomItem3.length;i++) {
            String itemConversion3 = getConversion(
                tempBomItem3[i], tempBomUom3[i]);
            itemConversion3 = itemConversion3 == '0' ? '1' : itemConversion3;
            double tempQty3 = double.parse(tempBomQty3[i]) *
                double.parse(itemConversion3);
            tempQty3=tempQty3*tempQty;
            tempBomQty3[i] = tempQty3.toString();
            String stockDetails = await readStock(tempBomItem3[i]);
            List itemStockDetailsSplit = stockDetails.split('~');
            String stockQuantity = itemStockDetailsSplit[1].toString().trim();
            String costPrice = itemStockDetailsSplit[2].toString().trim();
            String stockValue = itemStockDetailsSplit[3].toString().trim();
            double newStockQuantity = double.parse(stockQuantity) +
                double.parse(tempBomQty3[i]);
            double newSockValue = newStockQuantity * double.parse(costPrice);
            String stockBody = '${tempBomItem3[i]}~${newStockQuantity
                .toString()}~$costPrice~${newSockValue.toStringAsFixed(3)}';
            await updateStock(stockBody);
            updateWarehouse(tempBomItem3[i], tempBomQty3[i], 'purchase');
          }
        }
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
    double newStockQuantity=double.parse(stockQuantity)+double.parse(itemQty);
    double newSockValue=newStockQuantity*double.parse(costPrice);
    String stockBody='$itemName~${newStockQuantity.toString()}~$costPrice~${newSockValue.toStringAsFixed(3)}';
    await updateStock(stockBody);
    updateWarehouse(itemName,itemQty,'purchase');
  }
}
    if(currentOrderNo.length>0 ) {
      String tempTerminal=terminalList[userList.indexOf(createdBy)];
      if(tempTerminal=='Salesman'){
        DocumentSnapshot tempDoc= await firebaseFirestore.collection('invoice_list').doc(currentOrderNo).get();
        for(int k=0;k<tempDoc.get('cartList').length;k++){
          checkoutModifierList.add(tempDoc['cartList'][k]['modifier']);
        }
        firebaseFirestore.collection('invoice_list').doc(currentOrderNo).delete();
      }
      else{
        DocumentSnapshot tempDoc= await firebaseFirestore.collection('kot_order').doc(currentOrderNo).get();
        for(int k=0;k<tempDoc.get('cartList').length;k++){
          checkoutModifierList.add(tempDoc['cartList'][k]['modifier']);
        }
        firebaseFirestore.collection('kot_order').doc(currentOrderNo).delete();
      }
      if(selectedDelivery=='Spot'){
        removeTable(tableSelected.value,currentOrderNo);
      }
    }
    else{
      tempOrder=userPrefixList[userList.indexOf(currentUser)];
      createdBy=currentUser;
      checkoutModifierList=[];
      for(int k=0;k<cartListText.length;k++){
        List temp=cartListText[k].toString().split(':');
        if(temp.length==5)
        checkoutModifierList.add(temp[4].toString().trim());
        else
          checkoutModifierList.add('');
      }
    }

    // tempBody='Invoice No:$salesPrefix${ getSalesInvoiceNo().toString()}-Date:${dateNow()}-Customer Name:$selectedCustomer-Items:$cartListText-Payment:$selectedPayment-Delivery:$selectedDelivery-Total:$tot-Sales-$taxCum~-';
    String invCustomer='';
    if(customerUserUid.length>0){
      invCustomer=customerUserName;
    }
    else{
      invCustomer=selectedCustomer.length>0?selectedCustomer:'Standard';
    }
    if(customerOrderUid.length>0){
      deliveryKotFlag=false;
      tempDeliveryBoy=customerOrderDeliveryBoy;
      if(tempDeliveryBoy.trim()==''){
        firebaseFirestore.collection('customer_orders').doc(customerOrderUid).delete();
      }
      else{
        firebaseFirestore.collection('customer_orders').doc(customerOrderUid).update({
          "checkOut":true,
        });
    }
    }
    int invNo;
      invNo=await getLastInv('sales');
    List yourItemsList1=[];
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
    String tempEditInv='';
    if(invEdit.value){
      tempEditInv=invEditNumber.value;
    }
    else{
      tempEditInv='$userSalesPrefix$invNo';
    }
    String body='$tempEditInv~${dateNow()}~$invCustomer~$dPaymentS~$selectedDelivery~$dTotalS~Sales~$currentUser~$currentOrderNo~$createdBy~$balance~$tempDeliveryBoy';
    yourItemsList1.add({
     "invNo":"$tempEditInv",
      "date":DateTime.now().millisecondsSinceEpoch,
      "payment":dPaymentS,
      "total":dTotalS,
      "type":'Sales'
    });
    double taxable5=0;
    double taxable10=0;
    double taxable15=0;
    double tax5=0;
    double total5=0;
    double total0=0;
    double tempNetPayable=0;
    double tempbillAmount=0;
    double tempDiscount=0;
    String totalTaxDetails='';
    double gstTax5=0;
    double tax10=0;
    double tax12=0;
    double tax18=0;
    double tax28=0;
    double cess=0;
    List yourItemsList=[];
    totalTax=0;
    for(int k=0;k<cartListText.length;k++){
      List temp=cartListText[k].split(':');
      String itemName=temp[0];
      String itemQty=temp[3];
      String itemUom=temp[1];
      String itemPrice=temp[2];
      double amt = double.parse(temp[2]);
      amt = double.parse((amt).toStringAsFixed(decimals));
      tempNetPayable += amt;
      String itemTax=getTaxName(itemName);
      String taxPercent=getPercent(itemTax);
      if(organisationTaxType=='VAT'){
        if(taxPercent.trim()=='10'){
print('inside if vat 10');
taxable10+= double.parse(itemPrice)*(100/110);
totalTax+=  double.parse(itemPrice)*(10/110);
          // taxable5= double.parse(itemPrice)*0.1;
          // taxable5=  double.parse(itemPrice)-double.parse(itemPrice)/1.1;
          // tax5=tax5+double.parse(itemPrice)-double.parse(itemPrice)/1.1;
          // total5+=double.parse(itemPrice);
          // taxable5 = total5-tax5;

        }
        else if(taxPercent.trim()=='15'){

          taxable15+= double.parse(itemPrice)*(100/115);
          totalTax+=  double.parse(itemPrice)*(15/115);
          // tax15=tax15+double.parse(itemPrice)-double.parse(itemPrice)/1.1;
          // total15+=double.parse(itemPrice);
          // taxable15 = total15-tax15;
        }
        else{
          //print('inside 0 tax');
          total0+=double.parse(itemPrice);
        }
      }
      else{

        String tax = getTaxName(temp[0].toString().trim());
        double price = double.parse(temp[2]) /
            double.parse(temp[3]);
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
      }

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
      String itemBody='$tempEditInv~$itemName~$itemUom~$itemQty~$itemPrice~${getCategory(itemName)}~$itemTax~$taxPercent~$taxAmt~$lineTotal~$selectedDelivery';
      create(itemBody, 'item_report', yourItemsList);
    }
totalTaxDetails='$tax5~$tax12~$tax18~$tax28~$cess';
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
    body+='~${tempDiscount}';
    body+='~${customerUserUid}';
    if(checkoutPrint==true){
      tempbillAmount=tempNetPayable-totalTax;
      tempNetPayable=tempNetPayable-tempDiscount;
     if(currentPrinter=='Network'){
          const PaperSize paper = PaperSize.mm80;
          final profile = await CapabilityProfile.load();
          final printer = NetworkPrinter(paper, profile);
          //defaultIpAddress = "192.168.5.80";
          //defaultPort = "9100";
          try{
            // final PosPrintResult res = await printer.connect(defaultIpAddress, port: int.parse(defaultPort),timeout: Duration(seconds: 10));
            final PosPrintResult res = await printer.connect(allPrinterIp[allPrinter.indexOf(currentPrinterName)], port: 9100);

            if (res == PosPrintResult.success) {

              if(organisationInvPrint=='One'){
                await  networkPrint('$tempEditInv',printer,tempDiscount );
              }
              else{
                await  networkPrint('$tempEditInv',printer,tempDiscount );
                await  networkPrint('$tempEditInv',printer,tempDiscount );

              }

              printer.disconnect();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print result: ${res.msg}')));

              //  await networkPrint1(printer);

            }
            else{
              //await  networkPrint('$userSalesPrefix$invNo',printer );
              //printer.disconnect();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print result: ${res.msg}')));
            }
          }
          catch(e){

          }
      }
      else if(currentPrinter=='PDF A4'){
        generatePdf('dot orders',cartListText,'$tempEditInv',appbarCustomerController.text,tempNetPayable,tempDiscount,totalTax,tempbillAmount,totalTaxDetails,cartListText.length);
      }
     else if(currentPrinter=='PDF Thermal'){
        if(selectedBusiness=='Restaurant'){
          if(orgQrCodeIs=='true'){
            arabicPdf('dot orders',cartListText,'$tempEditInv',appbarCustomerController.text,tempNetPayable,tempDiscount,totalTax,tempbillAmount,totalTaxDetails,cartListText.length,dPaymentS,dTotalS);
          }
          else{
            restaurantPdf('dot orders',cartListText,'$tempEditInv',appbarCustomerController.text,tempNetPayable,tempDiscount,totalTax,tempbillAmount,totalTaxDetails,cartListText.length,dPaymentS,dTotalS);
          }
        }
        else{
          retailPdf('dot orders',cartListText,'$tempEditInv',appbarCustomerController.text,tempNetPayable,tempDiscount,totalTax,tempbillAmount,totalTaxDetails,cartListText.length,dPaymentS,dTotalS);
        }

      }
     else if(currentPrinter=='T2MINI'){
// sunmiT1Print('$tempEditInv');
//         sunmiPrint('$userSalesPrefix$invNo', '');
      }
     else if(currentPrinter=='Bluetooth'){
       final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
       if(connectionStatus==false){
         print('bluetooth false ${allPrinterIp[allPrinter.indexOf(currentPrinterName)]}');
         final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: allPrinterIp[allPrinter.indexOf(currentPrinterName)]);
         print('resultttt $result');
         const ep.PaperSize paper = ep.PaperSize.mm58;
         final profile = await ep.CapabilityProfile.load();
         List<int> ticket = await demoReceipt(paper,profile,'$tempEditInv');
         final result1 = await PrintBluetoothThermal.writeBytes(ticket);
       }
       else{
         print('bluetooth true');
         const ep.PaperSize paper = ep.PaperSize.mm58;
         final profile = await ep.CapabilityProfile.load();
         List<int> ticket = await demoReceipt(paper,profile,'$tempEditInv');
         final result = await PrintBluetoothThermal.writeBytes(ticket);
       }
      }
    }
    await firebaseFirestore.collection("customer_details").where('mobile',isEqualTo:numforroute.toString().trim()).get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        searchcurrentroute = result.get('route');
      });
    });
    body+='~${searchcurrentroute}';
    if(invEdit.value){
firebaseFirestore.collection('invoice_data').doc(invEditNumber.value).set(
    {
      'orderNo': invEditNumber.value,
      'date': DateTime.now().millisecondsSinceEpoch,
      'customer': invCustomer,
      'cartList': yourItemsList,
      'payment':dPaymentS,
      'deliveryType': selectedDelivery,
      'total': dTotalS,
      'transactionType': 'Sales',
      'user': getUser(tempOrder),
      'kotNumber': invEditKotNumber.value,
      'createdBy': invEditCreatedBy.value,
      'balance': balance,
      'deliveryBoy': invEditDeliveryBoy.value,
      'discount':tempDiscount,
      'textFile':false,
      'route':searchcurrentroute.toString().trim()
    });
    }
    else{

      print(searchCustomerResult);
     create(body, 'invoice_data', yourItemsList);
      updateInv('sales',invNo+1);
    }
    create(invCustomer, 'customer_report', yourItemsList1);
    String vatBody='$tempEditInv~${dateNow()}~$invCustomer~${getVat(selectedCustomer)}~${salesTotal.toStringAsFixed(3)}~${taxable5.toStringAsFixed(3)}~${tax5.toStringAsFixed(3)}~${total5.toStringAsFixed(3)}~${total0.toStringAsFixed(3)}~sales';
    create(vatBody, 'vat_report', []);
    if(dPaymentS.contains('*')){
      List tempDPaymentS=dPaymentS.split('*');
      List tempDTotalS=dTotalS.split('*');
      for(int i=0;i<2;i++){
     if(tempDPaymentS[i]=='Credit'){
      updateReport(invCustomer, tempDTotalS[i].toString().trim(), 'customer_details',getCustomerUid(invCustomer),getCustomerBalance(invCustomer),'sales');
    }
      }
    }
    else if(dPaymentS=='Credit'){
      updateReport(invCustomer, dTotalS, 'customer_details',getCustomerUid(invCustomer),getCustomerBalance(invCustomer),'sales');
    }
    for(int k=0;k<cartListText.length;k++){
      List temp=cartListText[k].split(':');
      String itemName=temp[0];
      String itemQty=temp[3].toString().trim();
      String itemPrice=temp[2];
      String itemUom=temp[1];
      String tempBom=checkIfBomExist(itemName);
      if(tempBom.isNotEmpty){
        String itemConversion00=getConversion(itemName, itemUom);
        itemConversion00=itemConversion00=='0'?'1':itemConversion00;
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
          tempQty=tempQty*double.parse(itemQty)*double.parse(itemConversion00);
          tempBomQty[i]=tempQty.toString();
          print('final qty ${tempBomQty[i]}');
          String stockDetails=await readStock(tempBomItem[i]);
          List itemStockDetailsSplit=stockDetails.split('~');
          String stockQuantity=itemStockDetailsSplit[1].toString().trim();
          String costPrice=itemStockDetailsSplit[2].toString().trim();
          String stockValue=itemStockDetailsSplit[3].toString().trim();
          double newStockQuantity=double.parse(stockQuantity)-double.parse(tempBomQty[i]);
          double newSockValue=newStockQuantity*double.parse(costPrice);
          String stockBody='${tempBomItem[i]}~${newStockQuantity.toString()}~$costPrice~${newSockValue.toStringAsFixed(3)}';
          await updateStock(stockBody);
          updateWarehouse(tempBomItem[i],tempBomQty[i],'sales');
          String tempBom2=checkIfBomExist(tempBomItem[i]);
          String bomName=tempBomItem[i];
          if(tempBom2.isNotEmpty){
            List tempBom3=tempBom2.split('``');
            List tempBomItem3=tempBom3[0].toString().split('*');
            List tempBomUom3=tempBom3[1].toString().split('*');
            List tempBomQty3=tempBom3[2].toString().split('*');
            tempBomItem3.removeLast();
            tempBomUom3.removeLast();
            tempBomQty3.removeLast();
            for(int i=0;i<tempBomItem3.length;i++) {
              String itemConversion3 = getConversion(
                  tempBomItem3[i], tempBomUom3[i]);
              itemConversion3 = itemConversion3 == '0' ? '1' : itemConversion3;
              double tempQty3 = double.parse(tempBomQty3[i]) *
                  double.parse(itemConversion3);
              tempQty3=tempQty3*tempQty;
              tempBomQty3[i] = tempQty3.toString();
              String stockDetails = await readStock(tempBomItem3[i]);
              List itemStockDetailsSplit = stockDetails.split('~');
              String stockQuantity = itemStockDetailsSplit[1].toString().trim();
              String costPrice = itemStockDetailsSplit[2].toString().trim();
              String stockValue = itemStockDetailsSplit[3].toString().trim();
              double newStockQuantity = double.parse(stockQuantity) -
                  double.parse(tempBomQty3[i]);
              double newSockValue = newStockQuantity * double.parse(costPrice);
              String stockBody = '${tempBomItem3[i]}~${newStockQuantity
                  .toString()}~$costPrice~${newSockValue.toStringAsFixed(3)}';
              await updateStock(stockBody);
              updateWarehouse(tempBomItem3[i], tempBomQty3[i], 'sales');
            }
          }
        }
      }
      if(cartComboList.length>0){
        for(int m=0;m<cartComboList.length;m++){
          List temp123=cartComboList[m].toString().split(';');
          if(temp123[0].toString().trim()==itemName.trim()) {
            List temp223=temp123[1].toString().split('~');
            for(int n=0;n<temp223.length;n++){
              List temp443=temp223[n].toString().split(':');
              String itemName=temp443[0].toString().trim();
              String itemQty=temp443[2].toString().trim();
              // String itemPrice=temp443[2];
              String itemUom=temp443[1];
              String itemConversion=getConversion(itemName, itemUom);
              itemConversion=itemConversion=='0'?'1':itemConversion;
              double tempQty=double.parse(itemQty)*double.parse(itemConversion);
              itemQty=tempQty.toString();
              String stockDetails=await readStock(itemName);
              print('stockDetails $stockDetails');
              List itemStockDetailsSplit=stockDetails.split('~');
              String stockQuantity=itemStockDetailsSplit[1].toString().trim();
              String costPrice=itemStockDetailsSplit[2].toString().trim();
              String stockValue=itemStockDetailsSplit[3].toString().trim();
              double newStockQuantity=double.parse(stockQuantity)-double.parse(itemQty);
              double newSockValue=newStockQuantity*double.parse(costPrice);
              String stockBody='$itemName~${newStockQuantity.toString()}~$costPrice~${newSockValue.toStringAsFixed(3)}';
             print('stock body $stockBody');
              await updateStock(stockBody);
              updateWarehouse(itemName,itemQty,'sales');
            }
          }
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
    setState(() {
      selectedCustomer='';
      appbarCustomerController.clear();
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
    //    await insertData(vatBody,'vat_report');

    //    //sunmiPrint('$salesPrefix$invNo',totalDiscountController.text.length>0?totalDiscountController.text:'0');
    // // bluetoothPrint(cartListText,'$salesPrefix$invNo',totalDiscountController.text);

    customerName="";
    return;
  }
String getFirstTable(String text){
    List temp=text.split('~');
    return temp[0].toString().trim();
}
  List<String> tempDeliveryBoy=[];

  List _list=[];
  String _searchText='';
  bool _isSearching=true;
  int countValueCheckout=0;
  int countValueOrder=0;
  int countValueCustomer=0;
  Timer _timer;
  DbCon dbCon=DbCon();
  var stream1= firebaseFirestore.collection('kot_order').where('user',isEqualTo: currentUser).where('type',isEqualTo:'Spot' ).snapshots();
  @override

  void initState() {

    // TODO: implement initState
    // nameNode.requestFocus();

    read('kot_data');
    read('kotOrders');
   paymentMode=mainPaymentList;
    // quantityNode=FocusNode();
    // nameNode=FocusNode();
    selectedCategory='All';
    // if(selectedBusiness=='Restaurant')
    //   SchedulerBinding.instance.addPostFrameCallback((_) => showDialog(
    //     context: context,
    //     builder:(BuildContext context)=>tableView(context),));

    super.initState();


  }
  @override
  void dispose() {
    // TODO: implement dispose
    // nameNode.dispose();
    // quantityNode.dispose();
    //cancel the timer
    // if(dbConnected=='1'){
    //   if (_timer.isActive) _timer.cancel();
    // }
    super.dispose();
  }

  void searchOperation(String text) {
    searchResult.clear();
    if(text.length>0){
      for (int i = 0; i < allProducts.length; i++) {
        String data = allProducts[i];
        if (data.toLowerCase().contains(text.toLowerCase().replaceAll('/', '#'))) {
          searchResult.add(data);
        }
      }
    }
    else{
      searchResult.clear();
    }
  }
  void searchBranch(String text) {
    branchResult.clear();
    if(text.length>0){
      print('inside ifffffff $text');
      for (int i = 0; i < allBranch.length; i++) {
        String data = allBranch[i];
        if (data.toLowerCase().contains(text.toLowerCase())) {
          branchResult.add(data);
          print('branchResult ${branchResult}');
        }
      }
    }
    else{
      print('inside elseeeeeeeeee $text');
      branchResult.clear();
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return MaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      builder: ( context,widget)=>SafeArea(
        child: Scaffold(
            drawerEnableOpenDragGesture: currentTerminal!='Call Center'?true:false,
            endDrawerEnableOpenDragGesture:currentTerminal=='Admin-POS'?true:false,
            key: _scaffoldKey,
            // drawer: MyDrawer(),
            // endDrawer: Drawer2(),
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
                                    if(currentTerminal!='Call Center')IconButton(onPressed: (){
                                      _scaffoldKey.currentState.openDrawer();
                                    }, icon: Icon(Icons.menu),color: kItemContainer,),
                                    if(currentTerminal!='Call Center')
                                      CustomerSelect(),
                                    if(currentTerminal!='Call Center') Row(
                                      children: [
                                        IconButton(onPressed: () {
                                          if(selectedCustomer.isEmpty){
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
                                          else{
                                            crInv=[];
                                            crDate=[];
                                            crPayment=[];
                                            crTotal=[];
                                            crTransaction=[];
                                            toDate =DateTime.now();
                                            toDate1=DateTime.now().millisecondsSinceEpoch;
                                            print('selectedCustomer $selectedCustomer');
                                            showDialog(context: context, builder: (BuildContext context){
                                              return StreamBuilder(
                                                  stream: firebaseFirestore.collection('customer_report').doc(selectedCustomer).snapshots(),
                                                  builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot2) {
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
                                                                          crInv=[];
                                                                          crDate=[];
                                                                          crPayment=[];
                                                                          crTotal=[];
                                                                          crTransaction=[];
                                                                          for(int i=0;i<snapshot2.data['data'].length;i++){
                                                                            print('presss $toDate1');
                                                                            print('presss ${snapshot2.data['data'][i]['date']}');
                                                                            if(snapshot2.data['data'][i]['date']>=fromDate1 && snapshot2.data['data'][i]['date']<=toDate1) {
                                                                              print('inside $fromDate1');
                                                                              crInv.add(snapshot2.data['data'][i]['invNo']);
                                                                              print(crInv);
                                                                              crDate.add(snapshot2.data['data'][i]['date']);
                                                                              crPayment.add(snapshot2.data['data'][i]['payment']);
                                                                              crTotal.add(snapshot2.data['data'][i]['total'].toString());
                                                                              crTransaction.add(snapshot2.data['data'][i]['type']);
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
                                                                            crInv.length, (index) =>
                                                                            DataRow(cells: [
                                                                              DataCell(Text(crInv[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                              DataCell(Text(convertEpox(crDate[index]).substring(0,16), style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                              DataCell(Text(crPayment[index].contains('*')?crPayment[index].replaceAll('*','/'):crPayment[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                              DataCell(Text(crTotal[index].contains('*')?crTotal[index].replaceAll('*','/'):crTotal[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),
                                                                              DataCell(Text(crTransaction[index], style: TextStyle(fontSize: MediaQuery.of(context).textScaleFactor * 15,))),]))),
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
                                                                            StreamBuilder(stream: firebaseFirestore.collection('customer_report').doc(selectedCustomer).snapshots(),
                                                                                builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
                                                                                  if (!snapshot.hasData) {
                                                                                    return Text(
                                                                                        '0'
                                                                                    );
                                                                                  }
                                                                                  var ds = snapshot.data['data'];
                                                                                  double totalCredit = 0.0;
                                                                                  double totalReturnsCredit = 0.0;
                                                                                  double receipts = 0.0;
                                                                                  double balance = 0.0;
                                                                                  for(int i=0; i<ds.length;i++){
                                                                                      if(ds[i]['type']=='Sales' || ds[i]['type']=='Sales Return') {
                                                                                        if(ds[i]['payment'].contains('*')){
                                                                                          List tempDPayment=ds[i]['payment'].split('*');
                                                                                          List tempDTotal=ds[i]['total'].split('*');
                                                                                          for(int j=0;j<2;j++){
                                                                                            print('iiiiii ${tempDPayment[j]}');
                                                                                            if(tempDPayment[j].toString().trim()=='Credit'){
                                                                                              print('inside if equals credit ${ds[i]['invNo']}');
                                                                                              if(ds[i]['type']=='Sales') {
                                                                                                totalCredit += double.parse(tempDTotal[j].toString().trim());
                                                                                              } else {
                                                                                                totalReturnsCredit += double.parse(tempDTotal[j].toString().trim());
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                        else{
                                                                                          if(ds[i]['payment']=='Credit'){
                                                                                            if(ds[i]['type']=='Sales') {
                                                                                              totalCredit +=double.parse(ds[i]['total'].toString());
                                                                                            } else {
                                                                                              totalReturnsCredit += double.parse(ds[i]['total'].toString());
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    else if(ds[i]['type']=='Receipt'){
                                                                                      receipts+=ds[i]['total'];
                                                                                    }
                                                                                  }
                                                                                  balance=totalCredit-(receipts+totalReturnsCredit);
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
                                        }, icon: Icon(Icons.account_circle_rounded,color: kItemContainer)),
                                        IconButton(
                                            tooltip: 'Add Customer',
                                            icon: SvgPicture.asset('images/customer2.svg'), onPressed: ()async{
                                          allCustomerMobileNameController.clear();
                                          allCustomerMobileAddressController.clear();
                                          allCustomerMobileController.clear();
                                          flatNoController.clear();
                                          buildNoController.clear();
                                          roadNoController.clear();
                                          blockNoController.clear();
                                          areaNoController.clear();
                                          landmarkNoController.clear();
                                          deliveryNoteController.clear();
                                        await   read('route_data');

                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                    child: Container(
                                                      padding: EdgeInsets.all(6.0),
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.vertical,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(context).size.width/3,
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Customer details',
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                    ),
                                                                  ),
                                                                  TextField(
                                                                    controller: allCustomerMobileController,
                                                                    onChanged: (value) {
                                                                    },
                                                                    keyboardType:
                                                                    TextInputType.number,
                                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                                                      labelText: 'Number',
                                                                      labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 20.0,),
                                                                  TextField(
                                                                    controller: allCustomerMobileNameController,
                                                                    onChanged: (value) {
                                                                    },
                                                                    keyboardType:
                                                                    TextInputType.name,
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
                                                                      labelText: 'Name',
                                                                      labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 20.0,),
                                                                  TextField(
                                                                    controller: allCustomerMobileAddressController,
                                                                    onChanged: (value) {
                                                                    },
                                                                    keyboardType:
                                                                    TextInputType.name,
                                                                    maxLines: 3,
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
                                                                      labelText: 'Address',
                                                                      labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 20.0,),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Expanded(
                                                                        child: TextField(
                                                                          controller: flatNoController,
                                                                          onChanged: (value) {
                                                                          },
                                                                          keyboardType:
                                                                          TextInputType.name,
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
                                                                            labelText: 'Flat NO',
                                                                            labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 10.0,),
                                                                      Expanded(
                                                                        child: TextField(
                                                                          controller: buildNoController,
                                                                          onChanged: (value) {
                                                                          },
                                                                          keyboardType:
                                                                          TextInputType.name,
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
                                                                            labelText: 'BLD NO',
                                                                            labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 20.0,),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Expanded(
                                                                        child: TextField(
                                                                          controller: roadNoController,
                                                                          onChanged: (value) {
                                                                          },
                                                                          keyboardType:
                                                                          TextInputType.name,
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
                                                                            labelText: 'ROAD NO',
                                                                            labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 10.0,),
                                                                      Expanded(
                                                                        child: TextField(
                                                                          controller: blockNoController,
                                                                          onChanged: (value) {
                                                                          },
                                                                          keyboardType:
                                                                          TextInputType.name,
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
                                                                            labelText: 'BLOCK NO',
                                                                            labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 20.0,),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width/3,
                                                              child: Column(
                                                                children: [
                                                                  TextField(
                                                                    controller: areaNoController,
                                                                    onChanged: (value) {



                                                                    },
                                                                    keyboardType:
                                                                    TextInputType.name,
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
                                                                      labelText: 'Area',
                                                                      labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 20.0,),
                                                                  TextField(
                                                                    controller: landmarkNoController,
                                                                    onChanged: (value) {
                                                                    },
                                                                    keyboardType:
                                                                    TextInputType.name,
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
                                                                      labelText: 'Land mark',
                                                                      labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 20.0,),
                                                                  TextField(
                                                                    controller: deliveryNoteController,
                                                                    onChanged: (value) {
                                                                    },
                                                                    keyboardType:
                                                                    TextInputType.name,
                                                                    maxLines: 3,
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
                                                                      labelText: 'Note',
                                                                      labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 20.0,),
                                                                  Container(
                                                                    height: MediaQuery.of(context).size.height*0.06,
                                                                    width: MediaQuery.of(context).size.width / 3,
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Colors.black,
                                                                          style: BorderStyle.solid,
                                                                          width: 3),
                                                                    ),

                                                                    child: DropdownButtonHideUnderline(
                                                                      child: DropdownButton(
                                                                        value:selectedcurrentroute2.toString().trim() , // Not necessary for Option 1
                                                                        items: currentroutes3.map((String val) {
                                                                          return DropdownMenuItem(
                                                                            child: new Text(val.toString().trim()),
                                                                            value: val,
                                                                          );
                                                                        }).toList(),
                                                                        onChanged: (val) async{
                                                                          selectedcurrentroute2 =await  val.toString().trim();

                                                                            setState(() {

                                                                          });
                                                                          setState(() {

                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 20.0,),
                                                                  RawMaterialButton(
                                                                    onPressed: () async {
                                                                      String inside='not';
                                                                      for(int i=0;i<allCustomerMobile.length;i++){
                                                                        if(allCustomerMobile[i] == allCustomerMobileController.text){
                                                                          inside='contains';
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) => AlertDialog(
                                                                                title: Text("Error"),
                                                                                content: Text("Customer Mobile Number Exists"),
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
                                                                          break;
                                                                        }
                                                                      }
                                                                      if(inside == 'not'){
                                                                        String body='${allCustomerMobileNameController.text}~${allCustomerMobileAddressController.text}~${allCustomerMobileController.text}~~~~${flatNoController.text}~${buildNoController.text}~${roadNoController.text}~${blockNoController.text}~${areaNoController.text}~${landmarkNoController.text}~${deliveryNoteController.text}~$selectedcurrentroute2';
                                                                        await create(body, 'customer_details',[]);
                                                                        await  read('customer_details');
                                                                        appbarCustomerController.text=selectedCustomer=allCustomerMobileNameController.text;
                                                                        Navigator.pushNamed(context, PosScreen.id);
                                                                      }
                                                                    },
                                                                    fillColor: kHighlight,
                                                                    //splashColor: Colors.greenAccent,
                                                                    child: Padding(
                                                                      padding: EdgeInsets.all(8.0),
                                                                      child: Text("Create",
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
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );}
                                                );
                                              });
                                        }),
                                        Visibility(
                                          visible: currentTerminal=='POS'?false:true,
                                          child: IconButton(
                                              tooltip: 'Receipt/Payment',
                                              icon: SvgPicture.asset('images/receipt2.svg'), onPressed: (){
                                            print('selectedCustomer $selectedCustomer');
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptPayment(customer: selectedCustomer,)));
                                          }),
                                        ),
                                      ],
                                    ),
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
                                      child: Text(currentTerminal=='Call Center'?'Call Center':'Pos Screen',style: TextStyle(
                                          color: kFont1Color,
                                          fontWeight: FontWeight.w500,
                                          fontSize: MediaQuery.of(context).textScaleFactor*17,
                                          fontFamily: 'BebasNeue',
                                          letterSpacing: 2.0
                                      ),),
                                    ),
                                    Row(
                                      // scrollDirection: Axis.horizontal,
                                      // shrinkWrap: true,
                                      children: [
                                        if(currentTerminal!='Call Center')Visibility(
                                          visible: selectedDelivery=='Spot'?true:false,
                                          child: SizedBox(
                                            height:30,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                                  elevation: MaterialStateProperty.all(3.0),
                                                  backgroundColor: MaterialStateProperty.all(kGreenColor),
                                                ),
                                                onPressed: (){
                                                  // if(!tableClicked.value){
                                                  print('inside if false');
                                                  // tableClicked.value=true;
                                                  tableMergeSelect.value=RxList<String>([]);
                                                  isMerge.value=false;
                                                  mergeCount.value=0;
                                                  // tableIndex=0.obs;
                                                  SchedulerBinding.instance.addPostFrameCallback((_){
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context){
                                                          return  buildDialog();
                                                        }
                                                    );
                                                    // Add Your Code here.

                                                  });
                                                  tableClicked.value=false;
                                                  // }
                                                  //  else{
                                                  //    print('inside else true');
                                                  //  }

                                                },
                                                child: Obx(()=>Text(tableSelected.value.contains('~')?getFirstTable(tableSelected.value):tableSelected.value,style: TextStyle(
                                                  color: kFont1Color,
                                                ),
                                                ),)
                                            ),
                                          ),
                                        ),
                                        SizedBox(width:10),
                                        if(currentTerminal!='Call Center')SizedBox(
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

                                              doc3 = await firebaseFirestore
                                                  .collection('expense_transaction')
                                                  // .where('user', isEqualTo: currentUser)
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
                                                      scrollBehavior: MaterialScrollBehavior().copyWith(
                                                        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
                                                      ),
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
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Till details',
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                        ),
                                                                      ),
                                                                      IconButton(
                                                                        tooltip: 'Order List',
                                                                        iconSize: 45,
                                                                        constraints: BoxConstraints(),
                                                                        icon: Image.asset(
                                                                          'images/pdf1.png',
                                                                        ),
                                                                        onPressed: () async {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) => Dialog(
                                                                                insetPadding: EdgeInsets.all(10.0),
                                                                                elevation: 6.0,
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                                                child:Container(
                                                                                  padding: EdgeInsets.all(10.0),
                                                                                  width :300,
                                                                                  height :150,
                                                                                  child: Center(
                                                                                    child: Column(
                                                                                      children:[
                                                                                        Text('Download options'  ,style: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                                    ),),
                                                                                        SizedBox(height:10),
                                                                                        TextButton(
                                                                                          onPressed: () async {
                                                                                            await tillPdf(cashAvailable,expense,paymentAmt,receiptAmt,cashPurchaseReturn,cashPurchase,cashSalesReturn,salesAmount,openingCashController.text,'without');
                                                                                          },
                                                                                          style: ButtonStyle(
                                                                                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                                                              // If the button is pressed, return green, otherwise blue
                                                                                              if (states.contains(MaterialState.pressed)) {
                                                                                                return Colors.grey;
                                                                                              }
                                                                                              return kBackgroundColor;
                                                                                            })),
                                                                                          child:   Text('Till Close',style:TextStyle(
                                                                                              color: Colors.white
                                                                                          )),
                                                                                        ),
                                                                                        SizedBox(height:10),
                                                                                        TextButton(
                                                                                            onPressed: () async {
                                                                                              categoryListDash=[];
                                                                                              categoryCountListDash=[];
                                                                                              categoryValueListDash=[];
                                                                                              QuerySnapshot snapshot=await firebaseFirestore.collection('item_report').where('date',isGreaterThanOrEqualTo: dateNowDash).orderBy('date',descending: true).get();

                                                                                              here: for(int i=0;i<snapshot.size;i++){
                                                                                                if(i==0){
                                                                                                  categoryListDash.add(snapshot.docs[i]['category']);
                                                                                                  categoryCountListDash.add(double.parse(snapshot.docs[i]['qty']));
                                                                                                  categoryValueListDash.add(double.parse(snapshot.docs[i]['lineTotal']));
                                                                                                }
                                                                                                else{
                                                                                                  for(int j=0;j<categoryListDash.length;j++){
                                                                                                    if(categoryListDash[j]==snapshot.docs[i]['category']){
                                                                                                      categoryCountListDash[j]=double.parse(snapshot.docs[i]['qty'])+categoryCountListDash[j];
                                                                                                      categoryValueListDash[j]=double.parse(snapshot.docs[i]['lineTotal'])+categoryValueListDash[j];
                                                                                                      continue here;
                                                                                                    }
                                                                                                  }
                                                                                                  categoryListDash.add(snapshot.docs[i]['category']);
                                                                                                  categoryCountListDash.add(double.parse(snapshot.docs[i]['qty']));
                                                                                                  categoryValueListDash.add(double.parse(snapshot.docs[i]['lineTotal']));
                                                                                                }
                                                                                              }
                                                                                              itemListDash=[];
                                                                                              itemCountListDash=[];
                                                                                              itemValueListDash=[];
                                                                                              here: for(int i=0;i<snapshot.size;i++){
                                                                                                if(i==0){
                                                                                                  itemListDash.add(snapshot.docs[i]['name']);
                                                                                                  itemCountListDash.add(double.parse(snapshot.docs[i]['qty']));
                                                                                                  itemValueListDash.add(double.parse(snapshot.docs[i]['lineTotal']));
                                                                                                }
                                                                                                else{
                                                                                                  for(int j=0;j<itemListDash.length;j++){
                                                                                                    if(itemListDash[j]==snapshot.docs[i]['name']){
                                                                                                      itemCountListDash[j]=double.parse(snapshot.docs[i]['qty'])+itemCountListDash[j];
                                                                                                      itemValueListDash[j]=double.parse(snapshot.docs[i]['lineTotal'])+itemValueListDash[j];
                                                                                                      continue here;
                                                                                                    }
                                                                                                  }
                                                                                                  itemListDash.add(snapshot.docs[i]['name']);
                                                                                                  itemCountListDash.add(double.parse(snapshot.docs[i]['qty']));
                                                                                                  itemValueListDash.add(double.parse(snapshot.docs[i]['lineTotal']));
                                                                                                }
                                                                                              }
                                                                                              await tillPdf(cashAvailable,expense,paymentAmt,receiptAmt,cashPurchaseReturn,cashPurchase,cashSalesReturn,salesAmount,openingCashController.text,'with');
                                                                                            },
                                                                                            style: ButtonStyle(
                                                                                                backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                                                                  // If the button is pressed, return green, otherwise blue
                                                                                                  if (states.contains(MaterialState.pressed)) {
                                                                                                    return Colors.grey;
                                                                                                  }
                                                                                                  return kBackgroundColor;
                                                                                                })
                                                                                            ),
                                                                                            child: Text('Till Close with details',style:TextStyle(
                                                                                              color: Colors.white
                                                                                            )),
                                                                                        ),
                                                                                      ]
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              )
                                                                          );
                                                                          // List<Map<String, dynamic>> temp=await getItemCategoryReport();
                                                                          // categoryListDash=[];
                                                                          // categoryCountListDash=[];
                                                                          // categoryValueListDash=[];
                                                                          // itemListDash=[];
                                                                          // itemCountListDash=[];
                                                                          // itemValueListDash=[];
                                                                          // here: for(int i=0;i<temp.length;i++){
                                                                          //   if(i==0){
                                                                          //     categoryListDash.add(temp[i]['category']);
                                                                          //     categoryCountListDash.add(double.parse(temp[i]['qty']));
                                                                          //     categoryValueListDash.add(double.parse(temp[i]['lineTotal']));
                                                                          //   }
                                                                          //   else{
                                                                          //     for(int j=0;j<categoryListDash.length;j++){
                                                                          //       if(categoryListDash[j]==temp[i]['category']){
                                                                          //         categoryCountListDash[j]=double.parse(temp[i]['qty'])+categoryCountListDash[j];
                                                                          //         categoryValueListDash[j]=double.parse(temp[i]['lineTotal'])+categoryValueListDash[j];
                                                                          //         continue here;
                                                                          //       }
                                                                          //     }
                                                                          //     categoryListDash.add(temp[i]['category']);
                                                                          //     categoryCountListDash.add(double.parse(temp[i]['qty']));
                                                                          //     categoryValueListDash.add(double.parse(temp[i]['lineTotal']));
                                                                          //   }
                                                                          // }
                                                                          // here1: for(int i=0;i<temp.length;i++){
                                                                          //   if(i==0){
                                                                          //     itemListDash.add(temp[i]['itemName']);
                                                                          //     itemCountListDash.add(double.parse(temp[i]['qty']));
                                                                          //     itemValueListDash.add(double.parse(temp[i]['lineTotal']));
                                                                          //   }
                                                                          //   else{
                                                                          //     for(int j=0;j<itemListDash.length;j++){
                                                                          //       if(itemListDash[j]==temp[i]['itemName']){
                                                                          //         itemCountListDash[j]=double.parse(temp[i]['qty'])+itemCountListDash[j];
                                                                          //         itemValueListDash[j]=double.parse(temp[i]['lineTotal'])+itemValueListDash[j];
                                                                          //         continue here1;
                                                                          //       }
                                                                          //     }
                                                                          //     itemListDash.add(temp[i]['itemName']);
                                                                          //     itemCountListDash.add(double.parse(temp[i]['qty']));
                                                                          //     tillPdf.add(double.parse(temp[i]['lineTotal']));
                                                                          //   }
                                                                          // }
                                                                        },
                                                                      ),
                                                                    ],
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
                                        // if(currentTerminal!='Call Center')
                                        //   // StreamBuilder(
                                        //   //     stream:firebaseFirestore.collection('kot_order').where('user',isEqualTo: currentUser).snapshots(),
                                        //   //     builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                                        //   //       if (!snapshot.hasData) {
                                        //   //         return Center(
                                        //   //           child: CircularProgressIndicator(),
                                        //   //         );
                                        //   //       }
                                        //   //       return Badge(
                                        //   //         badgeColor: kItemContainer,
                                        //   //         badgeContent:Text('${snapshot.data.docs.length}',style: TextStyle(
                                        //   //             fontWeight: FontWeight.bold,
                                        //   //             color: kGreenColor)),
                                        //   //         child: IconButton(
                                        //   //             tooltip: 'Order List',
                                        //   //             iconSize: 25,
                                        //   //             constraints: BoxConstraints(),
                                        //   //             icon: SvgPicture.asset(
                                        //   //               selectedBusiness=='Restaurant' ?'images/kot1.svg':'images/order.svg',
                                        //   //             ),
                                        //   //             onPressed: ()  async {
                                        //   //               if(selectedBusiness=='Restaurant')
                                        //   //                 stream1= firebaseFirestore.collection('kot_order').where('user',isEqualTo: currentUser).where('type',isEqualTo:'Spot' ).snapshots();
                                        //   //               else
                                        //   //                 stream1= firebaseFirestore.collection('kot_order').where('user',isEqualTo: currentUser).snapshots();
                                        //   //               isSelectedKot= [true, false,false];
                                        //   //               showDialog(context: context, builder: (context){
                                        //   //                 if (!snapshot.hasData) {
                                        //   //                   return Center(
                                        //   //                     child: CircularProgressIndicator(),
                                        //   //                   );
                                        //   //                 }
                                        //   //                 return Dialog(
                                        //   //                     child: StatefulBuilder(
                                        //   //                         builder: (context,setState){
                                        //   //                           return  Container(
                                        //   //                             padding: EdgeInsets.all(6.0),
                                        //   //                             child: Column(
                                        //   //                               children: [
                                        //   //                                 if(selectedBusiness=='Restaurant')
                                        //   //                                   Container(
                                        //   //                                     //  color:kGreenColor,
                                        //   //                                     child: ToggleButtons(
                                        //   //                                       isSelected: isSelectedKot,
                                        //   //                                       color:kGreenColor ,
                                        //   //                                       borderColor: kGreenColor,
                                        //   //                                       fillColor: kGreenColor,
                                        //   //                                       borderWidth: 2,
                                        //   //                                       selectedColor: kFont1Color,
                                        //   //                                       selectedBorderColor: kFont3Color,
                                        //   //                                       borderRadius: BorderRadius.circular(0),
                                        //   //                                       children: <Widget>[
                                        //   //                                         Padding(
                                        //   //                                           padding: const EdgeInsets.all(8.0),
                                        //   //                                           child: Text(
                                        //   //                                             'Dine In',
                                        //   //                                             style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        //   //                                           ),
                                        //   //                                         ),
                                        //   //                                         Padding(
                                        //   //                                           padding: const EdgeInsets.all(8.0),
                                        //   //                                           child: Text(
                                        //   //                                             'Take Away',
                                        //   //                                             style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20, ),
                                        //   //                                           ),
                                        //   //                                         ),Padding(
                                        //   //                                           padding: const EdgeInsets.all(8.0),
                                        //   //                                           child: Text(
                                        //   //                                             'Drive Through',
                                        //   //                                             style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20,),
                                        //   //                                           ),
                                        //   //                                         ),
                                        //   //                                       ],
                                        //   //                                       onPressed: (int index8) {
                                        //   //                                         setState(() {
                                        //   //                                           stream1 = firebaseFirestore.collection('kot_order').where('user',isEqualTo: currentUser).where('type',isEqualTo:deliveryModeKot[index8]).snapshots();
                                        //   //                                           print('deliveryModeKot[index8] ${deliveryModeKot[index8]}');
                                        //   //                                           for (int i = 0; i < isSelectedKot.length; i++) {
                                        //   //                                             isSelectedKot[i] = i == index8;
                                        //   //                                           }
                                        //   //                                           selectedDeliveryKot=deliveryModeKot[index8];
                                        //   //                                         });
                                        //   //                                       },
                                        //   //                                     ),
                                        //   //                                   ),
                                        //   //                                 Expanded(
                                        //   //                                     child: StatefulBuilder(builder: (context,setState){
                                        //   //                                       return StreamBuilder(
                                        //   //                                           stream: stream1,
                                        //   //                                           builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2) {
                                        //   //                                             if (!snapshot2
                                        //   //                                                 .hasData) {
                                        //   //                                               return Center(
                                        //   //                                                 child: CircularProgressIndicator(),
                                        //   //                                               );
                                        //   //                                             }
                                        //   //                                             return GridView.builder(
                                        //   //                                                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        //   //                                                   crossAxisCount: 4,
                                        //   //                                                 ),
                                        //   //                                                 scrollDirection: Axis.vertical,
                                        //   //                                                 itemCount: snapshot2.data.docs.length,
                                        //   //                                                 itemBuilder: (context, index2) {
                                        //   //                                                   double tempTotal=0;
                                        //   //                                                   for(int i=0;i<snapshot2.data.docs[index2]['cartList'].length;i++){
                                        //   //                                                     tempTotal+=double.parse(snapshot2.data.docs[index2]['cartList'][i]['price']);
                                        //   //                                                   }
                                        //   //                                                   return Padding(
                                        //   //                                                     padding: const EdgeInsets.all(10.0),
                                        //   //                                                     child: GestureDetector(
                                        //   //                                                       onLongPress: ()async{
                                        //   //                                                         if(selectedBusiness=='Restaurant'){
                                        //   //                                                           DocumentSnapshot orderData=await firebaseFirestore.collection('kot_order').doc(snapshot2.data.docs[index2].get('orderNo')).get();
                                        //   //                                                           List items=orderData['cartList'];
                                        //   //                                                           print("Line 6880");
                                        //   //                                                           for(int i=0;i<items.length;i++)
                                        //   //                                                           {
                                        //   //                                                             kotList.add('${orderData['cartList'][i]['name']}:${orderData['cartList'][i]['qty']}::${orderData['cartList'][i]['uom']}');
                                        //   //                                                             print("KOTLIST[0]"+kotList[0]);
                                        //   //                                                           }
                                        //   //                                                           print("format KOT  6886");
                                        //   //                                                           formatKotList(orderData['orderNo'], orderData['tableNo']);
                                        //   //                                                           Navigator.pop(context);
                                        //   //                                                         }
                                        //   //                                                       },
                                        //   //                                                       onTap: ()async{
                                        //   //                                                         DocumentSnapshot orderData=await firebaseFirestore.collection('kot_order').doc(snapshot2.data.docs[index2].get('orderNo')).get();
                                        //   //                                                         List items=orderData['cartList'];
                                        //   //                                                         selectedCustomer=orderData['customer'];
                                        //   //                                                         selectedPriceList=orderData['priceList'];
                                        //   //                                                         isSelected=[false,false,false,false,false];
                                        //   //                                                         // setState((){
                                        //   //                                                         salesTotalList=[];
                                        //   //                                                         salesUomList=[];
                                        //   //                                                         cartController=[];
                                        //   //                                                         cartListText=[];
                                        //   //                                                         cartComboList=[];
                                        //   //                                                         salesTotal=0;
                                        //   //                                                         appbarCustomerController.clear();
                                        //   //                                                         totalDiscountController.text='0';
                                        //   //                                                         if(selectedBusiness=='Restaurant'){
                                        //   //                                                           tableSelected.value=snapshot2.data.docs[index2].get('tableNo').contains(',')?snapshot2.data.docs[index2].get('tableNo').toString().replaceAll(',', '~'):snapshot2.data.docs[index2].get('tableNo');
                                        //   //                                                           selectedDelivery=snapshot2.data.docs[index2].get('type');
                                        //   //                                                           int pos=deliveryModeKot.indexOf(selectedDelivery);
                                        //   //                                                           isSelected[pos]=true;
                                        //   //                                                         }
                                        //   //                                                         else{
                                        //   //                                                           isEstimate.value=true;
                                        //   //                                                         }
                                        //   //                                                         checkoutFlag=true;
                                        //   //                                                         createdBy=snapshot2.data.docs[index2].get('user');
                                        //   //                                                         currentOrder=orderData['orderNo'];
                                        //   //                                                         currentKotDate=orderData['date'];
                                        //   //                                                         currentKotNote=orderData['note'];
                                        //   //                                                         currentKotOldList11=orderData['cartList'];
                                        //   //                                                         currentKotOldList=[];
                                        //   //                                                         modifierKotList=[];
                                        //   //                                                         for(int i=0;i<items.length;i++)
                                        //   //                                                         {
                                        //   //                                                           currentKotOldList.add('${orderData['cartList'][i]['name']}:${orderData['cartList'][i]['uom']}:${orderData['cartList'][i]['price']}:${orderData['cartList'][i]['qty']}');
                                        //   //
                                        //   //                                                           salesTotal+=double.parse(orderData['cartList'][i]['price']);
                                        //   //                                                           salesTotalList.add(double.parse(orderData['cartList'][i]['price']));
                                        //   //                                                           salesUomList.add(orderData['cartList'][i]['uom']);
                                        //   //                                                           cartController.add(TextEditingController(text: orderData['cartList'][i]['price']));
                                        //   //                                                           if(orderData['cartList'][i]['modifier'].length>0){
                                        //   //                                                             modifierKotList.add('${orderData['cartList'][i]['name']};${orderData['cartList'][i]['modifier']}');
                                        //   //                                                             cartListText.add('${orderData['cartList'][i]['name']}:${orderData['cartList'][i]['uom']}:${orderData['cartList'][i]['price']}:${orderData['cartList'][i]['qty']}:${orderData['cartList'][i]['modifier']}');
                                        //   //                                                           }
                                        //   //                                                          else{
                                        //   //                                                         cartListText.add('${orderData['cartList'][i]['name']}:${orderData['cartList'][i]['uom']}:${orderData['cartList'][i]['price']}:${orderData['cartList'][i]['qty']}');
                                        //   //                                                         }
                                        //   //                                                         if(orderData['cartList'][i].length==7){
                                        //   //                                                           if(orderData['cartList'][i]['combo'].length>0)
                                        //   //                                                     cartComboList.add('${orderData['cartList'][i]['name']};${orderData['cartList'][i]['combo']};true');
                                        //   //                                                         }
                                        //   //                                                         }
                                        //   //                                                         Navigator.pushReplacement(
                                        //   //                                                           context,
                                        //   //                                                           MaterialPageRoute(builder: (context) => PosScreen()),
                                        //   //                                                         );
                                        //   //                                                       },
                                        //   //                                                       child: Column(
                                        //   //                                                         mainAxisAlignment: MainAxisAlignment.start,
                                        //   //                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                        //   //                                                         children: [
                                        //   //                                                           Container(
                                        //   //                                                             height: snapshot2.data.docs[index2].get('type').toString()=='Spot'?25:50,
                                        //   //                                                             padding: EdgeInsets.all(4.0),
                                        //   //                                                             decoration:  BoxDecoration(
                                        //   //                                                               color:kGreenColor,
                                        //   //                                                               borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
                                        //   //                                                             ),
                                        //   //                                                             child: selectedBusiness=='Retail'?Text(snapshot.data.docs[index2].get('orderNo'),style: TextStyle(
                                        //   //                                                               //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //   //                                                               fontWeight: FontWeight.bold,
                                        //   //                                                               color:  Colors.white,
                                        //   //                                                             ),):snapshot2.data.docs[index2].get('type').toString()=='Spot'?
                                        //   //                                                             Row(
                                        //   //                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   //                                                               children: [
                                        //   //                                                                 Flexible(
                                        //   //                                                                   child: Row(
                                        //   //                                                                     children: [
                                        //   //                                                                       Text(snapshot2.data.docs[index2].get('orderNo'),style: TextStyle(
                                        //   //                                                                         //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //   //                                                                         fontWeight: FontWeight.bold,
                                        //   //                                                                         color:  Colors.white,
                                        //   //                                                                       ),),
                                        //   //                                                                       SizedBox(width: 10,),
                                        //   //                                                                       Text('Dine In',style: TextStyle(
                                        //   //                                                                         // fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //   //                                                                         fontWeight: FontWeight.bold,
                                        //   //                                                                         color:  Colors.white,
                                        //   //                                                                       ))
                                        //   //                                                                     ],
                                        //   //                                                                   ),
                                        //   //                                                                 ),
                                        //   //                                                                 Text(snapshot2.data.docs[index2].get('tableNo').contains(',')?'''${getFirstTable(snapshot2.data.docs[index2].get('tableNo').toString().replaceAll(',', '~'))}..''':snapshot2.data.docs[index2].get('tableNo'),
                                        //   //                                                                   overflow: TextOverflow.ellipsis
                                        //   //                                                                   ,style: TextStyle(
                                        //   //                                                                     fontWeight: FontWeight.bold,
                                        //   //                                                                     color:  Colors.white,
                                        //   //                                                                   ),)
                                        //   //                                                               ],
                                        //   //                                                             ):
                                        //   //                                                             Column(
                                        //   //                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   //                                                               crossAxisAlignment: CrossAxisAlignment.start,
                                        //   //                                                               children: [
                                        //   //                                                                 Flexible(
                                        //   //                                                                   child: Row(
                                        //   //                                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   //                                                                     children: [
                                        //   //                                                                       Text(snapshot2.data.docs[index2].get('orderNo'),style: TextStyle(
                                        //   //                                                                         //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //   //                                                                         fontWeight: FontWeight.bold,
                                        //   //                                                                         color:  Colors.white,
                                        //   //                                                                       ),),
                                        //   //                                                                       SizedBox(width: 10,),
                                        //   //                                                                       Text(snapshot2.data.docs[index2].get('type'),style: TextStyle(
                                        //   //                                                                         // fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //   //                                                                         fontWeight: FontWeight.bold,
                                        //   //                                                                         color:  Colors.white,
                                        //   //                                                                       ),),
                                        //   //                                                                     ],
                                        //   //                                                                   ),
                                        //   //                                                                 ),
                                        //   //                                                                 Text(snapshot2.data.docs[index2].get('note'),
                                        //   //                                                                   style: TextStyle(
                                        //   //                                                                     fontWeight: FontWeight.bold,
                                        //   //                                                                     color:  Colors.white,
                                        //   //                                                                   ),),
                                        //   //                                                               ],
                                        //   //                                                             ),
                                        //   //                                                           ),
                                        //   //                                                           Expanded(
                                        //   //                                                             child: Container(
                                        //   //                                                                 width: double.maxFinite,
                                        //   //                                                                 decoration:  BoxDecoration(
                                        //   //                                                                     borderRadius: BorderRadius.all(Radius.zero),
                                        //   //                                                                     border: Border.all(color: kGreenColor)
                                        //   //                                                                 ),
                                        //   //                                                                 //padding: EdgeInsets.only(left: 3.0,right: 3.0),
                                        //   //                                                                 child: Column(
                                        //   //                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   //                                                                   children: [
                                        //   //                                                                     Expanded(
                                        //   //                                                                       child: Container(
                                        //   //                                                                         child: ListView.builder(
                                        //   //                                                                             shrinkWrap:true,
                                        //   //                                                                             itemCount:snapshot2.data.docs[index2]['cartList'].length ,
                                        //   //                                                                             itemBuilder: (context,index3){
                                        //   //                                                                               return Padding(
                                        //   //                                                                                 padding: const EdgeInsets.only(top: 2.0,left: 2.0),
                                        //   //                                                                                 child: Row(
                                        //   //                                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   //                                                                                   children: [
                                        //   //                                                                                     Column(
                                        //   //                                                                                       children: [
                                        //   //                                                                                         Text('${snapshot2.data.docs[index2]['cartList'][index3]['qty']}x'),
                                        //   //                                                                                         Text(snapshot2.data.docs[index2]['cartList'][index3]['uom'].toString()),
                                        //   //                                                                                       ],
                                        //   //                                                                                     ),
                                        //   //                                                                                     Flexible(child: Text(snapshot2.data.docs[index2]['cartList'][index3]['name'].toString().replaceAll('#', '/'),maxLines: 2,)),
                                        //   //                                                                                     if(selectedBusiness=='Restaurant')
                                        //   //                                                                                       Icon(Icons.circle,
                                        //   //                                                                                         color: snapshot2.data.docs[index2]['cartList'][index3]['ready']==true?kKitchenGreenColor:kAppBarItems,
                                        //   //                                                                                       ),
                                        //   //                                                                                   ],
                                        //   //                                                                                 ),
                                        //   //                                                                               );
                                        //   //                                                                             }),
                                        //   //                                                                       ),
                                        //   //                                                                     ),
                                        //   //                                                                     Padding(
                                        //   //                                                                       padding: EdgeInsets.only(left: 3.0,right: 3.0),
                                        //   //                                                                       child: Row(
                                        //   //                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   //                                                                         children: [
                                        //   //                                                                           Text('Total',style: TextStyle(
                                        //   //                                                                             //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //   //                                                                             fontWeight: FontWeight.bold,
                                        //   //                                                                             color:  Colors.black,
                                        //   //                                                                           ),),
                                        //   //                                                                           SizedBox(width: 10,),
                                        //   //                                                                           ElevatedButton(
                                        //   //                                                                             style: ButtonStyle(
                                        //   //                                                                               side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                        //   //                                                                               elevation: MaterialStateProperty.all(3.0),
                                        //   //                                                                               backgroundColor: MaterialStateProperty.all(kGreenColor),
                                        //   //                                                                             ),
                                        //   //                                                                             onPressed: (){
                                        //   //                                                                               showDialog(
                                        //   //                                                                                 context:
                                        //   //                                                                                 context,
                                        //   //                                                                                 builder: (ctx) =>
                                        //   //                                                                                     AlertDialog(
                                        //   //                                                                                       title: Text("Are you sure?"),
                                        //   //                                                                                       actions: <Widget>[
                                        //   //                                                                                         TextButton(
                                        //   //                                                                                           onPressed: () {
                                        //   //                                                                                             Navigator.of(ctx).pop();
                                        //   //                                                                                           },
                                        //   //                                                                                           child: Text("No"),
                                        //   //                                                                                         ),
                                        //   //                                                                                         TextButton(
                                        //   //                                                                                           onPressed: () {
                                        //   //                                                                                             firebaseFirestore.collection('kot_order').doc(snapshot2.data.docs[index2].get('orderNo')).delete();
                                        //   //                                                                                             Navigator.of(ctx).pop();
                                        //   //                                                                                           },
                                        //   //                                                                                           child: Text("Yes"),
                                        //   //                                                                                         ),
                                        //   //                                                                                       ],
                                        //   //                                                                                     ),
                                        //   //                                                                               );
                                        //   //                                                                               },
                                        //   //                                                                             child: Text("Cancel",style: TextStyle(
                                        //   //                                                                               color: kFont1Color,
                                        //   //                                                                               fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                        //   //                                                                             ),
                                        //   //                                                                             ),
                                        //   //                                                                           ),
                                        //   //                                                                           Text(tempTotal.toStringAsFixed(decimals),style: TextStyle(
                                        //   //                                                                             // fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //   //                                                                             fontWeight: FontWeight.bold,
                                        //   //                                                                             color:  Colors.black,
                                        //   //                                                                           ),),
                                        //   //                                                                         ],
                                        //   //                                                                       ),
                                        //   //                                                                     ),
                                        //   //                                                                   ],
                                        //   //                                                                 )
                                        //   //                                                             ),
                                        //   //                                                           ),
                                        //   //
                                        //   //                                                         ],
                                        //   //                                                       ),
                                        //   //                                                     ),
                                        //   //                                                   );
                                        //   //                                                 });
                                        //   //                                           }
                                        //   //                                       );
                                        //   //                                     })
                                        //   //                                 ),
                                        //   //                                 Align(
                                        //   //                                   alignment: Alignment.bottomRight,
                                        //   //                                   child: TextButton(onPressed: () {
                                        //   //                                     Navigator.pop(context);
                                        //   //                                   },
                                        //   //                                       child: Container(
                                        //   //                                         padding: EdgeInsets.all(8.0),
                                        //   //                                         color: kGreenColor,
                                        //   //                                         child: Text('CLOSE',style: TextStyle(
                                        //   //                                           letterSpacing: 1.5,
                                        //   //                                           fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        //   //                                           color: kWhiteColor,
                                        //   //                                         ),),
                                        //   //                                       )),
                                        //   //                                 )
                                        //   //                               ],
                                        //   //                             ),);
                                        //   //                         })
                                        //   //                 );
                                        //   //               });
                                        //   //
                                        //   //             }
                                        //   //         ),
                                        //   //       );
                                        //   //     }),
                                        // if(currentTerminal!='Call Center')Visibility(
                                        //   visible: selectedBusiness=='Restaurant'?true:false,
                                        //   child: StreamBuilder(
                                        //       stream: firebaseFirestore.collection('invoice_list').snapshots(),
                                        //       builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2){
                                        //         if (!snapshot2.hasData) {
                                        //           return Center(
                                        //             child: CircularProgressIndicator(),
                                        //           );
                                        //         }
                                        //         return Badge(
                                        //           badgeColor: kItemContainer,
                                        //           badgeContent:Text('${snapshot2.data.docs.length}',style: TextStyle(fontWeight: FontWeight.bold,color: kGreenColor),),
                                        //           child: IconButton(
                                        //               tooltip: 'Checkout List',
                                        //               iconSize: 25,
                                        //               constraints: BoxConstraints(),
                                        //               icon: SvgPicture.asset('images/waiter.svg'),
                                        //               onPressed: ()  async {
                                        //                 showDialog(context: context, builder: (context){
                                        //                   if (!snapshot2.hasData) {
                                        //                     return Center(
                                        //                       child: CircularProgressIndicator(),
                                        //                     );
                                        //                   }
                                        //                   return Dialog(
                                        //                     child: Container(
                                        //                       padding: EdgeInsets.all(6.0),
                                        //                       child: Stack(
                                        //                         children: [
                                        //                           GridView.builder(
                                        //                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        //                                 crossAxisCount: 4,
                                        //
                                        //                               ),
                                        //                               scrollDirection: Axis.vertical,
                                        //                               itemCount: snapshot2.data.docs.length,
                                        //                               itemBuilder: (context, index3) {
                                        //                                 return Padding(
                                        //                                   padding: const EdgeInsets.all(10.0),
                                        //                                   child: GestureDetector(
                                        //                                       onTap: ()async{
                                        //                                         DocumentSnapshot orderData=await firebaseFirestore.collection('invoice_list').doc(snapshot2.data.docs[index3].get('orderNo')).get();
                                        //                                         List  items=orderData['cartList'];
                                        //                                           salesTotalList=[];
                                        //                                           salesUomList=[];
                                        //                                           cartController=[];
                                        //                                           cartListText=[];
                                        //                                           currentOrder=orderData['orderNo'];
                                        //                                           tableSelected.value=orderData['table'];
                                        //                                           selectedDelivery=orderData['delivery'];
                                        //                                           isSelected=[false,false,false,false,false];
                                        //                                           int pos=deliveryMode.indexOf(selectedDelivery);
                                        //                                           isSelected[pos]=true;
                                        //                                           checkoutFlag=true;
                                        //                                         appbarCustomerController.clear();
                                        //                                         totalDiscountController.text='0';
                                        //                                           createdBy=orderData['user'];
                                        //                                         // currentKotDate=orderData['date'];
                                        //                                         currentKotNote=orderData['note'];
                                        //                                         if(selectedBusiness=='Restaurant'){
                                        //                                           tableSelected.value=orderData['table'].contains(',')?orderData['table'].replaceAll(',', '~'):orderData['table'];
                                        //                                           selectedDelivery=orderData['delivery'];
                                        //                                           int pos=deliveryModeKot.indexOf(selectedDelivery);
                                        //                                           isSelected[pos]=true;
                                        //                                         }
                                        //                                         for(int i=0;i<items.length;i++)
                                        //                                         {
                                        //                                             salesTotal+=double.parse(orderData['cartList'][i]['price']);
                                        //                                             salesTotalList.add(double.parse(orderData['cartList'][i]['price']));
                                        //                                             salesUomList.add(orderData['cartList'][i]['uom']);
                                        //                                             cartController.add(TextEditingController(text: orderData['cartList'][i]['price']));
                                        //                                             if(orderData['cartList'][i]['modifier'].length>0){
                                        //                                               modifierKotList.add('${orderData['cartList'][i]['name']};${orderData['cartList'][i]['modifier']}');
                                        //                                               cartListText.add('${orderData['cartList'][i]['name']}:${orderData['cartList'][i]['uom']}:${orderData['cartList'][i]['price']}:${orderData['cartList'][i]['qty']}:${orderData['cartList'][i]['modifier']}');
                                        //                                             }
                                        //                                             else{
                                        //                                               cartListText.add('${orderData['cartList'][i]['name']}:${orderData['cartList'][i]['uom']}:${orderData['cartList'][i]['price']}:${orderData['cartList'][i]['qty']}');
                                        //                                             }
                                        //                                         }
                                        //                                         Navigator.pushReplacement(
                                        //                                           context,
                                        //                                           MaterialPageRoute(builder: (context) => PosScreen()),
                                        //                                         );
                                        //                                       },
                                        //                                       child:Column(
                                        //                                         mainAxisAlignment: MainAxisAlignment.start,
                                        //                                         crossAxisAlignment: CrossAxisAlignment.start,
                                        //                                         children: [
                                        //                                           Container(
                                        //                                             height: snapshot2.data.docs[index3].get('delivery').toString()=='Spot'?25:50,
                                        //                                             padding: EdgeInsets.all(4.0),
                                        //                                             decoration:  BoxDecoration(
                                        //                                               color:kGreenColor,
                                        //                                               borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
                                        //                                             ),
                                        //                                             child:snapshot2.data.docs[index3].get('delivery').toString()=='Spot'?
                                        //                                             Row(
                                        //                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                                               children: [
                                        //                                                 Flexible(
                                        //                                                     child: Row(
                                        //                                                       children: [
                                        //                                                         Text(snapshot2.data.docs[index3].get('orderNo'),style: TextStyle(
                                        //                                                           //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //                                                           fontWeight: FontWeight.bold,
                                        //                                                           color:  Colors.white,
                                        //                                                         ),),
                                        //                                                         SizedBox(width: 10,),
                                        //                                                         Text('Dine In',style: TextStyle(
                                        //                                                           // fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //                                                           fontWeight: FontWeight.bold,
                                        //                                                           color:  Colors.white,
                                        //                                                         ))
                                        //                                                       ],
                                        //                                                     )
                                        //                                                 ),
                                        //                                                 Text(snapshot2.data.docs[index3].get('table'),style: TextStyle(
                                        //                                                   fontWeight: FontWeight.bold,
                                        //                                                   color:  Colors.white,
                                        //                                                 ),),
                                        //                                               ],
                                        //                                             ):
                                        //                                             Column(
                                        //                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                                               crossAxisAlignment: CrossAxisAlignment.start,
                                        //                                               children: [
                                        //                                                 Flexible(
                                        //                                                     child: Row(
                                        //                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                                                       children: [
                                        //                                                         Text(snapshot2.data.docs[index3].get('orderNo'),style: TextStyle(
                                        //                                                           //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //                                                           fontWeight: FontWeight.bold,
                                        //                                                           color:  Colors.white,
                                        //                                                         ),),
                                        //                                                         SizedBox(width: 10,),
                                        //                                                         Text(snapshot2.data.docs[index3].get('delivery'),style: TextStyle(
                                        //                                                           // fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //                                                           fontWeight: FontWeight.bold,
                                        //                                                           color:  Colors.white,
                                        //                                                         ),)
                                        //                                                       ],
                                        //                                                     )
                                        //                                                 ),
                                        //                                                 Text(snapshot2.data.docs[index3].get('note'),style: TextStyle(
                                        //                                                   fontWeight: FontWeight.bold,
                                        //                                                   color:  Colors.white,
                                        //                                                 ),),
                                        //                                               ],
                                        //                                             ),
                                        //                                           ),
                                        //                                           Expanded(
                                        //                                             child: Container(
                                        //                                                 width: double.maxFinite,
                                        //                                                 decoration:  BoxDecoration(
                                        //                                                     borderRadius: BorderRadius.all(Radius.zero),
                                        //                                                     border: Border.all(color: kGreenColor)
                                        //                                                 ),
                                        //                                                 //padding: EdgeInsets.only(left: 3.0,right: 3.0),
                                        //                                                 child: ListView.builder(
                                        //                                                     itemCount:snapshot2.data.docs[index3]['cartList'].length ,
                                        //                                                     itemBuilder: (context,index4){
                                        //                                                       return Padding(
                                        //                                                         padding: const EdgeInsets.only(top: 2.0,left: 2.0),
                                        //                                                         child: Row(
                                        //                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                                                           children: [
                                        //                                                             Column(
                                        //                                                               children: [
                                        //                                                                 Text('${snapshot2.data.docs[index3]['cartList'][index4]['qty']}x'),
                                        //                                                                 Text(snapshot2.data.docs[index3]['cartList'][index4]['uom'].toString()),
                                        //                                                               ],
                                        //                                                             ),
                                        //                                                             Flexible(child: Text(snapshot2.data.docs[index3]['cartList'][index4]['name'].toString().replaceAll('#', '/'),maxLines: 2,)),
                                        //                                                           ],
                                        //                                                         ),
                                        //                                                       );
                                        //                                                     })
                                        //                                             ),
                                        //                                           ),
                                        //                                         ],
                                        //                                       )
                                        //                                   ),
                                        //                                 );
                                        //                               }),
                                        //                           Positioned.fill(
                                        //                             child: Align(
                                        //                               alignment: Alignment.bottomRight,
                                        //                               child: TextButton(onPressed: () => Navigator.pop(context),
                                        //                                   child: Container(
                                        //                                     padding: EdgeInsets.all(8.0),
                                        //                                     color: kGreenColor,
                                        //                                     child: Text('CLOSE',style: TextStyle(
                                        //                                       letterSpacing: 1.5,
                                        //                                       fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        //                                       color: kWhiteColor,
                                        //                                     ),),
                                        //                                   )),
                                        //                             ),
                                        //                           )
                                        //                         ],
                                        //                       ),
                                        //                     ),
                                        //                   );
                                        //                 });
                                        //               }
                                        //           ),
                                        //         );
                                        //       }),
                                        // ),
                                        // if(!(selectedBusiness=='Retail'&&currentTerminal=='POS'))
                                        //   Padding(
                                        //     padding: EdgeInsets.only(right:currentTerminal=='Call Center'?12:currentTerminal=='POS'?12:1),
                                        //     child: StreamBuilder(
                                        //         stream: orgCall=='false'?firebaseFirestore.collection('customer_orders').snapshots():
                                        //         currentTerminal=='Call Center'?firebaseFirestore.collection('customer_orders').snapshots():
                                        //         firebaseFirestore.collection('customer_orders').where('branch',isEqualTo:currentBranch).snapshots(),
                                        //         builder: (BuildContext context654,AsyncSnapshot<QuerySnapshot> snapshot2){
                                        //
                                        //           if (!snapshot2.hasData) {
                                        //             return Center(
                                        //               child: CircularProgressIndicator(),
                                        //             );
                                        //           }
                                        //           return Badge(
                                        //             badgeColor: kItemContainer,
                                        //             badgeContent:Text('${snapshot2.data.docs.length}',style: TextStyle(fontWeight: FontWeight.bold,color: kGreenColor),),
                                        //             child: IconButton(
                                        //                 tooltip: 'Customer Orders',
                                        //                 iconSize: 25,
                                        //                 constraints: BoxConstraints(),
                                        //                 icon: SvgPicture.asset('images/customer.svg'),
                                        //                 onPressed: ()  async {
                                        //                   print('org call $orgCall');
                                        //                   tempDeliveryBoy=[];
                                        //                   showDialog(context: context, builder: (context){
                                        //                     if (!snapshot2.hasData) {
                                        //                       return Center(
                                        //                         child: CircularProgressIndicator(),
                                        //                       );
                                        //                     }
                                        //                     // return Dialog(
                                        //                     //   child: StatefulBuilder(
                                        //                     //       builder: (context,setState){
                                        //                     //         return Container(
                                        //                     //           padding: EdgeInsets.all(6.0),
                                        //                     //           child: Stack(
                                        //                     //             children: [
                                        //                     //               GridView.builder(
                                        //                     //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        //                     //                     crossAxisCount: 4,
                                        //                     //
                                        //                     //                   ),
                                        //                     //                   scrollDirection: Axis.vertical,
                                        //                     //                   itemCount: snapshot2.data.docs.length,
                                        //                     //                   itemBuilder: (context, index6) {
                                        //                     //                     tempDeliveryBoy.add(snapshot2.data.docs[index6].get('deliveryBoy')) ;
                                        //                     //                     customerKotFlag=snapshot2.data.docs[index6].get('kot');
                                        //                     //                     double tempTotal=0;
                                        //                     //                     for(int i=0;i<snapshot2.data.docs[index6]['order'].length;i++){
                                        //                     //                       tempTotal+=double.parse(snapshot2.data.docs[index6]['order'][i]['price'].toString());
                                        //                     //                     }
                                        //                     //                     return Padding(
                                        //                     //                       padding: const EdgeInsets.all(6.0),
                                        //                     //                       child: GestureDetector(
                                        //                     //                         onLongPress: ()async{
                                        //                     //                           if(selectedBusiness=='Restaurant'){
                                        //                     //                             DocumentSnapshot orderData=snapshot2.data.docs[index6];
                                        //                     //                             List items=orderData['order'];
                                        //                     //                             print('lengthhhhhhhhhh ${items.length}');
                                        //                     //                             for(int i=0;i<items.length;i++)
                                        //                     //                             {
                                        //                     //                               kotList.add('${orderData['order'][i]['name']}:${orderData['order'][i]['qty']}:');
                                        //                     //
                                        //                     //                             }
                                        //                     //                             print("format KOT  7432");
                                        //                     //                             formatKotList(orderData['orderNo'], '');
                                        //                     //                             Navigator.pop(context);
                                        //                     //                           }
                                        //                     //                         },
                                        //                     //                         onTap: ()async{
                                        //                     //                           print('start');
                                        //                     //                           if(currentTerminal=='Call Center'){
                                        //                     //                             selectedBranch.value=snapshot2.data.docs[index6].get('branch');
                                        //                     //                           }
                                        //                     //                           customerUserUid=snapshot2.data.docs[index6].get('uid');
                                        //                     //                           customerOrderUid=snapshot2.data.docs[index6].id;
                                        //                     //                           deliveryKotFlag=snapshot2.data.docs[index6].get('kot');
                                        //                     //                           customerOrderDeliveryBoy=snapshot2.data.docs[index6].get('deliveryBoy');
                                        //                     //                           deliveryCheckoutFlag=snapshot2.data.docs[index6].get('checkOut');
                                        //                     //                           selectedDelivery='Delivery';
                                        //                     //                           DocumentSnapshot tempCustomerData=await firebaseFirestore.collection('customer_details').doc(customerUserUid).get();
                                        //                     //                           customerUserFlatNo=tempCustomerData.get('flatNo');
                                        //                     //                           print('start');
                                        //                     //                           customerUserBldNo=tempCustomerData.get('buildNo');
                                        //                     //                           customerUserRoadNo=tempCustomerData.get('roadNo');
                                        //                     //                           customerUserBlockNo=tempCustomerData.get('blockNo');
                                        //                     //                           customerUserArea=tempCustomerData.get('area');
                                        //                     //                           customerUserLandmark=tempCustomerData.get('landmark');
                                        //                     //                           List  items=snapshot2.data.docs[index6].get('order');
                                        //                     //                           allCustomerMobileController.text=selectedCustomer=appbarCustomerController.text=customerUserName=snapshot2.data.docs[index6].get('name');
                                        //                     //                           customerUserMobile=snapshot2.data.docs[index6].get('mobile');
                                        //                     //                           customerUserAddress=snapshot2.data.docs[index6].get('address');
                                        //                     //                           customerKotFlag=snapshot2.data.docs[index6].get('kot');
                                        //                     //                           setState(() {
                                        //                     //                             salesTotalList=[];
                                        //                     //                             salesUomList=[];
                                        //                     //                             cartController=[];
                                        //                     //                             cartListText=[];
                                        //                     //                             salesTotal=0;
                                        //                     //                             isSelected = [false, false,false,false,true];
                                        //                     //                             checkoutFlag=true;
                                        //                     //                             //currentOrder=orderData['orderNo'];
                                        //                     //                             //_selectedTable=int.parse(orderData['table']);
                                        //                     //                           });
                                        //                     //                           DocumentSnapshot orderData=snapshot2.data.docs[index6];
                                        //                     //                           print(orderData);
                                        //                     //                           for(int i=0;i<items.length;i++)
                                        //                     //                           {
                                        //                     //                             salesTotal+=snapshot2.data.docs[index6]['order'][i]['price'];
                                        //                     //                             salesTotalList.add(double.parse(snapshot2.data.docs[index6]['order'][i]['price'].toString()));
                                        //                     //                             salesUomList.add(snapshot2.data.docs[index6]['order'][i]['uom']);
                                        //                     //                             cartController.add(TextEditingController(text: snapshot2.data.docs[index6]['order'][i]['price'].toString()));
                                        //                     //                           if(orderData['order'][i].length==8){
                                        //                     //                             print('yes');
                                        //                     //                             if(orderData['order'][i]['combo'].length>0)
                                        //                     //                               cartComboList.add('${orderData['order'][i]['name']};${orderData['order'][i]['combo']};true');
                                        //                     //                             if(orderData['order'][i]['modifier'].length>0){
                                        //                     //                               modifierKotList.add('${orderData['order'][i]['name']};${orderData['order'][i]['modifier']}');
                                        //                     //                               cartListText.add('${orderData['order'][i]['name']}:${orderData['order'][i]['uom']}:${orderData['order'][i]['price']}:${orderData['order'][i]['qty']}:${orderData['order'][i]['modifier']}');
                                        //                     //                               customerOrdersList.add('${orderData['order'][i]['name']}:${orderData['order'][i]['uom']}:${orderData['order'][i]['price']}:${orderData['order'][i]['qty']}:${orderData['order'][i]['modifier']}');
                                        //                     //                             }
                                        //                     //                             else{
                                        //                     //                               cartListText.add('${orderData['order'][i]['name']}:${orderData['order'][i]['uom']}:${orderData['order'][i]['price']}:${orderData['order'][i]['qty']}');
                                        //                     //                               customerOrdersList.add('${orderData['order'][i]['name']}:${orderData['order'][i]['uom']}:${orderData['order'][i]['price']}:${orderData['order'][i]['qty']}');
                                        //                     //                             }
                                        //                     //                           }
                                        //                     //                             if(orderData['order'][i].length==6){
                                        //                     //                               // if(orderData['order'][i]['combo'].length>0)
                                        //                     //                               //   cartComboList.add('${orderData['order'][i]['name']};${orderData['order'][i]['combo']};true');
                                        //                     //                               // if(orderData['order'][i]['modifier'].length>0){
                                        //                     //                               //   modifierKotList.add('${orderData['order'][i]['name']};${orderData['order'][i]['modifier']}');
                                        //                     //                               //   cartListText.add('${orderData['order'][i]['name']}:${orderData['order'][i]['uom']}:${orderData['order'][i]['price']}:${orderData['order'][i]['qty']}:${orderData['order'][i]['modifier']}');
                                        //                     //                               //   customerOrdersList.add('${orderData['order'][i]['name']}:${orderData['order'][i]['uom']}:${orderData['order'][i]['price']}:${orderData['order'][i]['qty']}:${orderData['order'][i]['modifier']}');
                                        //                     //                               // }
                                        //                     //                               // else{
                                        //                     //                               print('yes');
                                        //                     //                                 cartListText.add('${orderData['order'][i]['name']}:${orderData['order'][i]['uom']}:${orderData['order'][i]['price']}:${orderData['order'][i]['qty']}');
                                        //                     //                                 customerOrdersList.add('${orderData['order'][i]['name']}:${orderData['order'][i]['uom']}:${orderData['order'][i]['price']}:${orderData['order'][i]['qty']}');
                                        //                     //
                                        //                     //                             }
                                        //                     //                           }
                                        //                     //                           print('cartListText $cartListText');
                                        //                     //                           Navigator.pushReplacement(
                                        //                     //                             context,
                                        //                     //                             MaterialPageRoute(builder: (context) => PosScreen()),
                                        //                     //                           );
                                        //                     //                         },
                                        //                     //                         // child: Container(
                                        //                     //                         //
                                        //                     //                         //   padding: EdgeInsets.all(10.0),
                                        //                     //                         //   decoration:  BoxDecoration(
                                        //                     //                         //     color: customerKotFlag==true?Colors.green:Colors.red,
                                        //                     //                         //     borderRadius: BorderRadius.circular(8.0),
                                        //                     //                         //     border: Border.all(
                                        //                     //                         //       color:kGreenColor,
                                        //                     //                         //     ),
                                        //                     //                         //   ),
                                        //                     //                         //   child: Flex(
                                        //                     //                         //     direction: Axis.vertical,
                                        //                     //                         //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        //                     //                         //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //                     //                         //     children: [
                                        //                     //                         //       Text('Name:${snapshot2.data.docs[index6].get('name')}',style: TextStyle(
                                        //                     //                         //         fontSize: MediaQuery.of(context).textScaleFactor*18,
                                        //                     //                         //         color: kBlack,
                                        //                     //                         //       ),),
                                        //                     //                         //       Text('Mobile :${snapshot2.data.docs[index6].get('mobile')}',style: TextStyle(
                                        //                     //                         //         fontSize: MediaQuery.of(context).textScaleFactor*18,
                                        //                     //                         //         color: kBlack,
                                        //                     //                         //       ),),
                                        //                     //                         //       Flexible(
                                        //                     //                         //         child: Text('Address :${snapshot2.data.docs[index6].get('address')}',style: TextStyle(
                                        //                     //                         //           fontSize: MediaQuery.of(context).textScaleFactor*18,
                                        //                     //                         //           color: kBlack,
                                        //                     //                         //           overflow: TextOverflow.ellipsis,
                                        //                     //                         //         ),
                                        //                     //                         //           maxLines: 3,
                                        //                     //                         //         ),
                                        //                     //                         //       ),
                                        //                     //                         //       Flexible(
                                        //                     //                         //           child: Row(
                                        //                     //                         //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                     //                         //             children: [
                                        //                     //                         //               Container(
                                        //                     //                         //                 // width: MediaQuery.of(context).size.width / 3,
                                        //                     //                         //                 // height: 30.0,
                                        //                     //                         //                 decoration: BoxDecoration(
                                        //                     //                         //                   border: Border.all(
                                        //                     //                         //                       color: kAppBarItems,
                                        //                     //                         //                       style: BorderStyle.solid,
                                        //                     //                         //                       width: 2),
                                        //                     //                         //                 ),
                                        //                     //                         //                 child: StreamBuilder(
                                        //                     //                         //                     stream: firebaseFirestore.collection('deliverBoy_data').snapshots(),
                                        //                     //                         //                     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                        //                     //                         //                       if (!snapshot.hasData) {
                                        //                     //                         //                         return Center(
                                        //                     //                         //                           // child: CircularProgressIndicator(),
                                        //                     //                         //                         );
                                        //                     //                         //                       }
                                        //                     //                         //                       return DropdownButtonHideUnderline(
                                        //                     //                         //                         child: ButtonTheme(
                                        //                     //                         //                           alignedDropdown: true,
                                        //                     //                         //                           child: DropdownButton(
                                        //                     //                         //                             dropdownColor:Colors.white,
                                        //                     //                         //                             isDense: true,// Not necessary for Option 1
                                        //                     //                         //                             value: tempDeliveryBoy[index6].length>0?tempDeliveryBoy[index6]:null,// Not necessary for Option 1
                                        //                     //                         //                             items: snapshot.data.docs.map((DocumentSnapshot document) {
                                        //                     //                         //                               return DropdownMenuItem(
                                        //                     //                         //                                 child: new Text(
                                        //                     //                         //                                   document['userName'],
                                        //                     //                         //                                   style: TextStyle(
                                        //                     //                         //                                       fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                        //                     //                         //                                       color: Colors.black),
                                        //                     //                         //                                 ),
                                        //                     //                         //                                 value: document['userName'],
                                        //                     //                         //                               );
                                        //                     //                         //                             }).toList(),
                                        //                     //                         //                             onChanged: (newValue)  {
                                        //                     //                         //                               firebaseFirestore.collection('customer_orders').doc(snapshot2.data.docs[index6].id).update(
                                        //                     //                         //                                   {
                                        //                     //                         //                                     "deliveryBoy":newValue,
                                        //                     //                         //                                     "status":'assigned',
                                        //                     //                         //                                   });
                                        //                     //                         //                               setState((){
                                        //                     //                         //                                 tempDeliveryBoy[index6]=newValue.toString();
                                        //                     //                         //                               });
                                        //                     //                         //                             },
                                        //                     //                         //                           ),
                                        //                     //                         //                         ),
                                        //                     //                         //                       );
                                        //                     //                         //                     }
                                        //                     //                         //                 ),
                                        //                     //                         //               ),
                                        //                     //                         //               IconButton(
                                        //                     //                         //                 icon: Icon(Icons.delivery_dining), onPressed: () {
                                        //                     //                         //                 firebaseFirestore.collection('customer_orders').doc(customerOrderUid).delete();
                                        //                     //                         //               },
                                        //                     //                         //               )
                                        //                     //                         //             ],
                                        //                     //                         //           )
                                        //                     //                         //       ),
                                        //                     //                         //     ],
                                        //                     //                         //   ),
                                        //                     //                         // ),
                                        //                     //                         child: Column(
                                        //                     //                           mainAxisAlignment: MainAxisAlignment.start,
                                        //                     //                           crossAxisAlignment: CrossAxisAlignment.start,
                                        //                     //                           children: [
                                        //                     //                             Container(
                                        //                     //                                 height:currentTerminal=='Call Center'?160:selectedBusiness=='Restaurant'?120:70,
                                        //                     //                                 padding: EdgeInsets.all(4.0),
                                        //                     //                                 decoration:  BoxDecoration(
                                        //                     //                                   color:kGreenColor,
                                        //                     //                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
                                        //                     //                                 ),
                                        //                     //                                 child: Column(
                                        //                     //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                     //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                        //                     //                                   children: [
                                        //                     //                                     Row(
                                        //                     //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                     //                                       children: [
                                        //                     //                                         Text(snapshot2.data.docs[index6].get('name'),style: TextStyle(
                                        //                     //                                           //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //                     //                                           fontWeight: FontWeight.bold,
                                        //                     //                                           color:  Colors.white,
                                        //                     //                                         ),),
                                        //                     //                                         Text(snapshot2.data.docs[index6].get('mobile'),style: TextStyle(
                                        //                     //                                           fontWeight: FontWeight.bold,
                                        //                     //                                           color:  Colors.white,
                                        //                     //                                         ),)
                                        //                     //                                       ],
                                        //                     //                                     ),
                                        //                     //                                     Row(
                                        //                     //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                     //                                       children: [
                                        //                     //                                         Expanded(
                                        //                     //                                           child: Text(snapshot2.data.docs[index6].get('address'),
                                        //                     //                                             maxLines: 2,
                                        //                     //                                             overflow: TextOverflow.ellipsis,
                                        //                     //                                             style: TextStyle(
                                        //                     //                                               fontWeight: FontWeight.bold,
                                        //                     //                                               color:  Colors.white,
                                        //                     //                                             ),),
                                        //                     //                                         ),
                                        //                     //                                         if(selectedBusiness=='Restaurant')
                                        //                     //                                           Column(
                                        //                     //                                             children: [
                                        //                     //                                               Row(
                                        //                     //                                                 children: [
                                        //                     //                                                   Text('KOT :',style: TextStyle(
                                        //                     //                                                     fontWeight: FontWeight.bold,
                                        //                     //                                                     color:  Colors.white,
                                        //                     //                                                   ),),
                                        //                     //                                                   SizedBox(width: 10,),
                                        //                     //                                                   Container(
                                        //                     //                                                     width: 15,
                                        //                     //                                                     height: 15,
                                        //                     //                                                     decoration: BoxDecoration(
                                        //                     //                                                         color:snapshot2.data.docs[index6].get('kot')==true? kKitchenGreenColor:Color(0xffFF2400),
                                        //                     //                                                         shape: BoxShape.circle
                                        //                     //                                                     ),
                                        //                     //                                                   )
                                        //                     //                                                 ],
                                        //                     //                                               ),
                                        //                     //                                               SizedBox(height:10),
                                        //                     //                                               if(snapshot2.data.docs[index6].get('kot')==true)
                                        //                     //                                                 Text(snapshot2.data.docs[index6].get('orderNo'),style: TextStyle(
                                        //                     //                                                   fontWeight: FontWeight.bold,
                                        //                     //                                                   color:  Colors.white,
                                        //                     //                                                 ),),
                                        //                     //                                             ],
                                        //                     //                                           ),
                                        //                     //                                       ],
                                        //                     //                                     ),
                                        //                     //                                     if(currentTerminal=='Call Center')
                                        //                     //                                       Row(
                                        //                     //                                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                     //                                         children: [
                                        //                     //                                           Text('Branch : ',
                                        //                     //                                             maxLines: 1,
                                        //                     //                                             overflow: TextOverflow.ellipsis,
                                        //                     //                                             style: TextStyle(
                                        //                     //                                               fontWeight: FontWeight.bold,
                                        //                     //                                               color:  Colors.white,
                                        //                     //                                             ),),
                                        //                     //                                           Text(snapshot2.data.docs[index6].get('branch'),
                                        //                     //                                             maxLines: 1,
                                        //                     //                                             overflow: TextOverflow.ellipsis,
                                        //                     //                                             style: TextStyle(
                                        //                     //                                               fontWeight: FontWeight.bold,
                                        //                     //                                               color:  Colors.white,
                                        //                     //                                             ),),
                                        //                     //                                         ],
                                        //                     //                                       ),
                                        //                     //                                     if(currentTerminal=='Call Center')
                                        //                     //                                       Row(
                                        //                     //                                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                     //                                         children: [
                                        //                     //                                           Text('Status : ',
                                        //                     //                                             maxLines: 1,
                                        //                     //                                             overflow: TextOverflow.ellipsis,
                                        //                     //                                             style: TextStyle(
                                        //                     //                                               fontWeight: FontWeight.bold,
                                        //                     //                                               color:  Colors.white,
                                        //                     //                                             ),),
                                        //                     //                                           Text(snapshot2.data.docs[index6].get('status'),
                                        //                     //                                             maxLines: 1,
                                        //                     //                                             overflow: TextOverflow.ellipsis,
                                        //                     //                                             style: TextStyle(
                                        //                     //                                               fontWeight: FontWeight.bold,
                                        //                     //                                               color:  Colors.white,
                                        //                     //                                             ),),
                                        //                     //                                         ],
                                        //                     //                                       ),
                                        //                     //                                     if(selectedBusiness=='Restaurant')
                                        //                     //                                       Container(
                                        //                     //                                         decoration: BoxDecoration(
                                        //                     //                                           border: Border.all(
                                        //                     //                                               color: kFont3Color,
                                        //                     //                                               style: BorderStyle.solid,
                                        //                     //                                               width: 0.9),
                                        //                     //                                         ),
                                        //                     //                                         child: StreamBuilder(
                                        //                     //                                             stream: firebaseFirestore.collection('deliverBoy_data').snapshots(),
                                        //                     //                                             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                        //                     //                                               if (!snapshot.hasData) {
                                        //                     //                                                 return Center(
                                        //                     //                                                   // child: CircularProgressIndicator(),
                                        //                     //                                                 );
                                        //                     //                                               }
                                        //                     //                                               return DropdownButtonHideUnderline(
                                        //                     //                                                 child: ButtonTheme(
                                        //                     //                                                   alignedDropdown: true,
                                        //                     //                                                   child: DropdownButton(
                                        //                     //                                                     isExpanded: true,
                                        //                     //                                                     dropdownColor:Colors.white,
                                        //                     //                                                     isDense: true,// Not necessary for Option 1
                                        //                     //                                                     value: tempDeliveryBoy[index6].length>0?tempDeliveryBoy[index6]:null,// Not necessary for Option 1
                                        //                     //                                                     items: snapshot.data.docs.map((DocumentSnapshot document) {
                                        //                     //                                                       return DropdownMenuItem(
                                        //                     //                                                         child: new Text(
                                        //                     //                                                           document['userName'],
                                        //                     //                                                           overflow: TextOverflow.ellipsis,
                                        //                     //                                                           style: TextStyle(
                                        //                     //                                                             // fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                        //                     //                                                               color: kFont1Color),
                                        //                     //                                                         ),
                                        //                     //                                                         value: document['userName'],
                                        //                     //                                                       );
                                        //                     //                                                     }).toList(),
                                        //                     //                                                     onChanged: (newValue)  {
                                        //                     //                                                       firebaseFirestore.collection('customer_orders').doc(snapshot2.data.docs[index6].id).update(
                                        //                     //                                                           {
                                        //                     //                                                             "deliveryBoy":newValue,
                                        //                     //                                                             "status":'assigned',
                                        //                     //                                                           });
                                        //                     //                                                       setState((){
                                        //                     //                                                         tempDeliveryBoy[index6]=newValue.toString();
                                        //                     //                                                       });
                                        //                     //                                                     },
                                        //                     //                                                   ),
                                        //                     //                                                 ),
                                        //                     //                                               );
                                        //                     //                                             }
                                        //                     //                                         ),
                                        //                     //                                       ),
                                        //                     //                                   ],
                                        //                     //                                 )
                                        //                     //                             ),
                                        //                     //                             if(currentTerminal!='Call Center')
                                        //                     //                               Expanded(
                                        //                     //                                 child: Container(
                                        //                     //                                     width: double.maxFinite,
                                        //                     //                                     decoration:  BoxDecoration(
                                        //                     //                                         borderRadius: BorderRadius.all(Radius.zero),
                                        //                     //                                         border: Border.all(color: kGreenColor)
                                        //                     //                                     ),
                                        //                     //                                     //padding: EdgeInsets.only(left: 3.0,right: 3.0),
                                        //                     //                                     child: Column(
                                        //                     //                                       children: [
                                        //                     //                                         Expanded(
                                        //                     //                                           child: ListView.builder(
                                        //                     //                                               itemCount:snapshot2.data.docs[index6]['order'].length ,
                                        //                     //                                               itemBuilder: (context,index3){
                                        //                     //
                                        //                     //                                                 return Padding(
                                        //                     //                                                   padding: const EdgeInsets.only(top: 2.0,left: 2.0),
                                        //                     //                                                   child: Row(
                                        //                     //                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                     //                                                     children: [
                                        //                     //                                                       Column(
                                        //                     //                                                         children: [
                                        //                     //                                                           Text('${snapshot2.data.docs[index6]['order'][index3]['qty']}x'),
                                        //                     //                                                           Text(snapshot2.data.docs[index6]['order'][index3]['uom'].toString()),
                                        //                     //                                                         ],
                                        //                     //                                                       ),
                                        //                     //                                                       if(selectedBusiness!='Restaurant')
                                        //                     //                                                         SizedBox(width:20),
                                        //                     //                                                       Flexible(child: Text(snapshot2.data.docs[index6]['order'][index3]['name'].toString().replaceAll('#', '/'),maxLines: 2,)),
                                        //                     //                                                       if(selectedBusiness=='Restaurant' && snapshot2.data.docs[index6].get('kot')==true)Icon(Icons.circle,
                                        //                     //                                                         color: snapshot2.data.docs[index6]['order'][index3]['ready']==true?kKitchenGreenColor:kAppBarItems,
                                        //                     //                                                       ),
                                        //                     //                                                     ],
                                        //                     //                                                   ),
                                        //                     //                                                 );
                                        //                     //                                               }),
                                        //                     //                                         ),
                                        //                     //                                         Padding(
                                        //                     //                                           padding: EdgeInsets.only(left: 3.0,right: 3.0),
                                        //                     //                                           child: Row(
                                        //                     //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                     //                                             children: [
                                        //                     //                                               Text('Total',style: TextStyle(
                                        //                     //                                                 //fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //                     //                                                 fontWeight: FontWeight.bold,
                                        //                     //                                                 color:  Colors.black,
                                        //                     //                                               ),),
                                        //                     //                                               SizedBox(width: 10,),
                                        //                     //                                               ElevatedButton(
                                        //                     //                                                 style: ButtonStyle(
                                        //                     //                                                   side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                        //                     //                                                   elevation: MaterialStateProperty.all(3.0),
                                        //                     //                                                   backgroundColor: MaterialStateProperty.all(kGreenColor),
                                        //                     //                                                 ),
                                        //                     //                                                 onPressed: (){
                                        //                     //                                                   showDialog(
                                        //                     //                                                     context:
                                        //                     //                                                     context,
                                        //                     //                                                     builder: (ctx) =>
                                        //                     //                                                         AlertDialog(
                                        //                     //                                                           title: Text("Are you sure?"),
                                        //                     //                                                           actions: <Widget>[
                                        //                     //                                                             TextButton(
                                        //                     //                                                               onPressed: () {
                                        //                     //                                                                 Navigator.of(ctx).pop();
                                        //                     //                                                               },
                                        //                     //                                                               child: Text("No"),
                                        //                     //                                                             ),
                                        //                     //                                                             TextButton(
                                        //                     //                                                               onPressed: () {
                                        //                     //                                                                 print('before');
                                        //                     //                                                                 firebaseFirestore.collection('customer_orders').doc(snapshot2.data.docs[index6].id).delete();
                                        //                     //                                                                 print('after');
                                        //                     //                                                                 Navigator.of(ctx).pop();
                                        //                     //                                                                 Navigator.pop(context654);
                                        //                     //                                                               },
                                        //                     //                                                               child: Text("Yes"),
                                        //                     //                                                             ),
                                        //                     //                                                           ],
                                        //                     //                                                         ),
                                        //                     //                                                   );
                                        //                     //                                                 },
                                        //                     //                                                 child: Text("Cancel",style: TextStyle(
                                        //                     //                                                   color: kFont1Color,
                                        //                     //                                                   fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                        //                     //                                                 ),
                                        //                     //                                                 ),
                                        //                     //                                               ),
                                        //                     //                                               Text(tempTotal.toStringAsFixed(decimals),style: TextStyle(
                                        //                     //                                                 // fontSize: MediaQuery.of(context).textScaleFactor*15,
                                        //                     //                                                 fontWeight: FontWeight.bold,
                                        //                     //                                                 color:  Colors.black,
                                        //                     //                                               ),),
                                        //                     //                                             ],
                                        //                     //                                           ),
                                        //                     //                                         ),
                                        //                     //                                       ],
                                        //                     //                                     )
                                        //                     //                                 ),
                                        //                     //                               ),
                                        //                     //
                                        //                     //                           ],
                                        //                     //                         ),
                                        //                     //                       ),
                                        //                     //                     );
                                        //                     //                   }),
                                        //                     //               Positioned.fill(
                                        //                     //                 child: Align(
                                        //                     //                   alignment: Alignment.bottomRight,
                                        //                     //                   child: TextButton(onPressed: () => Navigator.pop(context),
                                        //                     //                       child: Container(
                                        //                     //                         padding: EdgeInsets.all(8.0),
                                        //                     //                         color: kGreenColor,
                                        //                     //                         child: Text('CLOSE',style: TextStyle(
                                        //                     //                           letterSpacing: 1.5,
                                        //                     //                           fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        //                     //                           color: kWhiteColor,
                                        //                     //                         ),),
                                        //                     //                       )),
                                        //                     //                 ),
                                        //                     //               )
                                        //                     //             ],
                                        //                     //           ),
                                        //                     //         );
                                        //                     //       }
                                        //                     //   ),
                                        //                     // );
                                        //                   });
                                        //                 }
                                        //             ),
                                        //           );
                                        //         }),
                                        //   ),
                                        if(currentTerminal=='Admin-POS')  IconButton(onPressed: (){
                                          _scaffoldKey.currentState.openEndDrawer();
                                        }, icon: Icon(Icons.menu),color: kItemContainer,),
                                      ],
                                    ),
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
                            child: Stack(
                              children: [
                                Card(
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
                                                children:[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(left: 4.0, right: 4.0),
                                                    child: RawMaterialButton(
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(color: selectedCategory=='All'?kFont3Color:kGreenColor, width: 0.5),
                                                      ),
                                                      onPressed: () async {
                                                        await displayAllProducts('Salable');
                                                        // selectedCategory='All';
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
                                                            //  fontSize: MediaQuery.of(context).textScaleFactor*16,
                                                            color: selectedCategory=='All'?kFont1Color:kGreenColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      //shape: const StadiumBorder(),
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
                                                            shape: RoundedRectangleBorder(
                                                              side: BorderSide(color: selectedCategory==productCategoryF[index]?kFont3Color:kGreenColor, width:0.5),
                                                            ),
                                                            onPressed:() async{
                                                              await displayProducts(productCategoryF[index]);
                                                              selectedCategory=productCategoryF[index];
                                                              setState(() {

                                                              });
                                                            },
                                                            fillColor:selectedCategory==productCategoryF[index]?kGreenColor:kItemContainer,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(5.0),
                                                              child: Text(
                                                                productCategoryF[index],
                                                                textAlign: TextAlign.center,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  // fontSize: MediaQuery.of(context).textScaleFactor*16,
                                                                    color: selectedCategory==productCategoryF[index]?kFont1Color:kGreenColor,
                                                                    fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ),
                                                            //shape: const StadiumBorder(),
                                                          ),
                                                        );
                                                      }),]
                                            ),
                                          ),
                                      Expanded(
                                        child: Container(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: productNameF.isEmpty ? Center(child: Text('Empty')) : GridView.builder(
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 4,
                                                    childAspectRatio:selectedScreen=='withImage'? MediaQuery.of(context).size.width/1.5 /
                                                        (MediaQuery.of(context).size.height ):MediaQuery.of(context).size.width /
                                                        (MediaQuery.of(context).size.height ),
                                                  ),
                                                  scrollDirection: Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount: productNameF.length,
                                                  itemBuilder: (context, index) {
                                                    return selectedScreen=='withImage'?Padding(
                                                      padding: const EdgeInsets.all(4),
                                                      child: GestureDetector(
                                                          onTap: (){
                                                         bool check=checkCombo(productNameF[index]);
                                                         if(check){
                                                           addComboItems(productNameF[index],index,'grid');
                                                         }
                                                         else{
                                                           setState(() {
                                                             addToCart(index);
                                                           });
                                                         }
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
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Lato',
                                                                      // fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                                      color: kGreenColor,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                      ),
                                                    ):
                                                    GestureDetector(
                                                      onTap: (){
                                                        bool check=checkCombo(productNameF[index]);
                                                        if(check){
                                                          String val=comboData(productNameF[index]);
                                                          showDialog(
                                                            context:
                                                            context,
                                                            builder: (ctx) =>
                                                                Center(
                                                                  child: Container(
                                                                    width:MediaQuery.of(context).size.width/2,
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
                                                          setState(() {
                                                            addToCart(index);
                                                          });
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Card(
                                                          //color: kGreenColor,
                                                          elevation: 3,
                                                          // shape: RoundedRectangleBorder(
                                                          //   side: BorderSide(color: kGreenColor, width: 0.5),
                                                          //   borderRadius: BorderRadius.circular(15.0),
                                                          // ),
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
                                Obx(()=>Visibility(
                                  visible:searchCustomerResult.isNotEmpty,
                                  child:  Align(
                                    alignment:Alignment.topCenter,
                                    child: Container(
                                        width: MediaQuery.of(context).size.width/5.5,
                                        // height: MediaQuery.of(context).size.height/2,
                                        color: kItemContainer,
                                        child:ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: searchCustomerResult.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return GestureDetector(
                                              onTap: (){
                                                List tempVal=searchCustomerResult[index].toString().split('\n');
                                              numforroute = tempVal[1];
                                                setState(() {
                                                        selectedCustomer=appbarCustomerController.text=tempVal[0].toString().trim();
                                                      });
                                                      searchCustomerResult.clear();
                                              },
                                              child: new ListTile(
                                                title: new Text(searchCustomerResult[index]),
                                              ),
                                            );
                                          },
                                        )
                                    ),
                                  ),
                                )),
                              ],
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
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Visibility(
                                          visible: currentTerminal=='Call Center'?false:selectedBusiness=='Restaurant'?true:false,
                                          child: SizedBox(
                                              width: MediaQuery.of(context).size.width/3,
                                              height: 40,
                                              // fit: BoxFit.fitWidth,
                                              child: Center(child: buildDelivery(context))),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      // child: SimpleAutoCompleteTextField(
                                                      //   suggestionsAmount: 10,
                                                      //   style: TextStyle(
                                                      //     fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                      //   ),
                                                      //   focusNode: nameNode,
                                                      //   controller: nameController,
                                                      //   decoration: new InputDecoration(
                                                      //       border: OutlineInputBorder(),
                                                      //       disabledBorder: OutlineInputBorder(
                                                      //       ),
                                                      //       enabledBorder: OutlineInputBorder(),
                                                      //       hintText: 'search for items'
                                                      //   ),
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
                                                        // autofocus: true,
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                        ),
                                                        focusNode: nameNode,
                                                        textInputAction: TextInputAction.go,
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

                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 20,),
                                              Expanded(
                                                child: Container(
                                                  child: TextField(
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                    ),
                                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                    focusNode: quantityNode,
                                                    controller: quantityController,
                                                    showCursor: enableQuantity,
                                                    onEditingComplete: (){
                                                      print('_selectedItem $_selectedItem');
                                                      bool check=checkCombo(_selectedItem);
                                                      print('check $check');
                                                      if(check){
                                                        addComboItems(_selectedItem,0,'search');
                                                      }
                                                      else{
                                                        addFromSearch(_selectedItem, quantityController.text);
                                                        quantityController.clear();
                                                        nameController.clear();
                                                        _selectedItem='';
                                                        nameNode.requestFocus();
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => PosScreen()),
                                                        );
                                                      }
                                                    },
                                                    // onSubmitted: (val)  {
                                                    //   print('iniside qty ');
                                                    //      addFromSearch(_selectedItem, val);
                                                    //   quantityController.clear();
                                                    //   nameController.clear();
                                                    //   _selectedItem='';
                                                    //   nameNode.requestFocus();
                                                    //   setState(() {
                                                    //     _scrollController.jumpTo(60.0);
                                                    //   });
                                                    // },
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
                                            reverse: false,
                                            // controller:_scrollController,
                                            scrollDirection: Axis.vertical,
                                            child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: dataTable()),
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
                                        height: MediaQuery.of(context).size.height/5,
                                        // padding: EdgeInsets.all(8.0),
                                        alignment: Alignment.bottomCenter,
                                        child:Flex(
                                          direction: Axis.vertical,
                                          mainAxisSize:MainAxisSize.min ,
                                          children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                if(currentDiscount=='true')Row(
                                                  children: [
                                                    GestureDetector(
                                                        onTap:(){
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                title: Text("Discount Type"),
                                                                actions: <Widget>[
                                                                  // usually buttons at the bottom of the dialog
                                                                  Obx(()=> RadioListTile(
                                                                      activeColor: kBackgroundColor,
                                                                      title: Text(
                                                                        'VAL',
                                                                        style: TextStyle(
                                                                          // fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                                                        ),
                                                                      ),
                                                                      value: discountType.VAL,
                                                                      groupValue: _discountType.value,
                                                                      onChanged: (value) {
                                                                        _discountType.value = value as discountType;
                                                                        discountTypeSelected.value = 'VAL';
                                                                        totalDiscountController.text='0';
                                                                        Navigator.pop(context);
                                                                      }),),
                                                                  Obx(()=>  RadioListTile(
                                                                      activeColor: kBackgroundColor,
                                                                      title: Text(
                                                                        'PER',
                                                                        style: TextStyle(
                                                                          //  fontSize: MediaQuery.of(context).textScaleFactor * 20,
                                                                        ),
                                                                      ),
                                                                      value:discountType.PER,
                                                                      groupValue: _discountType.value,
                                                                      onChanged: (value) {
                                                                        _discountType.value = value as discountType;
                                                                        discountTypeSelected.value = 'PER';
                                                                        totalDiscountController.text='0';
                                                                        Navigator.pop(context);
                                                                      }),)
                                                                  // new TextButton(
                                                                  //   child: new Text("Close"),
                                                                  //   onPressed: () {
                                                                  //     Navigator.of(context).pop();
                                                                  //   },
                                                                  // ),
                                                                ],
                                                              )
                                                          );
                                                        },
                                                        child: Obx(()=>Text(discountTypeSelected.value=='VAL'?'Discount\nAmount':'Discount\nPercentage', style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                        ),),)
                                                    ),

                                                    SizedBox(width:10),
                                                    SizedBox(
                                                      width: 80,
                                                      // height: 40,
                                                      child: GestureDetector(

                                                        child: TextField(
                                                          controller: totalDiscountController,
                                                          keyboardType: TextInputType.number,
                                                          decoration: new InputDecoration(
                                                            isDense: true,
                                                            contentPadding: EdgeInsets.fromLTRB(5.0, 7.0, 5.0, 7.0),
                                                            // labelText:discountTypeSelected.value=='VAL'?'Amount':'Percentage' ,
                                                            border: OutlineInputBorder(),
                                                            disabledBorder: OutlineInputBorder(
                                                            ),
                                                            enabledBorder: OutlineInputBorder(),
                                                          ),
                                                          onSubmitted: (val){
                                                            setState(() {
                                                              getTotal(salesTotalList);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],),
                                                Text('Total', style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: MediaQuery.of(context).textScaleFactor*15,
                                                ),),
                                                // if(currentTerminal!='Call Center')  Container(
                                                //   decoration: BoxDecoration(
                                                //     border: Border.all(
                                                //         color: kAppBarItems,
                                                //         style: BorderStyle.solid,
                                                //         width: 2),
                                                //   ),
                                                //   child: DropdownButtonHideUnderline(
                                                //     child: ButtonTheme(
                                                //       alignedDropdown: true,
                                                //       child: DropdownButton(
                                                //         dropdownColor:Colors.white,
                                                //         isDense: true,
                                                //         value: selectedPayment, // Not necessary for Option 1
                                                //         items: paymentMode.map((String val) {
                                                //           return DropdownMenuItem(
                                                //             child: new Text(val.toString(),
                                                //               style: TextStyle(
                                                //                   fontWeight: FontWeight.bold,
                                                //                   letterSpacing: 1.5,
                                                //                   fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                //                   color: kHighlight
                                                //               ),
                                                //             ),
                                                //             value: val,
                                                //           );
                                                //         }).toList(),
                                                //         onChanged: (newValue) {
                                                //           setState(() {
                                                //             selectedPayment = newValue;
                                                //           });
                                                //         },
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
                                                Text(salesTotal.toStringAsFixed(decimals), style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                ),)
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
                                                        selectedCustomer='';
                                                        appbarCustomerController.clear();
                                                        cartListText=[];
                                                        totalDiscountController.text='0';
                                                        currentOrder='';
                                                        customerOrderUid='';
                                                        customerUserUid='';
                                                        cartController=[];
                                                        salesUomList=[];
                                                        salesTotalList=[];
                                                        salesTotal=0;
                                                        tableSelected.value='TABLE';
                                                        checkoutFlag=true;
                                                        kotFailedList=[];
                                                        deliveryKotFlag=false;
                                                        customerKotFlag=false;
                                                        customerOrderDeliveryBoy='';
                                                        cartComboList=[];
                                                        modifierKotList=[];
                                                      });
                                                      isEstimate.value=false;
                                                      selectedBranch.value='BRANCH';
                                                      invEdit.value=false;
                                                      if(currentTerminal=='Call Center'){
                                                        bool newValue=true;
                                                        allCustomerMobileNameController.text='';
                                                        allCustomerMobileAddressController.text='';
                                                        flatNoController.text='';
                                                        buildNoController.text='';
                                                        roadNoController.text='';
                                                        blockNoController.text='';
                                                        areaNoController.text='';
                                                        landmarkNoController.text='';
                                                        deliveryNoteController.text='';
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return StatefulBuilder(
                                                                  builder: (context,setState) {
                                                                    return Dialog(
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                                      child: Container(
                                                                        padding: EdgeInsets.all(6.0),
                                                                        // width: MediaQuery.of(context).size.width,
                                                                        // width: MediaQuery.of(context).size.width/3,
                                                                        //height: MediaQuery.of(context).size.height/2,
                                                                        child: SingleChildScrollView(
                                                                          scrollDirection: Axis.vertical,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width/3,
                                                                                child: Column(
                                                                                  // scrollDirection: Axis.vertical,
                                                                                  // shrinkWrap: true,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Customer details',
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      width: MediaQuery.of(context).size.width/3,
                                                                                      //padding: const EdgeInsets.all(8.0),
                                                                                      child: StatefulBuilder(
                                                                                        builder: (context,setState){
                                                                                          return SimpleAutoCompleteTextField(
                                                                                            style: TextStyle(
                                                                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                                            ),
                                                                                            decoration:InputDecoration(
                                                                                              suffixIcon: Icon(Icons.search,color: Colors.black),
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
                                                                                              labelText: 'enter mobile number',
                                                                                              labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                            ),
                                                                                            controller: allCustomerMobileController,
                                                                                            keyboardType:
                                                                                            TextInputType.number,
                                                                                            suggestions: allCustomerMobile,
                                                                                            clearOnSubmit: false,
                                                                                            textSubmitted: (text) async {
                                                                                              if(allCustomerMobile.contains(text)) {
                                                                                                QuerySnapshot variable=await  firebaseFirestore.collection('customer_details').where('mobile',isEqualTo: text).get();

                                                                                                setState(() {
                                                                                                  newValue=false;
                                                                                                  customerUserUid=variable.docs[0].id;
                                                                                                  allCustomerMobileController.text=text;
                                                                                                  allCustomerMobileNameController.text=customerList[allCustomerMobile.indexOf(text)];
                                                                                                  allCustomerMobileAddressController.text=allCustomerAddress[allCustomerMobile.indexOf(text)];
                                                                                                  flatNoController.text=variable.docs[0].get('flatNo');
                                                                                                  buildNoController.text=variable.docs[0].get('buildNo');
                                                                                                  roadNoController.text=variable.docs[0].get('roadNo');
                                                                                                  blockNoController.text=variable.docs[0].get('blockNo');
                                                                                                  areaNoController.text=variable.docs[0].get('area');
                                                                                                  landmarkNoController.text=variable.docs[0].get('landmark');
                                                                                                  deliveryNoteController.text=variable.docs[0].get('note');
                                                                                                });
                                                                                                print('inside allCustomerMobile $text');
                                                                                              }
                                                                                              else
                                                                                              {
                                                                                              }
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 20.0,),
                                                                                    TextField(
                                                                                      controller: allCustomerMobileNameController,
                                                                                      onChanged: (value) {
                                                                                      },
                                                                                      keyboardType:
                                                                                      TextInputType.name,
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
                                                                                        labelText: 'Name',
                                                                                        labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 20.0,),
                                                                                    TextField(
                                                                                      controller: allCustomerMobileAddressController,
                                                                                      onChanged: (value) {
                                                                                      },
                                                                                      keyboardType:
                                                                                      TextInputType.name,
                                                                                      maxLines: 3,
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
                                                                                        labelText: 'Address',
                                                                                        labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 20.0,),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: TextField(
                                                                                            controller: flatNoController,
                                                                                            onChanged: (value) {
                                                                                            },
                                                                                            keyboardType:
                                                                                            TextInputType.name,
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
                                                                                              labelText: 'Flat NO',
                                                                                              labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 10.0,),
                                                                                        Expanded(
                                                                                          child: TextField(
                                                                                            controller: buildNoController,
                                                                                            onChanged: (value) {
                                                                                            },
                                                                                            keyboardType:
                                                                                            TextInputType.name,
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
                                                                                              labelText: 'BLD NO',
                                                                                              labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: 20.0,),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: TextField(
                                                                                            controller: roadNoController,
                                                                                            onChanged: (value) {
                                                                                            },
                                                                                            keyboardType:
                                                                                            TextInputType.name,
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
                                                                                              labelText: 'ROAD NO',
                                                                                              labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 10.0,),
                                                                                        Expanded(
                                                                                          child: TextField(
                                                                                            controller: blockNoController,
                                                                                            onChanged: (value) {
                                                                                            },
                                                                                            keyboardType:
                                                                                            TextInputType.name,
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
                                                                                              labelText: 'BLOCK NO',
                                                                                              labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: 20.0,),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width/3,
                                                                                child: Column(
                                                                                  children: [
                                                                                    TextField(
                                                                                      controller: areaNoController,
                                                                                      onChanged: (value) {
                                                                                      },
                                                                                      keyboardType:
                                                                                      TextInputType.name,
                                                                                      maxLines: 3,
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
                                                                                        labelText: 'Area',
                                                                                        labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 20.0,),
                                                                                    TextField(
                                                                                      controller: landmarkNoController,
                                                                                      onChanged: (value) {
                                                                                      },
                                                                                      keyboardType:
                                                                                      TextInputType.name,
                                                                                      maxLines: 3,
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
                                                                                        labelText: 'Land mark',
                                                                                        labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 20.0,),
                                                                                    TextField(
                                                                                      controller: deliveryNoteController,
                                                                                      onChanged: (value) {
                                                                                      },
                                                                                      keyboardType:
                                                                                      TextInputType.name,
                                                                                      maxLines: 3,
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
                                                                                        labelText: 'Note',
                                                                                        labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                      ),
                                                                                    ),
                                                                                    RawMaterialButton(
                                                                                      onPressed: () async {
                                                                                        if(newValue==false){
                                                                                          appbarCustomerController.text=selectedCustomer=allCustomerMobileNameController.text;
                                                                                          Navigator.pushNamed(context, PosScreen.id);
                                                                                        }
                                                                                        else{
                                                                                          String inside='not';
                                                                                          for(int i=0;i<customerList.length;i++){
                                                                                            if(customerList[i].toLowerCase() == allCustomerMobileNameController.text.toLowerCase()){
                                                                                              inside='contains';
                                                                                              showDialog(
                                                                                                  context: context,
                                                                                                  builder: (context) => AlertDialog(
                                                                                                    title: Text("Error"),
                                                                                                    content: Text("Customer name Exists"),
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
                                                                                          }
                                                                                          if(inside == 'not'){
                                                                                            String body='${allCustomerMobileNameController.text}~${allCustomerMobileAddressController.text}~${allCustomerMobileController.text}~~~~${flatNoController.text}~${buildNoController.text}~${roadNoController.text}~${blockNoController.text}~${areaNoController.text}~${landmarkNoController.text}~${deliveryNoteController.text}';
                                                                                            await create(body, 'customer_details',[]);
                                                                                            await  read('customer_details');
                                                                                            appbarCustomerController.text=selectedCustomer=allCustomerMobileNameController.text;
                                                                                            QuerySnapshot variable=await  firebaseFirestore.collection('customer_details').where('mobile',isEqualTo: allCustomerMobileController.text).get();
                                                                                            setState(() {
                                                                                              customerUserUid=variable.docs[0].id;
                                                                                            });
                                                                                            Navigator.pushNamed(context, PosScreen.id);
                                                                                          }
                                                                                        }
                                                                                      },
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
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                              );
                                                            });
                                                      }
                                                    },
                                                    child: Text("New Order",style: TextStyle(
                                                      color: kFont1Color,
                                                      fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                    ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible:selectedBusiness=='Retail'?true: selectedDelivery=='QSR'?false:currentTerminal=='Call Center'?false:true,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                                        elevation: MaterialStateProperty.all(3.0),
                                                        backgroundColor: MaterialStateProperty.all(kGreenColor),
                                                      ),
                                                      onLongPress: () async {
                                                        kotList=kotFailedList;
                                                        print("format KOT  8985");
                                                        await formatKotList(currentOrder,tableSelected.value);
                                                      },
                                                      onPressed: ()async{

                                                        if(selectedBusiness!='Restaurant'){
                                                          await kotAssign(cartListText,currentOrder);
                                                        }
                                                        else if(selectedDelivery=='QSR'){
                                                        }
                                                        else {
                                                          if(cartListText.isEmpty){
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add Items')));
                                                            return;
                                                          }

                                                          else if(selectedDelivery=='Spot' && tableSelected.value=='TABLE'){
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Table not selected')));
                                                            return;
                                                          }
                                                          else{
                                                            List yourItemsList=[];

                                                            if(selectedDelivery=='Delivery'){
                                                              if(deliveryKotFlag==true){
                                                                showDialog(
                                                                  context:
                                                                  context,
                                                                  builder: (ctx) =>
                                                                      AlertDialog(
                                                                        title: Text("KOT already given"),
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
                                                              }
                                                              else  if(customerOrderUid.length>0 ){
                                                                // if(customerKotFlag==true){
                                                                //   print('inside if kot flag');
                                                                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('KOT Already given')));
                                                                // }

                                                                int invoice=await getLastInv('kot');
                                                                String orderNo='${getPrefix()}$invoice';
                                                                updateInv('kot', invoice+1);
                                                                firebaseFirestore.collection('customer_orders').doc(customerOrderUid).update(
                                                                    {
                                                                      "kot":true,
                                                                      "orderNo":orderNo,
                                                                    });
                                                                customerKotFlag=true;
                                                                kotList=[];
                                                                print("Adding  9039");

                                                                for(int i=0;i<cartListText.length;i++){
                                                                  List temp=cartListText[i].split(':');
                                                                  kotList.add('${temp[0]}:${temp[3]}:');
                                                                }
                                                                print("format KOT  9049");
                                                                await formatKotList(orderNo, '');

                                                              }
                                                              else if(allCustomerMobileController.text==''){
                                                                showDialog(
                                                                  context:
                                                                  context,
                                                                  builder: (ctx) =>
                                                                      AlertDialog(
                                                                        title: Text("customer not selected"),
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
                                                              else {
                                                                  kotList=[];
                                                                  List yourItemsList=[];
                                                                  String tempModifier='';
                                                                  String tempComboKot='';
                                                                  for(int i=0;i<cartListText.length;i++){
                                                                    tempModifier='';
                                                                    tempComboKot='';
                                                                    List temp=cartListText[i].split(':');
                                                                    if(temp.length>4){
                                                                      tempModifier=temp[4];
                                                                    }
                                                                    if(cartComboList.length>0){
                                                                      for(int m=0;m<cartComboList.length;m++){
                                                                        List temp123=cartComboList[m].toString().split(';');
                                                                        if(temp123[0].toString().trim()==temp[0].toString().trim()) {
                                                                          tempComboKot+=temp123[1].toString().trim();
                                                                          tempComboKot+='~';
                                                                        }
                                                                      }
                                                                      tempComboKot=tempComboKot.length>0?tempComboKot.substring(0,tempComboKot.length-1):'';
                                                                    }
                                                                    yourItemsList.add({
                                                                      "name":temp[0].toString().trim(),
                                                                      "uom":temp[1].toString().trim(),
                                                                      "qty":temp[3].toString().trim(),
                                                                      "price":double.parse(temp[2].toString().trim()),
                                                                      "image":'',
                                                                      "modifier":tempModifier,
                                                                      "ready":false,
                                                                      "combo":tempComboKot
                                                                    });
                                                                    kotList.add('${temp[0]}:${temp[3]}::${temp[1]}');
                                                                    print("kotList $kotList");

                                                                  }
                                                                  int invoice=await getLastInv('kot');
                                                                  String orderNo='${getPrefix()}$invoice';
                                                                  updateInv('kot', invoice+1);

                                                                  await  firebaseFirestore.collection('customer_orders').doc().set({
                                                                    "uid":customerUserUid,
                                                                    "name":allCustomerMobileNameController.text,
                                                                    "mobile":allCustomerMobileController.text,
                                                                    "address":allCustomerMobileAddressController.text,
                                                                    "order":yourItemsList,
                                                                    "date":DateTime.now().millisecondsSinceEpoch,
                                                                    "status":'placed',
                                                                    "kot":true,
                                                                    "orderNo":orderNo,
                                                                    "checkOut":false,
                                                                    "deliveryBoy":'',
                                                                    "branch":'',
                                                                  });
                                                                  customerKotFlag=true;
                                                                  print("format KOT  9124");
                                                                  await formatKotList(orderNo, '');

                                                              }
                                                            }
                                                            else{
                                                              await kotAssign(cartListText, currentOrder );
                                                              if(selectedDelivery=='Spot'){
                                                                addTable(tableSelected.value,currentTableOrders.value,currentOrder);
                                                              }
                                                            }
                                                          }
                                                        }
                                                        setState(() {
                                                          selectedCustomer='';
                                                          allCustomerMobileController.text='';
                                                          appbarCustomerController.clear();
                                                          cartListText=[];
                                                          totalDiscountController.text='0';
                                                          currentOrder='';
                                                          customerOrderUid='';
                                                          customerUserUid='';
                                                          cartController=[];
                                                          salesUomList=[];
                                                          salesTotalList=[];
                                                          cartComboList=[];
                                                          salesTotal=0;
                                                          tableSelected.value='TABLE';
                                                          checkoutFlag=true;
                                                          kotFailedList=[];
                                                          deliveryKotFlag=false;
                                                          customerKotFlag=false;
                                                          modifierKotList=[];
                                                        });
                                                        isEstimate.value=false;
                                                      },
                                                      child: Text(  selectedBusiness=='Restaurant'?'KOT':'Draft',style: TextStyle(
                                                        color: kFont1Color,
                                                        fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                      ),
                                                      ),
                                                    ),
                                                  ),
                                                    Obx(()=>Visibility(
                                                      visible:isEstimate.value,
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                                          elevation: MaterialStateProperty.all(3.0),
                                                          backgroundColor: MaterialStateProperty.all(kGreenColor),
                                                        ),
                                                        onPressed: () {
                                                          retailEstimate(cartListText,salesTotal);
                                                          isEstimate.value=false;
                                                          setState(() {
                                                            selectedCustomer='';
                                                            appbarCustomerController.clear();
                                                            cartListText=[];
                                                            totalDiscountController.text='0';
                                                            currentOrder='';
                                                            customerOrderUid='';
                                                            customerUserUid='';
                                                            cartController=[];
                                                            salesUomList=[];
                                                            salesTotalList=[];
                                                            salesTotal=0;
                                                            tableSelected.value='TABLE';
                                                            checkoutFlag=true;
                                                            kotFailedList=[];
                                                            deliveryKotFlag=false;
                                                            customerKotFlag=false;
                                                            customerOrderDeliveryBoy='';
                                                          });
                                                        },
                                                        child: Text('Estimate',style: TextStyle(
                                                          color: kFont1Color,
                                                          fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                        ),),
                                                      ),
                                                    ),),
                                                  if(currentTerminal=='Call Center')
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                          side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
                                                          elevation: MaterialStateProperty.all(3.0),
                                                          backgroundColor: MaterialStateProperty.all(kGreenColor),
                                                        ),
                                                        onPressed: (){
                                                          branchNameController.clear();
                                                          branchResult.clear();
                                                          showDialog(
                                                            context:
                                                            context,
                                                            builder: (ctx) =>
                                                                SingleChildScrollView(
                                                                  scrollDirection: Axis.vertical,
                                                                  child: Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(12.0)),
                                                                      child:Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              width:250,
                                                                              child: TextField(
                                                                                style: TextStyle(
                                                                                  fontSize: MediaQuery.of(context).textScaleFactor*14,
                                                                                ),
                                                                                textInputAction: TextInputAction.go,
                                                                                controller: branchNameController,
                                                                                decoration: new InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    disabledBorder: OutlineInputBorder(
                                                                                    ),
                                                                                    enabledBorder: OutlineInputBorder(),
                                                                                    hintText: 'search for branch'
                                                                                ),
                                                                                onChanged: searchBranch,
                                                                              ),
                                                                            ),
                                                                            Stack(
                                                                              children: [
                                                                                 Obx(()=>
                                                                                    Visibility(
                                                                                      visible:branchResult.length>0?false:true,
                                                                                      child: SizedBox(
                                                                                        width: MediaQuery.of(context).size.width/3,
                                                                                        child: ListView.builder(
                                                                                          shrinkWrap: true,
                                                                                          scrollDirection: Axis.vertical,
                                                                                          itemCount: allBranch.length,
                                                                                          itemBuilder: (BuildContext context, int index) {
                                                                                            return GestureDetector(
                                                                                              onTap: (){
                                                                                                selectedBranch.value=allBranch[index];
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: new ListTile(
                                                                                                title: new Text(allBranch[index].toString()),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),),
                                                                                Container(
                                                                                    width: MediaQuery.of(context).size.width/3,
                                                                                    color: kItemContainer,
                                                                                    child:  Obx(()=> ListView.builder(
                                                                                      scrollDirection: Axis.vertical,
                                                                                      shrinkWrap: true,
                                                                                      itemCount: branchResult.length,
                                                                                      itemBuilder: (BuildContext context, int index) {
                                                                                        return GestureDetector(
                                                                                          onTap: (){
                                                                                            selectedBranch.value=branchResult[index];
                                                                                            branchResult.clear();
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child: new ListTile(
                                                                                            title: new Text(branchResult[index].toString()),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ))
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                  ),
                                                                ),
                                                          );
                                                        },
                                                        child:Obx(()=> Text(selectedBranch.value,style: TextStyle(
                                                          color: kFont1Color,
                                                          fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                        ),),
                                                        )),

                                                  Visibility(
                                                    visible: currentTerminal!='Call Center'?true:false,
                                                    child: ElevatedButton(
    style: ButtonStyle(
    side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
    elevation: MaterialStateProperty.all(3.0),
    backgroundColor: MaterialStateProperty.all(kGreenColor),
    ),
    onPressed: (){
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
    width:MediaQuery.of(context).size.width/2,
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
                    deliveryKotFlag=false;
                    cartComboList=[];
                    customerOrderUid='';
                    customerKotFlag=false;
                    customerUserUid='';
                    currentOrder='';
                    totalDiscountController.text='0';
                    cartController=[];
                    salesTotalList=[];
                    salesUomList=[];
                    cartListText=[];
                    modifierKotList=[];
                    customerName="";
                    customerOrderDeliveryBoy='';
                    salesTotal=0;
                    selectedCustomer='';
                    appbarCustomerController.clear();
                    //   if(selectedBusiness=='Restaurant')
                    //     selectedTableList.remove(_selectedTable);
              });
              isEstimate.value=false;
              tableSelected.value='TABLE';
              invEdit.value=false;
            }
            else{
              Navigator.pop(context);
              await checkOut(currentOrder,false,1,'${dualPaymentSelected1.value}', '${double.parse(dualPayment3.value.text).toStringAsFixed(decimals)}');
              setState(() {
                      deliveryKotFlag=false;
                      customerOrderUid='';
                      customerKotFlag=false;
                      customerUserUid='';
                      cartComboList=[];
                      currentOrder='';
                      totalDiscountController.text='0';
                      cartController=[];
                      salesTotalList=[];
                      modifierKotList=[];
                      salesUomList=[];
                      cartListText=[];
                      customerName="";
                      customerOrderDeliveryBoy='';
                      salesTotal=0;
                      selectedCustomer='';
                      appbarCustomerController.clear();
                      //   if(selectedBusiness=='Restaurant')
                      //     selectedTableList.remove(_selectedTable);
                    });
                    isEstimate.value=false;
                    tableSelected.value='TABLE';
                    invEdit.value=false;
                    Navigator.pop(context);
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
           // print('customerUserUid $customerUserUid');
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
                    deliveryKotFlag=false;
                    cartComboList=[];
                    customerOrderUid='';
                    customerKotFlag=false;
                    customerUserUid='';
                    currentOrder='';
                    totalDiscountController.text='0';
                    cartController=[];
                    salesTotalList=[];
                    modifierKotList=[];
                    salesUomList=[];
                    cartListText=[];
                    customerName="";
                    customerOrderDeliveryBoy='';
                    salesTotal=0;
                    selectedCustomer='';
                    appbarCustomerController.clear();
                    //   if(selectedBusiness=='Restaurant')
                    //     selectedTableList.remove(_selectedTable);
              });
              isEstimate.value=false;
              tableSelected.value='TABLE';
              invEdit.value=false;
    }
    else{
              Navigator.pop(context);
              await checkOut(currentOrder,true,1,'${dualPaymentSelected1.value}', '${double.parse(dualPayment3.value.text)}');
              setState(() {
          deliveryKotFlag=false;
          cartComboList=[];
          customerOrderUid='';
          customerKotFlag=false;
          customerUserUid='';
          currentOrder='';
          totalDiscountController.text='0';
          cartController=[];
          salesTotalList=[];
          salesUomList=[];
          modifierKotList=[];
          cartListText=[];
          customerName="";
          customerOrderDeliveryBoy='';
          salesTotal=0;
          selectedCustomer='';
          appbarCustomerController.clear();
          //   if(selectedBusiness=='Restaurant')
          //     selectedTableList.remove(_selectedTable);
        });
        isEstimate.value=false;
        tableSelected.value='TABLE';
        invEdit.value=false;

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
    },
    child:Text('Checkout',style: TextStyle(
    color: kFont1Color,
    fontSize: MediaQuery.of(context).textScaleFactor * 16,
    ),),),
                                                    replacement:  ElevatedButton(
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
                                                        else if(selectedBranch.value=='BRANCH'){
                                                          showDialog(
                                                            context:
                                                            context,
                                                            builder: (ctx) =>
                                                                AlertDialog(
                                                                  title: Text("Select a branch name"),
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
                                                        else if(allCustomerMobileController.text==''){
                                                          bool newValue=true;
                                                          allCustomerMobileNameController.text='';
                                                          allCustomerMobileAddressController.text='';
                                                          flatNoController.text='';
                                                          buildNoController.text='';
                                                          roadNoController.text='';
                                                          blockNoController.text='';
                                                          areaNoController.text='';
                                                          landmarkNoController.text='';
                                                          deliveryNoteController.text='';
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return StatefulBuilder(
                                                                    builder: (context,setState) {
                                                                      return Dialog(
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                                        child: Container(
                                                                          padding: EdgeInsets.all(6.0),
                                                                          // width: MediaQuery.of(context).size.width,
                                                                          // width: MediaQuery.of(context).size.width/3,
                                                                          //height: MediaQuery.of(context).size.height/2,
                                                                          child: SingleChildScrollView(
                                                                            scrollDirection: Axis.vertical,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width/3,
                                                                                  child: Column(
                                                                                    // scrollDirection: Axis.vertical,
                                                                                    // shrinkWrap: true,
                                                                                    children: [
                                                                                      Text(
                                                                                        'Customer details',
                                                                                        style: TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: MediaQuery.of(context).size.width/3,
                                                                                        //padding: const EdgeInsets.all(8.0),
                                                                                        child: StatefulBuilder(
                                                                                          builder: (context,setState){
                                                                                            return SimpleAutoCompleteTextField(
                                                                                              style: TextStyle(
                                                                                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                                              ),
                                                                                              decoration:InputDecoration(
                                                                                                suffixIcon: Icon(Icons.search,color: Colors.black),
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
                                                                                                labelText: 'enter mobile number',
                                                                                                labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                              ),
                                                                                              controller: allCustomerMobileController,
                                                                                              keyboardType:
                                                                                              TextInputType.number,
                                                                                              suggestions: allCustomerMobile,
                                                                                              clearOnSubmit: false,
                                                                                              textSubmitted: (text) async {
                                                                                                if(allCustomerMobile.contains(text)) {
                                                                                                  QuerySnapshot variable=await  firebaseFirestore.collection('customer_details').where('mobile',isEqualTo: text).get();

                                                                                                  setState(() {
                                                                                                    newValue=false;
                                                                                                    customerUserUid=variable.docs[0].id;
                                                                                                    allCustomerMobileController.text=text;
                                                                                                    allCustomerMobileNameController.text=customerList[allCustomerMobile.indexOf(text)];
                                                                                                    allCustomerMobileAddressController.text=allCustomerAddress[allCustomerMobile.indexOf(text)];
                                                                                                    flatNoController.text=variable.docs[0].get('flatNo');
                                                                                                    buildNoController.text=variable.docs[0].get('buildNo');
                                                                                                    roadNoController.text=variable.docs[0].get('roadNo');
                                                                                                    blockNoController.text=variable.docs[0].get('blockNo');
                                                                                                    areaNoController.text=variable.docs[0].get('area');
                                                                                                    landmarkNoController.text=variable.docs[0].get('landmark');
                                                                                                    deliveryNoteController.text=variable.docs[0].get('note');
                                                                                                  });
                                                                                                  print('inside allCustomerMobile $text');
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                }
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: 20.0,),
                                                                                      TextField(
                                                                                        controller: allCustomerMobileNameController,
                                                                                        onChanged: (value) {
                                                                                        },
                                                                                        keyboardType:
                                                                                        TextInputType.name,
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
                                                                                          labelText: 'Name',
                                                                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: 20.0,),
                                                                                      TextField(
                                                                                        controller: allCustomerMobileAddressController,
                                                                                        onChanged: (value) {
                                                                                        },
                                                                                        keyboardType:
                                                                                        TextInputType.name,
                                                                                        maxLines: 3,
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
                                                                                          labelText: 'Address',
                                                                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: 20.0,),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: TextField(
                                                                                              controller: flatNoController,
                                                                                              onChanged: (value) {
                                                                                              },
                                                                                              keyboardType:
                                                                                              TextInputType.name,
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
                                                                                                labelText: 'Flat NO',
                                                                                                labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(width: 10.0,),
                                                                                          Expanded(
                                                                                            child: TextField(
                                                                                              controller: buildNoController,
                                                                                              onChanged: (value) {
                                                                                              },
                                                                                              keyboardType:
                                                                                              TextInputType.name,
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
                                                                                                labelText: 'BLD NO',
                                                                                                labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 20.0,),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: TextField(
                                                                                              controller: roadNoController,
                                                                                              onChanged: (value) {
                                                                                              },
                                                                                              keyboardType:
                                                                                              TextInputType.name,
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
                                                                                                labelText: 'ROAD NO',
                                                                                                labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(width: 10.0,),
                                                                                          Expanded(
                                                                                            child: TextField(
                                                                                              controller: blockNoController,
                                                                                              onChanged: (value) {
                                                                                              },
                                                                                              keyboardType:
                                                                                              TextInputType.name,
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
                                                                                                labelText: 'BLOCK NO',
                                                                                                labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 20.0,),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width/3,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      TextField(
                                                                                        controller: areaNoController,
                                                                                        onChanged: (value) {
                                                                                        },
                                                                                        keyboardType:
                                                                                        TextInputType.name,
                                                                                        maxLines: 3,
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
                                                                                          labelText: 'Area',
                                                                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: 20.0,),
                                                                                      TextField(
                                                                                        controller: landmarkNoController,
                                                                                        onChanged: (value) {
                                                                                        },
                                                                                        keyboardType:
                                                                                        TextInputType.name,
                                                                                        maxLines: 3,
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
                                                                                          labelText: 'Land mark',
                                                                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: 20.0,),
                                                                                      TextField(
                                                                                        controller: deliveryNoteController,
                                                                                        onChanged: (value) {
                                                                                        },
                                                                                        keyboardType:
                                                                                        TextInputType.name,
                                                                                        maxLines: 3,
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
                                                                                          labelText: 'Note',
                                                                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                                                                        ),
                                                                                      ),
                                                                                      RawMaterialButton(
                                                                                        onPressed: () async {
                                                                                          if(newValue==false){
                                                                                            appbarCustomerController.text=selectedCustomer=allCustomerMobileNameController.text;
                                                                                            Navigator.pushNamed(context, PosScreen.id);
                                                                                          }
                                                                                          else{
                                                                                            String inside='not';
                                                                                            for(int i=0;i<customerList.length;i++){
                                                                                              if(customerList[i].toLowerCase() == allCustomerMobileNameController.text.toLowerCase()){
                                                                                                inside='contains';
                                                                                                showDialog(
                                                                                                    context: context,
                                                                                                    builder: (context) => AlertDialog(
                                                                                                      title: Text("Error"),
                                                                                                      content: Text("Customer name Exists"),
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
                                                                                            }
                                                                                            if(inside == 'not'){
                                                                                              String body='${allCustomerMobileNameController.text}~${allCustomerMobileAddressController.text}~${allCustomerMobileController.text}~~~~${flatNoController.text}~${buildNoController.text}~${roadNoController.text}~${blockNoController.text}~${areaNoController.text}~${landmarkNoController.text}~${deliveryNoteController.text}';
                                                                                              await create(body, 'customer_details',[]);
                                                                                              await  read('customer_details');
                                                                                              appbarCustomerController.text=selectedCustomer=allCustomerMobileNameController.text;
                                                                                              QuerySnapshot variable=await  firebaseFirestore.collection('customer_details').where('mobile',isEqualTo: allCustomerMobileController.text).get();
                                                                                              setState(() {
                                                                                                customerUserUid=variable.docs[0].id;
                                                                                              });
                                                                                              Navigator.pushNamed(context, PosScreen.id);
                                                                                            }
                                                                                          }
                                                                                        },
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
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                );
                                                              });
                                                        }
                                                        else{
                                                          String process='yes';
                                                          String edit='no';
                                                          if(customerOrderUid.length>0){
                                                            if(listEquals(customerOrdersList,cartListText)){
                                                             print('list equallsssss');
                                                              process='no';
                                                              firebaseFirestore.collection('customer_orders').doc(customerOrderUid).update({
                                                                "branch":selectedBranch.value,
                                                              });
                                                            }
                                                            else{
                                                              print('list not equallll');
                                                              process='yes';
                                                              edit='yes';
                                                            }
                                                          }
                                                           if(process=='yes'){
                                                            List yourItemsList=[];
                                                            String tempModifier='';
                                                            String tempComboKot='';
                                                              for(int i=0;i<cartListText.length;i++){
                                                                tempModifier='';
                                                                tempComboKot='';
                                                                List temp=cartListText[i].split(':');
                                                                if(temp.length>4){
                                                                  tempModifier=temp[4];
                                                                }
                                                                if(cartComboList.length>0){
                                                                  for(int m=0;m<cartComboList.length;m++){
                                                                    List temp123=cartComboList[m].toString().split(';');
                                                                    if(temp123[0].toString().trim()==temp[0].toString().trim()) {
                                                                      tempComboKot+=temp123[1].toString().trim();
                                                                      tempComboKot+='~';
                                                                    }
                                                                  }
                                                                  tempComboKot=tempComboKot.length>0?tempComboKot.substring(0,tempComboKot.length-1):'';
                                                                }
                                                                yourItemsList.add({
                                                                  "name":temp[0].toString().trim(),
                                                                  "uom":temp[1].toString().trim(),
                                                                  "qty":temp[3].toString().trim(),
                                                                  "price":double.parse(temp[2].toString().trim()),
                                                                  "image":'',
                                                                  "modifier":tempModifier,
                                                                  "ready":false,
                                                                  "combo":tempComboKot
                                                                });
                                                              }
                                                              if(edit=='no'){
                                                                await  firebaseFirestore.collection('customer_orders').doc().set({
                                                                  "uid":customerUserUid,
                                                                  "name":allCustomerMobileNameController.text,
                                                                  "mobile":allCustomerMobileController.text,
                                                                  "address":allCustomerMobileAddressController.text,
                                                                  "order":yourItemsList,
                                                                  "date":DateTime.now().millisecondsSinceEpoch,
                                                                  "status":'placed',
                                                                  "kot":false,
                                                                  "checkOut":false,
                                                                  "deliveryBoy":'',
                                                                  "branch":selectedBranch.value,
                                                                });
                                                              }
                                                              else{
                                                                await  firebaseFirestore.collection('customer_orders').doc(customerOrderUid).update({
                                                                  "order":yourItemsList,
                                                                  "kot":false,
                                                                  "checkOut":false,
                                                                  "branch":selectedBranch.value,
                                                                });
                                                              }
                                                            }

                                                          setState(() {
                                                            selectedCustomer='';
                                                            appbarCustomerController.clear();
                                                            cartListText=[];
                                                            totalDiscountController.text='0';
                                                            currentOrder='';
                                                            customerOrderUid='';
                                                            customerUserUid='';
                                                            cartController=[];
                                                            salesUomList=[];
                                                            salesTotalList=[];
                                                            salesTotal=0;
                                                            tableSelected.value='TABLE';
                                                            checkoutFlag=true;
                                                            kotFailedList=[];
                                                            deliveryKotFlag=false;
                                                            customerKotFlag=false;
                                                          });
                                                          selectedBranch.value='BRANCH';
                                                          invEdit.value=false;
                                                        }

                                                      },
                                                      child: Text("Assign",style: TextStyle(
                                                        color: kFont1Color,
                                                        fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                                      ),
                                                      ),
                                                    ),
                                                  ),
    //                                               Visibility(
    // visible: currentTerminal!='Call Center'?true:false,
    // child: Row(
    // children: [
    // ElevatedButton(
    // style: ButtonStyle(
    // side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
    // elevation: MaterialStateProperty.all(3.0),
    // backgroundColor: MaterialStateProperty.all(checkoutFlag==true?kGreenColor:kHighlight.withOpacity(0.4),),
    // ),
    // onPressed: ()async{
    // // printerManager.selectPrinter(selectedPrinter);
    // if(checkoutFlag==true){
    // if(selectedPayment=='Credit' && selectedCustomer.isEmpty){
    // showDialog(
    // context: context,
    // builder: (context) => AlertDialog(
    // title: Text("Error"),
    // content: Text("Select a Customer name"),
    // actions: <Widget>[
    // // usually buttons at the bottom of the dialog
    // new TextButton(
    // child: new Text("Close"),
    // onPressed: () {
    // Navigator.of(context).pop();
    // },
    // ),
    // ],
    // )
    // );
    // }
    // else{
    // await checkOut(currentOrder,false);
    // setState(() {
    // deliveryKotFlag=false;
    // customerOrderUid='';
    // customerKotFlag=false;
    // customerUserUid='';
    // currentOrder='';
    // totalDiscountController.text='0';
    // cartController=[];
    // salesTotalList=[];
    // salesUomList=[];
    // cartListText=[];
    // customerName="";
    // customerOrderDeliveryBoy='';
    // salesTotal=0;
    // selectedCustomer='';
    // appbarCustomerController.clear();
    // //   if(selectedBusiness=='Restaurant')
    // //     selectedTableList.remove(_selectedTable);
    // });
    // isEstimate.value=false;
    // tableSelected.value='TABLE';
    // invEdit.value=false;
    // }
    // }
    // },
    // child: Text("Save",style: TextStyle(
    // color: kFont1Color,
    // fontSize: MediaQuery.of(context).textScaleFactor * 16,
    // ),
    // ),
    // ),
    // ElevatedButton(
    // style: ButtonStyle(
    // side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
    // elevation: MaterialStateProperty.all(3.0),
    // backgroundColor: MaterialStateProperty.all(checkoutFlag==true?kGreenColor:kHighlight.withOpacity(0.4),),
    // ),
    // onPressed: ()async{
    //
    // if(checkoutFlag==true){
    // if(selectedPayment=='Credit' && selectedCustomer.isEmpty){
    // showDialog(
    // context: context,
    // builder: (context) => AlertDialog(
    // title: Text("Error"),
    // content: Text("Select a Customer name"),
    // actions: <Widget>[
    // // usually buttons at the bottom of the dialog
    // new TextButton(
    // child: new Text("Close"),
    // onPressed: () {
    // Navigator.of(context).pop();
    // },
    // ),
    // ],
    // )
    // );
    // }
    // else{
    // await checkOut(currentOrder,true);
    // setState(() {
    // deliveryKotFlag=false;
    // customerOrderUid='';
    // customerKotFlag=false;
    // customerUserUid='';
    // currentOrder='';
    // totalDiscountController.text='0';
    // cartController=[];
    // salesTotalList=[];
    // salesUomList=[];
    // cartListText=[];
    // customerName="";
    // customerOrderDeliveryBoy='';
    // salesTotal=0;
    // selectedCustomer='';
    // appbarCustomerController.clear();
    // //   if(selectedBusiness=='Restaurant')
    // //     selectedTableList.remove(_selectedTable);
    // });
    // isEstimate.value=false;
    // tableSelected.value='TABLE';
    // invEdit.value=false;
    // }
    // }
    // },
    // child: Text("Print",style: TextStyle(
    // color: kFont1Color,
    // fontSize: MediaQuery.of(context).textScaleFactor * 16,
    // ),
    // ),
    // ),
    // ],
    // ),
    // replacement:  ElevatedButton(
    // style: ButtonStyle(
    // side: MaterialStateProperty.all(BorderSide(width: 2.0, color: kFont3Color,)),
    // elevation: MaterialStateProperty.all(3.0),
    // backgroundColor: MaterialStateProperty.all(kGreenColor),
    // ),
    // onPressed: () async {
    // if(cartListText.isEmpty){
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add Items')));
    // return;
    // }
    // else if(selectedBranch.value=='BRANCH'){
    // showDialog(
    // context:
    // context,
    // builder: (ctx) =>
    // AlertDialog(
    // title: Text("Select a branch name"),
    // actions: <Widget>[
    // TextButton(
    // onPressed: () {
    // Navigator.of(ctx).pop();
    // },
    // child: Text("OK"),
    // ),
    // ],
    // ),
    // );
    // return;
    // }
    // else{
    // print('customerOrderUid $customerOrderUid');
    // if(customerOrderUid.length>0){
    // firebaseFirestore.collection('customer_orders').doc(customerOrderUid).update({
    // "branch":selectedBranch.value,
    // });
    // }
    // else{
    // List yourItemsList=[];
    // if(allCustomerMobileController.text==''){
    // showDialog(
    // context:
    // context,
    // builder: (ctx) =>
    // AlertDialog(
    // title: Text("customer not selected"),
    // actions: <Widget>[
    // TextButton(
    // onPressed: () {
    // Navigator.of(ctx).pop();
    // },
    // child: Text("OK"),
    // ),
    // ],
    // ),
    // );
    // }
    // else {
    // kotList=[];
    // for(int i=0;i<cartListText.length;i++){
    // List temp=cartListText[i].split(':');
    // yourItemsList.add({
    // "name":temp[0].toString().trim(),
    // "uom":temp[1].toString().trim(),
    // "qty":temp[3].toString().trim(),
    // "price":double.parse(temp[2].toString().trim()),
    // "image":'',
    // "ready":false
    // });
    // kotList.add('${temp[0]}:${temp[3]}:');
    // }
    // print('reached hereee111');
    // await  firebaseFirestore.collection('customer_orders').doc().set({
    // "uid":customerUserUid,
    // "name":allCustomerMobileNameController.text,
    // "mobile":allCustomerMobileController.text,
    // "address":allCustomerMobileAddressController.text,
    // "order":FieldValue.arrayUnion(yourItemsList),
    // "date":dateNow(),
    // "status":'placed',
    // "kot":false,
    // "checkOut":false,
    // "deliveryBoy":'',
    // "branch":selectedBranch.value,
    // });
    // }
    // }
    // setState(() {
    // selectedCustomer='';
    // appbarCustomerController.clear();
    // cartListText=[];
    // totalDiscountController.text='0';
    // currentOrder='';
    // customerOrderUid='';
    // customerUserUid='';
    // cartController=[];
    // salesUomList=[];
    // salesTotalList=[];
    // salesTotal=0;
    // tableSelected.value='TABLE';
    // checkoutFlag=true;
    // kotFailedList=[];
    // deliveryKotFlag=false;
    // customerKotFlag=false;
    // });
    // selectedBranch.value='BRANCH';
    // invEdit.value=false;
    // }
    //
    // },
    // child: Text("Assign",style: TextStyle(
    // color: kFont1Color,
    // fontSize: MediaQuery.of(context).textScaleFactor * 16,
    // ),
    // ),
    // ),
    // ) ,
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
                return Column(
                  children: [
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
                                          crossAxisCount: 5,
                                          childAspectRatio:
                                          MediaQuery.of(context).size.width /
                                              (MediaQuery.of(context).size.height ),
                                        ),
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot3.data.docs.length,
                                        itemBuilder: (context, index8) {
                                          // tableIndex++;
                                          String ordersLen=snapshot3.data.docs[index8]['orders'];
                                          bool merge=snapshot3.data.docs[index8]['merged'];
                                          // tableMergeSelect.value.add(false);
                                          return   Padding(
                                            padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
                                            child:   GestureDetector(
                                              onTap: (){
                                                if(isMerge.value==true ){
                                                  if( ordersLen.length==0){
                                                    tableMergeSelect.value.add(snapshot3.data.docs[index8]['tableName']);
                                                    firebaseFirestore.collection('table_data').doc(snapshot3.data.docs[index8]['tableName']).update(
                                                        {
                                                          "merged":true,
                                                        }
                                                    );
                                                  }
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
                                         isMerge.value=true;
                                         tableMergeSelect.value.add(snapshot3.data.docs[index8]['tableName']);
                                         firebaseFirestore.collection('table_data').doc(snapshot3.data.docs[index8]['tableName']).update(
                                             {
                                               "merged":true,
                                             }
                                         );
                                       }
                                                }
                                                else{
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
  String temp='';
  for(int i=0;i<tableMergeSelect.value.length;i++){
   temp+='${tableMergeSelect.value[i]}';
   if(i!=tableMergeSelect.value.length-1)
     temp+='~';
  }
  tableSelected.value=temp;
  Navigator.pop(context);
}
else{
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
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
  Future networkKotPrint(String invNo,String table,String tempCategory,List tempPrintList)async{
    print('inside network tempCategory $tempCategory');
    print('inside network tempPrintList $tempPrintList');

    String temp='no';
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    String tempIpAddress=getKotIpAddressPrinter(tempCategory);
    NetworkPrinter printer=NetworkPrinter(paper, profile);
    try{
      final PosPrintResult res = await printer.connect(tempIpAddress.trim(), port: 9100,timeout: Duration(seconds: 5));
      if (res == PosPrintResult.success) {
        temp='yes';
        // if(kotPrint=='no')
        //  { kotPrint='yes';}

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
        printer.emptyLines(3);
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
      // else {
      //   kotPrint='no';
      //      print('no connection');
      //
      //  }
    }
    catch(e){
    }

  }
  Future<Uint8List> pdfKotPrint(String invNo,String table,String tempCategory,List tempPrintList)async{
    final pdf = pw.Document(version: PdfVersion.pdf_1_5,);
    final font = await PdfGoogleFonts.nunitoRegular();
    final rows = <pw.TableRow>[];
    final rows1 = <pw.TableRow>[];
    rows.add(pw.TableRow(
        children: [
          pw.SizedBox(
              width:150,
              child:pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child: pw.Text('Item',textScaleFactor: 0.6,style:pw.TextStyle(
                        fontWeight: pw.FontWeight.bold
                    )),
              )),
          pw.Padding(
                  padding:pw.EdgeInsets.all(3.0),
                  child: pw.Text('Qty',textScaleFactor: 0.6,style:pw.TextStyle(
                        fontWeight: pw.FontWeight.bold
                    )),
              )
        ]
    ));
    for(int i=0;i<tempPrintList.length;i++)
    {
      List cartItemsString=tempPrintList[i].split(':');
      String temp=cartItemsString[2].toString().replaceAll(' ', '');
      rows1.add(pw.TableRow(
        children:[
          pw.SizedBox(
            width:150,
            child:pw.Padding(
              padding:pw.EdgeInsets.all(3.0),
              child:temp.length>0? pw.Text('''${cartItemsString[2].length>0?'${cartItemsString[0]} \n ${cartItemsString[2]}':'${cartItemsString[0]}'}''',textScaleFactor: 0.6,style:pw.TextStyle(
                  fontWeight: pw.FontWeight.bold
              )): pw.Text(cartItemsString[0],textScaleFactor: 0.6,style:pw.TextStyle(
                  fontWeight: pw.FontWeight.bold
              ))),),

          pw.Padding(
            padding:pw.EdgeInsets.all(3.0),
            child: pw.Text(cartItemsString[1],textScaleFactor: 0.6,style:pw.TextStyle(
                fontWeight: pw.FontWeight.bold
            )),
          )
        ]
      ));
    }
    top(){
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children:[
          pw.Text('KOT',textScaleFactor: 1.0,style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
          )),
          pw.Text('User : $currentUser',textScaleFactor: 0.8,style: pw.TextStyle(
            // fontWeight: pw.FontWeight.bold,
          )),
          pw.Text('Section : $tempCategory',textScaleFactor: 0.8,style: pw.TextStyle(
            // fontWeight: pw.FontWeight.bold,
          )),
          if(selectedDelivery=='Spot')
            pw.Text(table.contains('~')?table.replaceAll('~', ','):table,textScaleFactor:0.8,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold,
            )),
          if(selectedDelivery=='Take Away')
            pw.Text('TAKEAWAY',textScaleFactor: 0.8,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold,
            )),
          pw.Text('Order No: $invNo',textScaleFactor: 0.8,style: pw.TextStyle(
            // fontWeight: pw.FontWeight.bold,
          )),
          pw.Text(dateNow(),textScaleFactor: 0.8,style: pw.TextStyle(
            // fontWeight: pw.FontWeight.bold,
          )),
          pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              border: pw.TableBorder(top: pw.BorderSide(color: PdfColors.black, width: 0.5), bottom: pw.BorderSide(color: PdfColors.black, width: 0.5)),
              // textDirection: pw.TextDirection.ltr,
              // border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
              children: rows),
          pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              border: pw.TableBorder( bottom: pw.BorderSide(color: PdfColors.black, width: 0.5)),
              // textDirection: pw.TextDirection.ltr,
              // border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
              children: rows1),
        ]
      );
    }
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => top(),
        pageFormat: PdfPageFormat.roll80,
      ),
    );
    List<int> bytes = await pdf.save();
    String tempIpAddress=getKotIpAddressPrinter(tempCategory);
    // html.AnchorElement(
    //     href:
    //     "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    //   ..setAttribute("download", "$tempIpAddress#${dateNow()}.pdf")
    //   ..click();
  }
  Future  formatKotList(String invNo,String table)async{
    String tempValue,tempText;
    List temp = kotList[0].split(':');
    print('inside format kott $temp');
    if(temp.length<5){
      for(int k=0;k<kotList.length;k++) {
        List temp = kotList[k].split(':');
        tempValue = getKotPrinterName(getCategory(temp[0].toString().trim()));
        tempText = temp.toString().replaceAll(',', ':');
        tempText=tempText.substring(1,tempText.length-1);
        tempText += ':$tempValue';
        kotList[k] = tempText;
      }
    }
    int i=0;
    while(i<kotList.length){
      String tempCategory;
      List<int> pos=[];
      List<String> tempPrintList=[];
      List temp=kotList[i].toString().split(':');
      print('temp beofre kot print hAJ $temp');

      tempCategory=temp[4].toString().trim();
      pos.add(i);
      tempPrintList.add(kotList[i]);
      print("......................");
      print(i);
      for(int j=i+1;j<kotList.length;j++){
        print("kkk"+kotList[j].toString());
        List tempSplit=kotList[j].toString().split(':');
        if(tempSplit[4].toString().trim()==tempCategory)
        {
          pos.add(j);
          tempPrintList.add(kotList[j]);
        }
      }
      String type=allPrinterType[allPrinter.indexOf(tempCategory)];
      if(currentPrinter=='PDF Thermal'){
        String tempIpAddress=getKotIpAddressPrinter(tempCategory);
        String line4='';
        if(selectedDelivery=='Spot'){
          line4='    Dine In \n';
          line4+='   \t ${table.contains('~')?table.replaceAll('~', ','):table}';
        }
        else
          line4='    $selectedDelivery';
        String text = '\t      KOT\n\t  User : $currentUser\n      Section : $tempCategory\n\t$line4\n\t Order No: $invNo\n\t${dateNow()}\n------------------------------\nItems\n------------------------------\n';
        for(int k=0;k<tempPrintList.length;k++){
  List cartItemsString=tempPrintList[k].split(':');
  String temp=cartItemsString[2].toString().replaceAll(' ', '');
  String txt='';
  String itemNameSplit=cartItemsString[0].toString();
  if(itemNameSplit.contains('#')){
    itemNameSplit=itemNameSplit.substring(0,itemNameSplit.indexOf('#'));
  }
  txt+='$itemNameSplit[${cartItemsString[3].toString().trim()}]*${cartItemsString[1].toString().trim()}';
  // int pos=itemNameSplit.length;
  // pos=26-pos;
  // for(int j=0;j<pos;j++){
  //   txt+=' ';
  // }
  // int pos1=cartItemsString[1].toString().length;
  // pos1=2-pos1;
  // for(int j=0;j<pos1;j++){
  //   txt+=' ';
  // }
  // txt+='\t';
  // txt+=cartItemsString[3];
  // txt+='\t';
  // txt+=cartItemsString[1];
  txt+='\n';
  text+=txt;
if(temp.length>0) {
  if(modifierKotList.length>0){
    String contains='no';
    for(int w=0;w<modifierKotList.length;w++){
     List temp3344=modifierKotList[w].split(';');
     if(temp3344[0].toString().trim()==cartItemsString[0].toString().trim()){
       contains='yes';
       String tempModifier='';
       List tempModifier1=temp3344[1].toString().split('/');
       tempModifier1.removeLast();
         List temp1=temp.split('/');
       temp1.removeLast();
       String temp2=temp3344[1].toString().trim();
         if(!identical(temp,temp2)){
          for(int j=0;j<tempModifier1.length;j++){
            if(!identical(tempModifier1[j].toString().trim(),temp1[j].toString().trim())){
              List temp3=tempModifier1[j].toString().split('*');
              List temp4=temp1[j].toString().split('*');
              int qty1=int.parse(temp3[1].toString().trim());
              int qty2=int.parse(temp4[1].toString().trim());
              int qty3=qty2-qty1;
              tempModifier +='${temp4[0].toString().trim()}*$qty3/';
            }
          }
          if(tempModifier1.length!=temp1.length){
            int pos1=tempModifier1.length;
            int pos2=temp1.length;
            for(int p=pos1;p<pos2;p++)
              tempModifier+='${temp1[p].toString().trim()}/';
          }
          text += tempModifier;
          text+='\n';
         }
     }
    }
    if(contains=='no'){
      text += temp;
      text+='\n';
    }
  }
  else{
    text += temp;
    text+='\n';
  }
}
if(cartComboList.length>0){
  for(int m=0;m<cartComboList.length;m++){
    List temp123=cartComboList[m].toString().split(';');
    if(temp123[2].toString().trim()=='false'){
      if(temp123[0].toString().trim()==cartItemsString[0].toString().trim()) {
        cartComboList[m]='${temp123[0].toString().trim()};${temp123[1].toString().trim()};true';
        List temp223=temp123[1].toString().split('~');
        String txt223='';
        for(int n=0;n<temp223.length;n++){
          txt223+='*';
          List temp443=temp223[n].toString().split(':');
          txt223+=temp443[0].toString().trim();
          int pos223=temp443[0].length;
          pos223=26-pos223;
          // for(int jn=0;jn<pos223;jn++){
          //   txt223+=' ';
          // }
          int pos1223=temp443[1].toString().length;
          pos1223=2-pos1223;
          // for(int jn=0;jn<pos1223;jn++){
          //   txt223+=' ';
          // }
          txt223+='\t';
          txt223+=temp443[1];
          txt223+='\t';
          txt223+=temp443[2];
          txt223+='\n';
        }
        text+=txt223;
      }
    }
  }
}
}
// prepare
        final bytes99= utf8.encode(text);
        // final blob = html.Blob([bytes99]);
        // final url = html.Url.createObjectUrlFromBlob(blob);
        // final anchor = html.document.createElement('a') as html.AnchorElement
        //   ..href = url
        //   ..style.display = 'none'
        //   ..download = '$tempIpAddress#${dateNow()}.txt';
        // html.document.body.children.add(anchor);

// download
//         anchor.click();

// cleanup
//         html.document.body.children.remove(anchor);
//         html.Url.revokeObjectUrl(url);
        // pdfKotPrint(invNo, table, tempCategory, tempPrintList);
      }
      else if(type=='Network'){
        await  networkKotPrint(invNo, table, tempCategory, tempPrintList);
      }
      else if(type=='Bluetooth'){
        final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
        if(connectionStatus==false){
          final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: allPrinterIp[allPrinter.indexOf(tempCategory)]);
          const ep.PaperSize paper = ep.PaperSize.mm58;
          final profile = await ep.CapabilityProfile.load();
          List<int> ticket = await bluetoothKot(paper,profile,invNo,table,tempPrintList,tempCategory);
          final result1 = await PrintBluetoothThermal.writeBytes(ticket);
        }
        else{
          const ep.PaperSize paper = ep.PaperSize.mm58;
          final profile = await ep.CapabilityProfile.load();
          List<int> ticket = await bluetoothKot(paper,profile,invNo,table,tempPrintList,tempCategory);
          final result = await PrintBluetoothThermal.writeBytes(ticket);

          print("print result: $result");
        }
      }
      if(kotPrint=='yes'){
        for(int k=pos.length-1;k>=0;k--){
          print(kotList);
          kotList.removeAt(pos[k]);
        }
        i=0;
      }

    }


  }
  Future kotAssign(List items,String orderNumber)async{
    print('orderNumber $orderNumber');
    kotList=[];
    int ex = 0;double tempQuantity=0;
    if(orderNumber.length>0){
      DocumentSnapshot documentSnapshot;
      List temp111=[];
      // documentSnapshot=await firebaseFirestore.collection('kot_order').doc('$currentOrder').get();
      // temp111=currentKotOldList;
      List oldItemsList=currentKotOldList;
      firebaseFirestore.collection('kot_order').doc('$currentOrder').delete();
      // for(int i=0;i<temp111.length;i++){
      //   oldItemsList.add(
      //       '${documentSnapshot['cartList'][i]['name']}:${documentSnapshot['cartList'][i]['uom']}:${documentSnapshot['cartList'][i]['price']}:${documentSnapshot['cartList'][i]['qty']}');
      // }

      // await firebaseFirestore.collection('kot_order').doc('$currentOrder').update({
      //   'cartList': FieldValue.arrayRemove(currentKotOldList11),
      // }).then((_) {
      //   print('old items removed');
      // });

      for(int i=0;i<items.length;i++)
      {
        String description;
        List tempCartListText=items[i].split(':');
        if(tempCartListText.length==5) {
          description = tempCartListText[4];
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
            if(double.parse(tempCartListText[3])!=double.parse(tempOldItemsList[3])) {
              tempQuantity = double.parse(tempCartListText[3]) -
                  double.parse(tempOldItemsList[3]);
              String tempKotItemAdded='${tempCartListText[0]}:$tempQuantity:$description:${tempCartListText[1]}';
              print("Adding  11306");

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
          String tempKotItemAdded='${tempCartListText[0]}:$tempQuantity:$description:${tempCartListText[1]}';
          print("Adding  11320");

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
        String tempKotItemAdded='${tempOldItemsList[0]}:-${tempOldItemsList[3]}::${tempOldItemsList[1]}';
        print("Adding  11334");
        kotList.add(tempKotItemAdded);
      }
      await  kotOrders(tableSelected.value,true);
      if(selectedBusiness=='Restaurant'){
        print("format KOT  11346");
        await formatKotList(currentOrder,tableSelected.value);
      }
      return;
    }
    else{
      kotOrders(tableSelected.value,false);
      for(int i=0;i<items.length;i++){
        String description;
        List tempList=items[i].split(':');
        if(tempList.length==5)
          description=tempList[4];
        else
          description='';
        String tempItemContent='${tempList[0]}:${tempList[3]}:$description:${tempList[1]}';

        print("Adding  11348");
        print("tempItemContent $tempItemContent");
        kotList.add(tempItemContent);
      }
      int invNo;
      invNo=await getLastInv('kot');
      currentOrder='${getPrefix()}$invNo';
      if(selectedBusiness=='Restaurant'){
        print("format KOT  11368");
        await formatKotList(currentOrder,tableSelected.value);
      }
      return;
    }
  }
  Future kotItems(List items,String orderNumber)async{
// if(kotPrint=='no'){
//   print('inside kot print no $kotList');
//  await formatKotList(orderNumber, '$_selectedTable');
//   return;
// }
    kotList=[];
    int ex = 0;double tempQuantity=0;
    if(orderNumber.length>0)
    {
      for(int i=0;i<savedOrders.length;i++){
      List temp=savedOrders[i].split(',');
      if(temp[0].toString().trim().contains(orderNumber)){
        List selectedOrderItems=savedOrders[i].split(',');
        String tempKot=selectedOrderItems[6].toString().trim();
        List oldItemsList=tempKot.split('-');
        oldItemsList.removeAt(oldItemsList.length-1);
        for(int i=0;i<items.length;i++)
        {
          String description;
          List tempCartListText=items[i].split(':');
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
              if(double.parse(tempCartListText[3])!=double.parse(tempOldItemsList[3])) {
                tempQuantity = double.parse(tempCartListText[3]) -
                    double.parse(tempOldItemsList[3]);
                String tempKotItemAdded='${tempCartListText[0]}:$tempQuantity:$description';
                print("Adding  11404");
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
            print("Adding  11417");
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
          print("Adding  11431");
          kotList.add(tempKotItemAdded);
        }
        await  kotOrders(tableSelected.value,true);
        print("format KOT  11444");
        await formatKotList(currentOrder,_selectedTable.toString());
        return;
        //allOrders(salesOrderNo,_selectedTable);
      }
    }}
    else{
      kotOrders(tableSelected.value,false);
      for(int i=0;i<items.length;i++){
        String description;
        List tempList=items[i].split(':');
        if(tempList.length==7)
          description=tempList[6];
        else
          description='';
        String tempItemContent='${tempList[0]}:${tempList[3]}:$description';
        print("Adding  11442");
        kotList.add(tempItemContent);
      }
      // int orderNo=await getSavedOrderInvoiceNo();
      // currentOrder='${getPrefix()}$orderNo';
      print('end of kot function');
      print("format KOT  11466");
      await formatKotList(currentOrder,_selectedTable.toString());
      return;
    }

  }
  Container tableView(BuildContext context) {
    return Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width/1.5,
      height: MediaQuery.of(context).size.height/1.5,
      child: GridView.builder(
        // physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: 25,
          itemBuilder: (context, index) {
            final _isSelected=selectedTableList.contains(index+1);
            return RawMaterialButton(
              onPressed: (){
                setState(() {
                  _selectedTable=index+1;
                });
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width/10,
                height:MediaQuery.of(context).size.height/8,
                decoration: BoxDecoration(
                  color: _isSelected?kHighlight:kGreenColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(10.0),
                child: AutoSizeText(
                  'Table \n ${index+1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaleFactor*22,
                    color: kItemContainer,
                  ),
                ),
              ),
            );
          }),
    );
  }

  ScrollController _scrollController = ScrollController();
  String getItem(int index,int itemNo){
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
          ),Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'QSR',
              style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*15,),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Delivery',
              style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*15,
              ),
            ),
          ),
        ],
        onPressed: (int index) {
          selectedMode=index+1;
          setState(() {
            selectedDelivery=deliveryMode[index];
            // cartListText=[];
            totalDiscountController.text='0';
            currentOrder='';
            customerUserUid='';
            // cartController=[];
            // salesUomList=[];
            // salesTotalList=[];
            // salesTotal=0;
            allCustomerMobileController.text='';
            for (int i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index;
            }

          });
          if(selectedDelivery=='Delivery'){
            bool newValue=true;
            allCustomerMobileNameController.text='';
            allCustomerMobileAddressController.text='';
            flatNoController.text='';
            buildNoController.text='';
            roadNoController.text='';
            blockNoController.text='';
            areaNoController.text='';
            landmarkNoController.text='';
            deliveryNoteController.text='';
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context,setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                         // width: MediaQuery.of(context).size.width,
                         // width: MediaQuery.of(context).size.width/3,
                          //height: MediaQuery.of(context).size.height/2,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width/3,
                                  child: Column(
                                    // scrollDirection: Axis.vertical,
                                    // shrinkWrap: true,
                                    children: [
                                      Text(
                                        'Customer details',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width/3,
                                        //padding: const EdgeInsets.all(8.0),
                                        child: StatefulBuilder(
                                          builder: (context,setState){
                                            return SimpleAutoCompleteTextField(
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                              ),
                                              decoration:InputDecoration(
                                                suffixIcon: Icon(Icons.search,color: Colors.black),
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
                                                labelText: 'enter mobile number',
                                                labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                              ),
                                              controller: allCustomerMobileController,
                                              keyboardType:
                                              TextInputType.number,
                                              suggestions: allCustomerMobile,
                                              clearOnSubmit: false,
                                              textSubmitted: (text) async {
                                                if(allCustomerMobile.contains(text)) {
                                                  QuerySnapshot variable=await  firebaseFirestore.collection('customer_details').where('mobile',isEqualTo: text).get();

                                                  setState(() {
                                                    newValue=false;
                                                    customerUserUid=variable.docs[0].id;
                                                    allCustomerMobileController.text=text;
                                                    allCustomerMobileNameController.text=customerList[allCustomerMobile.indexOf(text)];
                                                    allCustomerMobileAddressController.text=allCustomerAddress[allCustomerMobile.indexOf(text)];
                                                    flatNoController.text=variable.docs[0].get('flatNo');
                                                    buildNoController.text=variable.docs[0].get('buildNo');
                                                    roadNoController.text=variable.docs[0].get('roadNo');
                                                    blockNoController.text=variable.docs[0].get('blockNo');
                                                    areaNoController.text=variable.docs[0].get('area');
                                                    landmarkNoController.text=variable.docs[0].get('landmark');
                                                    deliveryNoteController.text=variable.docs[0].get('note');
                                                  });
                                                  print('inside allCustomerMobile $text');
                                                }
                                                else
                                                {
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 20.0,),
                                      TextField(
                                        controller: allCustomerMobileNameController,
                                        onChanged: (value) {
                                        },
                                        keyboardType:
                                        TextInputType.name,
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
                                          labelText: 'Name',
                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        ),
                                      ),
                                      SizedBox(height: 20.0,),
                                      TextField(
                                        controller: allCustomerMobileAddressController,
                                        onChanged: (value) {
                                        },
                                        keyboardType:
                                        TextInputType.name,
                                        maxLines: 3,
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
                                          labelText: 'Address',
                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        ),
                                      ),
                                      SizedBox(height: 20.0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: flatNoController,
                                              onChanged: (value) {
                                              },
                                              keyboardType:
                                              TextInputType.name,
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
                                                labelText: 'Flat NO',
                                                labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.0,),
                                          Expanded(
                                            child: TextField(
                                              controller: buildNoController,
                                              onChanged: (value) {
                                              },
                                              keyboardType:
                                              TextInputType.name,
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
                                                labelText: 'BLD NO',
                                                labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: roadNoController,
                                              onChanged: (value) {
                                              },
                                              keyboardType:
                                              TextInputType.name,
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
                                                labelText: 'ROAD NO',
                                                labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.0,),
                                          Expanded(
                                            child: TextField(
                                              controller: blockNoController,
                                              onChanged: (value) {
                                              },
                                              keyboardType:
                                              TextInputType.name,
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
                                                labelText: 'BLOCK NO',
                                                labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.0,),
                                    ],
                                  ),
                                ),
                                Container(
                                   width: MediaQuery.of(context).size.width/3,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: areaNoController,
                                        onChanged: (value) {
                                        },
                                        keyboardType:
                                        TextInputType.name,
                                        maxLines: 3,
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
                                          labelText: 'Area',
                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        ),
                                      ),
                                      SizedBox(height: 20.0,),
                                      TextField(
                                        controller: landmarkNoController,
                                        onChanged: (value) {
                                        },
                                        keyboardType:
                                        TextInputType.name,
                                        maxLines: 3,
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
                                          labelText: 'Land mark',
                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        ),
                                      ),
                                      SizedBox(height: 20.0,),
                                      TextField(
                                        controller: deliveryNoteController,
                                        onChanged: (value) {
                                        },
                                        keyboardType:
                                        TextInputType.name,
                                        maxLines: 3,
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
                                          labelText: 'Note',
                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        ),
                                      ),
                                      RawMaterialButton(
                                        onPressed: () async {
                                          if(newValue==false){
                                            appbarCustomerController.text=selectedCustomer=allCustomerMobileNameController.text;
                                            Navigator.pushNamed(context, PosScreen.id);
                                          }
                                          else{
                                            String inside='not';
                                            for(int i=0;i<allCustomerMobile.length;i++){
                                              if(allCustomerMobile[i] == allCustomerMobileController.text){
                                                inside='contains';
                                                print('customer name exist');
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text("Error"),
                                                      content: Text("Customer Mobile Number Exists"),
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
                                                break;
                                              }
                                            }
                                            if(inside == 'not'){
                                              String body='${allCustomerMobileNameController.text}~${allCustomerMobileAddressController.text}~${allCustomerMobileController.text}~~~~${flatNoController.text}~${buildNoController.text}~${roadNoController.text}~${blockNoController.text}~${areaNoController.text}~${landmarkNoController.text}~${deliveryNoteController.text}';
                                              await create(body, 'customer_details',[]);
                                              await  read('customer_details');
                                          appbarCustomerController.text=selectedCustomer=allCustomerMobileNameController.text;
                                              QuerySnapshot variable=await  firebaseFirestore.collection('customer_details').where('mobile',isEqualTo: allCustomerMobileController.text).get();
                                              setState(() {
                                                customerUserUid=variable.docs[0].id;
                                              });
                                              Navigator.pushNamed(context, PosScreen.id);
                                            }
                                          }
                                        },
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
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  );
                });
            print('home delivery inside if');
          }
          // else if(selectedDelivery=='Spot'){
          //   showDialog(
          //       context: context,
          //       builder: (BuildContext context){
          //         return StatefulBuilder(
          //           builder: (context,setState) {
          //             return Dialog(
          //               child: Container(
          //                 color: Colors.white,
          //                 padding: EdgeInsets.all(8.0),
          //                 child: SingleChildScrollView(
          //                   scrollDirection: Axis.vertical,
          //                   child: StreamBuilder(
          //                       stream: firebaseFirestore.collection('floor_data').snapshots(),
          //                       builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2) {
          //                         if (!snapshot2.hasData) {
          //                           return Center(
          //                             child: Text('Empty'),
          //                           );
          //                         }
          //                         return ListView.builder(
          //                             physics: NeverScrollableScrollPhysics(),
          //                             // scrollDirection: Axis.vertical,
          //                             shrinkWrap: true,
          //                             itemCount: snapshot2.data.docs.length,
          //                             itemBuilder: (context,index1){
          //                               String floor=snapshot2.data.docs[index1]['floorName'];
          //                               return Column(
          //                                 crossAxisAlignment: CrossAxisAlignment.start,
          //                                 children: [
          //                                   Text(floor,style: TextStyle(
          //                                     fontWeight: FontWeight.bold,
          //                                     fontSize: MediaQuery.of(context).textScaleFactor * 15,
          //                                     color: kLightBlueColor,
          //                                   ),),
          //                                   StreamBuilder(
          //                                       stream: firebaseFirestore.collection('table_data').where('area',isEqualTo:floor).snapshots(),
          //                                       builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot3) {
          //                                         if (!snapshot3.hasData) {
          //                                           return Center(
          //                                             child: Text('Empty'),
          //                                           );
          //                                         }
          //                                         return GridView.builder(
          //                                             physics: NeverScrollableScrollPhysics(),
          //                                             shrinkWrap: true,
          //                                             gridDelegate:
          //                                             SliverGridDelegateWithFixedCrossAxisCount(
          //                                               crossAxisCount: 5,
          //                                               childAspectRatio:
          //                                               MediaQuery.of(context).size.width /
          //                                                   (MediaQuery.of(context).size.height ),
          //                                             ),
          //                                             scrollDirection: Axis.vertical,
          //                                             itemCount: snapshot3.data.docs.length,
          //                                             itemBuilder: (context, index8) {
          //                                               bool occupied=snapshot3.data.docs[index8]['occupied'];
          //                                               return   Padding(
          //                                                 padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
          //                                                 child:   GestureDetector(
          //                                                   onTap: (){
          //                                                     setState(() {
          //                                                       tableSelected=snapshot3.data.docs[index8]['tableName'];
          //                                                     });
          //                                                     Navigator.pop(context);
          //                                                   },
          //                                                   child: Container(
          //                                                     decoration: BoxDecoration(
          //                                                       color: occupied==true?Colors.grey.shade400:Colors.white,
          //                                                       border: Border.all(
          //
          //                                                           color:kLightBlueColor,
          //
          //                                                           style: BorderStyle.solid,
          //
          //                                                           width: 0.80),
          //
          //                                                     ),
          //                                                     child: Stack(children: [
          //                                                       Positioned.fill(child: Align(alignment: Alignment.center,child: Text(snapshot3.data.docs[index8]['tableName'],style: TextStyle(
          //                                                         color: Colors.black,
          //                                                         letterSpacing: 1.0,
          //                                                         fontSize: MediaQuery.of(context).textScaleFactor*14,
          //                                                       ),))),
          //                                                       Positioned.fill(right: 5.0,top: 5.0,child: Align(alignment: Alignment.topRight,child: Text('''${snapshot3.data.docs[index8]['pax']} Pax'''))),
          //                                                     ],),
          //                                                   ),
          //                                                 ),
          //                                               );
          //                                             }
          //                                         );
          //                                       }
          //                                   ),
          //                                   Divider(thickness: 1.0,color: kLightBlueColor,),
          //                                 ],
          //                               );
          //                             }
          //                         );
          //                       }
          //                   ),
          //                 ),
          //               ),
          //             );
          //           }
          //         );
          //       }
          //   );
          // }
          else if(selectedDelivery=='Drive Through'){
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
  DataTable dataTable(){

    return DataTable(
        dataRowHeight: selectedBusiness=='Restaurant'?MediaQuery.of(context).size.height/6:MediaQuery.of(context).size.height/7,
        columns: [DataColumn(label: Text('Item',
          style: TextStyle(
              //fontSize: MediaQuery.of(context).textScaleFactor*20,
              color: kBlack
          ),
        )),
          DataColumn(label: Text('UOM',
            style: TextStyle(
               // fontSize: MediaQuery.of(context).textScaleFactor*20,
                color: kBlack
            ),
          ),

          ),
          DataColumn(label: Text('Qty',
            textAlign: TextAlign.center,
            style: TextStyle(
               // fontSize: MediaQuery.of(context).textScaleFactor*20,
                color: kBlack
            ),
          )),
          DataColumn(label: Text('U.Price',
            textAlign: TextAlign.center,
            style: TextStyle(
              // fontSize: MediaQuery.of(context).textScaleFactor*20,
                color: kBlack
            ),
          )),
          DataColumn(label: Text('T.price',
            textAlign: TextAlign.center,
            style: TextStyle(
              // fontSize: MediaQuery.of(context).textScaleFactor*20,
                color: kBlack
            ),
          )),




          DataColumn(
              label: Text('',
            style: TextStyle(
               // fontSize: MediaQuery.of(context).textScaleFactor*20,
                color: kBlack
            ),)),
        ], rows: List.generate(
        cartListText.length, (index) {
           List ab = cartListText[index].toString().split(':');
           double abc = double.parse(ab[2]);
        return DataRow(
            cells: [
              DataCell(selectedBusiness=='Restaurant'?
              SizedBox(
                width:200,
                child: Column(
                  children: [
                    SizedBox(
                      width:200,
                      child: ElevatedButton(
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
                                    child:  Row(
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
                                                                crossAxisCount: 2,
                                                                childAspectRatio:
                                                                MediaQuery.of(context).size.width /
                                                                    (MediaQuery.of(context).size.height ),
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
                                                                                    backgroundColor: MaterialStateProperty.all(checkoutFlag==true?kGreenColor:kHighlight.withOpacity(0.4),),
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
                                                                                    backgroundColor: MaterialStateProperty.all(checkoutFlag==true?kGreenColor:kHighlight.withOpacity(0.4),),
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
                                                                crossAxisCount: 2,
                                                                childAspectRatio:
                                                                MediaQuery.of(context).size.width /
                                                                    (MediaQuery.of(context).size.height ),
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
                                                                                      backgroundColor: MaterialStateProperty.all(checkoutFlag==true?kGreenColor:kHighlight.withOpacity(0.4),),
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
                                                                                      backgroundColor: MaterialStateProperty.all(checkoutFlag==true?kGreenColor:kHighlight.withOpacity(0.4),),
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
                                        )
                                      ],
                                    ),
                                  );
                                }
                            ),
                            );
                          },
                          child: getItem(index, 4).length>0?Text('${getItem(index, 0).replaceAll('#', '/')}\n  ${getItem(index, 4)}' , overflow: TextOverflow.ellipsis,style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                            color: kBlack,
                          ),maxLines: 3,):Text('${getItem(index, 0).replaceAll('#', '/')}' , overflow: TextOverflow.ellipsis,style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                            color: kBlack,
                          ),maxLines: 3,)
                      ),
                    ),
                    Text(showComboItems(getItem(index, 0)),style: TextStyle(
                      // fontSize: MediaQuery.of(context).textScaleFactor*20,
                      color: kBlack,
                      // fontWeight: FontWeight.bold
                    ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,),
                  ],
                ),
              ):
              SizedBox(
                  width:200,
                  child:Text('${getItem(index, 0).replaceAll('#', '/')}' ,style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                      color: kBlack,
                      fontWeight: FontWeight.bold
                  ),maxLines: 3, overflow: TextOverflow.ellipsis,))),
              DataCell(
                DropdownButton(
                  value: salesUomList[index].trim(),// Not necessary for Option 1
                  items: getUom(getItem(index,0)).map((String val) {
                    return DropdownMenuItem(
                      child: new Text(val.toString().trim(),style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                          color: kBlack,
                          fontWeight: FontWeight.bold
                      ),),
                      value: val.trim(),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    String tempPrice=getPrice(getItem(index, 0), newValue);
                    List showCartItems=cartListText[index].split(':');
                    double tempPrice1=double.parse(getItem(index, 3))*double.parse(tempPrice.trimLeft());
                    showCartItems[2]=tempPrice1.toString();
                    showCartItems[3]=getItem(index, 3);
                    // showCartItems[3]='1';
                    showCartItems[1]=newValue;
                    String tempVal=showCartItems.toString().replaceAll(',', ':');
                    tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                    setState(() {
                      salesTotalList[index]=tempPrice1;
                      cartController[index].text=tempPrice1.toString();
                      salesUomList[index] = newValue;
                      cartListText[index]=tempVal;

                      getTotal(salesTotalList);
                    });

                  },
                ),),
              DataCell(Row(
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5.0),
                      backgroundColor: MaterialStateProperty.all(kGreenColor),
                    ),
                    child: Icon(
                        Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        removeFromCart(getItem(index, 0),getItem(index, 1));
                      });

                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:3,right:3),
                    child: Text(getItem(index, 3),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                          color: kBlack,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5.0),
                      backgroundColor: MaterialStateProperty.all(kGreenColor),
                    ),
                    child: Icon(
                        Icons.add_circle_outline),
                    onPressed: () {
                      bool check=checkCombo(getItem(index, 0));
                      if(check){
                        addComboItems(getItem(index, 0),index,'plus');
                      }
                      else{
                        setState(() {
                          print('cl:$cartListText');
                           addQuantity(getItem(index, 0),getItem(index, 1));
                          print('cl:$cartListText');
                        });
                      }
                    },
                  ),
                ],
              ),),
              DataCell(
                currentPriceEdit=='true'?TextFormField(
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                      color: kBlack,
                      fontWeight: FontWeight.bold
                  ),
                  keyboardType: TextInputType.number ,
                  controller: cartController[index],
                  onChanged: (val){
                    print(cartListText);
                    List showCartItems=cartListText[index].split(':');
                    double bb = double.parse(showCartItems[3])*double.parse(val);
                    print('bb:$bb');
                    showCartItems[2]=bb.toStringAsFixed(2);
                    showCartItems[1].toString();
                    String tempVal=showCartItems.toString().replaceAll(',', ':');
                    tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
                    setState(() {
                      salesTotalList[index]=double.parse(bb.toStringAsFixed(2));
                      print('val:$tempVal');
                      cartListText[index]=tempVal;
                      getTotal(salesTotalList);
                    });
                  },):
                Text(cartController[index].text,style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                    color: kBlack,
                    fontWeight: FontWeight.bold
                ),),
                showEditIcon: currentPriceEdit=='true'?true:false,
              ),
              DataCell(
                Text(abc.toStringAsFixed(2),style:TextStyle(
                  fontSize: MediaQuery.of(context).size.width*0.014,fontWeight: FontWeight.bold),
                )
              ),
              DataCell(
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(3.0),
                      backgroundColor: MaterialStateProperty.all(kGreenColor),
                    ),
                    onPressed: (){
                      for(int i=0;i<cartComboList.length;i++) {
                        List temp = cartComboList[i].toString().split(';');
                        if(temp[0].toString().trim()==getItem(index, 0)){
                          cartComboList.removeAt(i);
                        }
                      }
                      setState(() {
                        salesTotalList.removeAt(index);
                        cartController.removeAt(index);
                        cartListText.removeAt(index);
                        salesUomList.removeAt(index);
                        getTotal(salesTotalList);
                      });
                    },
                    child: Icon(Icons.delete),
                  ))
    ]
    );}
    )
    );
  }

}
String getTax(String productName)
{
  String prod ="";

  for(int i=0;i<productFirstSplit.length;i++)
  {
    if(productFirstSplit[i].contains(productName))
    {
      List itemsL = productFirstSplit[i].split(':');
      prod = itemsL[4]+"%#"+itemsL[5];
    }
  }
  return prod;
}
// void sunmiT1Print(String orderNo)async{
//     double tax5=0;
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
//     if(organisationMobile.length>0)
//   await SunmiPrinter.printText('Mobile Number:$organisationMobile',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//     if(organisationGstNo.length>0) {
//       await SunmiPrinter.printText('$organisationTaxType Number:$organisationGstNo',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//       await SunmiPrinter.printText('$organisationTaxTitle',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//     }
//   await SunmiPrinter.line();
//       DateTime now = DateTime.now();
//   String dateS = DateFormat('dd-MM-yyyy – kk:mm').format(now);
//     await SunmiPrinter.printText('Invoice No:$orderNo',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//     await SunmiPrinter.printText('Date:$dateS',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//     if (appbarCustomerController.text.length>0){
//       await SunmiPrinter.printText('Customer Name:${appbarCustomerController.text}',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//       if(allCustomerAddress[customerList.indexOf(appbarCustomerController.text)].length>0)
//         await SunmiPrinter.printText('Customer Address:${allCustomerAddress[customerList.indexOf(appbarCustomerController.text)]}',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//     }
//     await SunmiPrinter.line();
//     await SunmiPrinter.printRow(cols: [
//       ColumnMaker(text: 'Item', width: organisationGstNo.length>0? 9:13, align: SunmiPrintAlign.LEFT),
//       ColumnMaker(text: 'Qty', width: 4,),
//       ColumnMaker(text: 'Rate', width: 5,),
//       if(organisationGstNo.length>0)
//       ColumnMaker(text: 'Tax', width: 4,),
//       ColumnMaker(text: 'Amount', width: 6, align: SunmiPrintAlign.RIGHT),
//     ]);
//     await SunmiPrinter.line();
//       grandTotal=0;double exclTotal =0;
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
//     await SunmiPrinter.line();
//       if(organisationTaxType=='VAT') {
//         exclTotal = grandTotal - tax10;
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:exclTotal.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Vat 10%', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:tax10.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//             grandTotal = exclTotal + tax10;
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Net Payable', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//       }
//       else{
//             if(organisationGstNo.length>0) {
//               exclTotal = grandTotal - totalTax;
//               await SunmiPrinter.printRow(cols: [
//                 ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//                 ColumnMaker(text:exclTotal.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//               ]);
//               await SunmiPrinter.printRow(cols: [
//                 ColumnMaker(text: 'Total Tax', width: 14, align: SunmiPrintAlign.LEFT),
//                 ColumnMaker(text:totalTax.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//               ]);
//               if(double.parse(totalDiscountController.text)>0){
//                 await SunmiPrinter.printRow(cols: [
//                   ColumnMaker(text: 'Discount', width: 14, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text:double.parse(totalDiscountController.text).toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//                 ]);
//                 grandTotal = grandTotal - double.parse(totalDiscountController.text);
//               }
//               await SunmiPrinter.printRow(cols: [
//                 ColumnMaker(text: 'Net Payable', width: 14, align: SunmiPrintAlign.LEFT),
//                 ColumnMaker(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//               ]);
//               await SunmiPrinter.line();
//               if(tax5>0){
//                 await SunmiPrinter.printRow(cols: [
//                   ColumnMaker(text: 'CGST 2.5%', width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: (tax5/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: 'SGST 2.5%', width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: (tax5/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//                 ]);
//               }
//               if(tax12>0){
//                 await SunmiPrinter.printRow(cols: [
//                   ColumnMaker(text: 'CGST 6%', width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: (tax12/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: 'SGST 6%', width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: (tax12/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//                 ]);
//               }
//               if(tax18>0){
//                 await SunmiPrinter.printRow(cols: [
//                   ColumnMaker(text: 'CGST 9%', width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: (tax18/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: 'SGST 9%', width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: (tax18/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//                 ]);
//               }
//               if(tax28>0){
//                 await SunmiPrinter.printRow(cols: [
//                   ColumnMaker(text: 'CGST 14%', width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: (tax28/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: 'SGST 14%', width: 7, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: (tax28/2).toStringAsFixed(decimals), width: 7, align: SunmiPrintAlign.LEFT),
//                 ]);
//               }
//               if(tax12>0){
//                 await SunmiPrinter.printRow(cols: [
//                   ColumnMaker(text: 'CESS 12%', width: 14, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text: cess.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.LEFT),
//                 ]);
//               }
//             }
//             else{
//               if(double.parse(totalDiscountController.text)>0) {
//                 await SunmiPrinter.printRow(cols: [
//                   ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text:exclTotal.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//                 ]);
//                 await SunmiPrinter.printRow(cols: [
//                   ColumnMaker(text: 'Discount', width: 14, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text:double.parse(totalDiscountController.text).toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//                 ]);
//                 grandTotal = grandTotal - double.parse(totalDiscountController.text);
//                 await SunmiPrinter.printRow(cols: [
//                   ColumnMaker(text: 'Net Payable', width: 14, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//                 ]);
//               }
//               else{
//                 await SunmiPrinter.printRow(cols: [
//                   ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//                   ColumnMaker(text:'$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//                 ]);
//               }
//               }
//               }
//     if(organisationGstNo.length>0)  await SunmiPrinter.line();
//     await SunmiPrinter.printText('Thank You,Visit Again',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//     await SunmiPrinter.lineWrap(5);
//   await SunmiPrinter.exitTransactionPrint(true);
// }

// void sunmiPrint(String orderNo,discount)
// {
//   double tax5=0;
//   double tax10=0;
//   double tax12=0;
//   double tax18=0;
//   double tax28=0;
//   double cess=0;
//   taxCum = "";
//   grandTotal=0;
//   print('here111');
//   SunmiPrinter.text('$organisationName', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.lg),);
//   SunmiPrinter.text('$organisationAddress', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
//   if(organisationMobile.length>0)
//     SunmiPrinter.text('Mobile Number:$organisationMobile', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
//   if(organisationGstNo.length>0) {
//     SunmiPrinter.text('$organisationTaxType Number:$organisationGstNo', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
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
//   SunmiPrinter.row(
//       cols: [
//         SunmiCol(text: 'Item', width:organisationGstNo.length>0? 5:6),
//         SunmiCol(text: 'Qty', width: 1),
//         SunmiCol(text: 'Rate', width: 2),
//         if(organisationGstNo.length>0)
//           SunmiCol(text: 'Tax', width: 1),
//         SunmiCol(text: 'Amount', width:3),
//       ]);
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
//     SunmiPrinter.row(
//       cols: [
//         SunmiCol(text: '${cartItemsString[0]}', width: organisationGstNo.length>0?5:6),
//         SunmiCol(text: '${cartItemsString[3]}', width: 1, ),
//         SunmiCol(text: '$price', width: 2, ),
//         if(organisationGstNo.length>0)
//           SunmiCol(text:'${getPercent(tax)}', width: 1, ),
//         SunmiCol(text: '${cartItemsString[2]}', width: 3, ),
//       ],
//     );
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
//       }
//     }
//   }
//   if(organisationGstNo.length>0) SunmiPrinter.hr(ch: '-');
//   SunmiPrinter.text('Thank You,Visit Again', styles: SunmiStyles(bold: true,align: SunmiAlign.center,size: SunmiSize.md),);
//   SunmiPrinter.emptyLines(2);
//
// }

Future networkPrint1(NetworkPrinter printer)async {
  printer.text('Print from Dubai', styles: PosStyles(align: PosAlign.center));
}

// Bitmap bitImage(){
//   String text = "Hello world!";
//   Bitmap b = Bitmap.fromHeadful(150.0, 30.0, Bitmap.Config.ARGB_8888);
//   Canvas c = new Canvas(b);
//   c.drawBitmap(b, 0, 0, null);
//   TextPaint textPaint = new TextPaint();
//   textPaint.setAntiAlias(true);
//   textPaint.setTextSize(16.0F);
//   StaticLayout sl= new StaticLayout(text, textPaint, b.getWidth()-8, Alignment.ALIGN_CENTER, 1.0f, 0.0f, false);
//   c.translate(6, 40);
//   sl.draw(c);
//   return b
// }
String getQrCode(double total,double tax){
  BytesBuilder bytesBuilder=BytesBuilder();
  //1. seller name
  bytesBuilder.addByte(1);
  List<int> sellerNameBytes=utf8.encode(organisationName);
  bytesBuilder.addByte(sellerNameBytes.length);
  bytesBuilder.add(sellerNameBytes);
  //2.VAT
  bytesBuilder.addByte(2);
  List<int> vatBytes=utf8.encode(organisationGstNo);
  bytesBuilder.addByte(vatBytes.length);
  bytesBuilder.add(vatBytes);
  //3.date
  bytesBuilder.addByte(3);
  List<int> dateBytes=utf8.encode(dateNowQr());
  bytesBuilder.addByte(dateBytes.length);
  bytesBuilder.add(dateBytes);
  //4.total
  bytesBuilder.addByte(4);
  List<int> totalBytes=utf8.encode(total.toStringAsFixed(decimals));
  bytesBuilder.addByte(totalBytes.length);
  bytesBuilder.add(totalBytes);
  //5.total vat
  bytesBuilder.addByte(5);
  List<int> vatTotalBytes=utf8.encode(tax.toStringAsFixed(decimals));
  bytesBuilder.addByte(vatTotalBytes.length);
  bytesBuilder.add(vatTotalBytes);

  Uint8List qrCodeAsBytes=bytesBuilder.toBytes();
  final Base64Encoder data=Base64Encoder();
  return data.convert(qrCodeAsBytes);
}
Future networkPrint(String invNo,NetworkPrinter printer,double discount)async{
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
    printer..text('$organisationTaxType Number:$organisationGstNo', styles: PosStyles(align: PosAlign.center,));
    if(orgQrCodeIs=='true'){
      // final ByteData data = await rootBundle.load('images/vat_ar.jpg');
      // final Uint8List bytes = data.buffer.asUint8List();
      // final img.Image image = img.decodeImage(bytes);
      // printer.image(image);
    }

    else{
      printer.text('$organisationTaxTitle' , styles: PosStyles(align: PosAlign.center,bold: true,));
    }
  }
  printer.hr(ch: '-');
  printer.text('Invoice No: $invNo',
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
  if(orgMultiLine=='true'){
    printer.text('Particulars',
        styles: PosStyles(align: PosAlign.left,bold: true));
    printer.row([
      PosColumn(text: 'Qty', width: organisationGstNo.length>0?7:8,styles: PosStyles(bold:true,align: PosAlign.right)),
      PosColumn(text: 'Rate', width: 2,styles: PosStyles(bold:true,align: PosAlign.right)),
      if(organisationGstNo.length>0)
        PosColumn(text: 'Tax%', width: 1,styles: PosStyles(bold:true,align: PosAlign.right)),
      PosColumn(text: 'Amount', width: 2,styles: PosStyles(bold:true,align: PosAlign.right)),
    ]);
  }
  else{
    printer.row([
      PosColumn(text: 'Particulars', width: organisationGstNo.length>0?5:6,styles: PosStyles(bold:true,align: PosAlign.left),),
      PosColumn(text: 'Qty', width: 2,styles: PosStyles(bold:true,align: PosAlign.right)),
      PosColumn(text: 'Rate', width: 2,styles: PosStyles(bold:true,align: PosAlign.right)),
      if(organisationGstNo.length>0)
        PosColumn(text: 'Tax%', width: 1,styles: PosStyles(bold:true,align: PosAlign.right)),
      PosColumn(text: 'Amount', width: 2,styles: PosStyles(bold:true,align: PosAlign.right)),
    ]);
  }
  printer.hr(ch: '-');
  grandTotal=0;double exclTotal =0;
  totalTax=0;
  for(int i=0;i<cartListText.length;i++)
  {
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
    if(orgMultiLine=='true'){
      printer.text(cartItemsString[0],
          styles: PosStyles(align: PosAlign.left,bold: true));
      printer.row([
        PosColumn(text: cartItemsString[3], width: organisationGstNo.length>0?7:8,styles: PosStyles(align: PosAlign.right,bold:true)),
        PosColumn(text:price.toStringAsFixed(decimals), width:2,styles: PosStyles(align: PosAlign.right,bold:true)),
        if(organisationGstNo.length>0)
          PosColumn(text: getPercent(tax), width:1,styles: PosStyles(align: PosAlign.right,bold:true)),
        PosColumn(
            text: double.parse(cartItemsString[2].toString()).toStringAsFixed(
                decimals), width: 2,styles: PosStyles(align: PosAlign.right,bold:true)),
      ]);
    }
    else{
      printer.row([
        PosColumn(text: '${cartItemsString[0]}', width:organisationGstNo.length>0?5:6,styles: PosStyles(align: PosAlign.left,bold:true)),
        PosColumn(text: cartItemsString[3], width: 2,styles: PosStyles(align: PosAlign.right,bold:true)),
        PosColumn(text:price.toStringAsFixed(decimals), width:2,styles: PosStyles(align: PosAlign.right,bold:true)),
        if(organisationGstNo.length>0)
          PosColumn(text: getPercent(tax), width:1,styles: PosStyles(align: PosAlign.right,bold:true)),
        PosColumn(
            text: double.parse(cartItemsString[2].toString()).toStringAsFixed(
                decimals), width: 2,styles: PosStyles(align: PosAlign.right,bold:true)),
      ]);
    }
  }
  printer.hr(ch: '-');
  print('gst 111111');
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
    if(discount>0){
      printer.row([
        PosColumn(text: 'Discount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
        PosColumn(text: '${discount.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
      ]);
      grandTotal = grandTotal - discount;
    }
    // grandTotal = exclTotal + tax10;

    printer.row([
      PosColumn(text: 'Net Payable', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
      PosColumn(text: '$organisationSymbol ${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
    ]);

  }

  else{

    if(organisationGstNo.length>0){
      print('gst number if');
      exclTotal = grandTotal - totalTax;
      printer.row([
        PosColumn(text: 'Bill Amount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
        PosColumn(text: '${exclTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
      ]);

      printer.row([
        PosColumn(text: 'Total Tax', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
        PosColumn(text: '${totalTax.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
      ]);
      if(discount>0){
        printer.row([
          PosColumn(text: 'Discount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '${discount.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
        ]);
        grandTotal = grandTotal - discount;
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
      print('gst number else');
      if(discount>0){
        printer.row([
          PosColumn(text: 'Bill Amount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '${grandTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
        ]);
        printer.row([
            PosColumn(text: 'Discount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
            PosColumn(text: '${discount.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
          ]);
        grandTotal = grandTotal -discount;

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
  if(orgQrCodeIs=='true'){
   BytesBuilder bytesBuilder=BytesBuilder();
   //1. seller name
   bytesBuilder.addByte(1);
   List<int> sellerNameBytes=utf8.encode(organisationName);
   bytesBuilder.addByte(sellerNameBytes.length);
   bytesBuilder.add(sellerNameBytes);
   //2.VAT
   bytesBuilder.addByte(2);
   List<int> vatBytes=utf8.encode(organisationGstNo);
   bytesBuilder.addByte(vatBytes.length);
   bytesBuilder.add(vatBytes);
   //3.date
   bytesBuilder.addByte(3);
   List<int> dateBytes=utf8.encode(dateNowQr());
   bytesBuilder.addByte(dateBytes.length);
   bytesBuilder.add(dateBytes);
   //4.total
   bytesBuilder.addByte(4);
   List<int> totalBytes=utf8.encode(grandTotal.toStringAsFixed(decimals));
   bytesBuilder.addByte(totalBytes.length);
   bytesBuilder.add(totalBytes);
   //5.total vat
   bytesBuilder.addByte(5);
   List<int> vatTotalBytes=utf8.encode(totalTax.toStringAsFixed(decimals));
   bytesBuilder.addByte(vatTotalBytes.length);
   bytesBuilder.add(vatTotalBytes);

   Uint8List qrCodeAsBytes=bytesBuilder.toBytes();
   final Base64Encoder data=Base64Encoder();

    // String data='$organisationName $organisationGstNo ${dateNowQr()} ${grandTotal.toStringAsFixed(decimals)} ${totalTax.toStringAsFixed(decimals)}';
    // String encoded = base64.encode(utf8.encode(data));
    printer.qrcode(data.convert(qrCodeAsBytes),size: QRSize.Size6);
  }
  if(organisationGstNo.length>0) printer.hr(ch: '-');
  printer.text('Thank You,Visit Again',
      styles: PosStyles(align: PosAlign.center,bold: true));
  printer.cut();
  // printer.drawer();
}



String getPrefix(){
  for(int i=0;i<userList.length;i++){
    if(currentUser==userList[i]){
      return userPrefixList[i];
    }
  }
  return '';
}
Future kotOrders(String tableNumber,bool exist)async{
  List yourItemsList=[];
  String tempModifier='';
  String tempComboKot='';
  String body='';
  tableNumber=tableNumber.contains('~')?tableNumber.replaceAll('~', ','):tableNumber;
  // List tempInv1=[];
  // await firebaseFirestore.collection("kot_order").get().then((querySnapshot) {
  //   querySnapshot.docs.forEach((result) {
  //     tempInv1.add(result.get('orderNo'));
  //   });
  // });
  // if(tempInv1.contains(currentOrder)){
  if(exist==true){
    for(int k=0;k<cartListText.length;k++){
      tempModifier='';
      tempComboKot='';
      List temp=cartListText[k].split(':');
      String itemName=temp[0];
      String itemQty=temp[3];
      String itemUom=temp[1];
      String itemPrice=temp[2];
      if(temp.length>4){
        tempModifier=temp[4];
      }
      if(cartComboList.length>0){
        for(int m=0;m<cartComboList.length;m++){
          List temp123=cartComboList[m].toString().split(';');
          print(temp123);
          if(temp123[0].toString().trim()==itemName.trim()) {
            tempComboKot+=temp123[1].toString().trim();
            tempComboKot+='~';
          }
        }
        tempComboKot=tempComboKot.length>0?tempComboKot.substring(0,tempComboKot.length-1):'';
      }
      yourItemsList.add({
        "name":itemName,
        "uom":itemUom,
        "qty":itemQty,
        "price":itemPrice,
        "modifier":tempModifier,
        "ready":false,
        "combo":tempComboKot
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
      'user': createdBy,
      'note': currentKotNote,
      'type': selectedDelivery,
      'cartList': yourItemsList,
    }).then((_) {
    });
    // update('kot_order', yourItemsList, currentOrder);
    return;
  }
  int invNo;
  invNo=await getLastInv('kot');
  String note='';
  if(selectedDelivery=='Drive Through'){
    note=driveNoteController.text;
  }
  else if(selectedDelivery=='Take Away'){
    note=takeAwayNoteController.text;
  }
  else if(selectedDelivery=='Delivery'){
    note='${allCustomerMobileNameController.text},${allCustomerMobileController.text},${allCustomerMobileAddressController.text}';
  }
  body='${getPrefix()}$invNo~${dateNow()}~$tableNumber~$selectedCustomer~$selectedPriceList~$currentUser~$note~$selectedDelivery';
  for(int k=0;k<cartListText.length;k++){
    tempModifier='';
    tempComboKot='';
    List temp=cartListText[k].split(':');
    String itemName=temp[0];
    String itemQty=temp[3];
    String itemUom=temp[1];
    String itemPrice=temp[2];
    if(temp.length>4){
      tempModifier=temp[4];
    }
    if(cartComboList.length>0){
      for(int m=0;m<cartComboList.length;m++){
        List temp123=cartComboList[m].toString().split(';');
        print(temp123);
        if(temp123[0].toString().trim()==itemName.trim()) {
          tempComboKot+=temp123[1].toString().trim();
          tempComboKot+='~';
        }
      }
      tempComboKot=tempComboKot.length>0?tempComboKot.substring(0,tempComboKot.length-1):'';
    }
    yourItemsList.add({
      "name":itemName,
      "uom":itemUom,
      "qty":itemQty,
      "price":itemPrice,
      "modifier":tempModifier,
      "ready":false,
      "combo":tempComboKot
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
String getKotIpAddressPrinter(String printer){
  for(int i=0;i<kotPrinter.length;i++){
    if(kotPrinter[i]==printer){
      return kotPrinterIpAddress[i];
    }
  }
  return '';
}
String getKotPrinterName(String category){
  for(int i=0;i<kotCategory.length;i++){
    if(kotCategory[i]==category){
      return kotPrinter[i];
    }
  }
  return '';
}
String dateNow(){
  final now = DateTime.now();
  final formatter = DateFormat('dd/MM/yyyy H:m');
  final String timestamp = formatter.format(now);
  return timestamp;
}
String dateNowQr(){
  final now = DateTime.now();
  final formatter = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
  final String timestamp =  now.toUtc().toIso8601String();
  return '${formatter}Z';
}
class DeliverySelect extends StatefulWidget {
  @override
  _DeliverySelectState createState() => _DeliverySelectState();
}
class _DeliverySelectState extends State<DeliverySelect> {
  TextEditingController flatNoController=TextEditingController();
  TextEditingController buildNoController=TextEditingController();
  TextEditingController roadNoController=TextEditingController();
  TextEditingController blockNoController=TextEditingController();
  TextEditingController areaNoController=TextEditingController();
  TextEditingController landmarkNoController=TextEditingController();
  TextEditingController deliveryNoteController=TextEditingController();
  int selectedMode=0;
  @override
  Widget build(BuildContext context) {
    Container tableView(BuildContext context) {
      return Container(
        color: Colors.grey,
        width: MediaQuery.of(context).size.width/1.5,
        height: MediaQuery.of(context).size.height/1.5,
        child: GridView.builder(
          // physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemCount: 25,
            itemBuilder: (context, index) {
              final _isSelected=selectedTableList.contains(index+1);
              return RawMaterialButton(
                onPressed: (){
                  setState(() {
                    _selectedTable=index+1;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width/10,
                  height:MediaQuery.of(context).size.height/8,
                  decoration: BoxDecoration(
                    color: _isSelected?kHighlight:kGreenColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: AutoSizeText(
                    'Table \n ${index+1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*22,
                      color: kItemContainer,
                    ),
                  ),
                ),
              );
            }),
      );
    }
    return  buildDelivery(context);
  }

  Padding buildDelivery(BuildContext context)  {
    return Padding(
      padding: const EdgeInsets.only(left:6.0,right: 6.0),
      child: Visibility(
        visible: selectedBusiness=='Restaurant'?true:false,
        child: Container(
          color: kGreenColor,
          child: ToggleButtons(
            isSelected: isSelected,
            borderColor: kItemContainer,
            fillColor: kHighlight,
            borderWidth: 2,
            selectedBorderColor: kItemContainer,
            selectedColor: kItemContainer,
            borderRadius: BorderRadius.circular(0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Dine In',
                  style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20, color: kItemContainer),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Take Away',
                  style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20, color: kItemContainer),
                ),
              ),Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Drive Through',
                  style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20, color: kItemContainer),
                ),
              ),Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'QSR',
                  style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20, color: kItemContainer),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Delivery',
                  style: TextStyle( fontSize: MediaQuery.of(context).textScaleFactor*20,
                      color: kItemContainer
                  ),
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
                salesUomList=[];
                salesTotalList=[];
                salesTotal=0;
                allCustomerMobileController.text='';
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                }

              });
              if(selectedDelivery=='Delivery'){
                bool newValue=true;
                allCustomerMobileNameController.text='';
                allCustomerMobileAddressController.text='';
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                          width: MediaQuery.of(context).size.width/3,
                          //height: MediaQuery.of(context).size.height/2,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              // scrollDirection: Axis.vertical,
                              // shrinkWrap: true,
                              children: [
                                Text(
                                  'Customer details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).textScaleFactor*20,
                                  ),
                                ),
                                Container(
                                  //padding: const EdgeInsets.all(8.0),
                                  child: StatefulBuilder(
                                    builder: (context,setState){
                                      return SimpleAutoCompleteTextField(
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                        ),
                                        decoration:InputDecoration(
                                          suffixIcon: Icon(Icons.search,color: Colors.black),
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
                                          labelText: 'enter mobile number',
                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        ),
                                        controller: allCustomerMobileController,
                                        suggestions: allCustomerMobile,
                                        clearOnSubmit: false,
                                        textSubmitted: (text) async {
                                          if(allCustomerMobile.contains(text)) {
                                            QuerySnapshot variable=await  firebaseFirestore.collection('customer_details').where('mobile',isEqualTo: text).get();

                                            setState(() {
                                              newValue=false;
                                              allCustomerMobileController.text=text;
                                              allCustomerMobileNameController.text=customerList[allCustomerMobile.indexOf(text)];
                                              allCustomerMobileAddressController.text=allCustomerAddress[allCustomerMobile.indexOf(text)];
                                              flatNoController.text=variable.docs[0].get('flatNo');
                                              buildNoController.text=variable.docs[0].get('buildNo');
                                              roadNoController.text=variable.docs[0].get('roadNo');
                                              blockNoController.text=variable.docs[0].get('blockNo');
                                              areaNoController.text=variable.docs[0].get('area');
                                              landmarkNoController.text=variable.docs[0].get('landmark');
                                              deliveryNoteController.text=variable.docs[0].get('note');
                                            });
                                            print('inside allCustomerMobile $text');
                                          }
                                          else
                                          {
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                TextField(
                                  controller: allCustomerMobileNameController,
                                  onChanged: (value) {
                                  },
                                  keyboardType:
                                  TextInputType.name,
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
                                    labelText: 'Name',
                                    labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                TextField(
                                  controller: allCustomerMobileAddressController,
                                  onChanged: (value) {
                                  },
                                  keyboardType:
                                  TextInputType.name,
                                  maxLines: 3,
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
                                    labelText: 'Address',
                                    labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: flatNoController,
                                        onChanged: (value) {
                                        },
                                        keyboardType:
                                        TextInputType.name,
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
                                          labelText: 'Flat NO',
                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0,),
                                    Expanded(
                                      child: TextField(
                                        controller: buildNoController,
                                        onChanged: (value) {
                                        },
                                        keyboardType:
                                        TextInputType.name,
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
                                          labelText: 'BLD NO',
                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: roadNoController,
                                        onChanged: (value) {
                                        },
                                        keyboardType:
                                        TextInputType.name,
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
                                          labelText: 'ROAD NO',
                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0,),
                                    Expanded(
                                      child: TextField(
                                        controller: blockNoController,
                                        onChanged: (value) {
                                        },
                                        keyboardType:
                                        TextInputType.name,
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
                                          labelText: 'BLOCK NO',
                                          labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
                                TextField(
                                  controller: areaNoController,
                                  onChanged: (value) {
                                  },
                                  keyboardType:
                                  TextInputType.name,
                                  maxLines: 3,
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
                                    labelText: 'Area',
                                    labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                TextField(
                                  controller: landmarkNoController,
                                  onChanged: (value) {
                                  },
                                  keyboardType:
                                  TextInputType.name,
                                  maxLines: 3,
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
                                    labelText: 'Land mark',
                                    labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                TextField(
                                  controller: deliveryNoteController,
                                  onChanged: (value) {
                                  },
                                  keyboardType:
                                  TextInputType.name,
                                  maxLines: 3,
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
                                    labelText: 'Note',
                                    labelStyle: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).textScaleFactor*20),
                                  ),
                                ),
                                RawMaterialButton(
                                  onPressed: () {
                                    if(newValue==false){
                                      print('inside newvalue');
                                      selectedCustomer=allCustomerMobileNameController.text;
                                    }
                                    else{
                                      String inside='not';
                                      for(int i=0;i<customerList.length;i++){
                                        if(customerList[i].toLowerCase() == allCustomerMobileNameController.text.toLowerCase()){
                                          inside='contains';
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Error"),
                                                content: Text("Customer name Exists"),
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
                                      }
                                      if(inside == 'not'){
                                        print('inside else notttttttttt');
                                        String body='${allCustomerMobileNameController.text}~${allCustomerMobileAddressController.text}~${allCustomerMobileController.text}~~~~${flatNoController.text}~${buildNoController.text}~${roadNoController.text}~${blockNoController.text}~${areaNoController.text}~${landmarkNoController.text}~${deliveryNoteController.text}';
                                        create(body, 'customer_details',[]);
                                        customerList.add(allCustomerMobileNameController.text);
                                        customerVatNo.add('');
                                        allCustomerMobile.add(allCustomerMobileController.text);
                                        allCustomerAddress.add(allCustomerMobileAddressController.text);
                                        selectedCustomer=allCustomerMobileNameController.text;
                                      }
                                    }
                                    setState(() {
                                    });
                                    Navigator.pop(context);
                                  },
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
                print('home delivery inside if');
              }
              // else if(selectedDelivery=='Spot'){
              //   showDialog(
              //       context: context,
              //       builder: (BuildContext context){
              //         return StatefulBuilder(
              //           builder: (context,setState) {
              //             return Dialog(
              //               child: Container(
              //                 color: Colors.white,
              //                 padding: EdgeInsets.all(8.0),
              //                 child: SingleChildScrollView(
              //                   scrollDirection: Axis.vertical,
              //                   child: StreamBuilder(
              //                       stream: firebaseFirestore.collection('floor_data').snapshots(),
              //                       builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2) {
              //                         if (!snapshot2.hasData) {
              //                           return Center(
              //                             child: Text('Empty'),
              //                           );
              //                         }
              //                         return ListView.builder(
              //                             physics: NeverScrollableScrollPhysics(),
              //                             // scrollDirection: Axis.vertical,
              //                             shrinkWrap: true,
              //                             itemCount: snapshot2.data.docs.length,
              //                             itemBuilder: (context,index1){
              //                               String floor=snapshot2.data.docs[index1]['floorName'];
              //                               return Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   Text(floor,style: TextStyle(
              //                                     fontWeight: FontWeight.bold,
              //                                     fontSize: MediaQuery.of(context).textScaleFactor * 15,
              //                                     color: kLightBlueColor,
              //                                   ),),
              //                                   StreamBuilder(
              //                                       stream: firebaseFirestore.collection('table_data').where('area',isEqualTo:floor).snapshots(),
              //                                       builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot3) {
              //                                         if (!snapshot3.hasData) {
              //                                           return Center(
              //                                             child: Text('Empty'),
              //                                           );
              //                                         }
              //                                         return GridView.builder(
              //                                             physics: NeverScrollableScrollPhysics(),
              //                                             shrinkWrap: true,
              //                                             gridDelegate:
              //                                             SliverGridDelegateWithFixedCrossAxisCount(
              //                                               crossAxisCount: 5,
              //                                               childAspectRatio:
              //                                               MediaQuery.of(context).size.width /
              //                                                   (MediaQuery.of(context).size.height ),
              //                                             ),
              //                                             scrollDirection: Axis.vertical,
              //                                             itemCount: snapshot3.data.docs.length,
              //                                             itemBuilder: (context, index8) {
              //                                               bool occupied=snapshot3.data.docs[index8]['occupied'];
              //                                               return   Padding(
              //                                                 padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6),
              //                                                 child:   GestureDetector(
              //                                                   onTap: (){
              //                                                     setState(() {
              //                                                       tableSelected=snapshot3.data.docs[index8]['tableName'];
              //                                                     });
              //                                                     Navigator.pop(context);
              //                                                   },
              //                                                   child: Container(
              //                                                     decoration: BoxDecoration(
              //                                                       color: occupied==true?Colors.grey.shade400:Colors.white,
              //                                                       border: Border.all(
              //
              //                                                           color:kLightBlueColor,
              //
              //                                                           style: BorderStyle.solid,
              //
              //                                                           width: 0.80),
              //
              //                                                     ),
              //                                                     child: Stack(children: [
              //                                                       Positioned.fill(child: Align(alignment: Alignment.center,child: Text(snapshot3.data.docs[index8]['tableName'],style: TextStyle(
              //                                                         color: Colors.black,
              //                                                         letterSpacing: 1.0,
              //                                                         fontSize: MediaQuery.of(context).textScaleFactor*14,
              //                                                       ),))),
              //                                                       Positioned.fill(right: 5.0,top: 5.0,child: Align(alignment: Alignment.topRight,child: Text('''${snapshot3.data.docs[index8]['pax']} Pax'''))),
              //                                                     ],),
              //                                                   ),
              //                                                 ),
              //                                               );
              //                                             }
              //                                         );
              //                                       }
              //                                   ),
              //                                   Divider(thickness: 1.0,color: kLightBlueColor,),
              //                                 ],
              //                               );
              //                             }
              //                         );
              //                       }
              //                   ),
              //                 ),
              //               ),
              //             );
              //           }
              //         );
              //       }
              //   );
              // }
              else if(selectedDelivery=='Drive Through'){
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
      ),
    );
  }
}
class CustomerSelect extends StatefulWidget {
  @override
  _CustomerSelectState createState() => _CustomerSelectState();
}

class _CustomerSelectState extends State<CustomerSelect> {
  void searchAppBarCustomer(String text) {
    searchCustomerResult.clear();
    if(text.length>0){
      for (int i = 0; i < customerList.length; i++) {
        String data = customerList[i];
        if (data.toLowerCase().contains(text.toLowerCase())) {
          searchCustomerResult.add('$data \n ${allCustomerMobile[customerList.indexOf(data)]}');
        }
      }
    }
    else{
      searchCustomerResult.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.only(left: 8.0),
      child: Row(
        children:[
          Text('Customer : ',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).textScaleFactor*16,
              color: kFont1Color
          ),
          ),
          SizedBox(
            width:MediaQuery.of(context).size.width/5.5,
            height: 30,
            // child: SimpleAutoCompleteTextField(
            //   style: TextStyle(
            //     fontSize: MediaQuery.of(context).textScaleFactor*14,
            //     color: kFont1Color
            //   ),
            //  // focusNode: nameNode,
            //   controller: appbarCustomerController,
            //   decoration: new InputDecoration(
            //       border: OutlineInputBorder(
            //         borderSide: BorderSide(color: kFont3Color)
            //       ),
            //       disabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: kFont3Color)
            //       ),
            //       enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: kFont3Color)
            //       ),
            //     focusedBorder: OutlineInputBorder(
            //         borderSide: BorderSide(color: kFont3Color)
            //     ),
            //   ),
            //   suggestions: customerList,
            //   clearOnSubmit: false,
            //   textSubmitted: (text) {
            //     if(customerList.contains(text)) {
            //       setState(() {
            //         selectedCustomer=appbarCustomerController.text=text;
            //       });
            //     }
            //     else
            //     {
            //       print('nothingggg');
            //     }
            //   },
            // ),
            child: TextField(
              // autofocus: true,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor*14,
                  color: kFont1Color
                ),
              textInputAction: TextInputAction.go,
              controller: appbarCustomerController,
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
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kFont3Color)
                  ),
                ),
              onChanged: searchAppBarCustomer,
            ),
          ),
        ],
      ),
    );
  }
}
String convertEpox(int val){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
  var format = new DateFormat("yMd");
  var dateString = format.format(date);
  return date.toString();
}