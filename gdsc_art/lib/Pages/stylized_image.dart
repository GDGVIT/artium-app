import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:artium/Constants/common_toast.dart';
import 'package:provider/provider.dart';
import '../Constants/colors.dart';
import '../Providers/create_art_provider.dart';
import '../Data/theme_constants.dart';

class StylizedImage extends StatefulWidget {
  final String? styleThemeTitle;
  final String? stylisedImage;

  const StylizedImage({
    super.key,
    this.styleThemeTitle,
    this.stylisedImage,
  });

  @override
  State<StylizedImage> createState() => _StylizedImageState();
}

class _StylizedImageState extends State<StylizedImage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController themeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool saveSuccess = false;
  final _publishedClicked = false;

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CreateArtProvider>();
      final success = await provider.saveArt(
        theme: widget.styleThemeTitle == ''
            ? themeController.text
            : widget.styleThemeTitle!,
        title: titleController.text,
        description: descriptionController.text,
        context: context,
        image: widget.stylisedImage ?? '',
      );
      if (success) {
        saveSuccess = true;
        commonToast('Art Saved Successfully');
      }
    }
  }

  void _handlePublish() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CreateArtProvider>();
      if (saveSuccess) {
        final publishSuccess = await provider.publishArt(context);
        if (publishSuccess) {
          commonToast('Art submitted for review!');
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        commonToast('Please save your art first');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1A1A),
      appBar: AppBar(
        backgroundColor: Color(0xff141414),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
      body: Consumer<CreateArtProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                        child: provider.stylizedImage != null
                            ? Image.memory(
                                base64Decode(widget.stylisedImage!
                                    .replaceAll('data:image/jpeg;base64,', '')),
                                height: 350,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 350,
                                color: const Color(0xFF333333),
                              ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF202020),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          color: const Color(0xFF202020),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Name your Art!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: CustomColors.primaryWhite,
                                    fontFamily: "OutfitRegular",
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: titleController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name for your art';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter a Name",
                                  hintStyle: const TextStyle(
                                    color: CustomColors.primaryBrown,
                                    fontFamily: "OutfitRegular",
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF363333),
                                  contentPadding: const EdgeInsets.symmetric(
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
                              const SizedBox(
                                height: 10,
                              ),
                              if (_publishedClicked)
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Name is missing",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: "OutfitRegular",
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                      widget.styleThemeTitle == ''
                          ? Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF202020),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                color: const Color(0xFF202020),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Theme",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: CustomColors.primaryWhite,
                                          fontFamily: "OutfitRegular",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField<String>(
                                      value: themeController.text.isEmpty
                                          ? ThemeConstants.availableThemes[0]
                                          : themeController.text,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a theme';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Select Theme",
                                        hintStyle: const TextStyle(
                                          color: CustomColors.primaryBrown,
                                          fontFamily: "OutfitRegular",
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFF363333),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 14.0,
                                          horizontal: 16.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      dropdownColor: const Color(0xFF363333),
                                      style: const TextStyle(
                                        color: CustomColors.primaryCream,
                                        fontFamily: "OutfitRegular",
                                      ),
                                      items: ThemeConstants.availableThemes
                                          .map((theme) => DropdownMenuItem(
                                                value: theme,
                                                child: Text(theme),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          themeController.text = value;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (_publishedClicked)
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Choose a Theme",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: "OutfitRegular",
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF202020),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          color: const Color(0xFF202020),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: CustomColors.primaryWhite,
                                    fontFamily: "OutfitRegular",
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                maxLines: 5,
                                controller: descriptionController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Describe your art",
                                  hintStyle: const TextStyle(
                                    color: CustomColors.primaryBrown,
                                    fontFamily: "OutfitRegular",
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF363333),
                                  contentPadding: const EdgeInsets.symmetric(
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
                              const SizedBox(
                                height: 10,
                              ),
                              if (_publishedClicked)
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Description is missing",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: "OutfitRegular",
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _handleSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: CustomColors.primaryCream,
                                side: const BorderSide(
                                    color: CustomColors.primaryCream),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
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
                              onPressed: _handlePublish,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.primaryCream,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14.0),
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
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
