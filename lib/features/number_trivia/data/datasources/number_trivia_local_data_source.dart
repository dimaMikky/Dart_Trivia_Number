import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_number/core/error/exceptions.dart';
import 'package:trivia_number/features/number_trivia/data/models/number_trivia_model.dart';

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastTriviaNumber();

  Future<void> cacheTriviaNumber(NumberTriviaModel numberTrivia);
}

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> cacheTriviaNumber(NumberTriviaModel numberTrivia) async {
    final jsonString = jsonEncode(numberTrivia);
    return await sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastTriviaNumber() async {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
