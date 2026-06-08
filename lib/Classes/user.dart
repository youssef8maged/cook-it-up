import 'package:cook_it_up/Classes/dummy_recipes.dart';

class User {
 
 late String email ;
 late String password;
 late String username;
 List<Recipe> favoriteRecipes = [];
  List<String> shownIngredients = [ 'SALT', 'PEPPER', 'SUGAR', 'FLOUR', 'BUTTER', 'OIL', 'ONION', 'GARLIC', 'EGGS', 'MILK', 'CREAM', 'CHEESE', 'TOMATO', 'LETTUCE', 'CARROT', 'POTATO', 'RICE', 'PASTA', 'CHICKEN', 'BEEF', 'PORK', 'FISH', 'SHRIMP', 'BEANS', 'CORN', 'PEAS', 'SPINACH', 'CUCUMBER', 'LEMON', 'LIME', 'ORANGE', 'APPLE', 'BANANA', 'STRAWBERRY', 'BLUEBERRY', 'AVOCADO', 'GINGER', 'CINNAMON', 'VANILLA', 'NUTMEG', 'THYME', 'ROSEMARY', 'BASIL', 'OREGANO', 'PARSLEY', 'CILANTRO', 'CUMIN', 'PAPRIKA', 'MUSTARD', 'KETCHUP', 'MAYONNAISE', 'VINEGAR', 'HONEY', 'COFFEE', 'TEA', ];
  List<String> choosenIngredients = [];
  List<Recipe> recommendedRecipes = [];

  User({required this.email, required this.password, required this.username});// CONSTRUCTOR

   User.fromMap(Map<String,dynamic> map){
    username = map["username"];
    email = map["email"];
    password = map["password"];
  }// from map CONSTRUCTOR

  Map<String,dynamic> toMap(){
    return {
      "username" : username,
      "email" : email,
      "password" : password,
    };  
  }// to map METHOD

  



}// CLASS