import 'package:cook_it_up/Favorites/favorites.dart';
import 'package:cook_it_up/Classes/user.dart';
import 'package:cook_it_up/Images/uploading.dart';
import 'package:cook_it_up/Info/profile.dart';
import 'package:cook_it_up/Recipes/ingredients_search.dart';
import 'package:cook_it_up/Recipes/Recommendations/recommendation_screen.dart';
import 'package:cook_it_up/Registeration/log_in.dart';
import 'package:cook_it_up/Search/recipes_search.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final User user;
  const Home({super.key, required this.user});// CONSTRUCTOR

  @override
  State<Home> createState() => _HomeState();// create state METHOD
}// PUBLIC

class _HomeState extends State<Home> {
  int index = 0;
  late String titleTxt;

  @override
  void initState() {
  super.initState();
  titleTxt = "Hi ${widget.user.username}";
  }// init state METHOD

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      animationDuration: const Duration(seconds: 1),
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: index == 0?  const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                text: "Ingredients",
              ),
              Tab(
                text: "Recommendations",
              )
            ],) : null,
          title: Text(
            titleTxt,
            style:const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ) ,
            ),
          backgroundColor:  const Color.fromARGB(255, 255, 166, 0),
          actions:  [
            TextButton(
             onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext screen){
                  return const LogIn();
                } ,
                )
                );
             },
             child: const Text(
              "Log Out",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              ) ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int indexP){
            setState(() {
              index = indexP;
              if (index == 0) {
                titleTxt = "Hi ${widget.user.username}";
              }else if(index == 1){
                titleTxt = "Meal Image";
              }else if (index == 2){
                titleTxt = "Favorite Recipes";
              }else if (index == 3){
                titleTxt = "Browse Recipes";
              }else {
                titleTxt = "Your Profile";
              }
            });
          },
          backgroundColor: Colors.grey,
          animationDuration: const Duration(seconds: 5),
          indicatorColor: Colors.amber,
          selectedIndex: index,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dinner_dining),
              label: "Recipes",
              ),
            NavigationDestination(
              icon: Icon(Icons.receipt),
              label: "Images",
              ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: "Favorites",
              ),
            NavigationDestination(
              icon: Icon(Icons.search),
              label: "Search",
              ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: "Info",
              ),
          ],
          ),
        body: [
           TabBarView(
            children: [
            IngredientsSearch(user: widget.user),
             RecommendationScreen(user: widget.user),
          ] ),
           const Uploading(),
           Favorites(user: widget.user),
           RecipesSearch(user: widget.user),
            Profile(user: widget.user),][index] ,
      ),
    );
  }// build METHOD

}//  PRIVATE CLASS