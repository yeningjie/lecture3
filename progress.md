# 进度报告3（第5周·Dart语言基础二：面向对象与集合）

## 一、任务理解

本次作业要求完成"课程成绩册"案例 dart_oo 的完整复现，用 Dart 面向对象编程和集合操作建模学生成绩管理系统。具体任务包括：

1. 定义 Student 类，含私有字段（下划线前缀）、命名构造函数 fromJson、getter/setter 封装与校验
2. 定义 GradeBook 类管理学生列表
3. 用集合链式方法（where/map/fold/reduce）实现统计功能：average（平均分）、maxBy（最高分学生）、countPassed（及格人数）、groupByGrade（按优良中分档返回Map），禁止手写for循环
4. 将日志能力抽为 Logger mixin 混入 GradeBook
5. 编写至少2个单元测试覆盖正常数据和异常路径
6. 每步一次 Git 提交，推送到 GitHub lecture3 仓库

验收标准：dart run 统计输出正确；dart test 全部通过；3次以上规范提交。

## 二、环境与工具

- 操作系统：Windows 11（25H2，build 26200.9457）
- Dart SDK：3.13.3（Flutter 3.47.4 stable 自带）
- 开发工具：Trae Code（AI 辅助编程，GLM-5.2 模型）
- 运行目标：控制台（纯 Dart 工程，无 UI 界面）
- 版本控制：Git + GitHub 远程仓库（lecture3）
- Flutter 中国镜像：storage.flutter-io.cn

## 三、过程记录

- 14:29  执行 dart create dart_oo 创建工程，git init 初始化仓库，首次提交 "feat: dart create dart_oo"
- 14:30  编写 lib/student.dart（Student 类）和 lib/gradebook.dart（GradeBook 类），更新 bin/dart_oo.dart，提交 "feat: Student & GradeBook models"
- 14:31  为 GradeBook 实现 average/maxBy/countPassed/groupByGrade 四个统计方法，提交 "feat: gradebook stats via collection chains"
- 14:32  创建 lib/logger.dart（Logger mixin），编写 test/dart_oo_test.dart（6个测试），提交 "feat: Logger mixin & unit tests"
- 14:33  git push 推送到 GitHub lecture3 仓库
- 14:48  分别运行 dart run、dart test、flutter doctor、git log --stat 截取全屏截图

## 四、关键代码

### 【代码段1】Student 类——封装、命名构造、校验setter（AI生成，本人通过 dart run 和 dart test 验证）

```dart
class Student {
  final String id;
  final String name;
  double _score;                       // 私有字段：下划线前缀

  Student(this.id, this.name, [this._score = 0]);  // 主构造，score默认0

  Student.fromJson(Map<String, dynamic> json)     // 命名构造：从Map造对象
      : id = json['id'] as String,
        name = json['name'] as String,
        _score = (json['score'] as num).toDouble();

  double get score => _score;                     // getter 只读
  set score(double v) {                           // setter 带校验
    if (v < 0 || v > 100) throw ArgumentError('分数越界: $v');
    _score = v;
  }
  bool get passed => _score >= 60;                // 便捷getter
}
```

逐行说明：final id/name 不可变字段；_score 下划线私有；Student() 主构造用 this. 语法糖；Student.fromJson() 命名构造用初始化列表从 Map 取值；getter score 只读访问；setter score 校验 0~100 越界抛 ArgumentError；passed 是计算型 getter。

### 【代码段2】GradeBook 统计方法——集合链式处理（AI生成，本人通过 dart run 验证输出正确）

```dart
double get average =>
    _students.fold<double>(0, (sum, s) => sum + s.score) / _students.length;

Student get maxBy =>
    _students.reduce((a, b) => a.score >= b.score ? a : b);

int get countPassed => _students.where((s) => s.passed).length;

Map<String, List<Student>> get groupByGrade {
  String gradeOf(double score) {
    if (score >= 90) return '优';
    if (score >= 80) return '良';
    if (score >= 60) return '中';
    return '不及格';
  }
  return _students.fold<Map<String, List<Student>>>(
    {}, (map, s) {
      final grade = gradeOf(s.score);
      map.putIfAbsent(grade, () => []);
      map[grade]!.add(s);
      return map;
    });
}
```

逐行说明：average 用 fold 累加分数再除以人数；maxBy 用 reduce 两两比较取高分者；countPassed 用 where 筛选及格再取 length；groupByGrade 用 fold 遍历学生，putIfAbsent 确保每个分档键存在，将学生加入对应列表。全程无手写 for 循环。

