import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_number/core/error/exceptions.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_number/features/number_trivia/data/models/number_trivia_model.dart';
import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('get last numberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return numberTrivia from shared preference where there is one',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await datasource.getLastTriviaNumber();
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaModel);
    });
    test('should return a CacheExeption when there is not a cached value',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = datasource.getLastTriviaNumber;
      expect(call, throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('Cache Number Trivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'some test');
    test('should call the sharedPreferences to cachr the data ', () {
      final expectedJsonString = jsonEncode(tNumberTriviaModel);

      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      datasource.cacheTriviaNumber(tNumberTriviaModel);

      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
