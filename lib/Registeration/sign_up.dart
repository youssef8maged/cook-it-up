import 'package:cook_it_up/Classes/database.dart';
import 'package:cook_it_up/Classes/user.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});// CONSTRUCTOR

  @override
  State<SignUp> createState() => _SignUpState();// create state METHOD
}//PUBLIC

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final usernameController = TextEditingController();


@override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    usernameController.dispose();
  }// dispose METHOD
  
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 166, 0),
        centerTitle: true,
        title: const Text("Create New Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40,),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'New Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'New Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
                
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            
              const SizedBox(height: 40,),
              TextButton(
                onPressed: () async{
                  String email = emailController.text.trim();
                  String pass = passwordController.text.trim();
                  String username = usernameController.text.trim();

                  bool isUsernameCorrect = false;
                  bool isEmailNotFound = false;
                  bool isUsernameNotFound = false;
                  bool isEmailCorrect = false;
                  bool isPasswordCorrect = false;
                  if (username.isNotEmpty) {
                    isUsernameCorrect = true;
                  }
                  if (await isUsernameFound(username) == false) {
                    isUsernameNotFound = true;
                  }
                  if (email.contains("@") && email.contains(".com")) {
                    isEmailCorrect = true;
                  }
                  if (pass.length > 7 && pass == confirmController.text.trim()) {
                    isPasswordCorrect = true;
                  }
                  if (await emailFound(email) == false) {
                    isEmailNotFound = true;
                  }
                  validate(emailValidated: isEmailCorrect, passValidated: isPasswordCorrect, usernameValidated: isUsernameCorrect, usernameNotFound: isUsernameNotFound,emailNotFound: isEmailNotFound);
                  
                  
                },
                style: TextButton.styleFrom(
                  padding:   EdgeInsets.symmetric(horizontal: size.width/6),
                  foregroundColor: Colors.white,
                   backgroundColor: const Color.fromARGB(255, 255, 166, 0),
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 16),
                ), 
              ),
              const SizedBox(height: 20,),
                Row(
                mainAxisAlignment:  MainAxisAlignment.start,
                 children: [

                     const Text(
                    "Already have an account ?",
                    style: TextStyle(
                      fontSize: 10
                    ),),
                  
                   TextButton(
                    onPressed: (){
                        Navigator.pop(context);
                    },
                     child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color:  Colors.green
                      ),
                      )
                      ), 
                 ],
               ),
            ],
            ),
        ),
          ),
            );
  }// build METHOD

  void validate({required bool emailValidated, required bool passValidated, required bool usernameValidated, required bool usernameNotFound, required bool emailNotFound}){
    String title = "";
    String message = "";
    bool isValidated = false;

if (emailNotFound == false) {
  title = "Email already exists";
  message = "Go to sign in instead";
    } else if (usernameValidated == false) {
      title = "Empty Username";
      message = "ُPlease enter a username";
    } else if (usernameNotFound == false) {
      title = "Username is taken";
      message = "Try different one";
    } else if (emailValidated == false) {
      title = "Invalid Email";
      message = "ُEnter a valid email";
    } else if (passValidated == false) {
      title = "Wrong Password";
      message = "ُAt least 8 characters required and confirm it";
    } else {
      title = "Account Created";
      message = "You can log in now";
      isValidated = true;
      Database.addUser(User(email: emailController.text.trim(), password: passwordController.text.trim(), username: usernameController.text.trim()));
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext screen){
        return  AlertDialog(
          title: Text(title),
          content:  Text(message),
          actions:  [
            TextButton(
              onPressed: (){
                if (isValidated) {
                  Navigator.popUntil(screen, (Route<dynamic> routes) => routes.isFirst);
                }else{
                  Navigator.pop(screen);
                }
              }, 
              child: const Text("OK")),
          ],
        );
      },
      );
  }// validate METHOD


Future<bool> isUsernameFound(String usernameP) async{
  final temp =await Database.retrieveUsers();
  for (var element in temp) {
    if (element.username == usernameP) {
      return true;
    }
  }
  return false;
  
}// user name found METHOD

Future<bool> emailFound(String emailP)async{
  final temp = await Database.retrieveUsers();
    for (var element in temp) {
    if (element.email == emailP) {
      return true;
    }
  }
  return false;
}// email found METHOD

}// PRIVATE