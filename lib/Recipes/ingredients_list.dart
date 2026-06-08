import 'package:cook_it_up/Classes/user.dart';
import 'package:flutter/material.dart';

class IngredientsList extends StatefulWidget {
  final User user;
  const IngredientsList({super.key, required this.user});//CONSTRUCTOR

  @override
  State<IngredientsList> createState() => _IngredientsListState();// create state METHOD
}// PUBLIC CLASS

class _IngredientsListState extends State<IngredientsList> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 166, 0),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text(
                "\nYour Choosen Ingredients :",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
                ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Card(
                  color: Colors.white,
                  child:  ListView.builder(
                    itemCount: widget.user.choosenIngredients.length,
                    itemBuilder: (BuildContext screen, int idx){
                      return  ListTile(
                        trailing: IconButton(
                          onPressed: (){
                            setState(() {
                            widget.user.shownIngredients.add(widget.user.choosenIngredients.removeAt(idx));
                              
                            });
                          },
                          icon: const Icon(Icons.delete),),
                        leading: Text(
                          "${idx+1}) ",
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        ),
                        title: Text(widget.user.choosenIngredients[idx]),
                      );
                    }
                    ),
                ),
              ),
              const SizedBox(height: 50,),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Return to previous page",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ) ,
                ),
              const SizedBox(height: 50,)    
            ],
          ),
        ),
      ),
    );
  }// build METHOD 
  
  }// PRIVATE CLASS