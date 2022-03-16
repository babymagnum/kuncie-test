import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kuncie_test/model/music.dart';
import '../utils/helper/constant.dart';

class BaseService {
  Dio get dioInstance {
    Dio _instance;

    final _baseOptions = BaseOptions(
      validateStatus: (status) => true,
      baseUrl: Constant.API,
      headers: {
        'Content-Type': 'application/json'
      }
    );
    _instance = Dio(_baseOptions);
    _instance.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    _instance.options.connectTimeout = 15000;
    _instance.options.sendTimeout = 15000;
    _instance.options.receiveTimeout = 15000;

    return _instance;
  }

  /// GET
  Future<T?> get<T>(String url) async {
    T? resultResponse;

    try {
      var response = await dioInstance.get(url);
      resultResponse = fromJson<T>((response.statusCode ?? 400) == 200 ? jsonDecode('${response.data}'.trim()) : null);
    } on DioError catch (e) {
      // write error logic
    }

    return resultResponse;
  }

  /// Converter json to dart object
  static T fromJson<T>(dynamic json) {
    if (T == Music) {
      return Music.fromJson(json) as T;
    } else {
      throw Exception(
          'Unknown class, dont forget to add your model in BaseService.dart to parse the json');
    }
  }

  //from json list
  static List<T> _fromJsonList<T>(List? jsonList) {
    if (jsonList == null) {
      return <T>[];
    }

    List<T> output = [];

    for (Map<String, dynamic> json in jsonList) {
      output.add(fromJson<T>(json));
    }

    return output;
  }
}