import 'package:dart_oo/student.dart';
import 'package:dart_oo/gradebook.dart';

void main(List<String> arguments) {
  // 用构造函数创建学生
  final students = [
    Student('01', '李华', 92),
    Student('02', '王芳', 55),
    Student('03', '张三', 78),
    Student('04', '赵四', 40),
  ];

  final gradebook = GradeBook(students);

  print('=== 课程成绩册 ===');
  for (final s in gradebook.students) {
    print('  ${s.id} ${s.name} 分数=${s.score} 及格=${s.passed}');
  }
  print('共 ${gradebook.count} 名学生');
}
