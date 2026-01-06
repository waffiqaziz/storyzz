import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:storyzz/core/design/widgets/not_found_widget.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const NotFoundWidget()),
      ],
    );
  });

  Widget createTestApp() {
    return MaterialApp.router(
      routerConfig: router,
      locale: const Locale('id'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('id')],
    );
  }

  group('NotFoundWidget', () {
    testWidgets(
      'renders all components correctly and navigates on button press',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        expect(find.text('Postingan Tidak Ditemukan'), findsOneWidget);
        expect(find.text('Kembali ke Beranda'), findsOneWidget);

        await tester.tap(find.text('Kembali ke Beranda'));
        await tester.pumpAndSettle();
      },
    );
  });
}
