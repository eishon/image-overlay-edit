import 'package:flutter/material.dart';

class StickerPanel extends StatefulWidget {
  StickerPanel({
    this.drawingList,
    this.emojisList,
    this.emojisTitle = 'Emojis',
    this.drawingTitle = 'Drawings',
    this.borderColor = Colors.orange,
    this.stickerPanelHeight = 200.0,
    this.panelBackgroundColor = Colors.black,
    this.panelStickerBackgroundColor = Colors.white10,
    this.panelStickercrossAxisCount = 2,
    this.panelStickerAspectRatio = 1.0,
    this.attachSticker,
    this.addDrawing,
  });

  final List<Image> drawingList;
  final List<Image> emojisList;

  final double stickerPanelHeight;
  final Color panelBackgroundColor;
  final Color panelStickerBackgroundColor;
  final int panelStickercrossAxisCount;
  final double panelStickerAspectRatio;

  final String emojisTitle;
  final String drawingTitle;
  final Color borderColor;

  final Function(Image) attachSticker;
  final Function addDrawing;

  @override
  State<StatefulWidget> createState() => _StickerPanelState();
}

class _StickerPanelState extends State<StickerPanel> {
  @override
  Widget build(BuildContext context) {
    ElevatedButton addDrawingButton = ElevatedButton(
      onPressed: () => widget.addDrawing(),
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );

    return Column(
      children: [
        SizedBox(height: 4),
        if (widget.emojisList.length > 0)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(widget.emojisTitle),
          ),
        if (widget.emojisList.length > 0)
          Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: widget.borderColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Scrollbar(
                child: DragTarget(
                  builder: (BuildContext context, List<String> candidateData,
                      List<dynamic> rejectedData) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: this.widget.panelBackgroundColor,
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: widget.emojisList.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              color: this.widget.panelStickerBackgroundColor,
                              child: TextButton(
                                onPressed: () {
                                  widget.attachSticker(widget.emojisList[i]);
                                },
                                child: widget.emojisList[i],
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                this.widget.panelStickercrossAxisCount,
                            childAspectRatio:
                                this.widget.panelStickerAspectRatio),
                      ),
                      height: this.widget.stickerPanelHeight,
                    );
                  },
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(widget.drawingTitle),
        ),
        widget.drawingList.length == 0
            ? addDrawingButton
            : Container(
                height: 86,
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: widget.borderColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.drawingList.map((item) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: this.widget.panelStickerBackgroundColor,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  widget.attachSticker(item);
                                },
                                child: item,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    VerticalDivider(),
                    addDrawingButton,
                  ],
                ),
              ),
      ],
    );
  }
}
