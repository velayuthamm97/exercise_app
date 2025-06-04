import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:exercise_app/domain/exercise_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'app_exception.dart';

abstract class RemoteDataSource {
  Future<List<Exercise>> getExerciseList();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final String exerciseListUrl =
      'https://68252ec20f0188d7e72c394f.mockapi.io/dev/workouts';

  @override
  Future<List<Exercise>> getExerciseList() async {
    try {
      final response = await http
          .get(Uri.parse(exerciseListUrl))
          .timeout(const Duration(seconds: 20));
      debugPrint('Status Code----${response.statusCode}');
      debugPrint('Response----${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        debugPrint('Response ---- $decoded');

        if (decoded is List) {
          return decoded.map((json) => Exercise.fromJson(json)).toList();
        } else {
          throw AppException('Unexpected data format from server.');
        }
      } else {
        throw AppException('Failed to load exercises');
      }
    } on SocketException {
      throw AppException('No Internet connection. Please check your network.');
    } on TimeoutException {
      throw AppException('Request timed out. Please try again later.');
    } catch (e) {
      debugPrint('Error fetching exercises: $e');
      throw AppException('Something went wrong. Please try again.');
    }
  }
}
