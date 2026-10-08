import 'student.dart';

/// GradeBook 类：管理一组学生成绩
class GradeBook {
  final List<Student> _students;

  /// 构造时接收学生列表
  GradeBook(this._students);

  /// 只读访问学生列表（不可变视图）
  List<Student> get students => List.unmodifiable(_students);

  /// 学生人数
  int get count => _students.length;
}
