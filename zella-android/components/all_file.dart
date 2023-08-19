// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:restaurant_app/screen/add_product.dart';
// import 'package:restaurant_app/screen/pos_screen.dart';
// import 'package:restaurant_app/screen/purchase_screen.dart';
//
// String imagePath;
// String customerBalance;
// String vendorBalance;
// String customerReport;
// String vendorReport;
// List<String> customerReportList=[];
//
// List<bool> modifierValue=[];
// List<String> taxList=[];
// double openBalance=0;
//
// class AllFile {
//     Future<String> get _localPath async {
//         final directory = await getExternalStorageDirectory();
//
//         print(directory.path);
//         return directory.path;
//     }
//
//     Future<File>  localFile(String fileName) async {
//         final path = await _localPath;
//         return File('$path/$fileName.txt');
//     }
//
//     Future<File> editFile(var body,String fileName) async {
//         final file = await localFile(fileName);
//         return file.writeAsString(body);
//     }
//     Future<File> writeFile(var body,String fileName) async {
//         //
//         //  print(body);
//         final file = await localFile(fileName);
//
// // Write the file
//         if(fileName=='customer' || fileName=='uom' || fileName=='invoice' || fileName=='purchase_invoice' || fileName=='purchaseReturn_invoice' ||fileName=='salesReturn_invoice')
//             return file.writeAsString(body,mode: FileMode.append);
//         else
//             return file.writeAsString(body);
//
//         /* final FileSystem fs = MemoryFileSystem();
//     final Directory tmp = await fs.systemTempDirectory.createTemp('example_');
//     final File outputFile = tmp.childFile('output');
//     await outputFile.writeAsString('Hello world!');
//     print(outputFile.readAsStringSync());*/
//
//     }
//     void deleteFile(String fileName)async{
//         try{
//             final file = await localFile(fileName);
//             file.delete();
//         }
//         catch(e){
//             print(e);
//         }
//     }
//     Future<FileImage> getImages(String fileName) async {
//         final path =  _localPath;
//         final fileImage= FileImage(File('$path/$fileName.jpeg'));
//         imagePath='$path/images';
//         return fileImage;
//     }
//     Future<String> readFile(String fileName) async {
//         try {
//             final file = await localFile(fileName);
//             // Read the file.
//             print("FILE NAME"+fileName);
//
//
//             String contents = await file.readAsString();
//             // if(fileName=='products'){
//             //     print("PRODUCTS INNN");
//             //     taxList.add("GST5");taxList.add("GST12");taxList.add("GST18");taxList.add("GST28");;
//             //
//             //     productFirstSplit=contents.toString().split('~');
//             //     for(int i=0;i<productFirstSplit.length;i++){
//             //         print("SPLIT  ....."+productFirstSplit[i]);
//             //         List temp=productFirstSplit[i].toString().split(':');
//             //         productNameF.add(temp[0].toString().trim());
//             //
//             //     }
//             //     // productNameF.removeLast();
//             //     //  print('$productCategoryF \n $productNameF \n $categoryCount');
//             // }
//             // else if(fileName=='category'){
//             //     List temp=contents.split('~');
//             //     categoryFirstSplit=temp;
//             //     //   print('categoryfirstsplit $categoryFirstSplit');
//             //     for(int i=0;i<temp.length;i++){
//             //         List tempSplit=temp[i].toString().split(':');
//             //         productCategoryF.add(tempSplit[0].toString().trim());
//             //         categoryCount.add(tempSplit[2].toString().trim());
//             //     }
//             // }
//             // else if(fileName=='customer'){
//             //     customerFirstSplit=[];
//             //     customerList=[];
//             //     customerPriceList=[];
//             //     List temp=contents.split('~');
//             //     temp.removeLast();
//             //     customerFirstSplit=temp;
//             //     for(int i=0;i<temp.length;i++){
//             //         List tempSplit=temp[i].toString().split(':');
//             //         if(i==0) {
//             //             selectedCustomer = tempSplit[0].toString().trim();
//             //             selectedPriceList=tempSplit[4].toString().trim();
//             //         }
//             //         customerList.add(tempSplit[0].toString().trim());
//             //         customerPriceList.add(tempSplit[4].toString().trim());
//             //         customerBalanceList.add(tempSplit[5].toString().trim());
//             //     }
//             // }
//             // else if(fileName=='vendor'){
//             //     List temp=contents.split('~');
//             //     temp.removeLast();
//             //     for(int i=0;i<temp.length;i++){
//             //         List tempSplit=temp[i].toString().split(':');
//             //         if(i==0) {
//             //             selectedVendor = tempSplit[0].toString().trim();
//             //             selectedVendorPriceList=tempSplit[4].toString().trim();
//             //         }
//             //         vendorList.add(tempSplit[0].toString().trim());
//             //         vendorPriceList.add(tempSplit[4].toString().trim());
//             //         vendorBalanceList.add(tempSplit[5].toString().trim());
//             //     }
//             // }
//             //  if(fileName=='modifier'){
//             //     List temp=contents.split(':');
//             //     modifier=temp;
//             //     modifierValue=List.generate(modifier.length, (index) => false);
//             // }
//             // else if(fileName=='sequence_data'){
//             //     sequenceData=contents;
//             // }
//             // else if(fileName=='uom') {
//             //     uomList=[];
//             //     List temp = contents.split('~');
//             //     temp.removeLast();
//             //     for (int i = 0; i < temp.length; i++) {
//             //         List tempSplit=temp[i].toString().split(':');
//             //         uomList.add(tempSplit[0].toString().trim());
//             //     }
//             // }
//              if(fileName=='openBalance') {
//                 openBalance = double.parse(contents.trim());
//                 //     print('openBalance $openBalance' );
//
//             }
//             else if(fileName=='customer_report') {
//                 customerReport = contents;
//                 customerReportList=customerReport.split('^');
//                 //  print('customerReport $customerReportList' );
//             }
//             else if(fileName=='vendor_report') {
//                 vendorReport = contents;
//                 //  print('vendorReport $vendorReport' );
//             }
//             else if(fileName=='customer_balance') {
//                 customerBalance = contents;
//                 // print('customerBalance $vendorReport' );
//             }
//             else if(fileName=='vendor_balance') {
//                 vendorBalance = contents;
//                 // print('vendorBalance $vendorBalance' );
//             }
//             // else if(fileName=='organisation_data') {
//             //     organisationData = contents;
//             //     //  print('organisationData $organisationData' );
//             //
//             // }
//             print('all file :$contents');
//             return contents;
//         } catch (e) {
//             // If encountering an error, return 0.
//             return 'dd';
//         }
//     }
// }