import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:spacehero/resources/app_colors.dart';

class ControlButton extends StatefulWidget {
  final void Function(BuildContext context) onTap;
  final String imageAssetPath;
  final int delayNextTapMilliseconds;
  final int value;

  final bool isAnimationActive;

  const ControlButton(
      {super.key,
      required this.onTap,
      required this.imageAssetPath,
      required this.delayNextTapMilliseconds,
      required this.value,
      required this.isAnimationActive});

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  late bool _active;
  late bool _isAnimationActive;
  late double _scale;

  Future<void> isActiveFuture = Future<void>(() => null);

  @override
  Widget build(BuildContext context) {
    if (widget.value == 0) {
      _active = false;
    } else {
      _active = true;
    }
    _scale = 1.0;
    _isAnimationActive = widget.isAnimationActive;

    return GestureDetector(
      onTap: !_active
          ? null
          : () {
              widget.onTap(context);
              _active = false;
              isActiveFuture = Future.delayed(
                Duration(milliseconds: widget.delayNextTapMilliseconds),
                () {
                  _active = true;
                  setState(() {});
                },
              );
              _scale = 1.2;
              setState(() {});
            },
      child: ShakeAnimatedWidget(
        enabled: _isAnimationActive,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 250),
        shakeAngle: Rotation.deg(z: 5),
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
                child: AnimatedScale(
                    scale: _scale,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceInOut,
                    onEnd: () => setState(() => _scale = 1.0),
                    child: Image.asset(widget.imageAssetPath)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    isActiveFuture.ignore();
    super.dispose();
  }
}
