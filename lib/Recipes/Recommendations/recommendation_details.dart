import 'package:cook_it_up/Classes/dummy_recipes.dart';
import 'package:cook_it_up/Classes/user.dart';
import 'package:cook_it_up/Recipes/Recommendations/recommendation_similar.dart';
import 'package:flutter/material.dart';

class RecommendationDetails extends StatefulWidget {
  final Recipe recipe;
  final bool isFromFav;
  final User user;
   final void Function()? refeshFavFromDetails;
  const RecommendationDetails({super.key, required this.recipe, required this.user, required this.refeshFavFromDetails, required this.isFromFav});// CONSTRUCTOR
  
  @override
  State<RecommendationDetails> createState() => _RecommendationDetailsState();// create state METHOD
}

class _RecommendationDetailsState extends State<RecommendationDetails> {

  late IconData fav;

@override
  void initState() {
    super.initState();
    fav = widget.user.favoriteRecipes.contains(widget.recipe) ? Icons.star : Icons.star_border;
  }//init state METHOD

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        actions:  [
          IconButton(
            icon:  Icon(fav),
            onPressed: () async{
              switch (fav) {
                case Icons.star_border:
                    widget.user.favoriteRecipes.add(widget.recipe);
                    fav = Icons.star;
                    if (mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Recipe is marked as favorite"),
                        duration: Duration(seconds: 5),
                      ),
                    );
                    }

                    if(widget.refeshFavFromDetails != null){
                    widget.refeshFavFromDetails!();
                    }
                    setState(() { });
                  break;
                case Icons.star:  
                    widget.user.favoriteRecipes.remove(widget.recipe);
                    fav = Icons.star_border;
                    if (mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Recipe is no longer a favorite"),
                        duration: Duration(seconds: 5),
                      ),
                    );
                    }
                     if(widget.refeshFavFromDetails != null){
                    widget.refeshFavFromDetails!();
                    }
                    setState(() { });
              }
            },
            )
        ],
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.amber,
        title:  Text(widget.recipe.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),
        ),
      ),
      body:   Column(
        children: [
          const SizedBox(height: 20,),
          const Text("Ingredients\n",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.recipe.ingredients.length,
              itemBuilder: (BuildContext screen , int idx){
                return Text(
                  widget.recipe.ingredients[idx],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white ,
                  ),
                  );
              },
              ),
          ),
          const SizedBox(height: 20,),
          const Text(
          "Steps\n",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.recipe.steps.length,
            itemBuilder: (BuildContext screen , int idx){
                return  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "${widget.recipe.steps[idx]}\n",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white ,
                    ),
                    ),
                );
            } ),
             ),
             if(!widget.isFromFav)
             ElevatedButton(
                    onPressed: (){
                      Recipe? similarRecipe = widget.recipe.similar; 
                      if (similarRecipe != null) {
                        Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext screen){
                          return RecommendationSimilar(similarRecipe: similarRecipe,originalRecipe: widget.recipe, user:  widget.user ,refeshFavFromSimilar: widget.refeshFavFromDetails,);
                        })
                      );
                      } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("There is no similar recipe"),
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
                  }, 
                  child: const Text("Show Similar Recipe",
                  )
                  ),
                  const SizedBox(height: 20,) 
        ],
      ),
    );
  }// build METHOD

  }// CLASS