import 'package:cook_it_up/Classes/dummy_recipes.dart';
import 'package:cook_it_up/Classes/user.dart';
import 'package:cook_it_up/Recipes/Recommendations/recommendation_details.dart';
import 'package:flutter/material.dart';

class RecommendationItem extends StatelessWidget {
  final Recipe recipe;
  final User user;
  final bool isFromFav;
  final void Function()? refeshFavFromItem;
  const RecommendationItem({super.key,required this.recipe,required this.user,required this.refeshFavFromItem, required this.isFromFav});// CONSTRUCTOR

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.grey.shade400,
      margin: const EdgeInsets.only(left: 10,right: 10,top: 10),
      child:  Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(recipe.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.schedule),
                const SizedBox(width: 10,),
                Text("${recipe.time} minutes"),
              ],
            ),
            const SizedBox(height: 10,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Fat: ${recipe.totalFat}"),
                Text("Saturated Fat: ${recipe.saturatedFat}"),
              ],
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sugar: ${recipe.sugar}"),
                Text("Sodium: ${recipe.sodium}"),
              ],
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Protein: ${recipe.protein}"),
                Text("Calories: ${recipe.calories}"),
              ],
            ),
             Row(
              children: [
                Text("Carbohydrates: ${recipe.carbohydrates}"),
              ],
            ),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext screen){
                      return RecommendationDetails(recipe: recipe, user:  user,refeshFavFromDetails: refeshFavFromItem, isFromFav: isFromFav,);
                    })
                  );
              }, 
              child: const Text("Details",
              ))

          ],
        ),
      ),
    );
  }// build METHOD
}// CLASS