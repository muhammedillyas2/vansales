import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../components/admin_firebase.dart';
import 'stock_transfer.dart';

String uomForSTList = '';
Future<Uint8List> generatePdf(List yourItemsList2, String body) async {
  final pdf = pw.Document(
    version: PdfVersion.pdf_1_5,
  );
  double totalQuantityInStockTransferPDF = 0.0;
  double netAmountInStockTransferPDF = 0.0;
  List temp = body.split('~');
  DateTime now = DateTime.now();
  String dateS = DateFormat('dd-MM-yyyy kk:mm').format(now);
  final font = await PdfGoogleFonts.nunitoExtraLight();
  Printing.layoutPdf(
    onLayout: (format) async {
      final doc = pw.Document();
      top() {
        return pw.Column(children: [
          pw.Row(
              // mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('From : ORG ',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                      pw.SizedBox(height: height * 0.008),
                      pw.Text('Address : ',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                      pw.SizedBox(height: height * 0.008),
                      pw.Text('Ware House : ${temp[1].toString().trim()}',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(width: width * 0.12),
                      pw.SizedBox(height: height * 0.008),
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('To : ORG',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                      pw.SizedBox(height: height * 0.008),
                      pw.Text('Address : ',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                      pw.SizedBox(height: height * 0.008),
                      pw.Text('Ware House : ${temp[2].toString().trim()}',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                    ])
              ]),
          pw.SizedBox(height: height * 0.01),
          pw.Row(
              // mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Document Status : Completed',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                      pw.SizedBox(height: height * 0.008),
                      pw.Text('Reference : ',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                      pw.SizedBox(height: height * 0.008),
                      pw.Text('Date : ${dateS}',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                      pw.Text('Document No : ${temp[0].toString().trim()}',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                    ]),
              ]),
          pw.SizedBox(height: height * 0.08),
          pw.Row(
              // mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Stock Transfer Lines',
                          style: pw.TextStyle(
                            fontSize: width * 0.015,
                          )),
                    ]),
              ]),
          pw.SizedBox(height: height * 0.04),
        ]);
      }

      final rows = <pw.TableRow>[];
      final rows1 = <pw.TableRow>[];
      rows1.add(pw.TableRow(children: [
        pw.SizedBox(
          // width: 20,
          child: pw.Padding(
            padding: pw.EdgeInsets.all(3.0),
            child: pw.Text(
              'Product Name',
              textScaleFactor: 0.8,
            ),
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3.0),
          child: pw.Text(
            'Barcode',
            textScaleFactor: 0.8,
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3.0),
          child: pw.Text(
            'Description',
            textScaleFactor: 0.8,
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3.0),
          child: pw.Text(
            'Total Quantity',
            textScaleFactor: 0.8,
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3.0),
          child: pw.Text(
            'Price',
            textScaleFactor: 0.8,
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3.0),
          child: pw.Text(
            'Net Price',
            textScaleFactor: 0.8,
          ),
        ),
      ]));
      for (int i = 0; i < yourItemsList2.length; i++) {
        String collectionName = 'product_data';
        uomForSTList = '';
        await firebaseFirestore
            .collection("$collectionName")
            .where('itemName', isEqualTo: yourItemsList2[i]['name'])
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            uomForSTList = result.get('uom');
          });
        });
        var arr = uomForSTList.split('*``');
        var priceD = arr[1].split('>');
        double price = double.parse(priceD[0]);
        double qty = double.parse(yourItemsList2[i]['qty']);
        double netPrice = qty * price;
        netAmountInStockTransferPDF += netPrice;
        totalQuantityInStockTransferPDF +=
            double.parse(yourItemsList2[i]['qty']);
        rows1.add(pw.TableRow(children: [
          pw.SizedBox(
              // width: 20,
              child: pw.Padding(
            padding: pw.EdgeInsets.all(3.0),
            child: pw.Text(
              yourItemsList2[i]['name'],
              textScaleFactor: 0.8,
            ),
          )),
          pw.Padding(
            padding: pw.EdgeInsets.all(3.0),
            child: pw.Text(
              '',
              textScaleFactor: 0.8,
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(3.0),
            child: pw.Text(yourItemsList2[i]['name'], textScaleFactor: 0.8),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(3.0),
            child: pw.Text(yourItemsList2[i]['qty'], textScaleFactor: 0.8),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(3.0),
            child: pw.Text(price.toString(), textScaleFactor: 0.8),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(3.0),
            child: pw.Text(netPrice.toString(), textScaleFactor: 0.8),
          ),
        ]));
      }
      rows1.add(pw.TableRow(children: [
        pw.SizedBox(
          // width: 20,
          child: pw.Padding(
            padding: pw.EdgeInsets.all(3.0),
            child: pw.Text(
              'TOTAL',
              textScaleFactor: 0.8,
            ),
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3.0),
          child: pw.Text(
            '',
            textScaleFactor: 0.8,
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3.0),
          child: pw.Text(
            '',
            textScaleFactor: 0.8,
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3.0),
          child: pw.Text(
            totalQuantityInStockTransferPDF.toString(),
            textScaleFactor: 0.8,
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3.0),
          child: pw.Text(
            '',
            textScaleFactor: 0.8,
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3.0),
          child: pw.Text(
            netAmountInStockTransferPDF.toString(),
            textScaleFactor: 0.8,
          ),
        ),
      ]));

      center() {
        return pw.Column(children: [
          pw.SizedBox(height: height * 0.01),
          pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              // textDirection: pw.TextDirection.ltr,
              border: pw.TableBorder.all(width: 1.0, color: PdfColors.black),
              children: rows),
          pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              // textDirection: pw.TextDirection.ltr,
              border: pw.TableBorder.all(width: 1.0, color: PdfColors.black),
              children: rows1),
        ]);
      }

      bottom() {
        return pw.Column(children: [
          pw.Row(
              // mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.SizedBox(height: height * 0.268),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                          'Prepared By: __________Driver Name: _________Received By: __________',
                          style: pw.TextStyle(
                            fontSize: width * 0.01,
                          )),
                      pw.SizedBox(height: height * 0.008),
                    ]),
              ]),
        ]);
      }

      doc.addPage(
        pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            build: (pw.Context context) =>
                <pw.Widget>[top(), center(), bottom()]),
      );
      final bytes = pdf.save();
      return doc.save();
    },
  );

  return pdf.save();
}
