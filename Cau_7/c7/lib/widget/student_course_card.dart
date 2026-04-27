import 'package:flutter/material.dart';

import '../controller/student_course_controller.dart';
import '../models/course.dart';
import '../models/student.dart';

class StudentCourseCard extends StatelessWidget {
  final Student student;
  final StudentCourseController controller;
  final VoidCallback onChanged;

  const StudentCourseCard({
    super.key,
    required this.student,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Course> enrolledCourses =
        controller.getCoursesByStudentId(student.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${student.id}. ${student.name}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dang ky mon hoc',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            ...controller.courses.map(
              (Course course) => CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(course.name),
                value: controller.isEnrolled(
                  studentId: student.id,
                  courseId: course.id,
                ),
                onChanged: (_) {
                  controller.toggleEnrollment(
                    studentId: student.id,
                    courseId: course.id,
                  );
                  onChanged();
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              enrolledCourses.isEmpty
                  ? 'Mon da dang ky: Chua co'
                  : 'Mon da dang ky: ${enrolledCourses.map((Course c) => c.name).join(', ')}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
