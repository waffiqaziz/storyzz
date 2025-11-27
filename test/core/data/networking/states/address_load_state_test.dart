// filepath: lib/core/data/networking/states/address_load_state_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';

void main() {
  group('AddressLoadState', () {
    test('AddressLoadState.initial is created correctly', () {
      const state = AddressLoadState.initial();
      expect(state, isA<AddressLoadStateInitial>());
    });

    test('AddressLoadState.loading is created correctly', () {
      const state = AddressLoadState.loading();
      expect(state, isA<AddressLoadStateLoading>());
    });

    test('AddressLoadState.loaded is created correctly', () {
      const state = AddressLoadState.loaded('Test Address');
      expect(state, isA<AddressLoadStateLoaded>());
    });

    test('AddressLoadState.error is created correctly', () {
      const state = AddressLoadState.error('Test Error');
      expect(state, isA<AddressLoadStateError>());
    });
  });
}
