import 'package:flutter/material.dart';
import 'package:maple/utils/constants.dart';

class PressableButton extends StatefulWidget {
  final Color sideColor;
  final Color backgroundColor;
  final double sideBottomWidth;
  final Color textColor;
  final Widget child;
  final bool enable;
  final VoidCallback onPressed;

  const PressableButton({
    super.key,
    required this.sideColor,
    required this.backgroundColor,
    required this.onPressed,
    required this.textColor,
    required this.child,
    required this.sideBottomWidth,
    this.enable = true,
  });

  @override
  State<PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<PressableButton> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = widget.enable;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.backgroundColor,
          border: Border(
            top: BorderSide(
              color: widget.sideColor, // Màu viền trên
              width: 1.0,
            ),
            left: BorderSide(
              color: widget.sideColor, // Màu viền trái
              width: 1.0,
            ),
            right: BorderSide(
              color: widget.sideColor, // Màu viền phải
              width: 1.0,
            ),
            bottom: BorderSide(
              color: widget.sideColor, // Màu viền dưới
              width: _isPressed ? 1.0 : widget.sideBottomWidth,
            ),
          ),
        ),
        child: Transform.scale(
          scale: 1.0,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            alignment: Alignment.center,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class ButtonCheck extends StatefulWidget {
  final bool enable;
  final String text;
  final VoidCallback onPressed;
  final String type;
  const ButtonCheck(
      {super.key,
      this.enable = true,
      this.text = "Kiểm tra",
      required this.onPressed,
      this.type = typeButtonCheck});

  @override
  State<ButtonCheck> createState() => _ButtonCheckState();
}

class _ButtonCheckState extends State<ButtonCheck> {
  @override
  Widget build(BuildContext context) {
    return PressableButton(
      enable: widget.enable,
      sideColor: widget.enable
          ? widget.type == typeButtonCheck
              ? buttonCheckEnableSideColor
              : buttonCheckDialogSideColor
          : buttonCheckDisableSideColor,
      backgroundColor: widget.enable
          ? widget.type == typeButtonCheck
              ? buttonCheckEnableBackgroundColor
              : buttonCheckDialogBackgroundColor
          : buttonCheckDisableBackgroundColor,
      textColor: widget.enable
          ? widget.type == typeButtonCheck
              ? buttonCheckEnableTextColor
              : buttonCheckDialogTextColor
          : buttonCheckDisableTextColor,
      onPressed: widget.enable ? widget.onPressed : () {},
      sideBottomWidth: widget.enable ? 5 : 1,
      child: Text(
        widget.text.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: widget.enable
              ? widget.type == typeButtonCheck
                  ? buttonCheckEnableTextColor
                  : buttonCheckDialogTextColor
              : buttonCheckDisableTextColor,
        ),
      ),
    );
  }
}

class ButtonItems extends StatefulWidget {
  final bool checked;
  final bool enable;
  final String text;
  final VoidCallback onPressed;
  final Widget child;
  const ButtonItems(
      {super.key,
      this.checked = false,
      this.text = "Kiểm tra",
      required this.onPressed,
      required this.child,  this.enable = true});

  @override
  State<ButtonItems> createState() => _ButtonItemsState();
}

class _ButtonItemsState extends State<ButtonItems> {
  @override
  Widget build(BuildContext context) {
    return PressableButton(
      enable: widget.enable,
      sideColor: widget.checked
          ? buttonItemCheckedSideColor
          : buttonItemUncheckedSideColor,
      backgroundColor: widget.checked
          ? buttonItemCheckedBackgroundColor
          : buttonItemUncheckedBackgroundColor,
      textColor: widget.checked
          ? buttonItemCheckedTextColor
          : buttonItemUncheckedTextColor,
      onPressed: 
        widget.onPressed,
      
      sideBottomWidth: widget.enable ? 5 : 1,
      child: widget.child,
    );
  }
}
class ButtomItemReplace extends StatefulWidget {
  final Widget child;
  const ButtomItemReplace(
      {super.key, required this.child,
     });

  @override
  State<ButtomItemReplace> createState() => _ButtomItemReplaceState();
}

class _ButtomItemReplaceState extends State<ButtomItemReplace> {
  @override
  Widget build(BuildContext context) {
    return PressableButton(
      enable: false,
      sideColor: Colors.grey,
      backgroundColor: Colors.grey,
      textColor: Colors.grey,
      onPressed: 
        (){},
      
      sideBottomWidth: 5,
      child: widget.child,
    );
  }
}
