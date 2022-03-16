import '../model/music.dart';
import 'base_service.dart';

class HttpService extends BaseService {

  static final HttpService _instance = HttpService._internal();

  HttpService._internal();

  factory HttpService() => _instance;

  Future<Music?> getSongs(String query) async {
    return await get('/search?media=music&term=$query&limit=100');
  }
}
