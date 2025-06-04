import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:exercise_app/data/exercise_repository_impl.dart';
import 'package:exercise_app/domain/exercise_list_model.dart';
import 'package:exercise_app/domain/get_exercise_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api_data_source.dart';

class ExerciseBloc extends Bloc<ExerciseBlocEvent, ExerciseBlocState> {
  final remoteDataSource = RemoteDataSourceImpl();

  Timer? timer;
  int remaining = 0;

  ExerciseBloc() : super(ExerciseBlocInitial()) {
    on<ExerciseBlocEvent>((event, emit) async {
      if (event is ExerciseBlocGetExercises) {
        emit(ExerciseBlocLoading());
        final repository = ExerciseRepositoryImpl(remoteDataSource);
        final getExercises = GetExerciseUseCase(repository);
        try {
          final exercises = await getExercises();
          emit(ExerciseBlocExerciseListSuccess(exercises));
        } catch (e) {
          emit(ExerciseBlocExerciseListFailure(e.toString()));
        }
      }

      if (event is StartExercise) {
        if (event.exercise.isCompleted == true) {
          return;
        }

        timer?.cancel();
        remaining = event.exercise.duration?.toInt() ?? 0;
        emit(ExerciseRunning(remaining));

        timer = Timer.periodic(Duration(seconds: 1), (_) {
          add(Tick());
        });
      }

      if (event is Tick) {
        remaining--;
        if (remaining <= 0) {
          timer?.cancel();
          emit(ExerciseCompleted());
        } else {
          emit(ExerciseRunning(remaining));
        }
      }

      if (event is ExerciseCompletedEvent &&
          state is ExerciseBlocExerciseListSuccess) {
        final successState = state as ExerciseBlocExerciseListSuccess;
        final updatedList =
            successState.exercises.map((exercise) {
              if (exercise.id == event.exerciseId) {
                return exercise.copyWith(isCompleted: true);
              }
              return exercise;
            }).toList();

        emit(ExerciseBlocExerciseListSuccess(updatedList));
      }
    });
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}

class ExerciseBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseBlocInitial extends ExerciseBlocState {}

class ExerciseBlocLoading extends ExerciseBlocState {}

class ExerciseBlocExerciseListSuccess extends ExerciseBlocState {
  final List<Exercise> exercises;

  ExerciseBlocExerciseListSuccess(this.exercises);

  @override
  List<Object?> get props => [exercises];
}

class ExerciseBlocExerciseListFailure extends ExerciseBlocState {
  final String message;

  ExerciseBlocExerciseListFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ExerciseRunning extends ExerciseBlocState {
  final int remaining;

  ExerciseRunning(this.remaining);

  @override
  List<Object?> get props => [remaining];
}

class ExerciseCompleted extends ExerciseBlocState {}

class ExerciseBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseBlocGetExercises extends ExerciseBlocEvent {}

class StartExercise extends ExerciseBlocEvent {
  final int duration;
  final Exercise exercise;

  StartExercise(this.duration, this.exercise);
}

class Tick extends ExerciseBlocEvent {}

class ExerciseCompletedEvent extends ExerciseBlocEvent {
  final String exerciseId;

  ExerciseCompletedEvent(this.exerciseId);
}
