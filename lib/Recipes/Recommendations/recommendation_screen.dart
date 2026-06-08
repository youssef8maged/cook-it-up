import 'dart:convert';
import 'dart:developer';

import 'package:cook_it_up/Classes/dummy_recipes.dart';
import 'package:cook_it_up/Classes/user.dart';
import 'package:cook_it_up/Recipes/Recommendations/recommendation_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecommendationScreen extends StatefulWidget {
  final User user;

  const RecommendationScreen({super.key, required this.user}); // CONSTRUCTOR

  @override
  State<RecommendationScreen> createState() =>
      _RecommendationScreenState(); // create state METHOD
} // PUBLIC

class _RecommendationScreenState extends State<RecommendationScreen> {
  int? maxTime;
  int? maxCalories;
  String? preference;
  int numberOfRecommendations = 2; // Default number of recommendations
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Max Time (minutes)'),
              onChanged: (value) {
                maxTime = int.tryParse(value);
              },
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Max Calories'),
              onChanged: (value) {
                maxCalories = int.tryParse(value);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButton<String>(
              value: preference,
              hint: const Text('Select Preference'),
              items: const [
                DropdownMenuItem(
                    value: '1', child: Text('Least number of steps')),
                DropdownMenuItem(
                    value: '2', child: Text('Least number of ingredients')),
                DropdownMenuItem(value: '3', child: Text('Least cooking time')),
                DropdownMenuItem(value: '4', child: Text('Highest rated')),
                DropdownMenuItem(value: '5', child: Text('Lowest calorie')),
                DropdownMenuItem(value: '6', child: Text('Highest calorie')),
                DropdownMenuItem(
                    value: '7', child: Text('Nutritional preferences')),
              ],
              onChanged: (value) {
                setState(() {
                  preference = value;
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Number of Recommendations'),
              onChanged: (value) {
                numberOfRecommendations = int.tryParse(value) ??
                    2; // Default to 2 if input is invalid
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if (widget.user.choosenIngredients.isEmpty) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please provide your ingredients !"),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  } else {
                    fetchRecommendations(widget.user.choosenIngredients);
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue),
                child: const Text(
                  "Go and Generate !",
                )),
            const SizedBox(
              height: 10,
            ),
            if (isLoading) const CircularProgressIndicator(),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.user.recommendedRecipes.length,
                itemBuilder: (BuildContext ctx, int idx) {
                  return RecommendationItem(
                      recipe: widget.user.recommendedRecipes[idx],
                      user: widget.user,
                      refeshFavFromItem: null,
                      isFromFav: false);
                }),
          ],
        ),
      ),
    );
  } // build METHOD

  void fetchRecommendations(List<String> preferredIngredients) async {
    if (maxCalories == null || maxTime == null || preference == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill the fields with your preferences"),
          duration: Duration(seconds: 5),
        ),
      );
      return ;
    }
    
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.2:5001/recommendations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'preferred_ingredients':
              preferredIngredients.map((String ingredient) {
            return ingredient.toLowerCase();
          }).toList(),
          'max_time': maxTime,
          'max_calories': maxCalories,
          'preference': preference,
          'number_of_recommendations': numberOfRecommendations,
        }),
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        setState(() {
          widget.user.recommendedRecipes.clear();
          for (var element in responseData) {
            widget.user.recommendedRecipes.add(Recipe(
                name: element['name'],
                ingredients: (element['ingredients'] as List<dynamic>)
                    .map((e) => e.toString())
                    .toList(),
                steps: (element['steps'] as String)
                    .substring(1, (element['steps'] as String).length - 1)
                    .split("', '"),
                time: element['minutes'],
                calories: element['calories'],
                totalFat: element['total fat (PDV)'],
                sugar: element['sugar (PDV)'],
                sodium: element['sodium (PDV)'],
                protein: element['protein (PDV)'],
                saturatedFat: element['saturated fat (PDV)'],
                carbohydrates: element['carbohydrates (PDV)']));
          }
        });
      } else {
        if (mounted) {
          setState(() {
            widget.user.recommendedRecipes.clear();
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("There is nothing to recommend"),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      log(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error while fetching recommendations"),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  } // fetch recommendations METHOD
}// PRIVATE CLASS