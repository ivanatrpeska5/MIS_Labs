import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mis_labs/auth/auth.dart';
import 'package:mis_labs/page/register_page.dart';

import '../domain/exam.dart';
import '../domain/notifications.dart';
import 'calendar_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  static const String id = '/home';
  final User? user = Auth().currentUser;

  Future<void> signOut(BuildContext context) async {
    await Auth().signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  Widget _signOutButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        signOut(context);
      },
      child: const Text("Sign Out"),
    );
  }

  Widget _loginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
      child: const Text("Login"),
    );
  }

  Widget _registerButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterPage(),
          ),
        );
      },
      child: const Text("Register"),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Exam> _exams = [
    Exam(id: 1, name: "Мобилни Информациски Системи", dateTime: DateTime.now()),
    Exam(id: 2, name: "Веб Програмирање", dateTime: DateTime.now()),
    Exam(id: 3, name: "Напредно Програмирање", dateTime: DateTime.now()),
  ];

  void addExam() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = "";
        DateTime newDateTime = DateTime.now();

        Future<void> _selectTime() async {
          TimeOfDay? selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (selectedTime != null) {
            setState(() {
              newDateTime = DateTime(
                newDateTime.year,
                newDateTime.month,
                newDateTime.day,
                selectedTime.hour,
                selectedTime.minute,
              );
            });
          }
        }

        return AlertDialog(
          title: const Text("Add new exam"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newName = value;
                },
                decoration: const InputDecoration(labelText: "Exam Name"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  _selectTime();
                },
                child: const Text("Select Time"),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      newDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        newDateTime.hour,
                        newDateTime.minute,
                      );
                    });
                  }
                },
                child: const Text("Select Date"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (newName.isNotEmpty) {
                    final newExam = Exam(
                      id: _exams.length + 1,
                      name: newName,
                      dateTime: newDateTime,
                    );
                    _exams.add(newExam);
                    Notifications.sendImmediateNotification(newExam);
                  }
                  Navigator.pop(context);
                });
              },
              child: const Text("Add"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var signedIn = FirebaseAuth.instance.currentUser != null;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text("Exams"),
                SizedBox(width: 8),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarPage(exams: _exams)),
                    );
                  },
                  child: const Text('Calendar'),
                ),
                const SizedBox(width: 8),
              ],
            ),
            if (signedIn) ...[
              TextButton(
                onPressed: addExam,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Add Exam"),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Spacer(), // Add this to create space between the options
            if (signedIn) ...[
              widget._signOutButton(context),
              const SizedBox(width: 8),
            ],
            if (!signedIn) ...[
              widget._loginButton(context),
              const SizedBox(width: 16),
              widget._registerButton(context),
            ],
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _exams.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                // Logic for selecting data if needed
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Text(
                          _exams[index].name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Date: ${_exams[index].dateTime.toLocal()}",
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
