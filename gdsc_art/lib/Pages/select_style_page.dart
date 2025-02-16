import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Pages/select_image_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Constants/Colors.dart';
import 'package:super_tooltip/super_tooltip.dart';

class SelectStylePage extends StatefulWidget {
  @override
  _SelectImagePageState createState() => _SelectImagePageState();
}

class _SelectImagePageState extends State<SelectStylePage> {
  File? _image;

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
        title: Text(
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
                  "ART STYLE",
                  style: TextStyle(
                    color: CustomColors.primaryCream,
                    fontFamily: "OutfitRegular",
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Select an art style to stylize with",
                  style: TextStyle(
                    color: CustomColors.primaryBrown,
                    fontFamily: "OutfitRegular",
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF333333),
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
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF333333),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SliderWithTitle(
                    title: "ART STYLE SIZE",
                    initialValue: 50.0,
                    width: double.infinity,
                    fontSize: 14,
                    tooltipMessage: "hello there this is rujin",
                  ),
                ),
                const SizedBox(height: 50),
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
                            side: BorderSide(color: CustomColors.primaryCream),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            "Change Art",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectImagePage()),
                            );
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
                          child: const Text('Proceed'),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
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

  SliderWithTitle({
    required this.title,
    required this.initialValue,
    required this.width,
    required this.fontSize,
    required this.tooltipMessage,
  });

  @override
  _SliderWithTitleState createState() => _SliderWithTitleState();
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
                  style: TextStyle(
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
        const SizedBox(height: 8),
        SizedBox(
          width: widget.width,
          child: CustomSlider(
            value: _sliderValue,
            onChanged: (newValue) {
              setState(() {
                _sliderValue = newValue;
              });
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

  CustomSlider({required this.value, required this.onChanged});

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
