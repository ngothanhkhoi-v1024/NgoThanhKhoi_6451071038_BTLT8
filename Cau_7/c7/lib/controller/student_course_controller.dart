import '../models/course.dart';
import '../models/enrollment.dart';
import '../models/student.dart';

class StudentCourseController {
  int _nextEnrollmentId = 1;

  final List<Student> students = <Student>[
    const Student(id: 1, name: 'Nguyen Van A'),
    const Student(id: 2, name: 'Tran Thi B'),
    const Student(id: 3, name: 'Le Van C'),
  ];

  final List<Course> courses = <Course>[
    const Course(id: 1, name: 'Lap trinh Flutter'),
    const Course(id: 2, name: 'Co so du lieu'),
    const Course(id: 3, name: 'CTDL & Giai thuat'),
    const Course(id: 4, name: 'He dieu hanh'),
  ];

  final List<Enrollment> enrollments = <Enrollment>[];

  bool isEnrolled({
    required int studentId,
    required int courseId,
  }) {
    return enrollments.any(
      (Enrollment e) => e.studentId == studentId && e.courseId == courseId,
    );
  }

  void toggleEnrollment({
    required int studentId,
    required int courseId,
  }) {
    final int index = enrollments.indexWhere(
      (Enrollment e) => e.studentId == studentId && e.courseId == courseId,
    );

    if (index != -1) {
      enrollments.removeAt(index);
      return;
    }

    enrollments.add(
      Enrollment(
        id: _nextEnrollmentId++,
        studentId: studentId,
        courseId: courseId,
      ),
    );
  }

  List<Course> getCoursesByStudentId(int studentId) {
    final Set<int> enrolledCourseIds = enrollments
        .where((Enrollment e) => e.studentId == studentId)
        .map((Enrollment e) => e.courseId)
        .toSet();

    return courses
        .where((Course course) => enrolledCourseIds.contains(course.id))
        .toList();
  }
}
