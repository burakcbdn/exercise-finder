import 'dart:convert';

import 'package:exercises_assistant_app/models/exercise.model.dart';
import 'package:http/http.dart';


class APIController {
  // rapid api key
  static const String apiKey = 'ffe36c754amsha920f3910187ec2p1711c6jsn373257c46401';
  static const String baseURL = 'https://exercises-by-api-ninjas.p.rapidapi.com/v1';

  // default headers
  static Map<String, String> headers = headers = {
    "X-RapidAPI-Key": apiKey,
    "X-RapidAPI-Host": "exercises-by-api-ninjas.p.rapidapi.com",
  };

  // get exercises with specified parameters
  static Future<List<ExerciseModel>> getExercises({
    int offset = 0,
    String query = 'rick',
    String muscle = '',
    String type = '',
  }) async {
    
    final response = await get(Uri.parse('$baseURL/exercises?offset=$offset&name=$query&type=$type&muscle=$muscle'), headers: headers);

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)).map<ExerciseModel>((e) => ExerciseModel.fromJson(e)).toList();
    } else {
      throw {
        'status': response.statusCode,
        'message': response.body,
      };
    }
  }
}
