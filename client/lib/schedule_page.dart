import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/seance.dart';
import 'models/class_model.dart';
import 'models/professor.dart';

import './login_page.dart';
class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Seance> seances = [];
  List<ClassModel> classes = [];
  List<Professor> professors = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedClass;
  String? selectedProfessor;
  String? room;
  String? selectedDay;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch seances, classes, and professors
      seances = await ApiService.fetchSeances();
      classes = await ApiService.fetchClasses();
      professors = await ApiService.fetchProfessors();
      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // Get the time range as a string
  String getTimeRange(Seance seance) {
    return seance.time ?? 'No Time';
  }

  // Find the class name based on classId
  String getClassName(String? classId) {
    if (classId == null) return 'No Class';
    final classModel = classes.firstWhere(
        (classItem) => classItem.id == classId,
        orElse: () => ClassModel(id: '', name: 'No Class'));
    return classModel.name;
  }

  // Find the professor name based on professorId
  String getProfessorName(String? professorId) {
    if (professorId == null) return 'No Professor';
    final professor = professors.firstWhere((prof) => prof.id == professorId,
        orElse: () => Professor(id: '', name: 'No Professor'));
    return professor.name;
  }

  // Show a dialog to fill in seance details
  void _showSeanceDetailsForm(String day, String time) {
    setState(() {
      selectedDay = day;
      selectedTime = time;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Seance Details'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Day: $selectedDay'),
                Text('Time: $selectedTime'),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedClass,
                  hint: Text('Select Class'),
                  items: classes.map((ClassModel classModel) {
                    return DropdownMenuItem<String>(
                      value: classModel.id,
                      child: Text(classModel.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedClass = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a class';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedProfessor,
                  hint: Text('Select Professor'),
                  items: professors.map((Professor professor) {
                    return DropdownMenuItem<String>(
                      value: professor.id,
                      child: Text(professor.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProfessor = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a professor';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: room,
                  decoration: InputDecoration(labelText: 'Room'),
                  onChanged: (value) {
                    setState(() {
                      room = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Submit the seance data to the server
                  Seance newSeance = Seance(
                    id: '', // You can leave this empty or generate an ID
                    day: selectedDay ?? 'No Day', // Ensure non-null value
                    time: selectedTime ?? 'No Time', // Ensure non-null value
                    classId: selectedClass,
                    professorId: selectedProfessor,
                    room: room,
                  );
                  ApiService.addSeance(newSeance).then((_) {
                    setState(() {
                      seances.add(newSeance);
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show the current seance details in a dialog (if necessary)
  void _showSeanceDetails(Seance seance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seance Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Class: ${getClassName(seance.classId)}'),
              Text('Professor: ${getProfessorName(seance.professorId)}'),
              Text('Room: ${seance.room ?? 'No Room'}'),
              Text('Day: ${seance.day}'),
              Text('Time: ${seance.time}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Delete a seance when long pressing a cell
  void _deleteSeance(Seance seance) {
    ApiService.deleteSeance(seance.id!).then((_) {
      setState(() {
        seances.remove(seance);
      });
    }).catchError((error) {
      print("Failed to delete seance: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday'];
    final timeSlots = [
      '08:00 - 10:00',
      '10:00 - 12:00',
      '12:00 - 14:00',
      '14:00 - 16:00',
      '16:00 - 18:00'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('University Schedule'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    onLoginSuccess: (success) {
                    },
                  ),
                ),
                (route) => false, // This clears the navigation stack.
              );
            },
          ),
        ],
      ),
      body: seances.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // Header Row (Days and Time Slots)
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 150,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: Text('Weekday/Time',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ...timeSlots.map((time) {
                          return Container(
                            height: 100,
                            width: 150,
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: Text(time,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          );
                        }).toList(),
                      ],
                    ),
                    // Data Rows (Days and their corresponding Seance data)
                    ...daysOfWeek.map((day) {
                      return Row(
                        children: [
                          Container(
                            height: 100, // Fixed height for the row
                            width: 150,
                            alignment: Alignment.center,
                            child: Text(day),
                          ),
                          ...timeSlots.map((time) {
                            // Filter seances based on day and time
                            final seance = seances.firstWhere(
                              (seance) =>
                                  seance.day == day && seance.time == time,
                              orElse: () => Seance(id: '', day: '', time: ''),
                            );

                            // Check if there's a valid seance, if not, return an empty cell with 'Click to Add'
                            if (seance.id == '') {
                              return GestureDetector(
                                onTap: () => _showSeanceDetailsForm(day, time),
                                child: Container(
                                  height: 100, // Fixed height for the row
                                  width: 150,
                                  alignment: Alignment.center,
                                  color: Colors.blue[50],
                                  child: Text('Click to Add'),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () => _showSeanceDetails(seance),
                                onLongPress: () => _deleteSeance(seance),
                                child: Container(
                                  height: 100, // Fixed height for the row
                                  width: 150,
                                  padding:
                                      EdgeInsets.all(8.0), // Optional padding
                                  color: Colors.blue[100],
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${getClassName(seance.classId)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('${seance.room ?? 'No Room'}'),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }
}
