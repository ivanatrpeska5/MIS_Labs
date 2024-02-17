import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../domain/exam.dart';
import 'home_page.dart';

class CalendarPage extends StatefulWidget {
  static const String id = "calendarPage";
  final List<Exam> exams;

  const CalendarPage({Key? key, required this.exams}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Exam>> _events;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late List<Exam> _selectedExams;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay =
        DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    _events = {};
    _selectedExams = [];

    for (var exam in widget.exams) {
      final date =
          DateTime(exam.dateTime.year, exam.dateTime.month, exam.dateTime.day);
      if (_events[date] == null) _events[date] = [];
      _events[date]!.add(exam);
    }

    _selectedExams = _events[_selectedDay] ?? [];
  }

  Widget _appBarTitle() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      child: const Text('Exams'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Calendar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day);
                _focusedDay = focusedDay;
                _selectedExams = _events[_selectedDay] ?? [];
              });
            },
            eventLoader: (day) => _events[day] ?? [],
          ),
          Expanded(
            child: _selectedExams.isEmpty
                ? Center(
                    child: Text('No exams for the selected date'),
                  )
                : ListView.builder(
                    itemCount: _selectedExams.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text(
                            _selectedExams[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            _selectedExams[index]
                                .dateTime
                                .toString()
                                .split(".")[0],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
