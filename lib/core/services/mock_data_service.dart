import '../models/student_history_model.dart';
import '../models/analytics_model.dart';
import '../models/class_model.dart';
import '../models/student_model.dart';

class MockDataService {
  // Статичные данные вместо БД

  // Добавить в MockDataService
  static final List<StudentHistoryModel> _commonHistory = [
    StudentHistoryModel(
      id: 'history_1',
      studentId: 'all', // Общая история для всех
      subject: 'Кыргыз тили',
      homeworkTitle: 'Сочинение "Менин мектебим"',
      grade: 4.5,
      status: 'checked',
      date: DateTime.now().subtract(Duration(days: 2)),
      comment: 'Отличная работа!',
    ),
    StudentHistoryModel(
      id: 'history_2',
      studentId: 'all',
      subject: 'Математика',
      homeworkTitle: 'Задачи на умножение',
      grade: 4.2,
      status: 'checked',
      date: DateTime.now().subtract(Duration(days: 3)),
      comment: 'Хорошо, но есть ошибки',
    ),
    StudentHistoryModel(
      id: 'history_3',
      studentId: 'all',
      subject: 'Русский язык',
      homeworkTitle: 'Диктант по теме "Весна"',
      grade: 4.8,
      status: 'checked',
      date: DateTime.now().subtract(Duration(days: 5)),
      comment: 'Превосходно!',
    ),
    StudentHistoryModel(
      id: 'history_4',
      studentId: 'all',
      subject: 'Кыргыз тили',
      homeworkTitle: 'Выучить стихотворение',
      grade: 4.0,
      status: 'checked',
      date: DateTime.now().subtract(Duration(days: 7)),
    ),
    StudentHistoryModel(
      id: 'history_5',
      studentId: 'all',
      subject: 'Математика',
      homeworkTitle: 'Примеры на деление',
      grade: 4.3,
      status: 'pending',
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  static final List<WeeklyPerformance> _weeklyPerformance = [
    WeeklyPerformance(
      week: 'Неделя 1',
      averageGrade: 4.2,
      homeworksCompleted: 8,
      totalHomeworks: 10,
    ),
    WeeklyPerformance(
      week: 'Неделя 2',
      averageGrade: 4.5,
      homeworksCompleted: 9,
      totalHomeworks: 10,
    ),
    WeeklyPerformance(
      week: 'Неделя 3',
      averageGrade: 4.1,
      homeworksCompleted: 7,
      totalHomeworks: 10,
    ),
    WeeklyPerformance(
      week: 'Неделя 4',
      averageGrade: 4.6,
      homeworksCompleted: 10,
      totalHomeworks: 10,
    ),
  ];

// Методы для получения истории
  Future<List<StudentHistoryModel>> getStudentHistory(String studentId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _commonHistory; // Возвращаем общую историю для всех
  }

  Future<List<WeeklyPerformance>> getWeeklyPerformance(String studentId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _weeklyPerformance;
  }

  static final List<ClassModel> _classes = [
    ClassModel(
      id: 'class_1',
      name: '4А класс',
      grade: 4,
      letter: 'А',
      studentCount: 20,
      averagePerformance: 4.2,
      students: _mockStudents4A,
      teacherId: 'teacher_1',
    ),
    ClassModel(
      id: 'class_2',
      name: '4Б класс',
      grade: 4,
      letter: 'Б',
      studentCount: 19,
      averagePerformance: 4.4,
      students: _mockStudents4B,
      teacherId: 'teacher_1',
    ),
  ];

  static final List<StudentModel> _mockStudents4A = [
    StudentModel(
      id: 'student_1',
      firstName: 'Айжан',
      lastName: 'Токтосунова',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.5, '2': 4.2, '3': 4.8, '4': 4.0},
    ),
    StudentModel(
      id: 'student_2',
      firstName: 'Бекзат',
      lastName: 'Мамбетов',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.1, '2': 4.3, '3': 4.0, '4': 4.2},
    ),
    StudentModel(
      id: 'student_3',
      firstName: 'Венера',
      lastName: 'Асанова',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.6, '2': 4.4, '3': 4.7, '4': 4.5},
    ),
    StudentModel(
      id: 'student_4',
      firstName: 'Данияр',
      lastName: 'Жумабеков',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 3.9, '2': 4.1, '3': 3.8, '4': 4.0},
    ),
    StudentModel(
      id: 'student_5',
      firstName: 'Эльмира',
      lastName: 'Кадырова',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.3, '2': 4.5, '3': 4.2, '4': 4.4},
    ),
    StudentModel(
      id: 'student_6',
      firstName: 'Жаныбек',
      lastName: 'Сыдыков',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.2, '2': 4.0, '3': 4.3, '4': 4.1},
    ),
    StudentModel(
      id: 'student_7',
      firstName: 'Зарина',
      lastName: 'Омурова',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.7, '2': 4.5, '3': 4.8, '4': 4.6},
    ),
    StudentModel(
      id: 'student_8',
      firstName: 'Кылычбек',
      lastName: 'Турдубаев',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.0, '2': 4.2, '3': 3.9, '4': 4.1},
    ),
    StudentModel(
      id: 'student_9',
      firstName: 'Лейла',
      lastName: 'Абдрахманова',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.4, '2': 4.2, '3': 4.5, '4': 4.3},
    ),
    StudentModel(
      id: 'student_10',
      firstName: 'Мирлан',
      lastName: 'Эсенбеков',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.1, '2': 4.3, '3': 4.0, '4': 4.2},
    ),
    StudentModel(
      id: 'student_11',
      firstName: 'Нурай',
      lastName: 'Касымова',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.5, '2': 4.7, '3': 4.4, '4': 4.6},
    ),
    StudentModel(
      id: 'student_12',
      firstName: 'Омурбек',
      lastName: 'Алымбеков',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 3.8, '2': 4.0, '3': 3.9, '4': 3.7},
    ),
    StudentModel(
      id: 'student_13',
      firstName: 'Роза',
      lastName: 'Абдыкеримова',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.2, '2': 4.4, '3': 4.1, '4': 4.3},
    ),
    StudentModel(
      id: 'student_14',
      firstName: 'Султан',
      lastName: 'Исаков',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.0, '2': 4.1, '3': 4.2, '4': 3.9},
    ),
    StudentModel(
      id: 'student_15',
      firstName: 'Тамара',
      lastName: 'Жолдошева',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.3, '2': 4.1, '3': 4.4, '4': 4.2},
    ),
    StudentModel(
      id: 'student_16',
      firstName: 'Улан',
      lastName: 'Бекболотов',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 3.9, '2': 4.0, '3': 3.8, '4': 4.1},
    ),
    StudentModel(
      id: 'student_17',
      firstName: 'Чолпон',
      lastName: 'Айтматова',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.8, '2': 4.6, '3': 4.9, '4': 4.7},
    ),
    StudentModel(
      id: 'student_18',
      firstName: 'Эркин',
      lastName: 'Молдобаев',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.1, '2': 4.2, '3': 4.0, '4': 4.3},
    ),
    StudentModel(
      id: 'student_19',
      firstName: 'Жибек',
      lastName: 'Сатыбалдиева',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.4, '2': 4.3, '3': 4.5, '4': 4.2},
    ),
    StudentModel(
      id: 'student_20',
      firstName: 'Кубат',
      lastName: 'Жунушов',
      classId: 'class_1',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.0, '2': 3.9, '3': 4.1, '4': 3.8},
    ),
  ];

  static final List<StudentModel> _mockStudents4B = [
    StudentModel(
      id: 'student_4b_1',
      firstName: 'Айжан',
      lastName: 'Токтосунова',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.5, '2': 4.2, '3': 4.8, '4': 4.0},
    ),
    StudentModel(
      id: 'student_4b_2',
      firstName: 'Бекзат',
      lastName: 'Мамбетов',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.1, '2': 4.3, '3': 4.0, '4': 4.2},
    ),
    StudentModel(
      id: 'student_4b_3',
      firstName: 'Венера',
      lastName: 'Асанова',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.6, '2': 4.4, '3': 4.7, '4': 4.5},
    ),
    StudentModel(
      id: 'student_4b_4',
      firstName: 'Данияр',
      lastName: 'Жумабеков',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 3.9, '2': 4.1, '3': 3.8, '4': 4.0},
    ),
    StudentModel(
      id: 'student_4b_5',
      firstName: 'Эльмира',
      lastName: 'Кадырова',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.3, '2': 4.5, '3': 4.2, '4': 4.4},
    ),
    StudentModel(
      id: 'student_4b_6',
      firstName: 'Жаныбек',
      lastName: 'Сыдыков',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.2, '2': 4.0, '3': 4.3, '4': 4.1},
    ),
    StudentModel(
      id: 'student_4b_7',
      firstName: 'Зарина',
      lastName: 'Омурова',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.7, '2': 4.5, '3': 4.8, '4': 4.6},
    ),
    StudentModel(
      id: 'student_4b_8',
      firstName: 'Кылычбек',
      lastName: 'Турдубаев',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.0, '2': 4.2, '3': 3.9, '4': 4.1},
    ),
    StudentModel(
      id: 'student_4b_9',
      firstName: 'Лейла',
      lastName: 'Абдрахманова',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.4, '2': 4.2, '3': 4.5, '4': 4.3},
    ),
    StudentModel(
      id: 'student_4b_10',
      firstName: 'Мирлан',
      lastName: 'Эсенбеков',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.1, '2': 4.3, '3': 4.0, '4': 4.2},
    ),
    StudentModel(
      id: 'student_4b_11',
      firstName: 'Нурай',
      lastName: 'Касымова',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.5, '2': 4.7, '3': 4.4, '4': 4.6},
    ),
    StudentModel(
      id: 'student_4b_12',
      firstName: 'Омурбек',
      lastName: 'Алымбеков',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 3.8, '2': 4.0, '3': 3.9, '4': 3.7},
    ),
    StudentModel(
      id: 'student_4b_13',
      firstName: 'Роза',
      lastName: 'Абдыкеримова',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.2, '2': 4.4, '3': 4.1, '4': 4.3},
    ),
    StudentModel(
      id: 'student_4b_14',
      firstName: 'Султан',
      lastName: 'Исаков',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.0, '2': 4.1, '3': 4.2, '4': 3.9},
    ),
    StudentModel(
      id: 'student_4b_15',
      firstName: 'Тамара',
      lastName: 'Жолдошева',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.3, '2': 4.1, '3': 4.4, '4': 4.2},
    ),
    StudentModel(
      id: 'student_4b_16',
      firstName: 'Улан',
      lastName: 'Бекболотов',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 3.9, '2': 4.0, '3': 3.8, '4': 4.1},
    ),
    StudentModel(
      id: 'student_4b_17',
      firstName: 'Чолпон',
      lastName: 'Айтматова',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.8, '2': 4.6, '3': 4.9, '4': 4.7},
    ),
    StudentModel(
      id: 'student_4b_18',
      firstName: 'Эркин',
      lastName: 'Молдобаев',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.1, '2': 4.2, '3': 4.0, '4': 4.3},
    ),
    StudentModel(
      id: 'student_4b_19',
      firstName: 'Жибек',
      lastName: 'Сатыбалдиева',
      classId: 'class_2',
      subjects: ['1', '2', '3', '4'],
      averageGrades: {'1': 4.4, '2': 4.3, '3': 4.5, '4': 4.2},
    ),
  ];


  // Методы-заглушки вместо БД операций
  Future<List<ClassModel>> getClasses() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _classes;
  }

  Future<List<StudentModel>> getStudentsByClass(String classId) async {
    await Future.delayed(Duration(milliseconds: 200));

    if (classId == 'class_1') {
      return _mockStudents4A;
    } else if (classId == 'class_2') {
      return _mockStudents4B;
    }

    return [];
  }

  Future<ClassModel?> getClassById(String classId) async {
    await Future.delayed(Duration(milliseconds: 100));

    try {
      return _classes.firstWhere((c) => c.id == classId);
    } catch (e) {
      return null;
    }
  }


  Future<DashboardStats> getDashboardStats() async {
    await Future.delayed(Duration(milliseconds: 150));
    return DashboardStats(
      totalStudents: 20,
      totalClasses: 1,
      homeworksChecked: 89,
      testsGenerated: 23,
    );
  }
}
