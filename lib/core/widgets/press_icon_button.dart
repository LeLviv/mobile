import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class PressIconButton extends StatefulWidget {
  final String asset;
  final String? pressedAsset;
  final double size;
  final VoidCallback? onTap;

  final bool toggle;
  final ValueChanged<bool>? onToggle;

  const PressIconButton({
    super.key,
    required this.asset,
    required this.size,
    this.pressedAsset,
    this.onTap,
    this.toggle = false,
    this.onToggle,
  });

  @override
  State<PressIconButton> createState() => _PressIconButtonState();
}

class _PressIconButtonState extends State<PressIconButton> {
  bool _pressed = false;
  bool _active = false;

  void _setPressed(bool value) {
    if (widget.toggle) return;
    if (_pressed != value) setState(() => _pressed = value);
  }

  void _handleTap() {
    if (widget.toggle) {
      setState(() => _active = !_active);
      widget.onToggle?.call(_active);
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final showPressed = widget.toggle ? _active : _pressed;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: _handleTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size * AppDimens.homeShadowCircleFraction,
              height: widget.size * AppDimens.homeShadowCircleFraction,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.homeShadow,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              widget.asset,
              width: widget.size,
              height: widget.size,
            ),
            if (widget.pressedAsset != null)
              AnimatedOpacity(
                opacity: showPressed ? 1 : 0,
                duration: const Duration(milliseconds: 100),
                child: SvgPicture.asset(
                  widget.pressedAsset!,
                  width: widget.size,
                  height: widget.size,
                ),
              ),
          ],
        ),
      ),
    );
  }
}