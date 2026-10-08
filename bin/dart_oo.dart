import 'package:dart_oo/student.dart';
import 'package:dart_oo/gradebook.dart';

void main(List<String> arguments) {
  // 用构造函数创建学生
  final students = [
    Student('01', '李华', 92),
    Student('02', '王芳', 55),
    Student('03', '张三', 78),
    Student('04', '赵四', 40),
    Student('05', '钱五', 85),
  ];

  final gradebook = GradeBook(students);
  gradebook.log('成绩册已创建，共 ${students.length} 名学生');

  print('=== 1. 学生列表 ===');
  for (final s in gradebook.students) {
    print('  ${s.id} ${s.name} 分数=${s.score} 及格=${s.passed}');
  }
  print('共 ${gradebook.count} 名学生\n');

  print('=== 2. 统计功能（集合链式方法）===');
  print('  平均分: ${gradebook.average.toStringAsFixed(1)}');
  print('  最高分: ${gradebook.maxBy.name} (${gradebook.maxBy.score})');
  print('  及格人数: ${gradebook.countPassed}');

  print('\n=== 3. 按优良中分档 ===');
  final groups = gradebook.groupByGrade;
  for (final entry in groups.entries) {
    final names = entry.value.map((s) => s.name).join(', ');
    print('  ${entry.key}: $names');
  }
}
