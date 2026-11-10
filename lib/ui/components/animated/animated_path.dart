import 'package:material_ui/material_ui.dart';

class AnimatedPath extends StatefulWidget {
  final String path;

  const AnimatedPath({super.key, required this.path});

  @override
  State<AnimatedPath> createState() => _AnimatedPathState();
}

class _AnimatedPathState extends State<AnimatedPath> {
  bool _isForward = true;

  @override
  void didUpdateWidget(covariant AnimatedPath oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _isForward = widget.path.length > oldWidget.path.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (currentChild, previousChildren) => Stack(
          alignment: Alignment.centerLeft,
          children: [...previousChildren, ?currentChild],
        ),
        transitionBuilder: (child, animation) {
          final bool isIncoming = child.key == ValueKey(widget.path);
          final double direction = _isForward ? 1 : -1;
          final double begin = isIncoming ? 0.5 * direction : -0.5 * direction;

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(begin, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: SingleChildScrollView(
          key: ValueKey(widget.path),
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Text(widget.path, maxLines: 1),
        ),
      ),
    );
  }
}
