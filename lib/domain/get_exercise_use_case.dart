import 'package:exercise_app/domain/exercise_list_model.dart';
import 'package:exercise_app/domain/exercise_repository.dart';

class GetExerciseUseCase {
  final ExerciseRepository repository;

  GetExerciseUseCase(this.repository);

  Future<List<Exercise>> call() async {
    return await repository.getExerciseList();
  }
}
