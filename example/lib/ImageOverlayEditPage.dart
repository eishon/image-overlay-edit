import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_overlay_edit/simple_sticker_view/sticker_image.dart';
import 'package:image_overlay_edit/simple_sticker_view/sticker_panel.dart';
import 'package:image_overlay_edit/simple_sticker_view/sticker_view.dart';
import 'package:image_util/image_util.dart';

class ImageOverlayEditPage extends StatefulWidget {
  ImageOverlayEditPage();
  @override
  _ImageOverlayEditPageState createState() => _ImageOverlayEditPageState();
}

class _ImageOverlayEditPageState extends State<ImageOverlayEditPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final key = GlobalKey();
  final bottomSheetKey = GlobalKey();

  Uint8List finalImage;
  Uint8List originalImage;

  ImageInfo originalImageInfo;

  bool _loaded = false;

  GlobalKey _keyImage = GlobalKey();
  double imageHeight;
  double imageWidth;

  BoxFit imageFit = BoxFit.none;

  List<Image> drawings = [];
  List<Image> emojis = [];

  List emojiFiles = [];

  List<StickerImage> attachedSticker = [];

  final double stickerPanelHeight = 300;
  final double drawingPanelHeight = 216;

  final double stickerSize = 200;
  final double stickerMaxScale = 10.0;
  final double stickerMinScale = 0.1;

  Size viewport;

  void addFrame() async {
    final file = await ImageUtil.getImageFileFromAssets('white.png');
    Uint8List whiteSpace = file.readAsBytesSync();

    finalImage = await compute(
      ImageUtil.computeFrameImage,
      {
        'imageData': originalImage,
        'whiteImage': whiteSpace,
        'width': imageWidth,
        'height': imageHeight,
      },
    );

    setState(() {});
  }

  void getEmojis() async {
    emojiFiles = await ImageUtil.getEmojisList(context);

    emojis = emojiFiles.map((item) {
      return Image.asset(item);
    }).toList();

    print('${emojis.length} emojis loaded');

    if (bottomSheetKey.currentState != null) {
      bottomSheetKey.currentState.setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    if (originalImage == null)
      ImageUtil.getImageFileFromAssets('demo.jpeg').then(
        (image) {
          originalImage = image.readAsBytesSync();
          setState(() {});
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    if (emojiFiles.length == 0) getEmojis();

    Image _imageWidget;
    if (originalImage != null)
      _imageWidget = Image.memory(
        originalImage,
        fit: BoxFit.cover,
        key: _keyImage,
      );
    if (!_loaded && _imageWidget != null)
      _imageWidget.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool syncCall) {
            setState(() {
              originalImageInfo = info;
              imageFit =
                  originalImageInfo.image.width > originalImageInfo.image.height
                      ? BoxFit.fitWidth
                      : BoxFit.fitHeight;

              imageWidth = originalImageInfo.image.width.toDouble();
              imageHeight = originalImageInfo.image.height.toDouble();

              _loaded = true;

              addFrame();
            });
          },
        ),
      );

    double imageAspectRatio =
        (originalImageInfo == null) ? 1 / 1 : imageWidth / imageHeight;

    StickerView stickerView = StickerView(
      source: Container(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: imageAspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: finalImage == null
                ? Container()
                : Image.memory(
                    finalImage,
                    fit: imageFit,
                    key: _keyImage,
                  ),
          ),
        ),
      ),
      attachedList: attachedSticker,
      key: key,
      aspectRatio: imageAspectRatio,
    );

    viewport = stickerView.getViewport(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Image Overlay Edit'),
        elevation: 1,
      ),
      floatingActionButton: (originalImage == null)
          ? null
          : ButtonBar(
              children: [
                FloatingActionButton(
                  heroTag: 'add_sticker',
                  child: Icon(
                    Icons.emoji_emotions,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showStickerPanel(context);
                  },
                ),
                FloatingActionButton(
                  heroTag: 'preview',
                  child: Icon(
                    Icons.preview,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    stickerView.exportImage().then((image) {
                      Navigator.pushNamed(context, '/preview', arguments: {
                        'image': image,
                      });
                    });
                  },
                ),
              ],
            ),
      body: SafeArea(
        child: (originalImage == null)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : stickerView,
      ),
    );
  }

  void addDrawingToStickers() {
    Navigator.of(context).pushNamed('/add_drawing').then((drawingData) {
      if (drawingData != null) {
        drawings.add(Image.memory(drawingData));
        //setState(() {});
        bottomSheetKey.currentState.setState(() {});
      } else {
        print('No Image Data');
      }
    });
  }

  void showStickerPanel(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              key: bottomSheetKey,
              builder: (context, setState) {
                return Container(
                  height: (emojis.length > 0)
                      ? stickerPanelHeight + drawingPanelHeight
                      : drawingPanelHeight,
                  child: StickerPanel(
                    drawingList: drawings,
                    emojisList: emojis,
                    attachSticker: attachSticker,
                    addDrawing: addDrawingToStickers,
                    stickerPanelHeight: stickerPanelHeight,
                    panelBackgroundColor: Colors.white,
                    //panelStickerBackgroundColor: Colors.white,
                    panelStickercrossAxisCount: 5,
                    panelStickerAspectRatio: 1.0,
                  ),
                );
              });
        });
  }

  void attachSticker(Image image) {
    Navigator.pop(context);
    setState(() {
      attachedSticker.add(StickerImage(
        image,
        key: Key("sticker_${attachedSticker.length}"),
        width: stickerSize,
        height: stickerSize,
        viewport: viewport,
        maxScale: stickerMaxScale,
        minScale: stickerMinScale,
        onTapRemove: (sticker) {
          this.onTapRemoveSticker(sticker);
        },
      ));
    });
  }

  void onTapRemoveSticker(StickerImage sticker) {
    setState(() {
      attachedSticker.removeWhere((s) => s.key == sticker.key);
    });
  }
}
