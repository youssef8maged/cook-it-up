import 'package:cook_it_up/Classes/dummy_recipes.dart';
import 'package:cook_it_up/Classes/user.dart';
import 'package:flutter/material.dart';

class RecommendationSimilar extends StatefulWidget {
  final Recipe similarRecipe;
  final Recipe originalRecipe;
  final User user;
  final void Function()? refeshFavFromSimilar;

  const RecommendationSimilar({
    super.key,
    required this.similarRecipe,
    required this.user,
    required this.refeshFavFromSimilar,
    required this.originalRecipe,
  });

  @override
  State<RecommendationSimilar> createState() => _RecommendationDetailsState();
}

class _RecommendationDetailsState extends State<RecommendationSimilar> {
  late IconData fav;

  @override
  void initState() {
    super.initState();
    fav = widget.user.favoriteRecipes.contains(widget.similarRecipe)
        ? Icons.star
        : Icons.star_border;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(fav),
            onPressed: () {
              if (fav == Icons.star_border) {
                widget.user.favoriteRecipes.add(widget.similarRecipe);
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
                widget.refeshFavFromSimilar?.call();
                setState(() {});
              } else {
                widget.user.favoriteRecipes.remove(widget.similarRecipe);
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
                widget.refeshFavFromSimilar?.call();
                setState(() {});
              }
            },
          )
        ],
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.amber,
        title: Text(
          widget.similarRecipe.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Text(
            "Similar to ${widget.originalRecipe.name}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ingredients\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.similarRecipe.ingredients.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  widget.similarRecipe.ingredients[index],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.schedule),
                            const SizedBox(width: 10),
                            Text("${widget.similarRecipe.time} minutes",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Total Fat: ${widget.similarRecipe.totalFat}",
                            style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                "Saturated Fat: ${widget.similarRecipe.saturatedFat}",
                                style: const TextStyle(color: Colors.white),
                                ),
                          ],
                        ),
                        Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Sugar: ${widget.similarRecipe.sugar}",
                            style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Sodium: ${widget.similarRecipe.sodium}",
                            style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Protein: ${widget.similarRecipe.protein}",
                            style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Calories: ${widget.similarRecipe.calories}",
                            style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Text(
                          "Carbohydrates: ${widget.similarRecipe.carbohydrates}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
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
              itemCount: widget.similarRecipe.steps.length,
              itemBuilder: (BuildContext screen, int idx) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "${widget.similarRecipe.steps[idx]}\n",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
