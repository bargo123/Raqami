import 'package:flutter/material.dart';

/// Reusable neumorphic toggle switch widget
class NeumorphicToggle extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;

  const NeumorphicToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<NeumorphicToggle> createState() => _NeumorphicToggleState();
}

class _NeumorphicToggleState extends State<NeumorphicToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NeumorphicToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final trackWidth = 50.0;
          final trackHeight = 28.0;
          final thumbSize = 22.0;
          final thumbPadding = 3.0;
          final thumbPosition = _animation.value * (trackWidth - thumbSize - thumbPadding * 2);

          return Container(
            width: trackWidth,
            height: trackHeight,
            decoration: BoxDecoration(
              color: widget.value ? Colors.red : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(trackHeight / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  offset: const Offset(-2, -2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(2, 2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: thumbPadding + thumbPosition,
                  top: thumbPadding,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          offset: const Offset(-2, -2),
                          blurRadius: 2,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          offset: const Offset(2, 2),
                          blurRadius: 3,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

