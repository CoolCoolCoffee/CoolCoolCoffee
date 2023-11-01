import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:palette_generator/palette_generator.dart';
class ColorPalette extends StatefulWidget {
  @override
  State<ColorPalette> createState() => _ColorPaletteState();
}

class _ColorPaletteState extends State<ColorPalette> {
  Image image = Image.asset('assets/mega.jpeg');
  late List<PaletteColor> colors;

  @override
  void initState() {
    super.initState();
    colors = [];
    _updatePalettes();
  }

  _updatePalettes() async {
    final PaletteGenerator generator = await
        PaletteGenerator.fromImageProvider(
          AssetImage('assets/mega.jpeg'),
        );
    for(var color in generator.paletteColors){
      colors.add(color);
    }
    setState(() {

    });

  }
  void getRecognizedText(XFile image) async {
    // XFile 이미지를 InputImage 이미지로 변환
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("camera palette")),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30, width: double.infinity),
              _buildPhotoArea(),
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                  itemCount: colors.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10
                  ),
                  itemBuilder: (context, index){
                    return Container(
                      color: Colors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              
                              margin: EdgeInsets.all(10),
                                color: colors[index].color,
                            ),
                          ),
                          Text(colors[index].hashCode.toString())
                        ],
                      ),
                    );
                  })
              //_buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return GestureDetector(
      child: Container(
        width: 300,
        height: 300,
        child: Image.asset('assets/mega.jpeg'),
      ),
    );
  }
}