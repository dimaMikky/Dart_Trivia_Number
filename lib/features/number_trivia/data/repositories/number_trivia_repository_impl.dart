import 'package:trivia_number/core/error/exceptions.dart';
import 'package:trivia_number/core/network/network_info.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_number/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_number/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia_number/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandom();

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandom getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final randomRemoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheTriviaNumber(randomRemoteTrivia);
        return Right(randomRemoteTrivia);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      try {
        final randonLocalTriviaNumber =
            await localDataSource.getLastTriviaNumber();
        return Right(randonLocalTriviaNumber);
      } on CacheException {
        return left(CacheFailure());
      }
    }
  }
}
