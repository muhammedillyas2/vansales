import 'package:flutter/material.dart';
import 'package:restaurant_app/components/database_con.dart';
import '../constants.dart';
List<String> terminals=['POS','Waiter'];
String selectedTerminal='POS';
class AddUser extends StatefulWidget {
  static const String id='user';
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String userName='',password='',terminal,prefix='';
  TextEditingController nameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController terminalController=TextEditingController();
  TextEditingController prefixController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
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
                'User Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                controller: nameController,
                onChanged: (value) {
                  userName=value;
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
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                controller: passwordController,
                onChanged: (value) {
                  password=value;
                },
                keyboardType:
                TextInputType.visiblePassword,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                'Terminal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 30.0,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black38,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text('  Terminal List'),
                    value: selectedTerminal,
                    items: terminals.map((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedTerminal = newValue.toString();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                'Prefix',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor*20,
                ),
              ),
              TextField(
                controller: prefixController,
                onChanged: (value) {
                  prefix=value;
                },
                keyboardType:
                TextInputType.text,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0,),
              TextButton(
                onPressed: ()async {
                  if(userName==''|| password=='' || prefix==''){
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
                    for(int i=0;i<userList.length;i++){
                      if(userList[i].toLowerCase() == userName.toLowerCase().trim()){
                        inside='contains';
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("User name Exists"),
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
                      String body='$userName:$password:$selectedTerminal:$prefix';
                      await insertData(body,'user_data');
                      setState(() {
                        userList.add(userName);
                        passwordList.add(password);
                        userPrefixList.add(prefix);
                      });
                      userName='';
                      password='';
                      prefix='';
                      nameController.clear();
                      passwordController.clear();
                      prefixController.clear();
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text('SAVE',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor*20,
                      color: Colors.white,
                      letterSpacing: 1.5,
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
