import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/responses/login_response.dart';
import 'package:storyzz/core/data/networking/responses/login_result.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';
import 'package:storyzz/core/design/widgets/language_selector.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/features/auth/presentation/screen/login_screen.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockSettingsProvider mockSettingsProvider;
  late MockAppProvider mockAppProvider;

  final mockLoginResponseSuccess = ApiResult.success(
    LoginResponse(
      error: false,
      loginResult: LoginResult(userId: 'UserId', name: 'Name', token: 'token'),
      message: 'Login successful',
    ),
  );

  final mockLoginResponseFailed = ApiResult.success(
    LoginResponse(
      error: true,
      loginResult: LoginResult(userId: '', name: '', token: ''),
      message: 'Failed message',
    ),
  );

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockAppProvider = MockAppProvider();
    mockSettingsProvider = MockSettingsProvider();

    when(() => mockSettingsProvider.locale).thenReturn(Locale('en'));
    when(() => mockAuthProvider.isLoadingLogin).thenReturn(false);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ChangeNotifierProvider<SettingsProvider>.value(
            value: mockSettingsProvider,
          ),
        ],
        child: Scaffold(body: LoginScreen()),
      ),
    );
  }

  group('LoginScren', () {
    testWidgets('should renders image, text, form, and button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(LanguageSelector), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Don\'t have an account?'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets(
      'should trigger to open register screen when button pressing the button',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final registerButton = find.byType(TextButton).last;
        expect(registerButton, findsOneWidget);

        await tester.tap(registerButton);
        await tester.pumpAndSettle();

        verify(() => mockAppProvider.openRegister()).called(1);
      },
    );

    testWidgets('should shows snackbar when pressing forget password', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final forgetPasswordButton = find.byType(TextButton).first;
      expect(forgetPasswordButton, findsOneWidget);

      await tester.tap(forgetPasswordButton);
      await tester.pumpAndSettle();

      expect(
        find.text('This feature only for user interface (UI).'),
        findsOneWidget,
      );
    });

    testWidgets('should call loginNetwork when form is valid', (tester) async {
      when(
        () => mockAuthProvider.loginNetwork(any(), any()),
      ).thenAnswer((_) async => mockLoginResponseSuccess);
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'user@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(
        () => mockAuthProvider.loginNetwork('user@example.com', 'password123'),
      ).called(1);
    });

    testWidgets('should show error snackbar on login response failure', (
      tester,
    ) async {
      when(
        () => mockAuthProvider.loginNetwork(any(), any()),
      ).thenAnswer((_) async => mockLoginResponseFailed);
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'user@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // expect message from mockLoginResponseFailed
      expect(find.text('Failed message'), findsOneWidget);
    });

    testWidgets('should show error snackbar on login error with message', (
      tester,
    ) async {
      final ApiResult<LoginResponse> mockLoginResponseFailed2 =
          ApiResult<LoginResponse>.error("Unknown error");
      when(
        () => mockAuthProvider.loginNetwork(any(), any()),
      ).thenAnswer((_) async => mockLoginResponseFailed2);
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'user@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text("Unknown error"), findsOneWidget);
    });

    testWidgets('should toggle obscureText when tapping visibility icon', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      final visibilityToggle = find.byIcon(Icons.visibility_off);
      expect(visibilityToggle, findsOneWidget);

      await tester.tap(visibilityToggle);
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should show error for invalid email format', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error when password is empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'user@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), '');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should show error when email is empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(1), 'passord12345');
      await tester.enterText(find.byType(TextFormField).at(1), '');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should show error when password is too short', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'user@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 8 characters long'),
        findsOneWidget,
      );
    });

    testWidgets(
      'should disable form and show CircularProgressIndicator when loading',
      (tester) async {
        // set return false initially, then true after login tap
        when(() => mockAuthProvider.isLoadingLogin).thenReturn(false);
        when(() => mockAuthProvider.loginNetwork(any(), any())).thenAnswer((
          _,
        ) async {
          when(() => mockAuthProvider.isLoadingLogin).thenReturn(true);
          return mockLoginResponseSuccess;
        });
        when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final emailField = find.byType(TextFormField).at(0);
        final passwordField = find.byType(TextFormField).at(1);
        final loginButton = find.byType(ElevatedButton);
        final loadingIndicator = find.byType(CircularProgressIndicator);

        await tester.enterText(emailField, 'user@example.com');
        await tester.enterText(passwordField, 'password123');
        await tester.tap(loginButton);

        await tester.pump();

        expect(tester.widget<TextFormField>(emailField).enabled, false);
        expect(tester.widget<TextFormField>(passwordField).enabled, false);
        expect(loginButton, findsOneWidget);
        expect(loadingIndicator, findsOneWidget);
      },
    );

    testWidgets(
      'should show success snackbar and call isLogged on successful login',
      (tester) async {
        final dpi = tester.view.devicePixelRatio;
        tester.view.physicalSize = Size(412 * dpi, 1200 * dpi);
        when(
          () => mockAuthProvider.loginNetwork(any(), any()),
        ).thenAnswer((_) async => mockLoginResponseSuccess);
        when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).at(0),
          'test@example.com',
        );
        await tester.enterText(find.byType(TextFormField).at(1), 'password123');

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Login success!'), findsOneWidget);
        verify(() => mockAuthProvider.isLogged()).called(1);
      },
    );

    // test('loginNetwork sets loading and updates listeners correctly', () async {
    //   final repository = MockAuthRepository();

    //   when(
    //     () => repository.loginRemote(any(), any()),
    //   ).thenAnswer((_) async => mockLoginResponseSuccess);
    //   when(() => repository.isLoggedIn()).thenAnswer((_) async => true);

    //   bool isLoadingCalled = false;
    //   mockAuthProvider.addListener(() {
    //     isLoadingCalled =
    //         mockAuthProvider.isLoadingLogin || !mockAuthProvider.isLoadingLogin;
    //   });

    //   final result = await mockAuthProvider.loginNetwork('email', 'pass');

    //   expect(result.data, isA<LoginResponse>());
    //   expect(mockAuthProvider.isLoadingLogin, isFalse);
    //   expect(isLoadingCalled, isTrue);
    // });
  });
}
