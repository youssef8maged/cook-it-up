import 'dart:convert';
import 'dart:math';
import 'package:cook_it_up/Classes/user.dart';
import 'package:cook_it_up/Classes/database.dart';
import 'package:cook_it_up/home.dart';
import 'package:cook_it_up/Registeration/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:developer' as dev;

class LogIn extends StatefulWidget {
  const LogIn({super.key}); // CONSTRUCTOR

  @override
  State<LogIn> createState() => _LogInState();// create state METHOD
}// PUBLIC

class _LogInState extends State<LogIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;
  IconData visibility = Icons.visibility_off;


@override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }// dispose METHOD

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              Image.asset(
                "pics/cook.png",
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Your Email',
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
                
              const SizedBox(height: 20),
              TextField(
               obscureText: isObscure, 
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Your Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon:  Icon(visibility),
                    onPressed: () {
                      setState(() {
                        if (isObscure) {
                          isObscure = false;
                          visibility = Icons.visibility;
                        }else{
                          isObscure = true;
                          visibility = Icons.visibility_off;
                        }
                      }
                      );
                    },
                  ),
                ),
              ),
                  Row(
                    mainAxisAlignment:  MainAxisAlignment.end,
                    children: [
                      Builder(
                        builder: (BuildContext screen) {
                          return TextButton(
                            onPressed: () async{
                             String email = emailController.text.trim();

                             if (!await emailFound(email) && email.isNotEmpty) {
                              if (screen.mounted) {
                                ScaffoldMessenger.of(screen).clearSnackBars();
                              ScaffoldMessenger.of(screen).showSnackBar(
                                const SnackBar(
                                  content: Text("Sorry you don't have an account with that email"),
                                  duration: Duration(seconds: 5),
                                  ),
                              );
                                
                              }
                             } else {
                              if (email.contains("@") && email.contains(".com") ) {
                              sendEmail(email,await generatePasswords());
                              if (screen.mounted) {
                              ScaffoldMessenger.of(screen).clearSnackBars();
                              ScaffoldMessenger.of(screen).showSnackBar(
                                const SnackBar(
                                  content: Text("An Email Is Sent !"),
                                  duration: Duration(seconds: 5),
                                  ),
                              );
                              }
                              emailController.text = "";
                              }else{
                                if (screen.mounted) {
                                  
                                ScaffoldMessenger.of(screen).clearSnackBars();
                                 ScaffoldMessenger.of(screen).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter your email above"),
                                  duration: Duration(seconds: 5),
                                  ),
                              );
                                }
                              } }
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                ),
                            ),
                          );
                        }
                      ),
                    ],
                  ),
              TextButton(
                onPressed: () async{
                  dev.log("Button Clicked");
                  User? user = await getUser(emailP: emailController.text.trim(), passwordP: passwordController.text.trim());
                  if (user != null && context.mounted) {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (BuildContext screen){
                        return  Home(user: user,);
                      })
                    );
                  }else if (context.mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "Incorrect Email or Password"
                      ),
                      duration: Duration(seconds: 5),
                      ));
                  }
                 

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
                  'Log In',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20,),
                Row(
                mainAxisAlignment:  MainAxisAlignment.start,
                 children: [
                   const Text(
                    "Don't have an account ?",
                    style: TextStyle(
                      fontSize: 10
                    ),),
                   TextButton(
                    onPressed: (){
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext screen){
                            return const SignUp();
                          }
                          ),
                       );
                    },
                     child: const Text(
                      "Sign up",
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

void sendEmail(String emailP, String passwordP)async{
final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
await post(
  url,
  headers: {
    "origin": 'http://localhost',
    "Content-Type": "application/json"
  },
  body: json.encode(
    {
  "service_id" : "service_4zh9fe7",
  "template_id" : "template_y6nd0tp",
  "user_id" :"-CdNk1E9ZmSpsa1AW" ,
  "template_params":{
    'user_to' : emailP,
    "user_pass" : passwordP,
  }
  },
  ),
  );
}// send email METHOD 
/* real password not updated & using email js */


Future<String> generatePasswords()async{
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  String newPass = String.fromCharCodes(Iterable.generate(
    8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))
    )
    );
    List<User> users = await Database.retrieveUsers();
    User user = users.singleWhere((User usr){return usr.email == emailController.text.trim();});
    Database.addUser(User(email: user.email, password: newPass, username: user.username));
  return newPass;
}// generate passwords METHOD

Future<User?> getUser({required String emailP, required String passwordP,})async{
  final users = await Database.retrieveUsers();
  for (var element in users) {
    if (emailP == element.email && passwordP == element.password) {
      return element;
    }
  }
  return null;
}// get user METHOD

Future<bool> emailFound(String emailP)async{
  final temp = await Database.retrieveUsers();
    for (var element in temp) {
    if (element.email == emailP) {
      return true;
    }
  }
  return false;
}// email found METHOD

}//PRIVATE