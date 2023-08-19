import 'package:flutter/material.dart';
import 'package:restaurant_app/components/database_con.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/components/all_file.dart';
import '../components/database_con.dart';
import '../components/database_con.dart';
import '../components/database_con.dart';
import '../components/database_con.dart';
String selectedCategory;
String categoryName='',sequence=''; VoidCallback continueCallBack;
final validCharacters = RegExp(r'^[a-zA-Z0-9\@]+$');

bool cat = false;
class CategoryScreen extends StatefulWidget {
  static const String id='category';
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {  Navigator.of(context).pop(); // dismiss dialog
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Category adding failed!"),
    content: Text("Category Already exists or Category name contain special characters"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


bool isCatExist(String catName)
{
  catName = catName + sequence.toString();

  print(validCharacters.hasMatch(catName));

  if(validCharacters.hasMatch(catName)==false)
  {cat = true;print("FALSE");}
  else {
    print("ENTERING ELSE");
    for (int i = 0; i < categoryFirstSplit.length; i++) {
      try {
        int m = categoryFirstSplit[i].indexOf(":");
        String nam = categoryFirstSplit[i].toString().substring(0, m).trim();
        if (nam == catName) {
          cat = true;
          return true;
          break;
        };
      } catch (Exception) {
        return false;
      }
    }
  }
}
class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController nameController=TextEditingController();
  TextEditingController sequenceController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('POSIMATE',style: TextStyle(
              fontFamily: 'BebasNeue',
              letterSpacing: 2.0
          ),),
          titleSpacing: 0.0,
          backgroundColor: kGreenColor,
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width/2,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Text(
                'Category Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                controller: nameController,
                onChanged: (value) {
                  categoryName=value;
                },
                keyboardType:
                TextInputType.name,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                'Sequence',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                controller: sequenceController,
                onChanged: (value) {
                  sequence=value;
                },
                keyboardType:
                TextInputType.name,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0,),
              TextButton(
                onPressed: ()async {
                  if(categoryName==''|| sequence==''){
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text("Fill all the fields"),
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
                    String inside='not';
                    for(int i=0;i<productCategoryF.length;i++){
                      if(productCategoryF[i].toLowerCase() == categoryName){
                        inside='contains';
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Category name Exists"),
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
                    if(inside=='not'){
                      productCategoryF.add(categoryName.trim());
                      String body = '$categoryName:$sequence';
                      await insertData(body,'category_data');
                      await getData('category_data');
                      // allFile.writeFile(tempCategoryBody, 'category');
                      categoryName='';
                      sequence='';
                      nameController.clear();
                      sequenceController.clear();
                    }
                  }

                },

                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text('SAVE',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                        color: Colors.white,
                        letterSpacing: 1.5
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: kGreenColor,
                    borderRadius:
                    BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
