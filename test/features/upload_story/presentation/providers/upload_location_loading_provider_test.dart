import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_location_loading_provider.dart';

void main() {
  group('UploadLocationLoadingProvider', () {
    late UploadLocationLoadingProvider provider;

    setUp(() {
      provider = UploadLocationLoadingProvider();
    });

    test('initial values are correct', () {
      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
    });

    test('setIsLoading updates isLoading and notifies listeners', () {
      int listenerCallCount = 0;
      provider.addListener(() => listenerCallCount++);

      provider.setIsLoading(true);

      expect(provider.isLoading, true);
      expect(listenerCallCount, 1);
    });

    test('setErrorMessage updates errorMessage and notifies listeners', () {
      int listenerCallCount = 0;
      provider.addListener(() => listenerCallCount++);

      provider.setErrorMessage('Test error');

      expect(provider.errorMessage, 'Test error');
      expect(listenerCallCount, 1);
    });

    test('setErrorMessage clear error message', () {
      provider.setErrorMessage('Error');
      provider.setErrorMessage(null);

      expect(provider.errorMessage, null);
    });
  });
}
