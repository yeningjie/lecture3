import 'student.dart';
import 'logger.dart';

/// GradeBook 类：管理一组学生成绩，混入 Logger 日志能力
class GradeBook with Logger {
  final List<Student> _students;

  /// 构造时接收学生列表
  GradeBook(this._students);

  /// 只读访问学生列表（不可变视图）
  List<Student> get students => List.unmodifiable(_students);

  /// 学生人数
  int get count => _students.length;

  /// 平均分（fold 聚合）
  double get average =>
      _students.fold<double>(0, (sum, s) => sum + s.score) / _students.length;

  /// 最高分学生（reduce 比较）
  Student get maxBy =>
      _students.reduce((a, b) => a.score >= b.score ? a : b);

  /// 及格人数（where 筛选）
  int get countPassed => _students.where((s) => s.passed).length;

  /// 按优良中分档返回 Map（fold 分组，禁止手写 for 循环）
  Map<String, List<Student>> get groupByGrade {
    String gradeOf(double score) {
      if (score >= 90) return '优';
      if (score >= 80) return '良';
      if (score >= 60) return '中';
      return '不及格';
    }
    return _students.fold<Map<String, List<Student>>>(
      {},
      (map, s) {
        final grade = gradeOf(s.score);
        map.putIfAbsent(grade, () => []);
        map[grade]!.add(s);
        return map;
      },
    );
  }
}
