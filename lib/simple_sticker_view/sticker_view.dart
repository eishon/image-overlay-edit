import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'sticker_image.dart';

class StickerView extends StatefulWidget {
  StickerView({
    this.source,
    this.attachedList, 
    this.key,
    this.aspectRatio = 1,
    this.devicePixelRatio = 3.0,
  }) : super(key: key);

  final GlobalKey key;

  final Widget source;
  final List<StickerImage> attachedList;

  final double aspectRatio;

  final double devicePixelRatio;

  Future<Uint8List> exportImage() async {
    await (key.currentState as _StickerViewState)._prepareExport();

    Future<Uint8List> exportImage =
        (key.currentState as _StickerViewState).exportImage();
    print("export image success!");
    return exportImage;
  }

  Size getViewport(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return key.currentState == null
        ? Size(width, width / aspectRatio)
        : (key.currentState as _StickerViewState).viewport;
  }

  @override
  _StickerViewState createState() => _StickerViewState();
}

class _StickerViewState extends State<StickerView> {
  _StickerViewState();

  Size viewport;

  final GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: RepaintBoundary(
            key: key,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    viewport = viewport ??
                        Size(constraints.maxWidth, constraints.maxHeight);
                    return widget.source;
                  },
                ),
                Stack(
                  children: widget.attachedList,
                  fit: StackFit.expand,
                  alignment: AlignmentDirectional.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> exportImage() async {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    var image =
        await boundary.toImage(pixelRatio: this.widget.devicePixelRatio);
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();

    return pngBytes;
  }

  Future<void> _prepareExport() async {
    widget.attachedList.forEach((s) {
      s.prepareExport();
    });
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
