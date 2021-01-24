import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';

class EmojiPickerWidget extends StatefulWidget {
  final ValueChanged<String> onEmojiSelected;
  const EmojiPickerWidget({
    @required this.onEmojiSelected,
    Key key,
  }) : super(key: key);
  @override
  _EmojiPickerWidgetState createState() => _EmojiPickerWidgetState();
}

class _EmojiPickerWidgetState extends State<EmojiPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      recommendKeywords: ["love", "smile", "hand"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        widget.onEmojiSelected(emoji.emoji);
      },
    );
  }
}
