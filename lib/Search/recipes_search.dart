import 'package:cook_it_up/Classes/dummy_recipes.dart';
import 'package:cook_it_up/Classes/user.dart';
import 'package:cook_it_up/Recipes/Recommendations/recommendation_item.dart';
import 'package:flutter/material.dart';

class RecipesSearch extends StatefulWidget {
  final User user;
  const RecipesSearch({super.key, required this.user});// CONSTRUCTOR

  @override
  State<RecipesSearch> createState() => _RecipesSearchState();// create state METHOD
}// PUBLIC

class _RecipesSearchState extends State<RecipesSearch> {
  final searchController = TextEditingController();
  late List<Recipe> recipes = recipeSamples;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }// dispose METHOD
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          children: [
            const SizedBox(height: 25,),
            TextField(
              controller: searchController,
              onChanged: (String txt){
                filterRecipes(txt);
              },
              style: const TextStyle(
                color: Colors.white
              ),
              decoration: InputDecoration(
                fillColor: Colors.black,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide:  BorderSide.none
                ),
                hintText: "eg: Chicken Francaise",
                hintStyle: const TextStyle(
                  color: Colors.white70
                ),
                prefixIcon: const Icon(Icons.search,color: Colors.white,),
                suffixIcon:   const Padding(
                  padding: EdgeInsets.all(15),
                  
                )
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
            child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (BuildContext screen , int idx){
                return RecommendationItem(
                  recipe: recipes[idx],
                 user: widget.user,
                  refeshFavFromItem: null, isFromFav: false,);
              },
            ),
          ),
          const SizedBox(height: 10,)
            ]
            ),
    );
  }// build METHOD
  
void filterRecipes(String input){
  List<Recipe> temp = input.isEmpty ? recipeSamples : 
  recipeSamples.where((Recipe element) => element.name.toUpperCase().contains(input.toUpperCase())).toList();
  setState(() {
    recipes = temp;
  });
}// filter data METHOD

}// PRIVATE