// models/seance.dart
class Seance {
  final int id;
  final String day;
  final String time;
  final int? classId;
  final int? professorId;
  final String? room;

  Seance({
    required this.id,
    required this.day,
    required this.time,
    this.classId,
    this.professorId,
    this.room,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: json['id'],
      day: json['day'],
      time: json['time'],
      classId: json['classId'],
      professorId: json['professorId'],
      room: json['room'],
    );
  }
}
