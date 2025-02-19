import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/common_toast.dart';
import 'package:gdsc_artwork/Pages/stylized_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Constants/colors.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:provider/provider.dart';
import '../Providers/create_art_provider.dart';
import 'package:http/http.dart' as http;
import '../Constants/base_url.dart';

class SelectImagePage extends StatefulWidget {
  final dynamic styleImage;
  final String? styleThemeTitle;

  const SelectImagePage({
    super.key,
    this.styleThemeTitle,
    required this.styleImage,
  });

  @override
  State<SelectImagePage> createState() => _SelectImagePageState();
}

class _SelectImagePageState extends State<SelectImagePage> {
  File? _image;
  double contentSize = 50.0;
  double stylizationStrength = 50.0;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _getStyleImageBase64() async {
    if (widget.styleImage is File) {
      return base64Encode(await widget.styleImage.readAsBytes());
    } else if (widget.styleImage is String) {
      final response = await http.get(Uri.parse('${BaseUrl.baseUrl}${widget.styleImage}'));
      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      }
      throw Exception('Failed to load style image');
    }
    throw Exception('Invalid style image format');
  }

  void _processImage() async {
    if (_image == null) {
      commonToast('Please choose an Image to Style');
      return;
    }

    try {
      final provider = context.read<CreateArtProvider>();
      final contentImageBase64 = base64Encode(await _image!.readAsBytes());
      final styleImageBase64 = await _getStyleImageBase64();

      final success = await provider.stylizeImage(
        contentImage: contentImageBase64,
        styleImage: styleImageBase64,
        context: context,
      );

      if (success is String) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StylizedImage(
              styleThemeTitle: widget.styleThemeTitle,
              stylisedImage: success,
            ),
          ),
        );
      }
    } catch (e) {
      commonToast('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isImageSelected = _image != null;

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
                    const SizedBox(height: 10),
                    const Text(
                      "Primary Image",
                      style: TextStyle(
                        color: CustomColors.primaryCream,
                        fontFamily: "OutfitRegular",
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Select an image to stylize",
                      style: TextStyle(
                        color: CustomColors.primaryBrown,
                        fontFamily: "OutfitRegular",
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 340,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: _image == null
                          ? Center(
                              child: ElevatedButton(
                                onPressed: _pickImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "OutfitRegular",
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 300,
                              ),
                            ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SliderWithTitle(
                        title: "Primary Image Size",
                        initialValue: contentSize,
                        width: double.infinity,
                        fontSize: 14,
                        tooltipMessage: "Change image size",
                        onChanged: (value) =>
                            setState(() => contentSize = value),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const SliderWithTitle(
                        title: "Stylization Strength",
                        initialValue: 50.0,
                        width: double.infinity,
                        fontSize: 14,
                        tooltipMessage: "Change style strength",
                      ),
                    ),
                    const SizedBox(height: 20),
                    Opacity(
                      opacity: _image == null ? 0.5 : 1.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isImageSelected ? _pickImage : null,
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
                                "Change image",
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
                              onPressed: _image != null ? _processImage : null,
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
                              child: const Text('Stylize'),
                            ),
                          )
                        ],
                      ),
                    )
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

class SliderWithTitle extends StatefulWidget {
  final String title;
  final double initialValue;
  final double width;
  final double fontSize;
  final String tooltipMessage;
  final ValueChanged<double>? onChanged;

  const SliderWithTitle({
    super.key,
    required this.title,
    required this.initialValue,
    required this.width,
    required this.fontSize,
    required this.tooltipMessage,
    this.onChanged,
  });

  @override
  State<SliderWithTitle> createState() => _SliderWithTitleState();
}

class _SliderWithTitleState extends State<SliderWithTitle> {
  late double _sliderValue;
  final _controller = SuperTooltipController();

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: CustomColors.primaryWhite,
                fontWeight: FontWeight.bold,
                fontSize: widget.fontSize,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () async {
                await _controller.showTooltip();
              },
              child: SuperTooltip(
                showBarrier: true,
                controller: _controller,
                content: Text(
                  widget.tooltipMessage,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: CustomColors.primaryWhite,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: widget.width,
          child: CustomSlider(
            value: _sliderValue,
            onChanged: (newValue) {
              setState(() {
                _sliderValue = newValue;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
          ),
        ),
      ],
    );
  }
}

class CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CustomSlider({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: CustomColors.primaryWhite,
        inactiveTrackColor: CustomColors.primaryWhite,
        thumbColor: CustomColors.primaryWhite,
        trackHeight: 1.0,
        thumbShape: CustomSliderThumbShape(customThumbRadius: 8.0),
      ),
      child: Slider(
        value: value,
        min: 0,
        max: 100,
        divisions: 100,
        onChanged: onChanged,
      ),
    );
  }
}

class CustomSliderThumbShape extends RoundSliderThumbShape {
  final double customThumbRadius;

  CustomSliderThumbShape({required this.customThumbRadius});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(customThumbRadius);
  }
}
