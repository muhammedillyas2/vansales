// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:restaurant_app/components/database_con.dart';
//
// import '../constants.dart';
// class KaboozPrinter extends StatefulWidget {
// static const String id='kabooz';
//   @override
//   _KaboozPrinterState createState() => _KaboozPrinterState();
// }
// PrinterBluetoothManager printerManager = PrinterBluetoothManager();
// PrinterBluetooth selectedPrinter;
// List<PrinterBluetooth> _devices = [];
// void bluetoothPrint(List cartList,String invNo,discount) async {
//   printerManager.selectPrinter(selectedPrinter);
//
//   // TODO Don't forget to choose printer's paper
//   final PosPrintResult res =
//   await printerManager.printTicket(await checkoutReceipt(cartList,invNo,discount));
//
//   //showToast(res.msg);
// }
// Future<Ticket> checkoutReceipt(List cartListText,String invNo,String discount) async {
//   const PaperSize paper = PaperSize.mm58;
//   final Ticket ticket = Ticket(paper);
//
//   // Print image
//   // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
//   // final Uint8List bytes = data.buffer.asUint8List();
//   // final Image image = decodeImage(bytes);
//   // ticket.image(image);
//
//   ticket.text('KABOOZ',
//       styles: PosStyles(
//         align: PosAlign.center,
//         height: PosTextSize.size2,
//         width: PosTextSize.size2,
//       ),
//       linesAfter: 1);
//   String dateNow(){
//     final now = DateTime.now();
//     final formatter = DateFormat('MM/dd/yyyy H:m');
//     final String timestamp = formatter.format(now);
//     return timestamp;
//   }
//   ticket.text('KANNADIPARAMBA,KANNUR,India', styles: PosStyles(align: PosAlign.center));
//   //ticket.text('KANNUR,India', styles: PosStyles(align: PosAlign.center));
//   ticket.text('Ph :9947774777', styles: PosStyles(align: PosAlign.center));
//   ticket.hr();
//   ticket.text('Invoice No:$invNo',
//       styles: PosStyles(align: PosAlign.left),);
//   ticket.text('Date:${dateNow()}',
//       styles: PosStyles(align: PosAlign.left),);
//   ticket.hr();
//   ticket.text('Item',
//     styles: PosStyles(align: PosAlign.left),);
//   ticket.row([
//     PosColumn(text: 'Price', width: 4),
//     PosColumn(text: 'Qty', width: 4),
//     PosColumn(
//         text: 'Total', width: 4, styles: PosStyles(align: PosAlign.right)),
//   ]);
//   double grandTotal=0;
//   for(int i=0;i<cartListText.length;i++)
//   {
//     // print(cartListText);
//     List cartItemsString=cartListText[i].split(':');
//     double tempTotal=double.parse(cartItemsString[2]);
//     grandTotal+=tempTotal;
//     print('grandTotal $grandTotal');
//     ticket.text('${cartItemsString[0]}',
//       styles: PosStyles(align: PosAlign.left),);
//     double tempPrice=double.parse(cartItemsString[2])/double.parse(cartItemsString[3]);
//     ticket.row([
//       PosColumn(text: '$tempPrice', width: 4),
//       PosColumn(text: '${cartItemsString[3]}', width: 4),
//       PosColumn(
//           text: '${cartItemsString[2]}', width: 4, styles: PosStyles(align: PosAlign.right)),
//     ]);
//   }
//   ticket.hr();
//   double temp=grandTotal-double.parse(discount);
//   ticket.row([
//     PosColumn(text: 'GRAND TOTAL', width: 6 ,styles: PosStyles(bold: true)),
//     PosColumn(text: '$grandTotal', width: 6,styles: PosStyles(bold: true,align: PosAlign.right)),
//   ]);
//   ticket.row([
//     PosColumn(text: 'DISCOUNT', width: 6,styles: PosStyles(bold: true)),
//     PosColumn(text: '${double.parse(discount)}', width: 6,styles: PosStyles(bold: true,align: PosAlign.right)),
//   ]);
//   ticket.row([
//     PosColumn(
//         text: 'NET TOTAL', width: 6,styles: PosStyles(bold: true)),
//     PosColumn(
//         text: '$temp', width: 6,styles: PosStyles(bold: true,align: PosAlign.right)),
//   ]);
//
//
//   // ticket.text('GRAND TOTAL             $grandTotal', styles: PosStyles(align: PosAlign.left,height: PosTextSize.size1,
//   //     width: PosTextSize.size1),);
//   // ticket.text('DISCOUNT                ${double.parse(discount)}', styles: PosStyles(align: PosAlign.left,height: PosTextSize.size1,
//   //     width: PosTextSize.size1),);
//   //
//   // ticket.text('NET TOTAL               $temp', styles: PosStyles(align: PosAlign.left,height: PosTextSize.size1,
//   //     width: PosTextSize.size1),);
//   ticket.hr();
//   ticket.cut();
//   return ticket;
// }
// void checkPrinter(){
//   printerManager.scanResults.listen((devices) async {
//     // print('UI: Devices found ${devices.length}');
//     for(int i=0;i<devices.length;i++){
//       if(bluetoothAddress==devices[i].address) {
//         selectedPrinter=devices[i];
//         print('contains ');
//       }
//     }
//   });
//   printerManager.startScan(Duration(seconds: 4));
//
// }
// class _KaboozPrinterState extends State<KaboozPrinter> {
//   void _startScanDevices() {
//     setState(() {
//       _devices = [];
//     });
//     printerManager.scanResults.listen((devices) async {
//       // print('UI: Devices found ${devices.length}');
//       setState(() {
//         _devices = devices;
//       });
//     });
//     printerManager.startScan(Duration(seconds: 4));
//     // setState(() {
//     //   _devices.add(_devices);
//     // });
//     print('inside scan $_devices');
//   }
//
//   void _stopScanDevices() {
//     printerManager.stopScan();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kLightBlueColor,
//       ),
//       body: Container(
//         padding: EdgeInsets.all(10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Bluetooth Printer',style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: MediaQuery.of(context).textScaleFactor*20,
//           ),),
//               MaterialButton(
//                 onPressed: (){
//                   _startScanDevices();
//                 },
//                 color: kLightBlueColor,
//                 child: Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text('SCAN'),
//                 ),
//               ),
//               Container(
//                 child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: _devices.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return InkWell(
//                         onTap: () {
//                           selectedPrinter=_devices[index];
//                           String body=selectedPrinter.address;
//                           insertData(body, 'bluetooth_data');
//                         },
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               height: 60,
//                               padding: EdgeInsets.only(left: 10),
//                               alignment: Alignment.centerLeft,
//                               child: Row(
//                                 children: <Widget>[
//                                   Icon(Icons.print),
//                                   SizedBox(width: 10),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         Text(_devices[index].name ?? ''),
//                                         Text(_devices[index].address),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Divider(),
//                           ],
//                         ),
//                       );
//                     }),
//               ),
//             ],
//           )
//       ),
//     );
//   }
// }
