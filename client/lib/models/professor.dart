class Professor {
  final String id;
  final String name;

  Professor({required this.id, required this.name});

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}