### 【代码段3】Logger mixin——跨类复用日志能力（AI生成，本人通过 dart run 验证 [GradeBook] 日志输出）

```dart
mixin Logger {
  void log(String msg) => print('[$runtimeType] $msg');
}

class GradeBook with Logger { ... }
```

逐行说明：mixin Logger 定义 log 方法，用 runtimeType 自动获取混入类名；GradeBook with Logger 混入后即可调用 gradebook.log()，输出格式为 [GradeBook] 消息内容。mixin 解决了"多个不相关类需要同一批能力"的复用问题。

## 五、检查点结果

- 检查点1——统计输出正确：dart run 输出平均分 70.0、最高分 李华(92.0)、及格人数 3、分档（优:李华 / 良:钱五 / 中:张三 / 不及格:王芳,赵四），全部与手算一致。
- 检查点2——测试全部通过：dart test 运行 6 个测试用例（平均分、最高分、及格人数、分档、分数越界抛异常、fromJson解析），全部绿色通过 "All tests passed!"。
- 检查点3——Git规范：4次提交，均使用 feat: 前缀的规范提交信息，已推送到 GitHub lecture3 仓库。

## 六、问题与调试

- 问题1：flutter doctor 的 Network resources 检查失败，报 "An HTTP error occurred while checking https://github.com/: 信号灯超时间已到"。定位：国内网络访问 GitHub 不稳定导致超时。解决：重试多次后网络恢复，flutter doctor 最终显示 "No issues found!"。
- 问题2：groupByGrade 方法最初用 for 循环遍历学生分组，但作业要求"禁止手写 for 循环"。定位：需要改用集合高阶方法。解决：改用 fold 遍历，putIfAbsent 确保键存在，add 加入列表，实现纯函数式分组。

## 七、AI使用记录

- 用途1：案例代码生成。指令摘要：根据实践指南创建 dart_oo 工程，编写 Student/GradeBook 类和统计方法，加 Logger mixin 和单元测试。输出：lib/ 下 4 个 Dart 文件、test/ 下 1 个测试文件。本人验证方式：dart run 验证输出正确、dart test 验证 6 个测试通过。
- 用途2：进度报告填写。指令摘要：根据三个文档内容和实际操作过程填写进度报告三十节。输出：本报告全文。本人验证方式：逐节核对内容与实际操作一致。
- 用途3：Git 操作指导。指令摘要：逐步指导 GitHub 建仓库、dart create、git init/add/commit/push。输出：4 次规范提交推送到 lecture3 仓库。本人验证方式：git log 确认提交历史、GitHub 页面确认远程仓库内容。

## 八、证据截图

- 图1：dart run 运行截图——展示 Logger 日志、学生列表、统计结果（平均分/最高分/及格人数）和优良中分档输出。（docs/dart_run_运行截图.png）
- 图2：dart test 运行截图——6个测试用例全部通过。（docs/dart_test_截图.png）
- 图3：flutter doctor 截图——Flutter 3.47.4 环境，最终 "No issues found!" 全部通过。（docs/flutter_doctor_截图.png）
- 图4：git log --stat 截图——4次规范提交，已推送到 origin/main。（docs/git_log_截图.png）

## 九、自评

- 6.1 案例复现（15分）：dart_oo 完整复现，Student 类含封装/命名构造/校验setter，GradeBook 含4个统计方法，Logger mixin 混入，6个测试全通过。——已完成
- 6.1 检查点（5分）：统计输出正确，测试全部通过。——已完成
- 6.1 Git规范（5分）：4次 feat: 前缀提交，推送到 lecture3 仓库。——已完成
- 6.1 报告记录（5分）：十节填写完整，含代码解释和截图。——已完成
- 6.2 自主实践基本要求：类设计合理性、mixin改造、集合统计链、单元测试、AI使用标注——全部完成
- 6.3 独立研究任务（选做）：mixin线性化实验、集合不可变实践、equality与hashCode重写——未做（选做）

## 十、一句话收获与下一步计划

- 一句话收获：Dart 用下划线私有 + getter/setter 实现封装，用 mixin 解决跨类复用，用 where/map/fold 链式处理集合，三者组合后成绩统计代码非常简洁。
- 遗留问题：mixin 的 with 顺序对同名方法的影响（线性化）还需要多做实验才能完全理解。
- 下一步计划：预习 Flutter Widget 开发，了解 StatelessWidget 和 StatefulWidget 的区别与生命周期。
