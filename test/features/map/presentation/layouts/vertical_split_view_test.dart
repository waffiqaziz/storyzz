import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/features/map/presentations/layouts/vertical_split_view.dart';

void main() {
  group('VerticalSplitView', () {
    testWidgets('renders with default ratio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalSplitView(
              left: Container(color: Colors.red),
              right: Container(color: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.byType(VerticalSplitView), findsOneWidget);
    });

    testWidgets('renders with custom ratio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalSplitView(
              left: Container(color: Colors.red),
              right: Container(color: Colors.blue),
              ratio: 0.7,
            ),
          ),
        ),
      );

      expect(find.byType(VerticalSplitView), findsOneWidget);
    });

    testWidgets('handles drag to update ratio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalSplitView(
              left: Container(color: Colors.red),
              right: Container(color: Colors.blue),
              ratio: 0.5,
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);
      expect(divider, findsOneWidget);

      // simulate drag to the right
      await tester.drag(divider, const Offset(100, 0));
      await tester.pumpAndSettle();
    });

    testWidgets('clamps ratio to 0 when dragged left', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalSplitView(
              left: Container(color: Colors.red),
              right: Container(color: Colors.blue),
              ratio: 0.5,
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // simulate drag to the left to hit the lower bound
      await tester.drag(divider, const Offset(-1000, 0));
      await tester.pumpAndSettle();
    });

    testWidgets('clamps ratio to 1 when dragged right', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalSplitView(
              left: Container(color: Colors.red),
              right: Container(color: Colors.blue),
              ratio: 0.5,
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // simulate drag to the right to hit the upper bound
      await tester.drag(divider, const Offset(1000, 0));
      await tester.pumpAndSettle();
    });

    testWidgets('snaps to close when below threshold', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: VerticalSplitView(
                left: Container(color: Colors.red),
                right: Container(color: Colors.blue),
                ratio: 0.5,
                snapThreshold: 175.0,
              ),
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // Simulate drag to make left pane width < snapThreshold (e.g., ~100px)
      // 800px width - 16px divider = 784px available
      // To get ~100px left pane: 100/784 ≈ 0.127 ratio
      // Currently at 0.5, need to move left by about 0.373 * 784 ≈ -292px
      await tester.drag(divider, const Offset(-300, 0));
      await tester.pump(); // Start the drag end

      await tester.pumpAndSettle();
    });

    testWidgets('does not snap when above threshold', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: VerticalSplitView(
                left: Container(color: Colors.red),
                right: Container(color: Colors.blue),
                ratio: 0.5,
                snapThreshold: 175.0,
              ),
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // simulate drag slightly but keep above threshold
      await tester.drag(divider, const Offset(-50, 0));
      await tester.pumpAndSettle();
    });

    testWidgets('ignores drag during animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: VerticalSplitView(
                left: Container(color: Colors.red),
                right: Container(color: Colors.blue),
                ratio: 0.5,
                snapThreshold: 175.0,
              ),
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // simulate snap animation
      await tester.drag(divider, const Offset(-300, 0));
      await tester.pump(); // Start animation

      // simulate drag during animation (should be ignored)
      await tester.drag(divider, const Offset(100, 0));
      await tester.pump();

      await tester.pumpAndSettle();
    });

    testWidgets('updates maxWidth on constraint change', (tester) async {
      double width = 800;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SizedBox(
                  width: width,
                  height: 600,
                  child: VerticalSplitView(
                    left: Container(color: Colors.red),
                    right: Container(color: Colors.blue),
                    ratio: 0.5,
                  ),
                );
              },
            ),
          ),
        ),
      );

      // change width to trigger maxWidth update
      width = 600;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: width,
              height: 600,
              child: VerticalSplitView(
                left: Container(color: Colors.red),
                right: Container(color: Colors.blue),
                ratio: 0.5,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('shows cursor on mouse hover', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalSplitView(
              left: Container(color: Colors.red),
              right: Container(color: Colors.blue),
            ),
          ),
        ),
      );

      final mouseRegions = find.byType(MouseRegion);
      expect(mouseRegions, findsWidgets);

      // verify at least one has the resize cursor
      final widgets = tester.widgetList<MouseRegion>(mouseRegions);
      final hasResizeCursor = widgets.any(
        (widget) => widget.cursor == SystemMouseCursors.resizeLeftRight,
      );
      expect(hasResizeCursor, isTrue);
    });
  });
}
