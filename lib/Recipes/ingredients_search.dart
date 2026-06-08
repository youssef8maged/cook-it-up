
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cook_it_up/Classes/user.dart';
import 'package:cook_it_up/Recipes/ingredients_list.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class IngredientsSearch extends StatefulWidget {
   final User user;
   const IngredientsSearch({super.key,required this.user});// CONSTRUCTOR

  @override
  State<IngredientsSearch> createState() => _IngredientsSearchState();// create state METHOD
}// PUBLIC CLASS

class _IngredientsSearchState extends State<IngredientsSearch> {

  final searchController = TextEditingController();
  late List<String> foundIngredients;
  bool isRecording = false;
  bool isClicked = false;
  SpeechToText speech = SpeechToText();

  @override
  void initState() {
    foundIngredients = widget.user.shownIngredients;
    super.initState();
  }// init state METHOD

@override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }// dispose METHOD

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 25,),
          TextField(
            controller: searchController,
            onChanged: (String txt){
              filterIngredients(txt);
            },
            style: const TextStyle(
              color: Colors.black
            ),
            decoration: InputDecoration(
              fillColor: Colors.grey.shade400,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide:  BorderSide.none
              ),
              hintText: "eg: Milk",
              prefixIcon: const Icon(Icons.search),
              suffixIcon:   Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: ()async{
                    if (!isClicked) {
                    bool available = await speech.initialize();  
                      if (available) {
                        setState(() {
                        isClicked =true;
                        isRecording = true;
                        speech.listen(
                          onResult: (results){
                            setState(() {
                              searchController.text = results.recognizedWords;
                            });
                          },
                        );
                        });
                      }
                      }
                      else{ 
                        await speech.stop();
                        setState(() {
                        isClicked = false;
                        isRecording = false;
                        takeVoice(searchController.text);
                        searchController.text = "";
                        });

                      }
                     
                  },
                  child: AvatarGlow(
                    animate: isRecording,
                    glowCount: 3,
                    glowRadiusFactor: 1,
                    duration: const Duration(seconds: 2),
                    glowColor: isRecording ? Colors.green : Colors.white,
                    child:  Icon(
                      isRecording ? Icons.mic : Icons.mic_none,
                      size: 40,
                      ),
                    ),
                ),
              )
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext screen){return   IngredientsList(user: widget.user,);}, 
                )
                );
            },
            child: const Text("View Your\nIngredients"),),
          Expanded(
            child: ListView.builder(
              itemCount: foundIngredients.length,
              itemBuilder: (BuildContext screen , int idx){
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.grey.shade200,
                  child: ListTile(
                    title: Text(
                      foundIngredients[idx],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      onPressed: (){
                          widget.user.choosenIngredients.add(foundIngredients[idx]);
                          widget.user.shownIngredients.remove(foundIngredients[idx]);
                          filterIngredients(searchController.text);
                      },
                      child: const Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white
                        ),
                        ),
                      ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }// build METHOD

void filterIngredients(String input){
  List<String> temp = [];
  if (input.isEmpty) {
      temp = widget.user.shownIngredients;
  }else{
    temp = widget.user.shownIngredients.where((element) => element.contains(input.toUpperCase())).toList();
  }
  setState(() {
    foundIngredients = temp;
  });
}// filter data METHOD


void takeVoice(String ingredients){
  final temp = ingredients.trim().split(" ");
  for (String element in temp) {
    element = element.toUpperCase();
    if (widget.user.shownIngredients.contains(element)) {
        widget.user.choosenIngredients.add(element);
        widget.user.shownIngredients.remove(element);
    }
  }
  filterIngredients("");
}// take voice METHOD

}// PRIVATE CLASS