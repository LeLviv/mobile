import 'package:flutter/material.dart';

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
          children: [
            Image.asset(
              widget.asset,
              width: widget.size,
              height: widget.size,
            ),
            if (widget.pressedAsset != null)
              AnimatedOpacity(
                opacity: showPressed ? 1 : 0,
                duration: const Duration(milliseconds: 100),
                child: Image.asset(
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