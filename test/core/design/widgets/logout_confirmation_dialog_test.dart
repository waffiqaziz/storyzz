import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/design/widgets/logout_confirmation_dialog.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';

import '../../../tetsutils/mock.dart';

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockAppProvider mockAppProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockAppProvider = MockAppProvider();
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
        ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: Scaffold(body: LogoutConfirmationDialog()),
      ),
    );
  }

  testWidgets('renders dialog with title and content', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Logout Confirmation'), findsOneWidget);
    expect(find.text('Are you sure you want to logout ?'), findsOneWidget);
  });

  testWidgets('cancel button calls closeDialogLogOut', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);

    await tester.tap(cancelButton);
    await tester.pump();

    verify(() => mockAppProvider.closeLogoutDialog()).called(1);
  });

  testWidgets('logout button calls logout and shows success snackbar', (
    tester,
  ) async {
    when(() => mockAuthProvider.logout()).thenAnswer((_) async {});
    when(() => mockAuthProvider.logoutSuccess).thenReturn(true);
    when(() => mockAppProvider.closeLogoutDialog()).thenReturn(null);

    await tester.pumpWidget(createTestWidget());

    final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);

    await tester.tap(logoutButton);
    await tester.pump();

    verify(() => mockAuthProvider.logout()).called(1);
    verify(() => mockAppProvider.closeLogoutDialog()).called(1);

    await tester.pump();
    expect(find.text('Logout success'), findsOneWidget);
  });

  testWidgets('logout button shows error snackbar on failure', (tester) async {
    when(() => mockAuthProvider.logout()).thenAnswer((_) async {});
    when(() => mockAuthProvider.logoutSuccess).thenReturn(false);
    when(() => mockAuthProvider.errorMessage).thenReturn('Logout failed');
    when(() => mockAppProvider.closeLogoutDialog()).thenReturn(null);

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Logout'));
    await tester.pump();

    verify(() => mockAuthProvider.logout()).called(1);

    await tester.pump();
    expect(find.text('Logout failed'), findsOneWidget);
  });

  testWidgets('PopScope calls closeDialogLogOut on pop', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(LogoutConfirmationDialog), findsOneWidget);

    Navigator.of(tester.element(find.byType(LogoutConfirmationDialog))).pop();
    await tester.pumpAndSettle();

    verify(() => mockAppProvider.closeLogoutDialog()).called(1);
  });
}
