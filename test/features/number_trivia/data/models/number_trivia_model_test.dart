import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_number/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'some test');

  test(
    'should be a subclass of NumberTriviaEntity',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('from Json', () {
    test(
      'should return a valid model when the json number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
    test(
      'should return a valid model when the json number is regarded as a double ',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            jsonDecode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('to Json', () {
    test(
      'should return a JSON map containing the propere data',
      () async {
        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        final expectedMap = {
          "text": "some test",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
