import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/seance.dart';
import '../models/class_model.dart';
import '../models/professor.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.167.44:3000';

  // Fetch classes
  static Future<List<ClassModel>> fetchClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/classes'));
    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      print("jsonData: $jsonData");
      return jsonData.map((json) => ClassModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load classes');
    }
  }

  // Fetch professors
  static Future<List<Professor>> fetchProfessors() async {
    final response = await http.get(Uri.parse('$baseUrl/professors'));
    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((json) => Professor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load professors');
    }
  }

  // Fetch seances
  static Future<List<Seance>> fetchSeances() async {
    final response = await http.get(Uri.parse('$baseUrl/seances'));
    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((json) => Seance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load seances');
    }
  }

  // Add a new seance
  static Future<void> addSeance(Seance seance) async {
    // generate a random id
    seance.id = DateTime.now().millisecondsSinceEpoch.toString();

    final response = await http.post(
      Uri.parse('$baseUrl/seances'),
      headers: {'Content-Type': 'application/json'},
      // headers: {'Authorization': 'Bearer $token'},

      body: json.encode(seance.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add seance');
    }
  }

  // Delete a seance
  static Future<void> deleteSeance(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/seances/$id'),
      // headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete seance');
    }
  }
}
