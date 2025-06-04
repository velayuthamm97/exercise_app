import 'package:exercise_app/core/app_theme_manager.dart';
import 'package:exercise_app/core/constants.dart';
import 'package:exercise_app/core/utils.dart';
import 'package:exercise_app/domain/exercise_list_model.dart';
import 'package:exercise_app/presentation/bloc/exercise_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseBloc(),
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  @override
  void initState() {
    super.initState();
    getExerciseList();
  }

  void getExerciseList() {
    ExerciseBloc bloc = BlocProvider.of<ExerciseBloc>(context);
    bloc.add(ExerciseBlocGetExercises());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Constants.exerciseList,
          style: AppThemeManager.customTextStyleWithSize(
            size: 18,
            weight: FontWeight.w700,
            isHeader: true,
          ),
        ),
      ),
      body: mainWidget(),
    );
  }

  Widget mainWidget() {
    return BlocBuilder<ExerciseBloc, ExerciseBlocState>(
      builder: (context, state) {
        if (state is ExerciseBlocLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is ExerciseBlocExerciseListSuccess) {
          return ListView.separated(
            itemBuilder: (context, index) {
              Exercise exercise = state.exercises[index];
              return InkWell(
                onTap: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(exercise: exercise),
                    ),
                  );
                  if (result != null && result == true) {
                    context.read<ExerciseBloc>().add(
                      ExerciseCompletedEvent(exercise.id!),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Row(
                    spacing: 15,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withAlpha(50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.sports_gymnastics, size: 40),
                      ),
                      Text(
                        exercise.name.toString().capitalize(),
                        style: AppThemeManager.customTextStyleWithSize(
                          size: 16,
                          weight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        exercise.isCompleted == true
                            ? Icons.check_circle
                            : Icons.access_time,
                        color:
                            exercise.isCompleted == true
                                ? Colors.green
                                : Colors.grey,
                      ),
                      Spacer(),
                      Text(
                        Utils.formatTime(exercise.duration?.toInt() ?? 0),
                        style: AppThemeManager.customTextStyleWithSize(
                          size: 16,
                          weight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, state) {
              return SizedBox(height: 15);
            },
            itemCount: state.exercises.length,
          );
        }

        if (state is ExerciseBlocExerciseListFailure) {
          return Center(child: Text(state.message));
        }

        return Container();
      },
    );
  }
}
