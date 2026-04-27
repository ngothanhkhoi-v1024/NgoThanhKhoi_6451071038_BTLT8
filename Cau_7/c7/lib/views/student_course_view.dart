import 'package:flutter/material.dart';

import '../controller/student_course_controller.dart';
import '../utils/app_constants.dart';
import '../widget/student_course_card.dart';

class StudentCourseView extends StatefulWidget {
  const StudentCourseView({super.key});

  @override
  State<StudentCourseView> createState() => _StudentCourseViewState();
}

class _StudentCourseViewState extends State<StudentCourseView> {
  final StudentCourseController _controller = StudentCourseController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _controller.students.length,
        itemBuilder: (BuildContext context, int index) {
          final student = _controller.students[index];
          return StudentCourseCard(
            student: student,
            controller: _controller,
            onChanged: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
