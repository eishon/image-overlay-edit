import 'package:flutter/material.dart';
import 'package:painter/painter.dart';

import 'color_picker_button.dart';

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  final Color color;

  DrawBar(this._controller, {this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Row(
            children: [],
          );
        }),
        IconButton(
          icon: Icon(
            Icons.replay,
            color: color,
          ),
          tooltip: 'Clear',
          onPressed: _controller.clear,
        ),
        ColorPickerButton(_controller, false),
        // ColorPickerButton(_controller, true),
      ],
    );
  }
}
