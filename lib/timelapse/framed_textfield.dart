import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/box_decoraation_frame.dart';

class FramedTextField extends StatelessWidget {
  final double width;
  final double? height;
  final FramedTF lock;
  final Widget textField;
  final VoidCallback? onLockLongPress;
  // final ValueChanged<FramedTF> onLockLongPress;

  FramedTextField({
    required this.textField,
    required this.width,
    this.lock = FramedTF.notLockable,
    this.height,
    this.onLockLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          decoration: BoxDecorationFrame().thinFrame,
          height: height,
          width: width,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 3, 0),
          width: 27,
          child: InkWell(
            onLongPress: () {
              if (lock != FramedTF.notLockable && onLockLongPress != null)
                onLockLongPress!();
            },
            borderRadius: BorderRadius.circular(10),
            child: lock != FramedTF.notLockable
                ? Transform.scale(
                    scale: 0.75,
                    child: lock == FramedTF.locked
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
          padding: lock == FramedTF.open || lock == FramedTF.notLockable
              ? const EdgeInsets.fromLTRB(20, 0, 20, 0)
              : const EdgeInsets.fromLTRB(10, 0, 25, 0),
          alignment: Alignment.center,
          width: width,
          child: textField,
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
