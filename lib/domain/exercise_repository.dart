import 'package:exercise_app/domain/exercise_list_model.dart';

abstract class ExerciseRepository{

  Future<List<Exercise>> getExerciseList();
}