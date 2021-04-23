import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_util/image_util.dart';

class ShowPreview extends StatefulWidget {
  final Uint8List image;

  ShowPreview({
    @required this.image,
  });

  @override
  _ShowPreviewState createState() => _ShowPreviewState();
}

class _ShowPreviewState extends State<ShowPreview> {
  Uint8List image;

  void _onPhotoSavePressed() {
    ImageUtil.saveToGallery(image).catchError((error) {
      print('Error: ${error.toString()}');
    });
  }

  @override
  void initState() {
    super.initState();

    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Preview'),
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPhotoSavePressed,
        child: Icon(Icons.file_download),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: Image.memory(image),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
