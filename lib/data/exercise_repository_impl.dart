import 'package:exercise_app/data/api_data_source.dart';
import 'package:exercise_app/domain/exercise_list_model.dart';
import 'package:exercise_app/domain/exercise_repository.dart';

class ExerciseRepositoryImpl extends ExerciseRepository {
  final RemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Exercise>> getExerciseList() {
    return remoteDataSource.getExerciseList();
  }
}
