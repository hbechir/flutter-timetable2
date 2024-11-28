class Seance {
  String id;
  final String day;
  final String time;
  final String? classId;
  final String? professorId;
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
      id: json['id'].toString(),
      day: json['day'],
      time: json['time'],
      classId: json['classId']?.toString(),
      professorId: json['professorId']?.toString(),
      room: json['room'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'time': time,
      'classId': classId,
      'professorId': professorId,
      'room': room,
    };
  }
}