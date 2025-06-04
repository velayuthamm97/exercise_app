import 'package:exercise_app/core/app_theme_manager.dart';
import 'package:exercise_app/core/constants.dart';
import 'package:exercise_app/core/utils.dart';
import 'package:exercise_app/domain/exercise_list_model.dart';
import 'package:exercise_app/presentation/bloc/exercise_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailScreen extends StatelessWidget {
  final Exercise exercise;

  const DetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseBloc(),
      child: DetailScreenContent(exercise: exercise),
    );
  }
}

class DetailScreenContent extends StatefulWidget {
  final Exercise exercise;

  const DetailScreenContent({super.key, required this.exercise});

  @override
  State<DetailScreenContent> createState() => _DetailScreenContentState();
}

class _DetailScreenContentState extends State<DetailScreenContent> {
  int start = 0;

  @override
  void initState() {
    super.initState();
    start = widget.exercise.duration?.toInt() ?? 0;
  }

  void startTimer() {
    ExerciseBloc bloc = BlocProvider.of<ExerciseBloc>(context);
    bloc.add(StartExercise(start, widget.exercise));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          final blocState = context.read<ExerciseBloc>().state;
          switch (blocState) {
            case ExerciseCompleted():
              Navigator.pop(context, true);
            case ExerciseRunning():
              showAlertDialog(
                message: Constants.workoutIsRunning,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context, false);
                    },
                    child: Text(Constants.yes),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Constants.no),
                  ),
                ],
              );
            default:
              Navigator.pop(context, false);
          }
        }
      },
      canPop: false,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: AppThemeManager.whiteColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.exercise.name.toString().capitalize(),
              style: AppThemeManager.customTextStyleWithSize(
                size: 18,
                weight: FontWeight.w700,
                isHeader: true,
              ),
            ),
          ),
          body: mainWidget(),
        ),
      ),
    );
  }

  Widget mainWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Row(
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
                      widget.exercise.name.toString().capitalize(),
                      style: AppThemeManager.customTextStyleWithSize(size: 14),
                    ),
                  ],
                ),
                iconWithLabelWidget(
                  icon: Icons.description_outlined,
                  label: Constants.description,
                  description:
                      widget.exercise.description.toString().capitalize(),
                ),
                iconWithLabelWidget(
                  icon: Icons.dangerous_outlined,
                  label: Constants.difficulty,
                  description:
                      widget.exercise.difficulty.toString().capitalize(),
                ),
                iconWithLabelWidget(
                  icon: Icons.timer_outlined,
                  label: Constants.duration,
                  description: Utils.formatTime(
                    widget.exercise.duration?.toInt() ?? 0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 60,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                startTimer();
              },
              child: BlocListener<ExerciseBloc, ExerciseBlocState>(
                listener: (context, state) {
                  if (state is ExerciseCompleted) {
                    widget.exercise.completed = true;
                    Navigator.pop(context, true);
                  }
                },
                child: BlocBuilder<ExerciseBloc, ExerciseBlocState>(
                  builder: (context, state) {
                    String label = '';

                    if (state is ExerciseBlocInitial) {
                      label =
                          widget.exercise.isCompleted ?? false
                              ? Constants.completed
                              : Constants.start;
                    } else if (state is ExerciseRunning) {
                      label = Utils.formatTime(state.remaining);
                    } else if (state is ExerciseCompleted) {
                      label = Constants.completed;
                    }

                    return Text(
                      label,
                      style: AppThemeManager.customTextStyleWithSize(
                        size: 16,
                        color: Colors.orange,
                        weight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAlertDialog({
    required String message,
    required List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Constants.alert,
            style: AppThemeManager.customTextStyleWithSize(
              size: 16,
              weight: FontWeight.w700,
              color: Colors.orange,
              isHeader: true,
            ),
          ),
          content: Text(
            message,
            style: AppThemeManager.customTextStyleWithSize(
              size: 14,
              weight: FontWeight.w500,
            ),
          ),
          actions: actions,
        );
      },
    );
  }

  Widget iconWithLabelWidget({
    required IconData icon,
    required String label,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(icon, color: Colors.orange),
            Text(
              label,
              style: AppThemeManager.customTextStyleWithSize(
                size: 16,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Text(
          description,
          style: AppThemeManager.customTextStyleWithSize(size: 14),
        ),
      ],
    );
  }
}
