import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/design/widgets/empty_story.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

void main() {
  Widget createTestApp(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('id')],
      home: Scaffold(body: child),
    );
  }

  group('EmptyStory', () {
    testWidgets('renders all components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(CustomScrollView(slivers: [EmptyStory()])),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.auto_stories), findsOneWidget);
      expect(find.text('Tidak ada cerita yang tersedia'), findsOneWidget);
      expect(
        find.text(
          'Tarik ke bawah untuk menyegarkan atau ketuk tombol + untuk menambahkan cerita baru',
        ),
        findsOneWidget,
      );
    });

    testWidgets('display correct message style', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(CustomScrollView(slivers: [EmptyStory()])),
      );
      await tester.pumpAndSettle();

      final textWidget1 = tester.widget<Text>(
        find.text('Tidak ada cerita yang tersedia'),
      );
      expect(textWidget1.style?.fontSize, 18);
      expect(textWidget1.style?.fontWeight, FontWeight.bold);

      final textWidget2 = tester.widget<Text>(
        find.text(
          'Tarik ke bawah untuk menyegarkan atau ketuk tombol + untuk menambahkan cerita baru',
        ),
      );
      expect(textWidget2.style?.color, Colors.grey[600]);
    });
  });
}
