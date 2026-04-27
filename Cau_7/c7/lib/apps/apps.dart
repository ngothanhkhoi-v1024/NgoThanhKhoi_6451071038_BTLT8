import 'package:flutter/material.dart';

import '../utils/app_constants.dart';
import '../views/student_course_view.dart';

class StudentCourseApp extends StatelessWidget {
  const StudentCourseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StudentCourseView(),
    );
  }
}
