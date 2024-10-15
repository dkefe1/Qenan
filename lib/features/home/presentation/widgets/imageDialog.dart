import 'dart:async';

import 'package:flutter/material.dart';

void showImageDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.9),
    builder: (context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder(
            future: _getImageSize(imageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final Size imageSize = snapshot.data as Size;
                final double maxHeight = constraints.maxHeight - 80;
                final double maxWidth = constraints.maxWidth - 40;

                double width = imageSize.width;
                double height = imageSize.height;

                if (width > maxWidth) {
                  final scaleFactor = maxWidth / width;
                  width *= scaleFactor;
                  height *= scaleFactor;
                }

                if (height > maxHeight) {
                  final scaleFactor = maxHeight / height;
                  width *= scaleFactor;
                  height *= scaleFactor;
                }

                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      );
    },
  );
}

Future<Size> _getImageSize(String imageUrl) async {
  final Completer<Size> completer = Completer();
  final Image image = Image.network(imageUrl);
  image.image.resolve(ImageConfiguration()).addListener(
    ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(
          Size(info.image.width.toDouble(), info.image.height.toDouble()));
    }),
  );
  return completer.future;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Image Dialog Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showImageDialog(context, "https://example.com/your_image.jpg");
            },
            child: Text('Show Image Dialog'),
          ),
        ),
      ),
    );
  }
}
