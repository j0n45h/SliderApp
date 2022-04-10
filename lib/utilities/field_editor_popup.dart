import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/colors.dart';

class FieldEditorPopup extends StatefulWidget {
  final Widget child;

  FieldEditorPopup({Key? key, required this.child}) : super(key: key);

  @override
  _FieldEditorPopupState createState() => _FieldEditorPopupState();
}

class _FieldEditorPopupState extends State<FieldEditorPopup> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: IgnorePointer(ignoring: true, child: widget.child),
      onTap: () => _showPopup(context),
    );
  }

  Future<void> _showPopup(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _FieldEditorDialog(child: widget.child),
    );
  }
}

class _FieldEditorDialog extends StatelessWidget {
  final Widget child;

  const _FieldEditorDialog({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 24,
      insetAnimationDuration: Duration(milliseconds: 500),
      insetAnimationCurve: Curves.easeInOut,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
            onPressed: () => print('+'),
          ),
          Transform.scale(
            scale: 1.5,
            child: child,
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () => print('-'),
            color: Colors.blue,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
