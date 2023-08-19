import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/components/firebase_con.dart';
import 'package:restaurant_app/screen/pos_screen.dart';
// import 'package:sunmi_printer_plus/column_maker.dart';
// import 'package:sunmi_printer_plus/enums.dart';
// import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
// import 'package:sunmi_printer_plus/sunmi_style.dart';
import '../constants.dart';
import 'login_page.dart';
import 'package:get/get.dart';

import 'organisation_screen.dart';

RxString selectedUser=currentUser.obs;
RxString selectedPayment='Cash'.obs;
String selectedDelivery='Dine In';
RxString selectedDeliveryBoy=''.obs;
List<String> paymentMode=['*'];
List<String> deliveryMode=['*','Dine In','Take Away','Drive Through','QSR','Delivery'];
List<String> displayList=[];
DateTime  fromDate;
DateTime toDate =DateTime.now();
String dateFrom='',dateTo='';
int toDate1=0;
int fromDate1=0;
var datePicked;
class StreamReports extends StatefulWidget {
  final String transactionType;
  static const String id='stream_reports';

  const StreamReports({Key key, this.transactionType}) : super(key: key);
  @override
  _StreamReportsState createState() => _StreamReportsState(transactionType);
}
Future<Uint8List> arabicPdf( int date,List items,String inv,String customer,double total,double discount,double tempTax,double billAmount,String taxDetails,int len,String tempPayment,String tempTotal,String mode,String user,String tempUid)async{
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
                pw.Text(' : ${convertEpox(date).substring(0,16)}',textScaleFactor: 0.8,style: pw.TextStyle(
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
                pw.Text(' : $user',textScaleFactor: 0.8,style: pw.TextStyle(
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
                pw.Text(' : ${customer!='Standard'?customer:'Standard' }',textScaleFactor:0.8,style: pw.TextStyle(
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
                pw.Text(' : ${customer!='Standard'?customerVatNo[customerList.indexOf(customer)]:'' }',textScaleFactor:0.8,style: pw.TextStyle(
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

  // if(mode=='share'){
  //   html.AnchorElement(
  //       href:
  //       "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
  //     ..setAttribute("download", "$inv${dateNow()}.pdf")
  //     ..click();
  // }
  // else{
  //   html.AnchorElement(
  //       href:
  //       "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
  //     ..setAttribute("download", "PSlipasd.pdf")
  //     ..click();
  // }

}
Future<Uint8List> restaurantPdf( int date,List items,String inv,String customer,double total,double discount,double tempTax,double billAmount,String taxDetails,int len,String tempPayment,String tempTotal,String mode,String user,String tempUid)async{

  print('inside res pdf tempUid $tempUid');
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
  if(tempUid.length>0){
    DocumentSnapshot doc2=await firebaseFirestore.collection('customer_details').doc(tempUid).get();
    if(doc2['mobile'].length>0)
      rows3.add(pw.TableRow(
          children:[
            pw.Text('Mobile No : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.SizedBox(width:100,
              child: pw.Text(doc2['mobile'],textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ),
          ]
      ));
    if(doc2['address'].length>0)
      rows3.add(pw.TableRow(
          children:[
            pw.Text('Address : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.SizedBox(width:100,
              child: pw.Text(doc2['address'],textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ),
          ]
      ));
    if(doc2['flatNo'].length>0)
      rows3.add(pw.TableRow(
          children:[
            pw.Text('Flat No : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.SizedBox(width:100,
              child: pw.Text(doc2['flatNo'],textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ),
          ]
      ));
    if(doc2['buildNo'].length>0)
      rows3.add(pw.TableRow(
          children:[
            pw.Text('Build No : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.SizedBox(width:100,
              child: pw.Text(doc2['buildNo'],textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ),
          ]
      ));
    if(doc2['roadNo'].length>0)
      rows3.add(pw.TableRow(
          children:[
            pw.Text('Road No : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.SizedBox(width:100,
              child: pw.Text(doc2['roadNo'],textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ),
          ]
      ));
    if(doc2['blockNo'].length>0)
      rows3.add(pw.TableRow(
          children:[
            pw.Text('Block No : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.SizedBox(width:100,
              child: pw.Text(doc2['blockNo'],textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ),
          ]
      ));
    if(doc2['area'].length>0)
      rows3.add(pw.TableRow(
          children:[
            pw.Text('Area : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.SizedBox(width:100,
              child: pw.Text(doc2['area'],textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ),
          ]
      ));
    if(doc2['landmark'].length>0)
      rows3.add(pw.TableRow(
          children:[
            pw.Text('Landmark : ',textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
            pw.SizedBox(width:100,
              child: pw.Text(doc2['landmark'],textScaleFactor: 0.8,textAlign:pw.TextAlign.left,style: pw.TextStyle(
                  font:fontNo
              )),
            ),
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

print('before top');
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
          pw.Text('Created on : ${convertEpox(date).substring(0,16)}',textScaleFactor: 0.8,style: pw.TextStyle(
            // fontWeight: pw.FontWeight.bold
          )),
          space2,
          pw.Text('Sales person : $user',textScaleFactor: 0.8,style: pw.TextStyle(
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
                pw.Text(' : ${customer!='Standard'?customerVatNo[customerList.indexOf(customer)]:'' }',textScaleFactor:0.8,style: pw.TextStyle(
                  // fontWeight: pw.FontWeight.bold
                )),
              ]),
          space1,

          if(selectedBusiness=='Restaurant')
            pw.Text('Order Mode : ${selectedDelivery=='Spot'?'Dine In':selectedDelivery}',textScaleFactor: 0.8,style: pw.TextStyle(
              // fontWeight: pw.FontWeight.bold
            )),
          space1,
          if(tempUid.length>0)
            pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                border: pw.TableBorder(top: pw.BorderSide(color: PdfColors.black, width: 0.5), bottom: pw.BorderSide(color: PdfColors.black, width: 0.5)),
                // textDirection: pw.TextDirection.ltr,
                // border:pw.TableBorder.all(width: 1.0,color: PdfColors.black),
                children: rows3),
          if(tempUid.length>0)
            space1,
          pw.Container(height:0.5,color:PdfColors.black),
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
                    width:70,
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
  // if(mode=='share'){
  //   html.AnchorElement(
  //       href:
  //       "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
  //     ..setAttribute("download", "$inv${dateNow()}.pdf")
  //     ..click();
  // }
  // else{
  //   html.AnchorElement(
  //       href:
  //       "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
  //     ..setAttribute("download", "PSlipasd.pdf")
  //     ..click();
  // }
}
Future<Uint8List> retailPdf(int date,List items,String inv,String customer,double total,double discount,double tempTax,double billAmount,String taxDetails,int len,String tempPayment,String tempTotal,String mode) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5,);
  final fontNo = await PdfGoogleFonts.oswaldBold();
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
                        if (customer!='Standard')
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
                              pw.Text('Date : ${convertEpox(date).substring(0,16)}',textScaleFactor:0.6,style: pw.TextStyle(
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
                                  child:pw.Text('$organisationSymbol ${total.toStringAsFixed(decimals)}',textScaleFactor: 0.8),
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
      // if(mode=='share'){
      //   html.AnchorElement(
      //       href:
      //       "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      //     ..setAttribute("download", "inv${dateNow()}.pdf")
      //     ..click();
      // }
      // else{
      //   html.AnchorElement(
      //       href:
      //       "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      //     ..setAttribute("download", "PSlipasd.pdf")
      //     ..click();
      // }
      return doc.save();
    },
  );
}
Future networkPrint(String invNo,NetworkPrinter printer,String date,String customer,String discount,List tempItemList)async{
  double tax5=0;
  double tax10=0;
  double tax12=0;
  double tax18=0;
  double tax28=0;
  double cess=0;
  double invTotal=0;
  double tempTax=0;
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
  printer.text('Invoice No: $invNo',
      styles: PosStyles(align: PosAlign.left,bold: true));
  printer.text(date,
      styles: PosStyles(align: PosAlign.left,bold:true));
   if (customer!='Standard'){
    printer.text('Customer Name: $customer',
        styles: PosStyles(align: PosAlign.left,bold: true));
    if(allCustomerAddress[customerList.indexOf(customer)].length>0)
      printer.text('Customer Address: ${allCustomerAddress[customerList.indexOf(customer)]}',
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
  invTotal=0;double exclTotal =0;
  tempTax=0;
  for(int i=0;i<tempItemList.length;i++)
  {
    List cartItemsString = tempItemList[i].split(':');
    double tempTotal = double.parse(cartItemsString[2]);
    String tax = getTaxName(cartItemsString[0].toString().trim());
    double amt = double.parse(cartItemsString[2]);
    double price = double.parse(cartItemsString[2]) /
        double.parse(cartItemsString[3]);
    amt = double.parse((amt).toStringAsFixed(3));
    invTotal += amt;
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
        tempTax+=tax5;
      }
      if (tax.trim() == 'GST 10') {
        tax10 =  tax10 + amt-amt/1.1;
        tempTax+=tax10;
      }

      if (tax.trim() == 'GST 12') {
        tax12 += (double.parse(getPercent(tax)) / 100) * price;
        tempTax+=tax12;
      }
      if (tax.trim() == 'GST 18') {
        tax18 += (double.parse(getPercent(tax)) / 100) * price;
        tempTax+=tax18;
      }
      if (tax.trim() == 'GST 28') {
        tax28 += (double.parse(getPercent(tax)) / 100) * price;
        cess += (12 / 100) * price;
        tempTax+=tax28+cess;
      }
      print('${cartItemsString[0]} totalTax $tempTax   tax $tax');
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
  if(organisationTaxType=='VAT'){
    exclTotal = invTotal - tax10;
    printer.row([
      PosColumn(text: 'Bill Amount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
      PosColumn(text: '${exclTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
    ]);

    printer.row([
      PosColumn(text: 'Vat 10%', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
      PosColumn(text: '${tax10.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
    ]);

    invTotal = exclTotal + tax10;

    printer.row([
      PosColumn(text: 'Net Payable', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
      PosColumn(text: '$organisationSymbol ${invTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
    ]);

  }

  else{

    if(organisationGstNo.length>0){
      exclTotal = invTotal - tempTax;
      printer.row([
        PosColumn(text: 'Bill Amount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
        PosColumn(text: '${exclTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
      ]);
      if(tempTax>0){
        printer.row([
          PosColumn(text: 'Total Tax', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '${tempTax.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
        ]);
      }

      if(double.parse(discount)>0){
        printer.row([
          PosColumn(text: 'Discount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '${double.parse(discount).toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
        ]);
        invTotal = invTotal - double.parse(discount);
      }
      printer.row([
        PosColumn(text: 'Net Payable', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
        PosColumn(text: '$organisationSymbol ${invTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
      ]);
      if(tempTax>0)
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
      if(double.parse(discount)>0){
        printer.row([
          PosColumn(text: 'Bill Amount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '${invTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
        ]);
        printer.row([
          PosColumn(text: 'Discount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '${double.parse(discount).toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
        ]);
        invTotal = invTotal - double.parse(discount);

        printer.row([
          PosColumn(text: 'Net Payable', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '$organisationSymbol ${invTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
        ]);
      }
      else{
        printer.row([
          PosColumn(text: 'Bill Amount', width: 6,styles: PosStyles(bold:true,align: PosAlign.left,)),
          PosColumn(text: '$organisationSymbol ${invTotal.toStringAsFixed(decimals)}', width: 6,styles: PosStyles(bold:true,align: PosAlign.right)),
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
// void sunmiT1Print(String invNo,String date,String customer,String discount,List tempItemList)async{
//   double tax5=0;
//   double tax10=0;
//   double tax12=0;
//   double tax18=0;
//   double tax28=0;
//   double cess=0;
//   double invTotal=0;
//   double tempTax=0;
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
//   await SunmiPrinter.printText('Invoice No:$invNo',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//   await SunmiPrinter.printText('Date:$date',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//   if (appbarCustomerController.text.length>0){
//     await SunmiPrinter.printText('Customer Name:$customer',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
//     if(allCustomerAddress[customerList.indexOf(appbarCustomerController.text)].length>0)
//       await SunmiPrinter.printText('Customer Address:${allCustomerAddress[customerList.indexOf(customer)]}',style: SunmiStyle(bold: true,align: SunmiPrintAlign.LEFT));
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
//   invTotal=0;double exclTotal =0;
//   totalTax=0;
//   for(int i=0;i<tempItemList.length;i++) {
//     List cartItemsString = tempItemList[i].split(':');
//     double tempTotal = double.parse(cartItemsString[2]);
//     String tax = getTaxName(cartItemsString[0].toString().trim());
//     double amt = double.parse(cartItemsString[2]);
//     double price = double.parse(cartItemsString[2]) /
//         double.parse(cartItemsString[3]);
//     amt = double.parse((amt).toStringAsFixed(3));
//     invTotal += amt;
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
//       ColumnMaker(text: price.toStringAsFixed(3), width: 5,),
//       if(organisationGstNo.length>0)
//         ColumnMaker(text: getPercent(tax), width: 4,),
//       ColumnMaker(text: double.parse(cartItemsString[2].toString()).toStringAsFixed(
//           3), width: 6, align: SunmiPrintAlign.RIGHT),
//     ]);
//   }
//   await SunmiPrinter.line();
//   if(organisationTaxType=='VAT') {
//     exclTotal = invTotal - tax10;
//     await SunmiPrinter.printRow(cols: [
//       ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//       ColumnMaker(text:exclTotal.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//     ]);
//     await SunmiPrinter.printRow(cols: [
//       ColumnMaker(text: 'Vat 10%', width: 14, align: SunmiPrintAlign.LEFT),
//       ColumnMaker(text:tax10.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//     ]);
//     invTotal = exclTotal + tax10;
//     await SunmiPrinter.printRow(cols: [
//       ColumnMaker(text: 'Net Payable', width: 14, align: SunmiPrintAlign.LEFT),
//       ColumnMaker(text:'$organisationSymbol ${invTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//     ]);
//   }
//   else{
//     if(organisationGstNo.length>0) {
//       exclTotal = invTotal - totalTax;
//       await SunmiPrinter.printRow(cols: [
//         ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//         ColumnMaker(text:exclTotal.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//       ]);
//       await SunmiPrinter.printRow(cols: [
//         ColumnMaker(text: 'Total Tax', width: 14, align: SunmiPrintAlign.LEFT),
//         ColumnMaker(text:totalTax.toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//       ]);
//       if(double.parse(discount)>0){
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Discount', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:double.parse(discount).toStringAsFixed(decimals), width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//         invTotal = invTotal -  double.parse(discount);
//       }
//       await SunmiPrinter.printRow(cols: [
//         ColumnMaker(text: 'Net Payable', width: 14, align: SunmiPrintAlign.LEFT),
//         ColumnMaker(text:'$organisationSymbol ${invTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
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
//         invTotal = invTotal - double.parse(discount);
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Net Payable', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:'$organisationSymbol ${invTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//       }
//       else{
//         await SunmiPrinter.printRow(cols: [
//           ColumnMaker(text: 'Bill Amount', width: 14, align: SunmiPrintAlign.LEFT),
//           ColumnMaker(text:'$organisationSymbol ${invTotal.toStringAsFixed(decimals)}', width: 14, align: SunmiPrintAlign.RIGHT),
//         ]);
//       }
//     }
//   }
//   if(organisationGstNo.length>0)  await SunmiPrinter.line();
//   await SunmiPrinter.printText('Thank You,Visit Again',style: SunmiStyle(bold: true,align: SunmiPrintAlign.CENTER));
//   await SunmiPrinter.lineWrap(5);
//   await SunmiPrinter.exitTransactionPrint(true);
// }
class _StreamReportsState extends State<StreamReports> {
  RxDouble cashTotal=0.0.obs;
  RxDouble cardTotal=0.0.obs;
  RxDouble creditTotal=0.0.obs;
  RxDouble upiTotal=0.0.obs;
  RxDouble total=0.0.obs;
  Rx<List<double>> salesAmount=RxList<double>([]).obs;
int orderIndex=0;
  final String transactionType;
  _StreamReportsState(this.transactionType);
  @override
  void initState() {
    // TODO: implement initState
    fromDate=beginDate;
    toDate =DateTime.now();
    fromDate1=dateNowDash;
    toDate1=DateTime.now().millisecondsSinceEpoch;
    selectedDelivery=selectedBusiness=='Restaurant'?selectedDelivery:'*';
    selectedDeliveryBoy.value=deliveryBoyList.isEmpty?'':deliveryBoyList[0];
    paymentMode=paymentMode+mainPaymentList;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double currentWidth=MediaQuery.of(context).size.width;
    TextStyle kStyle=TextStyle(
      fontSize: MediaQuery.of(context).textScaleFactor*20,
    );
    return MaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      builder: (context,widget)=>SafeArea(child: Scaffold(
        appBar: AppBar(
          title: Text('SALES REPORT',style: TextStyle(
              fontFamily: 'BebasNeue',
              letterSpacing: 2.0
          ),),
          titleSpacing: 0.0,
          backgroundColor: kGreenColor,
          automaticallyImplyLeading: true,

        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child:currentWidth>600? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(children: [
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
                             var s = datePicked;
                              String a=s.toString().substring(0,10);
                              fromDate=DateTime.parse('$a 0$orgClosedHour:00:00');
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

                                  Text(fromDate!=null?fromDate.toString().substring(0,16):"",style: TextStyle(color: kGreenColor),)
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
                            var s = datePicked;
                            String a=s.toString().substring(0,10);
                            toDate=DateTime.parse('$a 0$orgClosedHour:00:00');
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
                                Text(toDate.toString().substring(0,16),style: TextStyle(color: kGreenColor),),
                              ],
                            ),
                          ),
                        ),
                      ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: kAppBarItems,
                                  style: BorderStyle.solid,
                                  width: 1.5),
                            ),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: Obx(()=> DropdownButton(
                                icon:FaIcon(FontAwesomeIcons.userAlt),
                                underline: SizedBox(),
                                value: selectedUser.value, // Not necessary for Option 1
                                items: tempUserList.map((String val) {
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: new Text(val.toString(),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor*20,
                                            color: kGreenColor
                                        ),
                                      ),
                                    ),
                                    value: val,
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  selectedUser.value = newValue;
                                },
                              )),
                            ),
                          ),
                          SizedBox(width: 20,),
                          if(selectedBusiness=='Restaurant')
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: kAppBarItems,
                                  style: BorderStyle.solid,
                                  width: 1.5),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton(
                                  // isDense: true,
                                  icon:FaIcon(FontAwesomeIcons.box) ,
                                  underline: SizedBox(),
                                  value: selectedDelivery, // Not necessary for Option 1
                                  items: deliveryMode.map((String val) {
                                    return DropdownMenuItem(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: new Text(val.toString(),
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                                              color: kGreenColor
                                          ),
                                        ),
                                      ),
                                      value: val,
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedDelivery= newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Obx(()=>DropdownButton(
                          //   icon:Icon(Icons.account_circle_rounded) ,
                          //   underline: SizedBox(),
                          //   value: selectedPayment.value, // Not necessary for Option 1
                          //   items: paymentMode.map((String val) {
                          //     return DropdownMenuItem(
                          //       child: new Text(val.toString(),
                          //         style: TextStyle(
                          //             fontSize: MediaQuery.of(context).textScaleFactor*20,
                          //             color: kGreenColor
                          //         ),
                          //       ),
                          //       value: val,
                          //     );
                          //   }).toList(),
                          //   onChanged: (newValue) {
                          //     selectedPayment.value = newValue;
                          //     selectedUser.value = selectedUser.value;
                          //   },
                          // ),),
                          // SizedBox(width: 20,),
                          // Obx(()=>DropdownButton(
                          //   icon:Icon(Icons.account_circle_rounded) ,
                          //   underline: SizedBox(),
                          //   value: selectedDelivery.value, // Not necessary for Option 1
                          //   items: deliveryMode.map((String val) {
                          //     return DropdownMenuItem(
                          //       child: new Text(val.toString(),
                          //         style: TextStyle(
                          //             fontSize: MediaQuery.of(context).textScaleFactor*20,
                          //             color: kGreenColor
                          //         ),
                          //       ),
                          //       value: val,
                          //     );
                          //   }).toList(),
                          //   onChanged: (newValue) {
                          //     selectedDelivery.value = newValue;
                          //   },
                          // ),),
                          // SizedBox(width: 20,),
                          // Obx(()=>DropdownButton(
                          //   icon:Icon(Icons.account_circle_rounded) ,
                          //   underline: SizedBox(),
                          //   value: selectedDeliveryBoy.value, // Not necessary for Option 1
                          //   items: deliveryBoyList.map((String val) {
                          //     return DropdownMenuItem(
                          //       child: new Text(val.toString().trim(),
                          //         style: TextStyle(
                          //             fontSize: MediaQuery.of(context).textScaleFactor*20,
                          //             color: kGreenColor
                          //         ),
                          //       ),
                          //       value: val,
                          //     );
                          //   }).toList(),
                          //   onChanged: (newValue) {
                          //     print('selectedDelivery ${selectedDelivery.value}');
                          //     print('deliveryBoyList $deliveryBoyList');
                          //     selectedDeliveryBoy.value = newValue;
                          //   },
                          // ),),
                        ],
                      ),
                    ],
                  ),
                ],
              ):
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(currentTerminal=='Owner')
                    Obx(()=> DropdownButton(
                      icon:Icon(Icons.account_circle_rounded) ,
                      underline: SizedBox(),
                      value: selectedUser.value, // Not necessary for Option 1
                      items: userList.map((String val) {
                        return DropdownMenuItem(
                          child: new Text(val.toString(),
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                color: kGreenColor
                            ),
                          ),
                          value: val,
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        selectedUser.value = newValue;
                      },
                    )),

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
                        var s = datePicked;
                        String a=s.toString().substring(0,10);
                        fromDate=DateTime.parse('$a 0$orgClosedHour:00:00');
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

                            Text(fromDate!=null?fromDate.toString().substring(0,16):"",style: TextStyle(color: kGreenColor),)
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
                      var s = datePicked;
                      String a=s.toString().substring(0,10);
                      toDate=DateTime.parse('$a 0$orgClosedHour:00:00');
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
                          Text(toDate.toString().substring(0,16),style: TextStyle(color: kGreenColor),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Obx(()=>StreamBuilder(
                    stream:  selectedUser.value=='*'?firebaseFirestore.collection('invoice_data').where('date',isGreaterThanOrEqualTo: fromDate1)
                        .where('date',isLessThanOrEqualTo: toDate1)
                        .orderBy('date',descending: true) .snapshots():firebaseFirestore.collection('invoice_data').where('date',isGreaterThanOrEqualTo: fromDate1)
                        .where('date',isLessThanOrEqualTo: toDate1)
                        .where('user',isEqualTo:selectedUser.value)
                        .orderBy('date',descending: true) .snapshots(),
                    // stream:  getStream(selectedUser.value, selectedDelivery.value),
                    // stream:selectedBusiness=='Restaurant'?
                    // firebaseFirestore.collection('$transactionType').where('date',isGreaterThanOrEqualTo: fromDate1)
                    //     .where('date',isLessThanOrEqualTo: toDate1)
                    //     .where('user',isEqualTo: "${selectedUser.value}")
                    //     .where('payment',isEqualTo: "${selectedPayment.value}")
                    //     .where('deliveryBoy',isEqualTo: "${selectedDeliveryBoy.value}")
                    //     .where('deliveryType',isEqualTo: "${selectedDelivery.value}")
                    //     .orderBy('date',descending: true) .snapshots():
                    // firebaseFirestore.collection('$transactionType').where('date',isGreaterThanOrEqualTo: fromDate1)
                    //     .where('date',isLessThanOrEqualTo: toDate1)
                    //     .where('user',isEqualTo: "${selectedUser.value}")
                    //     .where('payment',isEqualTo: "${selectedPayment.value}")
                    //     .where('deliveryBoy',isEqualTo: "${selectedDeliveryBoy.value}")
                    //     .orderBy('date',descending: true) .snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<DocumentSnapshot> documentSnapshot = [];
                      String delivery=selectedDelivery=='Dine In'?'Spot':selectedDelivery;
                      if(delivery=='*'){
                        documentSnapshot=snapshot.data.docs;
                      }
                      else{
                        for(int i=0;i<snapshot.data.size;i++){
                          if(snapshot.data.docs[i]['deliveryType']==delivery)
                            documentSnapshot.add(snapshot.data.docs[i]);
                        }
                      }
                      return currentWidth>600?FittedBox(
                        fit: BoxFit.fitWidth,
                        child: DataTable(columns:
                        [
                          DataColumn(label: Text('Date', style: kStyle)),
                          DataColumn(label: Text(transactionType=='invoice_data'?'Customer': transactionType=='sales_return'?'Customer' :'Vendor', style: kStyle)),
                          DataColumn(label: Text('Total', style: kStyle)),
                          DataColumn(label: Text('Payment', style: kStyle)),
                          DataColumn(label: Text('InvoiceNo', style:kStyle)),
                          DataColumn(label: Text('OrderNo', style:kStyle)),
                          DataColumn(label: Text('CreatedBy', style:kStyle)),
                          DataColumn(label: Text('Delivery', style:kStyle)),
                          DataColumn(label: Text('User', style: kStyle)),
                          DataColumn(label: Text('Reprint', style: kStyle)),
                          if(kIsWeb && (currentPrinter=='PDF Thermal' || currentPrinter=='PDF A4'))
                          DataColumn(label: Text('Share', style: kStyle)),
                          if(orgInvoiceEdit=='true')
                            DataColumn(label: Text('Edit', style: kStyle)),
                        ],
                            rows: documentSnapshot.map((document) {
                              return DataRow(cells: [
                                DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                                DataCell(Text(transactionType=='invoice_data'?document['customer'] : transactionType=='sales_return'?document['customer'] :document['vendor'],style: kStyle)),
                                DataCell(Text(document['total'].contains('*')?document['total'].replaceAll('*','/'):document['total'],style: kStyle)),
                                DataCell(Text(document['payment'].contains('*')?document['payment'].replaceAll('*','/'):document['payment'],style: kStyle)),
                                DataCell(TextButton(
                                    onPressed: () async {
                                      DocumentSnapshot snapshot =
                                      await firebaseFirestore
                                          .collection('$transactionType')
                                          .doc(document['orderNo']
                                          .toString())
                                          .get();
                                      orderIndex =
                                          snapshot.get('cartList').length;
                                      showDialog(context: context, builder: (context)=>Center(
                                        child: SingleChildScrollView(
                                          child: Dialog(
                                            child: DataTable(
                                              columns: [  DataColumn(label: Text('Item',
                                                style: kStyle,
                                              )),
                                                DataColumn(label: Text('UOM',
                                                  style: kStyle,
                                                ),

                                                ),
                                                DataColumn(label: Text('Qty',
                                                  textAlign: TextAlign.center,
                                                  style: kStyle,
                                                )),
                                                DataColumn(label: Text('Price',
                                                  style:kStyle,)),],
                                              rows:List.generate(orderIndex, (index) {
                                                return DataRow(cells: [
                                                  DataCell(Text(document[
                                                  'cartList']
                                                  [index]['name'].toString().replaceAll('#', '/'),
                                                    style:kStyle,)),
                                                  DataCell(Text(document[
                                                  'cartList']
                                                  [index]['uom'],
                                                    style:kStyle,)),
                                                  DataCell(Text(document[
                                                  'cartList']
                                                  [index]['qty'],
                                                    style:kStyle,)),
                                                  DataCell(Text(document[
                                                  'cartList']
                                                  [index]['price'],
                                                    style:kStyle,)),

                                                ]);
                                              }) ,
                                            ),
                                          ),
                                        ),
                                      ));
                                    },
                                    child: Text(document['orderNo'],style: kStyle,))),
                                DataCell(Text(document['kotNumber'],style: kStyle)),
                                DataCell(Text(document['createdBy'],style: kStyle)),
                                DataCell(Text(document['deliveryType']=='Spot'?'Dine In':document['deliveryType'],style: kStyle)),
                                DataCell(Text(document['user'],style: kStyle)),
                                DataCell(IconButton(onPressed: () async {
                                  String tempCustomer= transactionType=='invoice_data'?document['customer'] : transactionType=='sales_return'?document['customer'] :document['vendor'];
                                  List items=document['cartList'];
                                  List tempItemsList=[];
                                  for(int i=0;i<items.length;i++)
                                  {
                                    tempItemsList.add('${document['cartList'][i]['name']}:${document['cartList'][i]['uom']}:${document['cartList'][i]['price']}:${document['cartList'][i]['qty']}');

                                  }
                                  if(currentPrinter=='Network'){
                                    const PaperSize paper = PaperSize.mm80;
                                    final profile = await CapabilityProfile.load();
                                    final printer = NetworkPrinter(paper, profile);
                                    try{
                                      final PosPrintResult res = await printer.connect(allPrinterIp[allPrinter.indexOf(currentPrinterName)], port: 9100);
                                      if (res == PosPrintResult.success) {
                                        await  networkPrint(document['orderNo'],printer,convertEpox(document['date']).substring(0,16),tempCustomer,document['discount'],tempItemsList);
                                        printer.disconnect();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print result: ${res.msg}')));
                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print result: ${res.msg}')));
                                      }
                                    }
                                    catch(e){

                                    }
                                  }
                                  if(kIsWeb && (currentPrinter=='PDF Thermal' || currentPrinter=='PDF A4')){
                                    String tempCustomer= transactionType=='invoice_data'?document['customer'] : transactionType=='sales_return'?document['customer'] :document['vendor'];
                                    List items=document['cartList'];
                                    List tempItemsList=[];
                                    double totalTax=0;
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
                                    for(int i=0;i<items.length;i++)
                                    {
                                      tempItemsList.add('${document['cartList'][i]['name']}:${document['cartList'][i]['uom']}:${document['cartList'][i]['price']}:${document['cartList'][i]['qty']}');
                                      String itemTax=getTaxName(document['cartList'][i]['name']);
                                      String taxPercent=getPercent(itemTax);
                                      String itemPrice=document['cartList'][i]['price'];
                                      if(organisationTaxType=='VAT'){
                                        print('taxPercent $taxPercent');
                                        if(taxPercent.trim()=='10'){
                                          taxable10+= double.parse(itemPrice)*(100/110);
                                          totalTax+=  double.parse(itemPrice)*(10/110);
                                        }
                                        else if(taxPercent.trim()=='15'){
                                          taxable15+= double.parse(itemPrice)*(100/115);
                                          totalTax+=  double.parse(itemPrice)*(15/115);
                                        }
                                        else{
                                          total0+=double.parse(itemPrice);
                                        }
                                      }
                                      else{
                                        String tax = getTaxName(document['cartList'][i]['name']);
                                        double price = double.parse(document['cartList'][i]['price']) /
                                            double.parse(document['cartList'][i]['qty']);
                                        if (tax.trim() == 'GST 5') {
                                          tax5 += (double.parse( getPercent(tax)) / 100) * price;
                                          totalTax+=tax5;
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
                                    }
                                    double billAmt=0;
                                    double totalAmt=0;
                                    if(document['total'].contains('*')){
                                      List tempT=document['total'].split('*');
                                      totalAmt= billAmt=double.parse(tempT[0].toString().trim())+double.parse(tempT[1].toString().trim());
                                      billAmt=billAmt-totalTax;
                                    }
                                    else{
                                      totalAmt=double.parse(document['total']);
                                      billAmt=double.parse(document['total'])-totalTax;
                                    }
                                    totalTaxDetails='$tax5~$tax12~$tax18~$tax28~$cess';
                                    String tempUid='';
                                    Map map1=document.data();
                                    if(map1.length==16){
                                      tempUid=document['uid'];
                                    }
                                    print('tempUid $tempUid');
                                    if(selectedBusiness=='Retail')
                                    retailPdf(document['date'], tempItemsList, document['orderNo'], tempCustomer, totalAmt, double.parse(document['discount'].toString()), totalTax, billAmt, totalTaxDetails, items.length,document['payment'],document['total'],'reprint');
                                   else if(selectedBusiness=='Restaurant' && orgQrCodeIs=='false')
                                     restaurantPdf(document['date'], tempItemsList, document['orderNo'], tempCustomer, totalAmt, double.parse(document['discount'].toString()), totalTax, billAmt, totalTaxDetails, items.length, document['payment'], document['total'], 'reprint',document['user'],tempUid);
                                    else if(selectedBusiness=='Restaurant' && orgQrCodeIs=='true')
                                      arabicPdf(document['date'], tempItemsList, document['orderNo'], tempCustomer, totalAmt, double.parse(document['discount'].toString()), totalTax, billAmt, totalTaxDetails, items.length, document['payment'],  document['total'], 'reprint',document['user'],tempUid);
                                  }
//                               else if(currentPrinter=='PDF Thermal' || currentPrinter=='PDF A4'){
//                                 if(double.parse(totalDiscountController.text)>0){
//                                   if(discountTypeSelected=='VAL'){
//                                     tempDiscount=double.parse(totalDiscountController.text);
//                                   }
//                                   else{
//                                     double val=double.parse(totalDiscountController.text);
//                                     val=val/100;
//                                     val=val*tempNetPayable;
//                                     tempDiscount=val;
//                                   }
//                                 }
//                                 tempbillAmount=tempNetPayable-totalTax;
//                                 print('totalTaxxxxxxxxx $totalTax');
//                                 tempNetPayable=tempNetPayable-tempDiscount;
//                                 generatePdf('dot orders',cartListText,'$userSalesPrefix$invNo',appbarCustomerController.text,tempNetPayable,tempDiscount,totalTax,tempbillAmount,totalTaxDetails,cartListText.length);
//                               }
                                  else if(currentPrinter=='T2MINI'){
                                    // sunmiT1Print(document['orderNo'],convertEpox(document['date']).substring(0,16),tempCustomer,document['discount'],tempItemsList);
//         sunmiPrint('$userSalesPrefix$invNo', '');
                                  }
//                               else if(currentPrinter=='Bluetooth'){
//                                 print('inside bluetooth');
//                                 final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
//                                 print('connectionStatus $connectionStatus');
//                                 if(connectionStatus==false){
//                                   print('inside if ${allPrinterIp[allPrinter.indexOf(currentPrinterName)]}');
//                                   final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: allPrinterIp[allPrinter.indexOf(currentPrinterName)]);
//                                   print('result $result');
//                                   const ep.PaperSize paper = ep.PaperSize.mm58;
//                                   final profile = await ep.CapabilityProfile.load();
//                                   List<int> ticket = await demoReceipt(paper,profile,'$userSalesPrefix$invNo');
//                                   final result1 = await PrintBluetoothThermal.writeBytes(ticket);
//                                   print("print result: $result1");
//                                 }
//                                 else{
//                                   print('inside else');
//                                   const ep.PaperSize paper = ep.PaperSize.mm58;
//                                   final profile = await ep.CapabilityProfile.load();
//                                   List<int> ticket = await demoReceipt(paper,profile,'$userSalesPrefix$invNo');
//                                   final result = await PrintBluetoothThermal.writeBytes(ticket);
//                                   print("print result: $result");
//                                 }
//                               }

                                },
                                  icon: Icon(Icons.print),
                                  iconSize: 40,
                                )),
                                if(kIsWeb && (currentPrinter=='PDF Thermal' || currentPrinter=='PDF A4'))
                                  DataCell(IconButton(onPressed: () async {
                                    String tempCustomer= transactionType=='invoice_data'?document['customer'] : transactionType=='sales_return'?document['customer'] :document['vendor'];
                                    List items=document['cartList'];
                                    List tempItemsList=[];
                                    double totalTax=0;
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
                                    for(int i=0;i<items.length;i++)
                                    {
                                      tempItemsList.add('${document['cartList'][i]['name']}:${document['cartList'][i]['uom']}:${document['cartList'][i]['price']}:${document['cartList'][i]['qty']}');
                                      String itemTax=getTaxName(document['cartList'][i]['name']);
                                      String taxPercent=getPercent(itemTax);
                                      String itemPrice=document['cartList'][i]['price'];
                                      if(organisationTaxType=='VAT'){
                                        if(taxPercent.trim()=='10'){
                                          taxable10+= double.parse(itemPrice)*(100/110);
                                          totalTax+=  double.parse(itemPrice)*(10/110);

                                        }
                                        else if(taxPercent.trim()=='15'){
                                          taxable15+= double.parse(itemPrice)*(100/115);
                                          totalTax+=  double.parse(itemPrice)*(15/115);
                                        }
                                        else{
                                          //print('inside 0 tax');
                                          total0+=double.parse(itemPrice);
                                        }
                                      }
                                      else{
                                        String tax = getTaxName(document['cartList'][i]['name']);
                                        double price = double.parse(document['cartList'][i]['price']) /
                                            double.parse(document['cartList'][i]['qty']);
                                        if (tax.trim() == 'GST 5') {
                                          tax5 += (double.parse( getPercent(tax)) / 100) * price;
                                          totalTax+=tax5;
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
                                    }
                                    double billAmt=0;
                                    double totalAmt=0;
                                    if(document['total'].contains('*')){
                                      List tempT=document['total'].split('*');
                                      totalAmt= billAmt=double.parse(tempT[0].toString().trim())+double.parse(tempT[1].toString().trim());
                                      billAmt=billAmt-totalTax;
                                    }
                                    else{
                                      totalAmt=double.parse(document['total']);
                                      billAmt=double.parse(document['total'])-totalTax;
                                    }
                                    totalTaxDetails='$tax5~$tax12~$tax18~$tax28~$cess';
                                    String tempUid='';
                                    Map map1=document.data();
                                    if(map1.length==16){
                                      tempUid=document['uid'];
                                    }
                                    print('tempUid $tempUid');
                                    if(selectedBusiness=='Retail')
                                    retailPdf(document['date'], tempItemsList, document['orderNo'], tempCustomer, totalAmt, double.parse(document['discount'].toString()), totalTax, billAmt, totalTaxDetails, items.length,document['payment'],document['total'],'share');
                                    else if(selectedBusiness=='Restaurant' && orgQrCodeIs=='false')
                                      restaurantPdf(document['date'], tempItemsList, document['orderNo'], tempCustomer, totalAmt, double.parse(document['discount'].toString()), totalTax, billAmt, totalTaxDetails, items.length, document['payment'], document['total'], 'share',document['user'],tempUid);
                                    else if(selectedBusiness=='Restaurant' && orgQrCodeIs=='true')
                                      arabicPdf(document['date'], tempItemsList, document['orderNo'], tempCustomer, totalAmt, double.parse(document['discount'].toString()), totalTax, billAmt, totalTaxDetails, items.length, document['payment'],  document['total'], 'share',document['user'],tempUid);
                                  },
                                    icon: Icon(Icons.download),
                                    iconSize: 40,
                                  )),
                                if(orgInvoiceEdit=='true')
                                  DataCell(IconButton(onPressed: () async {
                                    print('before is online');
                                    // bool isOnline = await hasNetwork();
                                    // print('resulttttttt $isOnline');
                                    // if(!isOnline){
                                    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Internet is not available')));
                                    //   return;
                                    // }
                                    invEdit.value=true;
                                    invEditNumber.value=document['orderNo'];
                                    List items=document['cartList'];
                                    invEditCartList.value=RxList<String>([]);
                                    cartController=[];
                                    salesUomList=[];
                                    salesTotalList=[];
                                    salesTotal=0;
                                    cartListText=[];
                                    for(int i=0;i<items.length;i++)
                                    {
                                      setState((){
                                        salesTotal+=double.parse(document['cartList'][i]['price']);
                                        salesTotalList.add(double.parse(document['cartList'][i]['price']));
                                        salesUomList.add(document['cartList'][i]['uom']);
                                        cartController.add(TextEditingController(text: document['cartList'][i]['price']));
                                        cartListText.add('${document['cartList'][i]['name']}:${document['cartList'][i]['uom']}:${document['cartList'][i]['price']}:${document['cartList'][i]['qty']}');
                                      });
                                      invEditCartList.value.add('${document['cartList'][i]['name']}:${document['cartList'][i]['uom']}:${document['cartList'][i]['price']}:${document['cartList'][i]['qty']}');
                                    }
                                    appbarCustomerController.text=document['customer']=='Standard'?'':document['customer'];
                                    invEditCustomerName.value=selectedCustomer=appbarCustomerController.text;
                                    invEditPaymentMethod.value=document['payment'];
                                    invEditTotal.value=document['total'];
                                    invEditDate.value=document['date'];
                                    invEditKotNumber.value=document['kotNumber'];
                                    invEditCreatedBy.value=document['createdBy'];
                                    invEditDeliveryBoy.value=document['deliveryBoy'];
                                    await displayAllProducts('Salable');
                                    Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => PosScreen()),
                                    );
                                  },
                                    icon: Icon(Icons.edit),
                                    iconSize: 40,
                                  )),
                              ]);
                            }).toList()),
                      ):
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(columns:
                        [
                          DataColumn(label: Text('Date', style: kStyle)),
                          DataColumn(label: Text(transactionType=='invoice_data'?'Customer': transactionType=='sales_return'?'Customer' :'Vendor', style: kStyle)),
                          DataColumn(label: Text('Total', style: kStyle)),
                          DataColumn(label: Text('Payment', style: kStyle)),
                          DataColumn(label: Text('InvoiceNo', style:kStyle)),
                          DataColumn(label: Text('OrderNo', style:kStyle)),
                          DataColumn(label: Text('CreatedBy', style:kStyle)),
                          DataColumn(label: Text('Delivery', style:kStyle)),
                          DataColumn(label: Text('User', style: kStyle)),

                          // DataColumn(label: Text('Reprint', style: kStyle)),
                          // DataColumn(label: Text('Edit', style: kStyle)),
                        ],
                            rows: snapshot.data.docs.map((document) {
                              return DataRow(cells: [
                                DataCell(Text(convertEpox(document['date']).substring(0,16),style: kStyle)),
                                DataCell(Text(transactionType=='invoice_data'?document['customer'] : transactionType=='sales_return'?document['customer'] :document['vendor'],style: kStyle)),
                                DataCell(Text(document['total'].contains('*')?document['total'].replaceAll('*','/'):document['total'],style: kStyle)),
                                DataCell(Text(document['payment'].contains('*')?document['payment'].replaceAll('*','/'):document['payment'],style: kStyle)),
                                DataCell(TextButton(
                                    onPressed: () async {
                                      DocumentSnapshot snapshot =
                                      await firebaseFirestore
                                          .collection('$transactionType')
                                          .doc(document['orderNo']
                                          .toString())
                                          .get();
                                      orderIndex =
                                          snapshot.get('cartList').length;
                                      showDialog(context: context, builder: (context)=>Center(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Dialog(
                                            child: DataTable(
                                              columns: [  DataColumn(label: Text('Item', style: kStyle,)),
                                                DataColumn(label: Text('UOM',
                                                  style: kStyle,
                                                ),

                                                ),
                                                DataColumn(label: Text('Qty',
                                                  textAlign: TextAlign.center,
                                                  style: kStyle,
                                                )),
                                                DataColumn(label: Text('Price',
                                                  style:kStyle,)),],
                                              rows:List.generate(orderIndex, (index) {
                                                return DataRow(cells: [
                                                  DataCell(Text(document[
                                                  'cartList']
                                                  [index]['name'],
                                                    style:kStyle,)),
                                                  DataCell(Text(document[
                                                  'cartList']
                                                  [index]['uom'],
                                                    style:kStyle,)),
                                                  DataCell(Text(document[
                                                  'cartList']
                                                  [index]['qty'],
                                                    style:kStyle,)),
                                                  DataCell(Text(document[
                                                  'cartList']
                                                  [index]['price'],
                                                    style:kStyle,)),

                                                ]);
                                              }) ,
                                            ),
                                          ),
                                        ),
                                      ));
                                    },
                                    child: Text(document['orderNo'],style: kStyle,))),
                                DataCell(Text(document['kotNumber'],style: kStyle)),
                                DataCell(Text(document['createdBy'],style: kStyle)),
                                DataCell(Text(selectedBusiness!='Restaurant'?document['deliveryType']:document['deliveryType']=='Spot'?'Dine In':document['deliveryType'],style: kStyle)),
                                DataCell(Text(document['user'],style: kStyle)),
                                // DataCell(IconButton(onPressed: (){
                                //
                                // },
                                //   icon: Icon(Icons.print),
                                //
                                // )),
                                // DataCell(IconButton(onPressed: () async {
                                //
                                // },
                                //   icon: Icon(Icons.edit),
                                //   iconSize: 40,
                                // )),
                              ]);
                            }).toList()),
                      );
                    })),
              ),
            ),
            Container(
                // padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/6),
                height:  MediaQuery.of(context).size.height/12,
                width: MediaQuery.of(context).size.width,
                child: Obx(()=>StreamBuilder(
                    stream:  selectedUser.value=='*'?firebaseFirestore.collection('$transactionType').where('date',isGreaterThanOrEqualTo: fromDate1)
                        .where('date',isLessThanOrEqualTo: toDate1)
                        .orderBy('date',descending: true) .snapshots():firebaseFirestore.collection('$transactionType').where('date',isGreaterThanOrEqualTo: fromDate1)
                        .where('date',isLessThanOrEqualTo: toDate1)
                        .where('user',isEqualTo: selectedUser.value)
                        .orderBy('date',descending: true) .snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      // QuerySnapshot<Object> doc2=snapshot.data;
                      List<DocumentSnapshot> doc2 = [];
                      String delivery=selectedDelivery=='Dine In'?'Spot':selectedDelivery;
                      if(delivery=='*'){
                        doc2=snapshot.data.docs;
                      }
                      else{
                        for(int i=0;i<snapshot.data.size;i++){
                          if(snapshot.data.docs[i]['deliveryType']==delivery)
                            doc2.add(snapshot.data.docs[i]);
                        }
                      }
                      cashTotal.value=0.0;
                      cardTotal.value=0.0;
                      creditTotal.value=0.0;
                      upiTotal.value=0.0;
                      total.value=0.0;
                      salesAmount.value=RxList<double>([]);
                      for(int k=0;k<mainPaymentList.length;k++){
                        salesAmount.value.add(0.0);
                      }
                      for(int i=0;i<doc2.length;i++){
                        if(doc2[i]['total'].contains('*')){
                          List tempDPayment=doc2[i]['payment'].split('*');
                          List tempDTotal=doc2[i]['total'].split('*');
                          total.value+=double.parse(tempDTotal[0].toString().trim());
                          total.value+=double.parse(tempDTotal[1].toString().trim());
                          for(int k=0;k<mainPaymentList.length;k++){
                            if(tempDPayment.contains(mainPaymentList[k])){
                              int pos=tempDPayment.indexOf(mainPaymentList[k]);
                              salesAmount.value[k]+=double.parse(tempDTotal[pos].toString().trim());
                            }
                          }
                        }
                        else{
                          total.value+=double.parse(doc2[i].get('total'));
                          for(int k=0;k<mainPaymentList.length;k++){
                            if(doc2[i]['payment']==mainPaymentList[k]){
                              salesAmount.value[k]+=double.parse(doc2[i].get('total'));
                              break;
                            }
                          }
                        }
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              // padding: EdgeInsets.only(top: 4.0,bottom: 4.0),
                              scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:mainPaymentList.length,
                                itemBuilder: (BuildContext,index){
                              return Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Card(
                                  elevation: 10,
                                  color: kItemContainer,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: kItemContainer, width: 3),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(children: [
                                      Text(mainPaymentList[index],
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.0,
                                      ),
                                      Text(salesAmount.value[index].toStringAsFixed(decimals),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],),
                                  ),),
                              );
                            }),
                          ),
                              Card(
                                elevation: 10,
                                color: kItemContainer,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: kItemContainer, width: 3),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    Text('Total',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    Text(total.value.toStringAsFixed(decimals),
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor*22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],),
                                ),)
                        ],
                      );
                    }
                ))
            )
          ],
        ),
      )),
    );
  }
}
String convertEpox(int val){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(val);
  var format = new DateFormat("d/m/y");
  // String time=date.toString().substring(11)
  var dateString = format.format(date);
  return date.toString();
}