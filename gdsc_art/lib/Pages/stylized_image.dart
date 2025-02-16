import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Constants/Colors.dart';

class StylizedImage extends StatefulWidget {
  @override
  _SelectImagePageState createState() => _SelectImagePageState();
}

class _SelectImagePageState extends State<StylizedImage> {
  File? _image;
  final TextEditingController _imageName = TextEditingController();
  bool _publishedClicked = false;


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isImageSelected = _image != null;

    return Scaffold(
      backgroundColor: Color(0xFF1B1A1A),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Create",
          style: TextStyle(
            color: CustomColors.primaryWhite,
            fontFamily: "OutfitMedium",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "STYLIZE IMAGE",
                  style: TextStyle(
                    color: CustomColors.primaryCream,
                    fontFamily: "OutfitRegular",
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Publish in the public gallery or save privately!",
                  style: TextStyle(
                    color: CustomColors.primaryBrown,
                    fontFamily: "OutfitRegular",
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      height: 350,
                      color: Color(0xFF333333),
                    )),
                const SizedBox(height: 20),
                Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF202020),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      color: Color(0xFF202020),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Name",
                              style: TextStyle(
                                color: CustomColors.primaryCream,
                                fontFamily: "OutfitRegular",
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: TextField(
                              controller: _imageName,
                              decoration: InputDecoration(
                                hintText: "Enter a Name",
                                hintStyle: const TextStyle(
                                  color: CustomColors.primaryBrown,
                                  fontFamily: "OutfitRegular",
                                ),
                                filled: true,
                                fillColor: Color(0xFF363333),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(
                                color: CustomColors.primaryBrown,
                                fontFamily: "OutfitRegular",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_publishedClicked)
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "X",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: "OutfitRegular",
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "cannot Publish an untitled piece!",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: "OutfitRegular",
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    )),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isImageSelected ? _pickImage : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: CustomColors.primaryCream,
                          side: BorderSide(color: CustomColors.primaryCream),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Save Art",
                          style: TextStyle(
                            color: CustomColors.primaryCream,
                            fontFamily: "OutfitRegular",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_imageName.text.isEmpty) {
                            setState(() {
                              _publishedClicked = true;
                            });
                          } else {
                            setState(() {
                              _publishedClicked = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryCream,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontFamily: "OutfitMedium",
                          ),
                        ),
                        child: const Text('Publish'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
