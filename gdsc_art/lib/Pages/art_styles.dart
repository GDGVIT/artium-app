import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

class ArtStylesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Art Styles',
            style: TextStyle(color: Colors.white, fontFamily: "OutfitMedium")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.9, // Adjust this to control the item height
          ),
          itemBuilder: (BuildContext context, int index) {
            return Card(
                color: CustomColors.tertiaryBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.0),
                          ),
                          child: Image.asset(
                            index % 2 == 0
                                ? 'images/galleryImage1.png'
                                : 'images/galleryImage2.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          index % 2 == 0
                              ? 'Post - Impressionism'
                              : 'Abstractism',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "OutfitMedium",
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
