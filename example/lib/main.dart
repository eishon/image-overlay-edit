import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_overlay_edit/add_drawing/add_drawing_page.dart';
import 'package:image_overlay_edit_example/ImageOverlayEditPage.dart';
import 'package:image_overlay_edit_example/show_preview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/add_drawing') {
          return MaterialPageRoute(
            builder: (context) {
              return AddDrawingPage();
            },
          );
        } else if (settings.name == '/preview') {
          final Map args = settings.arguments as Map;

          return MaterialPageRoute(
            builder: (context) {
              return ShowPreview(
                image: args['image'] as Uint8List,
              );
            },
          );
        } else {
          return MaterialPageRoute(
            builder: (context) {
              return ImageOverlayEditPage();
            },
          );
        }
      },
    );
  }
}
