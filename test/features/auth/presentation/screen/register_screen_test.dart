import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/models/user.dart';
import 'package:storyzz/core/data/networking/models/general/general_response.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';
import 'package:storyzz/core/design/widgets/language_selector.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/features/auth/presentation/screen/register_screen.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockSettingsProvider mockSettingsProvider;
  late MockAppProvider mockAppProvider;

  final userTest = User(
    name: 'John Doe',
    email: 'john@example.com',
    password: 'password123',
  );

  final mockRegisterResponseSuccess = ApiResult.success(
    GeneralResponse(error: false, message: 'Registration successful'),
  );

  final mockRegisterResponseFailed = ApiResult.success(
    GeneralResponse(error: true, message: 'Registration failed'),
  );

  setUpAll(() {
    registerFallbackValue(userTest);
  });

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockAppProvider = MockAppProvider();
    mockSettingsProvider = MockSettingsProvider();

    when(() => mockSettingsProvider.locale).thenReturn(const Locale('en'));
    when(() => mockAuthProvider.isLoadingRegister).thenReturn(false);
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
        child: const Scaffold(body: RegisterScreen()),
      ),
    );
  }

  group('RegisterScreen', () {
    testWidgets('should render image, text, form fields, and button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(LanguageSelector), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(4),
      ); // name, email, password, confirm password
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign up to get started'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets(
      'should trigger to open login screen when pressing the login button',
      (WidgetTester tester) async {
        final dpi = tester.view.devicePixelRatio;
        tester.view.physicalSize = Size(412 * dpi, 915 * dpi);
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final loginButton = find.byType(TextButton).first;
        expect(loginButton, findsOneWidget);

        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        verify(() => mockAppProvider.openLogin()).called(1);
      },
    );

    testWidgets('should call register when form is valid', (tester) async {
      when(
        () => mockAuthProvider.register(userTest),
      ).thenAnswer((_) async => mockRegisterResponseSuccess);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), userTest.name!);
      await tester.enterText(find.byType(TextFormField).at(1), userTest.email!);
      await tester.enterText(
        find.byType(TextFormField).at(2),
        userTest.password!,
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        userTest.password!,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => mockAuthProvider.register(any())).called(1);
    });

    testWidgets('should show error snackbar on registration failure', (
      tester,
    ) async {
      when(
        () => mockAuthProvider.register(userTest),
      ).thenAnswer((_) async => mockRegisterResponseFailed);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), userTest.name!);
      await tester.enterText(find.byType(TextFormField).at(1), userTest.email!);
      await tester.enterText(
        find.byType(TextFormField).at(2),
        userTest.password!,
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        userTest.password!,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Registration failed'), findsOneWidget);
    });

    testWidgets('should show error when API returns error message', (
      tester,
    ) async {
      final ApiResult<GeneralResponse> mockRegisterResponseError =
          ApiResult<GeneralResponse>.error("Email already exists");

      when(
        () => mockAuthProvider.register(userTest),
      ).thenAnswer((_) async => mockRegisterResponseError);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), userTest.name!);
      await tester.enterText(find.byType(TextFormField).at(1), userTest.email!);
      await tester.enterText(
        find.byType(TextFormField).at(2),
        userTest.password!,
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        userTest.password!,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text("Email already exists"), findsOneWidget);
    });

    testWidgets('should toggle obscureText when tapping visibility icons', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initially both password fields should be obscured
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

      // Test toggling password visibility
      final passwordVisibilityToggle = find.byIcon(Icons.visibility_off).first;
      await tester.tap(passwordVisibilityToggle);
      await tester.pump();

      // Test toggling confirm password visibility
      final confirmPasswordVisibilityToggle = find
          .byIcon(Icons.visibility_off)
          .first;
      await tester.tap(confirmPasswordVisibilityToggle);
      await tester.pump();

      // After toggling, both fields should show the visibility icon
      expect(find.byIcon(Icons.visibility), findsNWidgets(2));
    });

    testWidgets('should show error for empty name', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(1), userTest.email!);
      await tester.enterText(
        find.byType(TextFormField).at(2),
        userTest.password!,
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        userTest.password!,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('should show error for empty email', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), userTest.name!);
      await tester.enterText(
        find.byType(TextFormField).at(2),
        userTest.password!,
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        userTest.password!,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should show error for empty password', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), userTest.name!);
      await tester.enterText(find.byType(TextFormField).at(1), userTest.email!);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should show error for invalid email format', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Fill all fields with invalid email
      await tester.enterText(find.byType(TextFormField).at(0), userTest.name!);
      await tester.enterText(find.byType(TextFormField).at(1), 'invalid-email');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        userTest.password!,
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        userTest.password!,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error for password too short', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Fill all fields with short password
      await tester.enterText(find.byType(TextFormField).at(0), userTest.name!);
      await tester.enterText(find.byType(TextFormField).at(1), userTest.email!);
      final shortPassword = '123';
      await tester.enterText(find.byType(TextFormField).at(2), shortPassword);
      await tester.enterText(find.byType(TextFormField).at(3), shortPassword);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 8 characters long'),
        findsOneWidget,
      );
    });

    testWidgets('should show error when passwords do not match', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), userTest.name!);
      await tester.enterText(find.byType(TextFormField).at(1), userTest.email!);
      await tester.enterText(find.byType(TextFormField).at(3), 'password456');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets(
      'should disable form and show CircularProgressIndicator when loading',
      (tester) async {
        final dpi = tester.view.devicePixelRatio;
        tester.view.physicalSize = Size(412 * dpi, 1200 * dpi);

        when(() => mockAuthProvider.isLoadingRegister).thenReturn(false);
        when(() => mockAuthProvider.register(userTest)).thenAnswer((_) async {
          when(() => mockAuthProvider.isLoadingRegister).thenReturn(true);
          return mockRegisterResponseSuccess;
        });

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final nameField = find.byType(TextFormField).at(0);
        final emailField = find.byType(TextFormField).at(1);
        final registerButton = find.byType(ElevatedButton);
        final loadingIndicator = find.byType(CircularProgressIndicator);

        await tester.enterText(nameField, userTest.name!);
        await tester.enterText(emailField, userTest.email!);

        await tester.enterText(
          find.byType(TextFormField).at(2),
          userTest.password!,
        );
        await tester.enterText(
          find.byType(TextFormField).at(3),
          userTest.password!,
        );
        await tester.tap(registerButton);

        await tester.pump();

        expect(loadingIndicator, findsOneWidget);
        expect(tester.widget<TextFormField>(nameField).enabled, false);
        expect(tester.widget<TextFormField>(emailField).enabled, false);
      },
    );

    testWidgets(
      'should trigger redirect to login and show success snackbar on successful registration',
      (tester) async {
        when(
          () => mockAuthProvider.register(any()),
        ).thenAnswer((_) async => mockRegisterResponseSuccess);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).at(0),
          userTest.name!,
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          userTest.email!,
        );
        await tester.enterText(
          find.byType(TextFormField).at(2),
          userTest.password!,
        );
        await tester.enterText(
          find.byType(TextFormField).at(3),
          userTest.password!,
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Register success'), findsOneWidget);
        verify(() => mockAppProvider.openLogin()).called(1);
      },
    );
  });
}
