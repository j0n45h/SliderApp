import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/box_decoraation_frame.dart';
import 'package:sliderappflutter/utilities/text_field.dart';

class FramedTextField extends StatefulWidget {
  final double width;
  final double height;
  final FramedTF lock;
  final Widget textField;
  final ValueChanged<FramedTF> onLockLongPress;


  FramedTextField({
    @required this.textField,
    @required this.width,
    this.height,
    this.lock = FramedTF.notLockable,
    this.onLockLongPress,
  });

  @override
  _FramedTextFieldState createState() => _FramedTextFieldState();
}

class _FramedTextFieldState extends State<FramedTextField> {
  FramedTF locked;

  @override
  void initState() {
    locked = widget.lock;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          decoration: BoxDecorationFrame().thinFrame,
          height: widget.height,
          width: widget.width,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 3, 0),
          width: 27,
          child: InkWell(
            onLongPress: () {
              setState(() {
                if (locked == FramedTF.open)
                  locked = FramedTF.locked;
                else if (locked == FramedTF.locked)
                  locked = FramedTF.open;
              });
              if (locked != FramedTF.notLockable && widget.onLockLongPress != null)
                widget.onLockLongPress(locked);
            },
            borderRadius: BorderRadius.circular(10),
            child: locked != FramedTF.notLockable
                ? Transform.scale(
                    scale: 0.75,
                    child: locked == FramedTF.locked
                        ? Icon(
                            Icons.lock_outline,
                            color: const Color(0xffBC3930),
                          )
                        : Icon(
                            Icons.lock_open,
                            color: Colors.black.withOpacity(0.5),
                          ),
                  )
                : Container(),
          ),
        ),
        Container(
          padding: locked == FramedTF.open || locked == FramedTF.notLockable
              ? const EdgeInsets.fromLTRB(20, 0, 20, 0)
              : const EdgeInsets.fromLTRB(10, 0, 25, 0),
          alignment: Alignment.center,
          width: widget.width,
          child: widget.textField,
        ),
      ],
    );
  }
}

enum FramedTF {
  notLockable,
  locked,
  open,
}
