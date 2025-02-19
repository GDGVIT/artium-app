import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/common_toast.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _publishedClicked = false;

  void _handleSave() async {
    if (_titleController.text.isEmpty) return;

    final provider = context.read<CreateArtProvider>();
    final success = await provider.saveArt(
      theme: widget.styleThemeTitle,
      title: _titleController.text,
      description: _descriptionController.text,
      context: context,
    );

    if (success) {
      commonToast('Art Saved Succesfully');
    }
  }

  void _handlePublish() async {
    if (_titleController.text.isEmpty) {
      setState(() => _publishedClicked = true);
      return;
    }

    final provider = context.read<CreateArtProvider>();
    final saveSuccess = await provider.saveArt(
      theme: widget.styleThemeTitle,
      title: _titleController.text,
      description: _descriptionController.text,
      context: context,
    );

    if (saveSuccess && mounted) {
      final publishSuccess = await provider.publishArt(context);
      if (publishSuccess && mounted) {
        commonToast('Art Published!');
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1A1A),
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
      body: Consumer<CreateArtProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
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
                    if (widget.styleThemeTitle == null) ...[
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF202020),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: provider.themeController.text.isEmpty
                              ? null
                              : provider.themeController.text,
                          decoration: const InputDecoration(
                            labelText: 'Select Theme',
                            labelStyle: TextStyle(
                              color: CustomColors.primaryCream,
                              fontFamily: "OutfitRegular",
                            ),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.primaryCream),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.primaryCream),
                            ),
                          ),
                          dropdownColor: const Color(0xFF202020),
                          style: const TextStyle(
                            color: CustomColors.primaryWhite,
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
                              provider.themeController.text = value;
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
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
                                "Name",
                                style: TextStyle(
                                  color: CustomColors.primaryCream,
                                  fontFamily: "OutfitRegular",
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _titleController,
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
