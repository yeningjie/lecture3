/// Student 类：课程成绩册中的学生模型
class Student {
  final String id;
  final String name;
  double _score; // 私有字段：下划线前缀表示库内私有

  /// 主构造函数：位置参数，score 默认 0
  Student(this.id, this.name, [this._score = 0]);

  /// 命名构造函数：从 Map/JSON 构造对象
  Student.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        _score = (json['score'] as num).toDouble();

  /// getter：只读访问私有分数
  double get score => _score;

  /// setter：带校验，分数必须在 0~100 之间
  set score(double v) {
    if (v < 0 || v > 100) throw ArgumentError('分数越界: $v');
    _score = v;
  }

  /// 是否及格（便捷 getter）
  bool get passed => _score >= 60;

  @override
  String toString() => 'Student($id, $name, $score)';
}
