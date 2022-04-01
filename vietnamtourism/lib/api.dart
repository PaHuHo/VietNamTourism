import 'package:http/http.dart' as http;

class API {
  API({required this.url});
  String url;
  Future<String> getDataString() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed!');
    }
  }
}