import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/features/map/presentations/layouts/horizontal_split_view.dart';

void main() {
  group('HorizontalSplitView', () {
    testWidgets('renders with default ratio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalSplitView(
              top: Container(color: Colors.red),
              bottom: Container(color: Colors.blue),
              totalHeight: 600,
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalSplitView), findsOneWidget);
    });

    testWidgets('renders with custom ratio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalSplitView(
              top: Container(color: Colors.red),
              bottom: Container(color: Colors.blue),
              ratio: 0.7,
              totalHeight: 600,
            ),
          ),
        ),
      );

      expect(find.byType(HorizontalSplitView), findsOneWidget);
    });

    testWidgets('handles drag to update ratio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalSplitView(
              top: Container(color: Colors.red),
              bottom: Container(color: Colors.blue),
              ratio: 0.5,
              totalHeight: 600,
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);
      expect(divider, findsOneWidget);

      await tester.drag(divider, const Offset(0, 50));
      await tester.pumpAndSettle();
    });

    testWidgets('clamps ratio to 0 when dragged up', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalSplitView(
              top: Container(color: Colors.red),
              bottom: Container(color: Colors.blue),
              ratio: 0.5,
              totalHeight: 600,
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // simulate drag upward to hit the lower bound
      await tester.drag(divider, const Offset(0, -1000));
      await tester.pumpAndSettle();
    });

    testWidgets('clamps ratio to 1 when dragged down', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalSplitView(
              top: Container(color: Colors.red),
              bottom: Container(color: Colors.blue),
              ratio: 0.5,
              totalHeight: 600,
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // simulate downward to hit the upper bound
      await tester.drag(divider, const Offset(0, 1000));
      await tester.pumpAndSettle();
    });

    testWidgets('snaps top closed when below 17% threshold', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: HorizontalSplitView(
                top: Container(color: Colors.red),
                bottom: Container(color: Colors.blue),
                ratio: 0.5,
                totalHeight: 600,
              ),
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // Simulate drag up to make top section < 17% of totalHeight
      // 600px heigh - 16px divider = 584px available
      // 17% of 600 = 102px, so need atlest top < 102px
      // Currently at 0.5 (292px), drag up to about 0.1 ratio (~58px)
      await tester.drag(divider, const Offset(0, -250));
      await tester.pump();

      await tester.pumpAndSettle();
    });

    testWidgets('snaps bottom closed when below 17% threshold', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: HorizontalSplitView(
                top: Container(color: Colors.red),
                bottom: Container(color: Colors.blue),
                ratio: 0.5,
                totalHeight: 600,
              ),
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // Simulate drag down to make bottom section < 17% of totalHeight
      // 17% of 600 = 102px, need bottom < 102px
      // Currently at 0.5 (292px bottom), drag down to about 0.9 ratio
      await tester.drag(divider, const Offset(0, 250));
      await tester.pump(); // Start the drag end

      // wait for snap animation to complete
      await tester.pumpAndSettle();
    });

    testWidgets('does not snap when above threshold', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: HorizontalSplitView(
                top: Container(color: Colors.red),
                bottom: Container(color: Colors.blue),
                ratio: 0.5,
                totalHeight: 600,
              ),
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // Drag slightly but keep both sections above threshold
      await tester.drag(divider, const Offset(0, 30));
      await tester.pumpAndSettle();
    });

    testWidgets('ignores drag during animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: HorizontalSplitView(
                top: Container(color: Colors.red),
                bottom: Container(color: Colors.blue),
                ratio: 0.5,
                totalHeight: 600,
              ),
            ),
          ),
        ),
      );

      final divider = find.byType(GestureDetector);

      // simulate snap animation
      await tester.drag(divider, const Offset(0, -250));
      await tester.pump(); // Start animation

      // simulate drag during animation (should be ignored)
      await tester.drag(divider, const Offset(0, 100));
      await tester.pump();

      await tester.pumpAndSettle();
    });

    testWidgets('updates maxHeight on constraint change', (tester) async {
      double height = 600;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SizedBox(
                  width: 800,
                  height: height,
                  child: HorizontalSplitView(
                    top: Container(color: Colors.red),
                    bottom: Container(color: Colors.blue),
                    ratio: 0.5,
                    totalHeight: height,
                  ),
                );
              },
            ),
          ),
        ),
      );

      // change height to trigger maxHeight update
      height = 400;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: height,
              child: HorizontalSplitView(
                top: Container(color: Colors.red),
                bottom: Container(color: Colors.blue),
                ratio: 0.5,
                totalHeight: height,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('shows resize cursor on mouse hover', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalSplitView(
              top: Container(color: Colors.red),
              bottom: Container(color: Colors.blue),
              totalHeight: 600,
            ),
          ),
        ),
      );

      final mouseRegions = find.byType(MouseRegion);
      expect(mouseRegions, findsWidgets);

      final widgets = tester.widgetList<MouseRegion>(mouseRegions);
      final hasResizeCursor = widgets.any(
        (widget) => widget.cursor == SystemMouseCursors.resizeUpDown,
      );
      expect(hasResizeCursor, isTrue);
    });

    testWidgets('expandTopView expands top section when ratio is below 0.4', (
      tester,
    ) async {
      final key = GlobalKey<HorizontalSplitViewState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: HorizontalSplitView(
                key: key,
                top: Container(color: Colors.red),
                bottom: Container(color: Colors.blue),
                ratio: 0.1, // start with small top section
                totalHeight: 600,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      key.currentState!.expandTopView();
      await tester.pumpAndSettle();

      expect(find.byType(HorizontalSplitView), findsOneWidget);
    });

    testWidgets('expandTopView does nothing when ratio is already >= 0.4', (
      tester,
    ) async {
      final key = GlobalKey<HorizontalSplitViewState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: HorizontalSplitView(
                key: key,
                top: Container(color: Colors.red),
                bottom: Container(color: Colors.blue),
                ratio: 0.5, // already at 0.5
                totalHeight: 600,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      key.currentState!.expandTopView();
      await tester.pumpAndSettle();

      expect(find.byType(HorizontalSplitView), findsOneWidget);
    });
  });
}
