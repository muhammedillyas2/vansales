// import 'dart:convert';
// import 'package:restaurant_app/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:restaurant_app/screen/pos_screen.dart';
// import 'customer_screen.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:restaurant_app/components/database_con.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:whatsapp_unilink/whatsapp_unilink.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:restaurant_app/components/sqlite_db.dart';
// List<int> cartQuantity=[];
// TextEditingController customerNameController=TextEditingController();
// TextEditingController orderNoteController=TextEditingController();
// TextEditingController addressController=TextEditingController();
// String orderNote,customerName,address;
// class CartScreen extends StatefulWidget {
//     static const String id='cart';
//     @override
//     _CartScreenState createState() => _CartScreenState();
// }
// CustomerScreen customerScreen=CustomerScreen();
// Future<String> _onItemTapped()async{
//
//     double lat,long;
//     String orderList='';
//     orderList += '(Home Delivery)\n';
//
//     // Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     lat=position.latitude;
//     long=position.longitude;
//     print(position);
//
//
//     int totalItems = customerCart.length;
//     orderList += '\n Total items:$totalItems\n';
//     List items = [];
//     List quantity = [];
//     for(int i=0;i<customerCart.length;i++){
//         List temp=customerCart[i].split(':');
//         items.add(temp[0].toString().trim());
//         quantity.add(temp[3].toString().trim());
//     }
//     print(items);
//     print(quantity);
//     for (int n = 0;  n < totalItems; n++) {
//         orderList += '${n+1}. ${items[n]} x ${quantity[n]}\n';
//     }
//
//     orderList +=orderNote!=''? '\nOrder Note : \n$orderNote\n':'';
//     orderList += 'Name : \n$customerName \n';
//     orderList+=  'Address :\n$address\n';
//     orderList += '\n Location: \n https://www.google.com/maps?q=$lat,$long \n';
//     orderList += '\n *********** \n Please confirm via reply';
//     print(orderList);
//     return orderList;
//
// }
// void getQuantity(){
//     cartQuantity=[];
//     for(int i=0;i<customerCart.length;i++){
//         List temp=customerCart[i].split(':');
//         cartQuantity.add(int.parse(temp[3].toString().trim()));
//     }
// }
// class _CartScreenState extends State<CartScreen> {
//     void removeFromCart(String name,int index){
//         String temp='';
//         for(int i=0;i<customerCart.length;i++){
//             if(customerCart[i].contains(name)){
//                 List tempList=customerCart[i].split(':');
//                 print('tempList $tempList');
//                 int tempQty=int.parse(tempList[3].toString().trim());
//                 if(tempQty==1){
//                     setState(() {
//                         selectedProductImage.removeAt(i);
//                         customerCart.removeAt(i);
//                     });
//                     return;
//                 }
//                 tempQty--;
//                 setState(() {
//                     cartQuantity[index]=tempQty;
//                 });
//                 print('tempQty $tempQty');
//                 double tempPrice=double.parse(getBasePrice(name, 'price 1'));
//                 tempPrice=tempPrice*tempQty;
//                 print('tempPrice $tempPrice');
//                 temp='$name:${getBaseUom(name)}:$tempPrice:$tempQty';
//                 customerCart[i]=temp;
//                 return;
//             }
//         }
//     }
//     String getBasePrice(String productName, String priceList) {
//         String basePrice;
//         for (int i = 0; i < productFirstSplit.length; i++) {
//             if (productFirstSplit[i].contains(productName)) {
//                 List temp = productFirstSplit[i].split(':');
//                 List tempUom = temp[4].split('``');
//                 List tempUomSplit = tempUom[1].toString().split('*');
//
//                 if (tempUomSplit[0].toString().contains('>')) {
//                     List tempPriceListSplit = tempUomSplit[0].toString().split('>');
//                     int pos = int.parse(selectedPriceList.substring(6));
//                     pos = pos - 1;
//                     basePrice = tempPriceListSplit[pos];
//                 } else
//                     basePrice = tempUomSplit[0];
//                 return basePrice;
//             }
//         }
//     }
//     void addQuantity(String name,int index){
//         String temp='';
//         for(int i=0;i<customerCart.length;i++){
//             if(customerCart[i].contains(name)){
//                 List tempList=customerCart[i].split(':');
//                 print('tempList $tempList');
//                 int tempQty=int.parse(tempList[3].toString().trim());
//                 tempQty++;
//                 setState(() {
//                     cartQuantity[index]=tempQty;
//                 });
//                 print('tempQty $tempQty');
//                 double tempPrice=double.parse(getBasePrice(name, 'price 1'));
//                 tempPrice=tempPrice*tempQty;
//                 print('tempPrice $tempPrice');
//                 temp='$name:${getBaseUom(name)}:$tempPrice:$tempQty';
//                 customerCart[i]=temp;
//                 return;
//             }
//         }
//     }
//     double getTotal(){
//         double cartTotal=0;
//         for(int i=0;i<customerCart.length;i++){
//             List temp=customerCart[i].split(':');
//             cartTotal+=double.parse(temp[2].toString().trim());
//         }
//         return cartTotal;
//     }
//     String getBaseUom(String productName){
//         for(int i=0;i<productFirstSplit.length;i++){
//             if(productFirstSplit[i].contains(productName)){
//                 List temp=productFirstSplit[i].split(':');
//                 List tempUom=temp[4].split('``');
//                 List tempUomSplit=tempUom[0].toString().split('*');
//                 print('base uom ${tempUomSplit[0].toString().trim()}');
//                 return tempUomSplit[0].toString().trim();
//             }
//         }
//
//     }
//     @override
//     void initState() {
//         // TODO: implement initState
//
//         getQuantity();
//         super.initState();
//     }
//     @override
//     Widget build(BuildContext context) {
//         return SafeArea(
//             child: Scaffold(
//                 appBar: AppBar(
//                     leading: IconButton(
//                         icon: FaIcon(FontAwesomeIcons.store),
//                         onPressed: () {
//                             Navigator.popAndPushNamed(context, CustomerScreen.id);
//                             // Navigator.pop(context,MaterialPageRoute(builder: (_)=>CustomerScreen()));
//                         }),
//                     titleSpacing: 0,
//                     title: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                             Text('Back To Store',style: TextStyle(
//                                 fontSize: MediaQuery.of(context).textScaleFactor*13,)),
//                             Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text('YOUR CART',style: TextStyle(
//                                     fontSize: MediaQuery.of(context).textScaleFactor*15,letterSpacing: 1.0),
//                                 ),
//                             ),
//                         ],
//                     ),
//                     backgroundColor: kLightBlueColor,
//                 ),
//                 body: Column(
//                     children: [
//                         Expanded(
//                             child: SingleChildScrollView(
//                                 scrollDirection: Axis.vertical,
//                                 child: ListView.builder(
//                                     physics: ScrollPhysics(),
//                                     shrinkWrap: true,
//                                     scrollDirection: Axis.vertical,
//                                     itemCount: customerCart.length,
//                                     itemBuilder:(context,index){
//                                         List temp=customerCart[index].split(':');
//                                         return Card(
//                                             elevation: 3.0,
//                                             child: Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                         SizedBox(
//                                                             width: MediaQuery.of(context)
//                                                                 .size
//                                                                 .width /
//                                                                 4,
//                                                             height: MediaQuery.of(context)
//                                                                 .size
//                                                                 .height /
//                                                                 9,
//                                                             child: CircleAvatar(
//                                                                 backgroundImage : MemoryImage(base64Decode(
//                                                                     selectedProductImage[index])),
//                                                             )),
//                                                         Text('${temp[0].toString().trim()}',style: TextStyle(
//                                                             fontSize: MediaQuery.of(context).textScaleFactor*15,
//                                                         )),
//                                                         Column(
//                                                             children: [
//                                                                 SizedBox(
//                                                                     width: 100.0,
//                                                                     child: Row(
//                                                                         children: <Widget>[
//                                                                             Expanded(
//                                                                                 child: IconButton(
//                                                                                     icon: FaIcon(
//                                                                                         FontAwesomeIcons
//                                                                                             .minusCircle),
//                                                                                     color: kLightBlueColor,
//                                                                                     onPressed: () {
//                                                                                         removeFromCart(temp[0].toString().trim(), index);
//                                                                                     },
//                                                                                 ),
//                                                                             ),
//                                                                             AutoSizeText(
//                                                                                 cartQuantity[index]
//                                                                                     .toString()),
//                                                                             Expanded(
//                                                                                 child: IconButton(
//                                                                                     icon: FaIcon(
//                                                                                         FontAwesomeIcons
//                                                                                             .plusCircle),
//                                                                                     color: kLightBlueColor,
//                                                                                     onPressed: () {
//                                                                                         addQuantity(temp[0].toString().trim(),index);
//                                                                                     },
//                                                                                 ),
//                                                                             ),
//                                                                         ],
//                                                                     ),
//                                                                 ),
//                                                                 SizedBox(
//                                                                     height: 10.0,
//                                                                 ),
//                                                                 Text('\u{20B9} ${temp[2].toString().trim()}',style: TextStyle(
//                                                                     fontSize: MediaQuery.of(context).textScaleFactor*18,),)
//                                                             ],),
//
//                                                     ],
//                                                 ),
//                                             ),
//                                         );
//                                     }),
//                             ),
//                         ),
//                         Padding(
//                             padding: const EdgeInsets.only(left: 8.0,right: 8.0),
//                             child: SizedBox(
//
//                                 height: MediaQuery.of(context).size.height/11,
//                                 width: MediaQuery.of(context).size.width,
//                                 child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                         Text('Total',style: TextStyle(
//                                             fontSize: MediaQuery.of(context).textScaleFactor*22,letterSpacing: 1.0,color: Colors.black)),
//                                         Text('\u{20B9} ${getTotal()}',style: TextStyle(
//                                             fontSize: MediaQuery.of(context).textScaleFactor*22,letterSpacing: 1.0,color: Colors.black)),
//                                     ],
//                                 ),
//                             ),
//                         ),
//                         SizedBox(
//                             height: MediaQuery.of(context).size.height/11,
//                             width: MediaQuery.of(context).size.width,
//                             child: GestureDetector(
//                                 onTap: () async {
//                                     await showDialog(context: context, builder: (context)=>Dialog(
//                                         child: SingleChildScrollView(
//                                             child:  Container(
//                                                 padding: EdgeInsets.all(8.0),
//                                                 child: Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//
//                                                         Text('Name'),
//                                                         TextField(
//                                                             controller: nameController,
//
//                                                             onChanged: (value){
//                                                                 customerName=value;
//                                                                 print(customerName);
//                                                             },
//                                                             keyboardType: TextInputType.name,
//                                                             decoration: InputDecoration(
//                                                                 errorText: nameController.text.isEmpty?'Please Enter Your Name' : null,
//                                                                 border: OutlineInputBorder(),
//                                                                 labelText: 'Enter your Name'
//                                                             ),
//                                                         ),
//
//                                                         Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                             children: [
//                                                                 Text('Address'),
//                                                                 TextField(
//                                                                     onSubmitted: (value){
//                                                                         address=value;
//                                                                         print(address);
//                                                                     },
//                                                                     decoration: InputDecoration(
//                                                                         border: OutlineInputBorder(),
//                                                                         labelText: 'Enter your Address for Home Delivery'
//                                                                     ),),
//                                                             ],
//                                                         ),
//
//                                                         Text('Order Note'),
//                                                         TextField(
//                                                             onChanged: (value){
//                                                                 orderNote=value;
//                                                                 print(orderNote) ;
//                                                             },
//                                                             decoration: InputDecoration(
//                                                                 border: OutlineInputBorder(),
//                                                                 labelText: 'Order Notes'
//                                                             ),
//                                                         ),
//                                                         Align(
//                                                             alignment: Alignment.bottomRight,
//                                                             child: TextButton(onPressed: () async {
//                                                                 int invNo=await getCustomerInvoiceNo();
//                                                                 print('invNo $invNo');
//                                                                 String tempCart='';
//                                                                 if(customerCart.length>1){
//                                                                     tempCart=customerCart.toString().replaceAll(',', '>');
//                                                                     print('tempCart $tempCart');
//                                                                 }
//                                                                 else{
//                                                                     tempCart=customerCart.toString();
//                                                                 }
//                                                                 String body='CI$invNo~${dateNow()}~standard~$tempCart~${getTotal()}';
//                                                                 await insertData(body, 'customer_checkout');
//                                                                 String data=await _onItemTapped();
//                                                                 print('data $data');
//                                                                 //launchWhatsApp(data) ;
//                                                                 //FlutterOpenWhatsapp.sendSingleMessage("919995005656", data);
//                                                                 setState(() {
//                                                                     customerCart=[];
//                                                                 });
//                                                                 Navigator.pop(context);
//                                                             },
//                                                                 child: Container(
//                                                                     padding: EdgeInsets.all(8.0),
//                                                                     color: Colors.teal,
//                                                                     child: Text('SAVE',style: TextStyle(
//                                                                         letterSpacing: 1.5,
//                                                                         fontSize: MediaQuery.of(context).textScaleFactor*20,
//                                                                         color: kBlack,
//                                                                     ),),
//                                                                 )),
//                                                         )
//                                                     ],
//                                                 ),
//                                             ),
//                                         ),
//                                     ));
//                                 },
//                                 child: Card(
//                                     color: kLightBlueColor,
//                                     child: Center(
//                                         child: Text('Place Order',style: TextStyle(
//                                             fontSize: MediaQuery.of(context).textScaleFactor*22,letterSpacing: 1.0,color: kWhiteColor),textAlign: TextAlign.center,),
//                                     ),
//                                 ),
//                             ),
//                         )
//                     ],
//                 ),
//             ),
//         );
//     }
// }
//
// launchWhatsApp(String tex) async {
//     final link = WhatsAppUnilink(
//         phoneNumber: '+91-9995005656',
//         text: tex,
//     );
//     // Convert the WhatsAppUnilink instance to a string.
//     // Use either Dart's string interpolation or the toString() method.
//     // The "launch" method is part of "url_launcher".
//     await launch('$link');
// }
//
// Future<int> getCustomerInvoiceNo()async {
//     print('inside');
//     String tempLastInvoiceNo;
//     List invoiceDataList1=[];
//     List invoiceDataList=[];
//     try{
//         invoiceDataList=await getData('customer_checkout');
//     }
//     catch(e){
//     }
//     print('invoiceDataList $invoiceDataList');
//     int inv=invoiceDataList.length;
//     print('inv $inv');
//     if(inv==0)
//         return 1;
//     else
//         return inv+1;
//     // if(invoiceDataList.isNotEmpty){
//     //   for(int i=0;i<invoiceDataList.length;i++){
//     //     invoiceDataList1.add(invoiceDataList[i].toString().substring(1,invoiceDataList[i].toString().length-1));
//     //   }
//     //   int end=invoiceDataList1.length-1;
//     //   List eachOrder=invoiceDataList1[end].toString().split(',');
//     //   tempLastInvoiceNo=eachOrder[1].toString().trim();
//     //   salesOrderNo = int.parse(tempLastInvoiceNo.trim().replaceAll(RegExp('[^0-9]'), ''))+1;
//     // }
//     // else{
//     //   salesOrderNo=int.parse(salesFrom);
//     // }
//     // print('salesOrderNo $salesOrderNo');
// }