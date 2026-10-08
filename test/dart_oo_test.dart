import 'package:dart_oo/student.dart';
import 'package:dart_oo/gradebook.dart';
import 'package:test/test.dart';

void main() {
  // 准备测试数据
  final students = [
    Student('01', '李华', 92),
    Student('02', '王芳', 55),
    Student('03', '张三', 78),
  ];

  group('GradeBook 统计功能', () {
    final gradebook = GradeBook(students);

    test('平均分计算正确', () {
      // (92 + 55 + 78) / 3 = 75.0
      expect(gradebook.average, closeTo(75.0, 0.01));
    });

    test('最高分学生正确', () {
      expect(gradebook.maxBy.name, '李华');
      expect(gradebook.maxBy.score, 92);
    });

    test('及格人数正确', () {
      // 李华(92) 和 张三(78) 及格，王芳(55) 不及格
      expect(gradebook.countPassed, 2);
    });

    test('分档结果正确', () {
      final groups = gradebook.groupByGrade;
      expect(groups['优']?.length, 1); // 李华
      expect(groups['中']?.length, 1); // 张三
      expect(groups['不及格']?.length, 1); // 王芳
      expect(groups['良'], isNull); // 无人
    });
  });

  group('Student 边界与异常', () {
    test('分数越界抛 ArgumentError', () {
      final s = Student('10', '测试', 50);
      expect(() => s.score = 101, throwsArgumentError);
      expect(() => s.score = -1, throwsArgumentError);
    });

    test('fromJson 命名构造正确解析', () {
      final s = Student.fromJson({
        'id': '07',
        'name': '赵六',
        'score': 88,
      });
      expect(s.id, '07');
      expect(s.name, '赵六');
      expect(s.score, 88);
      expect(s.passed, isTrue);
    });
  });
}
