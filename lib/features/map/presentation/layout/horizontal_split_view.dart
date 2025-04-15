import 'package:flutter/material.dart';

/// A resizable vertical split view with draggable divider.
///
/// Displays [top] and [bottom] widgets stacked vertically with a
/// draggable divider in between. The initial height distribution is
/// controlled by [ratio].
///
/// Automatically snaps closed if a section becomes too small,
/// based on [totalHeight].
///
/// - [top]: Widget displayed in the top section.
/// - [bottom]: Widget displayed in the bottom section.
/// - [ratio]: Initial height ratio for the top section (0.0 - 1.0). Default is 0.5.
/// - [totalHeight]: Full height used to calculate snap thresholds.
class HorizontalSplitView extends StatefulWidget {
  final Widget top;
  final Widget bottom;
  final double ratio;
  final double totalHeight;

  const HorizontalSplitView({
    super.key,
    required this.top,
    required this.bottom,
    this.ratio = 0.5,
    required this.totalHeight,
  }) : assert(ratio >= 0),
       assert(ratio <= 1);

  @override
  State<HorizontalSplitView> createState() => HorizontalSplitViewState();
}

/// Internal state for [HorizontalSplitView].
///
/// Handles layout calculations, drag gestures, and snapping animation
/// when either section becomes too small.
class HorizontalSplitViewState extends State<HorizontalSplitView>
    with SingleTickerProviderStateMixin {
  final _dividerHeight = 16.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _ratio = 0.5;
  double _maxHeight = 0.0;
  bool _isAnimating = false;

  /// Current height of the top section based on [_ratio].
  get _height1 => _ratio * _maxHeight;

  /// Current height of the bottom section based on [_ratio].
  get _height2 => (1 - _ratio) * _maxHeight;

  /// Expands the top view to a minimum visible height if it's mostly closed.
  ///
  /// Useful for programmatically reopening the top section.
  void expandTopView() {
    if (_ratio < 0.4) {
      _snapToPosition(0.4); // expand to 40%
    }
  }

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

  /// Animates the divider to a target [ratio].
  ///
  /// Used internally to smoothly snap the layout to a desired state.
  void _snapToPosition(double targetRatio) {
    if (_isAnimating) return;

    _isAnimating = true;
    _animation = Tween<double>(begin: _ratio, end: targetRatio).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.reset();
    _animationController.forward();
  }

  /// Checks if either the top or bottom section is too small and should snap closed.
  ///
  /// If a section is less than ~17% of [totalHeight], snaps to fully collapse it.
  void _checkForSnap() {
    // Define a small tolerance range around the threshold
    // debugPrint("height1 = $_height1");
    // debugPrint("height2 = $_height2");

    if (_height1 / widget.totalHeight * 100 < 17) {
      _snapToPosition(0.0); // Snap to close top
    }
    if (_height2 / widget.totalHeight * 100 < 17) {
      _snapToPosition(1.0); // Snap to close bottom
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        assert(_ratio <= 1);
        assert(_ratio >= 0);
        if (_maxHeight != constraints.maxHeight) {
          _maxHeight = constraints.maxHeight - _dividerHeight;
        }

        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            children: <Widget>[
              SizedBox(height: _height1, child: widget.top),
              MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    height: _dividerHeight,
                    width: constraints.maxWidth,
                    child: const Icon(Icons.drag_handle),
                  ),
                  onPanUpdate: (DragUpdateDetails details) {
                    if (_isAnimating) return;

                    setState(() {
                      _ratio += details.delta.dy / _maxHeight;
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
              SizedBox(height: _height2, child: widget.bottom),
            ],
          ),
        );
      },
    );
  }
}
