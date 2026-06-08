import 'package:cook_it_up/Classes/database.dart';
import 'package:cook_it_up/Classes/user.dart';
import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final User user;
  final String source;
  final void Function() refreshProfileFromMydialog;
  const MyDialog({super.key, required this.user,required this.source, required this.refreshProfileFromMydialog});// CONSTRUCTOR


  @override
  Widget build(BuildContext context) {
  String data = "";
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title:  Text("edit $source",
      style: const TextStyle(color: Colors.white),
      ),
      content: TextField(
        autofocus: true,
        onChanged: (String value){
          data = value;
        },
        cursorColor: Colors.deepPurple,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Write your new data",
          hintStyle: TextStyle(color:  Colors.white70),
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        },
         child: const Text("Cancel",
         style: TextStyle(color: Colors.white),
         )),
        TextButton(onPressed: ()async{
          if (source == "username" && data.isNotEmpty) {
            if (!await userFound(data)) {
          user.username = data;
          refreshProfileFromMydialog();
          context.mounted ?Navigator.of(context).pop(): null;
            }else{
              if (context.mounted) {
               ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Username is taken try another one"),
                      duration: Duration(seconds: 5),
                    ),
                  );
              }
            }
          }else if (source == "password" && data.isNotEmpty) {
            if (data.length < 8) {
               ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password must be 8 characters at least"),
                      duration: Duration(seconds: 5),
                    ),
                  );
            }else{
            user.password = data;
          refreshProfileFromMydialog();
          Navigator.of(context).pop();
            }
          }
        },
         child: const Text("Save",
         style: TextStyle(color: Colors.white),
         )),
      ],
    );
  }// build METHOD

  Future<bool> userFound(String userP) async{
  final temp =await Database.retrieveUsers();
  for (var element in temp) {
    if (element.username == userP) {
      return true;
    }
  }
  return false;
  
}// user found METHOD
}//  CLASS