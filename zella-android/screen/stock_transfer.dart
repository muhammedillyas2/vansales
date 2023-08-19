import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/screen/sequence_manager.dart';
import '../constants.dart';
import 'login_page.dart';
import 'printPDFfromStockTransfer.dart';

Rx<FocusNode> nameNode=FocusNode().obs;
Rx<FocusNode> quantityNode=FocusNode().obs;
TextEditingController quantityController=TextEditingController();
Rx<TextEditingController> nameController=TextEditingController().obs;
RxList warehouseProducts=[].obs;
String _selectedItem='';
var selectedFrom=''.obs;
var selectedTo=''.obs;
List <String> stockCartListText=[];
List<double> stockCartTotalList=[];
List<TextEditingController> stockCartController=[];
List<String> stockCartUomList=[];
bool enableQuantity=false;
var height, width; //SUFYAN
class StockTransfer extends StatefulWidget {
static const String id='stock_transfer';

  @override
  _StockTransferState createState() => _StockTransferState();
}

class _StockTransferState extends State<StockTransfer> {
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
              for (int i = 0; i < stockCartListText.length; i++) {
                if (stockCartListText[i].contains(name.trim())) {
                  print('contains name');
                  List tempList = stockCartListText[i].split(':');
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
                      stockCartTotalList[i] = tempRate;
                      stockCartController[i].text = tempRate.toString();
                      stockCartListText[i] = tempText;
                    });
                    print(tempText);
                    return;
                  }
                }
              }

              setState(() {
                tempText = '$name:${tempUomSplit[j]}:$tempPrice: 1';
                stockCartTotalList.add(double.parse(tempPrice));
                stockCartController.add(TextEditingController(
                    text: tempPrice
                ));
                stockCartUomList.add(tempUomSplit[j]);
                stockCartListText.add(tempText.trim());
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
              stockCartController.add(TextEditingController(
                  text: tempPrice.toString()
              ));
              stockCartTotalList.add(tempPrice);
              stockCartUomList.add(uom[0]);
              stockCartListText.add(tempText.trim());
            });
            print(tempText);
            return;
          }
        }
      }}
  }
  void addFromSearch(String name,String quantityValue){
    String tempText='';
    if(stockCartListText.isEmpty){
      String uom=getBaseUom(name);
      String tempr=getPrice(name,getBaseUom(name));
      double tempRate=double.parse(tempr);
      stockCartController.add(TextEditingController());
      tempRate=double.parse(quantityValue)*tempRate;
      tempText='$name:$uom:$tempRate: $quantityValue';
      setState(() {
        stockCartTotalList.add(tempRate);
        stockCartController[0].text=tempRate.toString();
        stockCartUomList.add(getBaseUom(name));
        stockCartListText.add(tempText.trim());
      });
    }
    else {
      for (int i = 0; i < stockCartListText.length; i++) {
        List tempCart=stockCartListText[i].split(':');
        if (tempCart[0]==name) {
          List tempList = stockCartListText[i].split(
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
              stockCartTotalList[i] = tempRate;
              stockCartController[i].text = tempRate.toString();
              stockCartListText[i] = tempText.trim();
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
        stockCartController.add(TextEditingController(
            text: tempRate.toString()
        ));
        stockCartTotalList.add(tempRate);
        stockCartUomList.add(getBaseUom(name));
        stockCartListText.add(tempText.trim());
      });
    }

  }
  void removeFromCart(String text,String uom){
    String tempText='';
    for(int i=0;i<stockCartListText.length;i++) {
      List tempCart=stockCartListText[i].split(':');
      if (tempCart[0]==text) {
        List tempList =stockCartListText[i].split(
            ':');
        if (tempList[1].toString().trim() ==
            uom.toString().trim()) {
          double tempQuantity = double.parse(
              tempList[3]);
          tempQuantity = tempQuantity - 1;
          if (tempQuantity == 0 || tempQuantity.isNegative) {
            setState(() {
              stockCartTotalList.removeAt(i);
              stockCartController.removeAt(i);
              stockCartListText.removeAt(i);
              stockCartUomList.removeAt(i);
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
              stockCartTotalList[i] = tempRate;
              stockCartController[i].text = tempRate.toString();
              stockCartListText[i] = tempText.trim();
            });
            return;
          }
        }

      }
    }
  }
  void addQuantity(String text,String uom){
    String tempText='';
    for(int i=0;i<stockCartListText.length;i++) {
      List tempCart=stockCartListText[i].split(':');
      if (tempCart[0]==text) {
        List tempList = stockCartListText[i].split(
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
            stockCartTotalList[i] = tempRate;
            stockCartController[i].text = tempRate.toString();
            stockCartListText[i] = tempText.trim();
          });
          return;
        }
      }
    }
  }
  List<String> getUom(String productName){
    for(int i=0;i<productFirstSplit.length;i++){
      if(productFirstSplit[i].contains(productName)){
        List temp=productFirstSplit[i].split(':');
        List tempUom=temp[4].split('``');
        List tempUomSplit=tempUom[0].toString().split('*');
        tempUomSplit.removeLast();
        print('inisde get uom$tempUomSplit');
        return tempUomSplit;
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
  String getPrice(String productName,String uomName){
    print('uomName $uomName');
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
            print('inside if');
            String basePrice;
            if(tempPriceSplit[j].toString().trimLeft().contains('>')){
              List tempPriceListSplit=tempPriceSplit[j].toString().split('>');
              print(tempPriceListSplit);
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
  @override
  void initState() {
    // TODO: implement initState
    if(warehouseList.isNotEmpty){
     selectedTo.value=selectedFrom.value=warehouseList[0];
     warehouseProduct(selectedFrom.toString());
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width; //SUFYAN
    height = MediaQuery.of(context).size.height; //SUFYAN
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('STOCK TRANSFER',style: TextStyle(
            fontFamily: 'BebasNeue',
            letterSpacing: 2.0
        ),),
        titleSpacing: 0.0,
        backgroundColor: kGreenColor,
      ),
      body: Padding(
      //  padding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text('From Warehouse: ',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*16,
                          color: kAppBarItems
                      ),
                      ),
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
                              isDense: false,
                              value: selectedFrom.toString(), // Not necessary for Option 1
                              items: warehouseList.map((String val) {
                                return DropdownMenuItem(
                                  child: new Text(val.toString(),
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*16,
                                    ),
                                  ),
                                  value: val,
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                warehouseProduct(selectedFrom.toString());
                             selectedFrom.value = newValue;
                              },
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text('To Warehouse: ',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).textScaleFactor*16,
                          color: kAppBarItems
                      ),
                      ),
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
                              isDense: false,
                              value: selectedTo.toString(), // Not necessary for Option 1
                              items: warehouseList.map((String val) {
                                return DropdownMenuItem(
                                  child: new Text(val.toString(),
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor*16,
                                    ),
                                  ),
                                  value: val,
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                selectedTo.value = newValue;
                              },
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Container(
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                child: Obx(()=>SimpleAutoCompleteTextField(
                  style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor*14,
                ),
                focusNode: nameNode.value,
                decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    disabledBorder: OutlineInputBorder(
                    ),
                    enabledBorder: OutlineInputBorder(),
                    hintText: 'search for items'
                ),
                controller: nameController.value,
                suggestions: warehouseProducts.cast<String>(),
                clearOnSubmit: false,
                textSubmitted:  (text) {
                  _selectedItem=text;
                  if(allProducts.contains(_selectedItem)) {
                      nameController.value.text=_selectedItem;
                    quantityNode.value.requestFocus();
                  }
                  else
                  {
                    print('inside else');
                    barcodeEntry(_selectedItem);
                    nameController.value.clear();
                    nameNode.value.requestFocus();
                  }
                },
              )),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              child: Container(
                                child: Obx(()=>TextField(
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).textScaleFactor*14,
                                  ),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  focusNode: quantityNode.value,
                                  controller: quantityController,
                                  showCursor: enableQuantity,
                                  onSubmitted: (val){
                                    addFromSearch(_selectedItem, val);
                                    quantityController.clear();
                                    nameController.value.clear();
                                    nameNode.value.requestFocus();
                                  },
                                  decoration: new InputDecoration(
                                    hintText: 'quantity',
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(
                                    ),
                                    enabledBorder: OutlineInputBorder(),
                                  ),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          //controller:_scrollController,
                          scrollDirection: Axis.vertical,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: dataTable(
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                      if(selectedFrom.toString()==selectedTo.toString()){
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Same warehouse"),
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
                      else if(stockCartListText.isEmpty){
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Cart is empty"),
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
                        invNo=await getLastInv('stock');
                        List yourItemsList1=[];
                        String body='$stockPrefix$invNo~$selectedFrom~$selectedTo~$currentUser';
              for(int k=0;k<stockCartListText.length;k++){
              List temp=stockCartListText[k].split(':');
              String itemName=temp[0];
              String itemQty=temp[3];
              String itemUom=temp[1];
              yourItemsList1.add({
                "name":itemName,
                "uom":itemUom,
                "qty":itemQty,
                "category":getCategory(itemName),
              });
              stockTransfer(itemName, itemQty, selectedFrom.value, selectedTo.value);
              }
                        String title1 = 'abc'; //SUFYAN
                        generatePdf(yourItemsList1, body); //SUFYAN
                        create(body, 'stock_transfer', yourItemsList1);
                        updateInv('stock', invNo+1);
                        setState(() {
                          stockCartListText=[];
                        });


                      }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text('TRANSFER',
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
              ),
            ),
          ],
        ),
      ),
    ));
  }
  String getItem(int index,int itemNo){
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    List showCartItems=stockCartListText[index].split(':');
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
          DataColumn(label: Text('',
            style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor*20,
                color: kBlack
            ),)),
        ], rows: List.generate(stockCartListText.length, (index) => DataRow(cells: [
      DataCell(Text(getItem(index, 0),style: TextStyle(
          fontSize: MediaQuery.of(context).textScaleFactor*20,
          color: kBlack
      ),)),
      DataCell( DropdownButton(
        value: stockCartUomList[index].toString().trim(),// Not necessary for Option 1
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
          List showCartItems=stockCartListText[index].split(':');
          showCartItems[2]=tempPrice.trimLeft();
          showCartItems[3]='1';
          showCartItems[1]=newValue;
          String tempVal=showCartItems.toString().replaceAll(',', ':');
          tempVal=tempVal.substring(1,tempVal.length-1).replaceAll(new RegExp(r"\s+"), " ");
          print(tempVal);
          setState(() {
            stockCartTotalList[index]=double.parse(tempPrice.trimLeft());
            stockCartController[index].text=tempPrice.trimLeft();
            stockCartUomList[index] = newValue;
            stockCartListText[index]=tempVal;
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
      DataCell(IconButton(
        onPressed: (){
          setState(() {
            stockCartTotalList.removeAt(index);
            stockCartController.removeAt(index);
            stockCartListText.removeAt(index);
            stockCartUomList.removeAt(index);
          });
        },
        icon: Icon(Icons.delete),
      ))
    ])));
  }
}
