import 'package:cook_it_up/Registeration/log_in.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}// main FUNCTION

class MainApp extends StatelessWidget {
  const MainApp({super.key}); // CONSTRUCTOR

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: "Cook It Up",
      debugShowCheckedModeBanner: false,
      home: LogIn(),
    );
  }// build METHOD
}



//uploadImage
//fetchRecommendations