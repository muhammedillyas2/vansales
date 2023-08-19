// import 'package:flutter/material.dart';
// import 'package:restaurant_app/components/database_con.dart';
//
// import '../constants.dart';
// List<TextEditingController> categoryNameEditController=[];
// List<TextEditingController> sequenceEditController=[];
// class EditCategory extends StatefulWidget {
//   static const String id='category_edit';
//   @override
//   _EditCategoryState createState() => _EditCategoryState();
// }
//
// class _EditCategoryState extends State<EditCategory> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: kLightBlueColor,
//         ),
//         body: Container(
//           width: MediaQuery.of(context).size.width/2,
//           child: ListView(
//             children: [
//               DataTable(
//
//                 columns: [
//                   DataColumn(label: Text('Category Name',
//                     style: TextStyle(
//                       fontSize: MediaQuery.of(context).textScaleFactor*20,
//                     ),
//                   ),
//                   ),
//                   DataColumn(label: Text('Sequence',
//                     style: TextStyle(
//                       fontSize: MediaQuery.of(context).textScaleFactor*20,
//                     ),
//                   ),
//                     numeric: true,
//                   ),
//                   DataColumn(label: Text('',
//                   ),
//                   ),
//                 ],
//                 rows: List.generate(categoryNameEditController.length, (index) => DataRow(cells: [
//                   DataCell(
//                     TextFormField(
//                       style: TextStyle(
//                         fontSize: MediaQuery.of(context).textScaleFactor*20,
//                       ),
//                       controller: categoryNameEditController[index],
//                     ),
//                     showEditIcon: true,
//                   ),
//                   DataCell( TextFormField(
//                     style: TextStyle(
//                       fontSize: MediaQuery.of(context).textScaleFactor*20,
//                     ),
//                     controller: sequenceEditController[index],
//                   ),
//                     showEditIcon: true,
//                   ),
//                   DataCell(FlatButton(onPressed: () async {
//                     String temp='${categoryNameEditController[index].text}:${sequenceEditController[index].text}:0';
//                     await updateData(temp,'category_data',index+1,'');
//                     categoryFirstSplit[index]=temp;
//                     print(categoryFirstSplit);
//                   }, child: Container(
//                     decoration: BoxDecoration(
//                       color: kLightBlueColor,
//                     ),
//                     padding: EdgeInsets.all(8.0),
//                     child: Text('SAVE',
//                       style: TextStyle(
//                         color: Colors.white,
//                         letterSpacing: 1.5,
//                         fontSize: MediaQuery.of(context).textScaleFactor*20,
//                       ),
//                     ),
//                   )))
//                 ])),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// void displayCategoryData(){
//   categoryNameEditController=[];
//   sequenceEditController=[];
//   for(int i=0;i<productCategoryF.length;i++){
//     List temp=categoryFirstSplit[i].split(',');
//     categoryNameEditController.add(TextEditingController(text: temp[0].toString().trim()));
//     sequenceEditController.add(TextEditingController(text: temp[1].toString().trim()));
//   }
// }
