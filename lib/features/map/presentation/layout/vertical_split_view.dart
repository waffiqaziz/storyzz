import 'package:flutter/material.dart';

/// A resizable horizontal split view with draggable divider.
///
/// Displays [left] and [right] widgets side by side with a movable divider
/// in between. The initial width distribution is controlled by [ratio].
///
/// If the left pane's width drops below [snapThreshold], it animates closed.
///
/// - [left]: Widget shown on the left side.
/// - [right]: Widget shown on the right side.
/// - [ratio]: Initial width ratio for the left pane (0.0 - 1.0). Default is 0.5.
/// - [snapThreshold]: Auto-close threshold in pixels. Default is 175.0.
class VerticalSplitView extends StatefulWidget {
  final Widget left;
  final Widget right;
  final double ratio;
  final double snapThreshold;

  const VerticalSplitView({
    super.key,
    required this.left,
    required this.right,
    this.ratio = 0.5,
    this.snapThreshold = 175.0,
  }) : assert(ratio >= 0),
       assert(ratio <= 1);

  @override
  State<VerticalSplitView> createState() => _VerticalSplitViewState();
}

/// Internal state for [VerticalSplitView].
///
/// Manages layout calculation, user interaction, and snap animation
/// when the left pane width goes below [snapThreshold].
class _VerticalSplitViewState extends State<VerticalSplitView>
    with SingleTickerProviderStateMixin {
  final _dividerWidth = 16.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _ratio = 0.5;
  double _maxWidth = 0.0;
  bool _isAnimating = false;

  /// Current width of the left pane based on [_ratio].
  double get _width1 => _ratio * _maxWidth;

  /// Current width of the right pane based on [_ratio].
  double get _width2 => (1 - _ratio) * _maxWidth;

  @override
  void initState() {
    super.initState();
    _ratio = widget.ratio;

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _animationController.addListener(() {
      setState(() {
        _ratio = _animation.value;
      });
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimating = false;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Animates the left pane to fully collapse (width = 0).
  ///
  /// Triggered when current width is below [snapThreshold].
  /// Does nothing if an animation is already in progress.
  void _snapToClose() {
    if (_isAnimating) return;

    _isAnimating = true;
    _animation = Tween<double>(begin: _ratio, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.reset();
    _animationController.forward();
  }

  /// Checks if the left pane should snap closed based on current width.
  ///
  /// If the left pane width is below [snapThreshold] but greater than 0,
  /// triggers [_snapToClose].
  void _checkForSnap() {
    if (_width1 < widget.snapThreshold && _width1 > 0) {
      _snapToClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        assert(_ratio <= 1);
        assert(_ratio >= 0);
        if (_maxWidth != constraints.maxWidth) {
          _maxWidth = constraints.maxWidth - _dividerWidth;
        }

        return SizedBox(
          width: constraints.maxWidth,
          child: Row(
            children: <Widget>[
              SizedBox(width: _width1, child: widget.left),
              MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    width: _dividerWidth,
                    height: constraints.maxHeight,
                    child: const RotationTransition(
                      turns: AlwaysStoppedAnimation(0.25),
                      child: Icon(Icons.drag_handle),
                    ),
                  ),
                  onPanUpdate: (DragUpdateDetails details) {
                    if (_isAnimating) return;

                    setState(() {
                      _ratio += details.delta.dx / _maxWidth;
                      if (_ratio > 1) {
                        _ratio = 1;
                      } else if (_ratio < 0.0) {
                        _ratio = 0.0;
                      }
                    });
                  },
                  onPanEnd: (DragEndDetails details) {
                    _checkForSnap();
                  },
                ),
              ),
              SizedBox(width: _width2, child: widget.right),
            ],
          ),
        );
      },
    );
  }
}
