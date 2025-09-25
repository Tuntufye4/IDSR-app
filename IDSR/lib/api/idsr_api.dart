import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/idsr_case.dart';

class IdsrApi {
  final String baseUrl;

  IdsrApi({required this.baseUrl});

  // Fetch all cases
  Future<List<IdsrCase>> fetchCases() async {
    final response = await http.get(
      Uri.parse('$baseUrl/cases/'),        
    ); // trailing slash added
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => IdsrCase.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cases');
    }
  }     

  // Submit a new case
  Future<bool> submitCase(IdsrCase idsrCase) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cases/'), // trailing slash added
      headers: {'Content-Type': 'application/json'},
      body: json.encode(idsrCase.toJson()),
    );

    return response.statusCode == 201;
  }   
}       
