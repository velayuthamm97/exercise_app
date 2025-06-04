import 'dart:convert';

import 'package:exercise_app/domain/exercise_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<List<Exercise>> getExerciseList();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final String exerciseListUrl =
      'https://68252ec20f0188d7e72c394f.mockapi.io/dev/workouts';

  @override
  Future<List<Exercise>> getExerciseList() async {
    final response = await http.get(Uri.parse(exerciseListUrl));
    debugPrint('Status Code----${response.statusCode}');
    debugPrint('Response----${jsonDecode(response.body)}');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
