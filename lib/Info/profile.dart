import 'package:cook_it_up/Classes/database.dart';
import 'package:cook_it_up/Classes/user.dart';
import 'package:cook_it_up/Info/my_dialog.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({super.key, required this.user});// CONSTRUCTOR

  @override
  State<Profile> createState() => _ProfileState();
}// PULBIC CLASS

class _ProfileState extends State<Profile> {
  
  void refreshProfile()async{
    await Database.addUser(widget.user);
    setState(() { });
  }// refresh profile METHOD
  
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person,
          size: 100,
          ),
          Text(widget.user.email),
          const SizedBox(height: 20,),
           Card(
            color: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Username :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      IconButton(
                        onPressed: (){
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                             builder: (BuildContext screen){
                              return  MyDialog(user: widget.user,source: "username",refreshProfileFromMydialog: refreshProfile,);
                             }
                             );
                        },
                        icon: const Icon(Icons.settings))
                    ],
                  ),
                   Text(widget.user.username)
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,),
           Card(
            color: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Password :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      IconButton(
                        onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext screen) {
                                  return MyDialog(
                                    user: widget.user,
                                    source: "password",
                                    refreshProfileFromMydialog: refreshProfile,
                                  );
                                });
                          },
                        icon: const Icon(Icons.settings))
                    ],
                  ),
                   Text(widget.user.password)
                ],
              ),
            ),
          ),
      
        ],
      ),
    );
  }// build METHOD
  
}// PRIVATE CLASS