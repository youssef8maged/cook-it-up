import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart' as pick;

class Uploading extends StatefulWidget {
  const Uploading({super.key}); // CONSTRUCTOR

  @override
  State<Uploading> createState() => _UploadingState(); // create state METHOD
} // PUBLIC CLASS

class _UploadingState extends State<Uploading> {
  File? selected;
  late IconData checkIcon;
  String label = "Please upload an image";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (label.contains("Please")) {
      checkIcon = Icons.question_mark;
    } else {
      if (label.contains("Unk")) {
        checkIcon = Icons.close;
      } else {
        checkIcon = Icons.check;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      pickRecipe("gal");
                    },
                    child: const Text("Image from gallery")),
                TextButton(
                    onPressed: () {
                      if (selected == null) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No image to remove"),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      } else {
                        setState(() {
                          selected = null;
                          label = "Please upload an image";
                        });
                      }
                    },
                    child: const Text("Remove image")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      pickRecipe("cam");
                    },
                    child: const Text("Image from camera")),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Icon(checkIcon),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            if (isLoading) const CircularProgressIndicator(),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            selected != null
                ? Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Image.file(
                      selected!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(
                    height: 20,
                  ),
          ],
        ),
      ),
    );
  } // build METHOD

  Future<void> pickRecipe(String source) async {
    final returned = await pick.ImagePicker().pickImage(
      source:
          source == "cam" ? pick.ImageSource.camera : pick.ImageSource.gallery,
      imageQuality: 100,
    );
    if (returned == null) {
      return;
    } else {
      setState(() async {
        selected = null;
        selected = File(returned.path);
        await uploadImage(selected!);
      });
    }
  } // pick recipe METHOD

  Future<void> uploadImage(File image) async {
    setState(() {
      isLoading = true;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.3:5000/upload'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final result = jsonDecode(responseData)['result'];
        setState(() {
          label = result.toString();
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sorry we can't recognize it"),
              duration: Duration(seconds: 5),
            ),
          );
        }
        setState(() {
          label = "Failed to upload image";
        });
      }
    } catch (e) {
      log(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error while recognizing"),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  } // upload image METHOD
}// PRIVATE CLASS