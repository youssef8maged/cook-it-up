import 'package:cook_it_up/Classes/user.dart';
import 'package:cook_it_up/Recipes/Recommendations/recommendation_item.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  final User user;
  const Favorites({super.key, required this.user, }); // CONSTRUCTOR

  @override
  State<Favorites> createState() => _FavoritesState();// create state METHOD
}// PUBLIC CLASS

class _FavoritesState extends State<Favorites> {
 

  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        Expanded(
            child: ListView.builder(
             itemCount: widget.user.favoriteRecipes.length,
             itemBuilder: (BuildContext screen , int idx){
               return RecommendationItem(recipe: widget.user.favoriteRecipes[idx], user: widget.user,refeshFavFromItem: refreshFav, isFromFav: true,);
             }),
          ),
      ],
    );
  }// build METHOD

   void refreshFav(){
    setState(() { });
  }// refresh METHOD
  
  }// CLASS