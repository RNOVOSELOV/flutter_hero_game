import 'package:flutter/material.dart';
import 'package:spacehero/resources/app_colors.dart';

class ControlButton extends StatefulWidget {
  final void Function(BuildContext context) onTap;
  final String imageAssetPath;
  final int delayNextTapMilliseconds;
  final int value;

  const ControlButton({
    super.key,
    required this.onTap,
    required this.imageAssetPath,
    required this.delayNextTapMilliseconds,
    required this.value,
  });

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool _active = true;

  @override
  Widget build(BuildContext context) {
    if (widget.value == 0) {
      _active = false;
    } else {
      _active = true;
    }
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
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.colorInfoButtonEnabledColor,
        ),
        child: Stack(
          children: [
            if (widget.value != 0)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 15,
                  width: 20,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.colorWhite,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    shape: BoxShape.rectangle,
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.value < 1000 ? '${widget.value}' : '...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: AppColors.colorInfoButtonTextColor,
                            fontSize: 6),
                      )),
                ),
              ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _active
                    ? AppColors.colorTransparent
                    : AppColors.colorInfoButtonDisabledColor,
                BlendMode.saturation,
              ),
              child: Image.asset(widget.imageAssetPath),
            ),
          ],
        ),
      ),
    );
  }
}
