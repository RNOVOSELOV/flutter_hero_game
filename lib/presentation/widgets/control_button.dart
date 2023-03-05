import 'package:flutter/material.dart';

class ControlButton extends StatefulWidget {
  final void Function(BuildContext context) onTap;
  final String imageAssetPath;
  final int delayNextTapMilliseconds;

  const ControlButton({
    super.key,
    required this.onTap,
    required this.imageAssetPath,
    required this.delayNextTapMilliseconds,
  });

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool _active = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !_active
          ? null
          : () {
              widget.onTap(context);
              _active = false;
              Future.delayed(
                Duration(milliseconds: widget.delayNextTapMilliseconds),
                () {
                  _active = true;
                  setState(() {});
                },
              );
              setState(() {});
            },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.only(right: 12, top: 12),
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            _active ? Colors.transparent : Colors.grey,
            BlendMode.saturation,
          ),
          child: Image.asset(widget.imageAssetPath),
        ),
      ),
    );
  }
}
