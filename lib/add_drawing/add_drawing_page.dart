import 'package:flutter/material.dart';
import 'package:painter/painter.dart';

import 'image_editor/color_picker_button.dart';

class AddDrawingPage extends StatefulWidget {
  final Color color;

  AddDrawingPage({
    this.color = Colors.orange,
  });

  @override
  State<StatefulWidget> createState() => AddDrawingPageState();
}

class AddDrawingPageState extends State<AddDrawingPage> {
  PainterController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PainterController()
      ..thickness = 5.0
      ..backgroundColor = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Drawing'),
        elevation: 1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: widget.color,
                ),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Container(color: Colors.white),
                    Painter(_controller),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                          child: Slider(
                        value: _controller.thickness,
                        onChanged: (double value) => setState(() {
                          _controller.thickness = value;
                        }),
                        min: 1.0,
                        max: 20.0,
                        activeColor: Colors.white,
                      ));
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.undo,
                    color: widget.color,
                  ),
                  tooltip: 'Undo',
                  onPressed: () {
                    if (!_controller.isEmpty) {
                      _controller.undo();
                    }
                  },
                ),

                IconButton(
                  icon: Icon(Icons.delete, color: widget.color),
                  tooltip: 'Clear',
                  onPressed: _controller.clear,
                ),
                ColorPickerButton(_controller, false),
                // ColorPickerButton(_controller, true),
              ],
            ),
            ElevatedButton(
              child: Text(
                'Add Drawing',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                PictureDetails pictureDetails = _controller.finish();

                pictureDetails.toPNG().then((picture) {
                  Navigator.pop(
                    context,
                    picture,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
