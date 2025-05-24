import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/class_model.dart';
import '../models/student_model.dart';
import '../models/teacher_model.dart';
import '../models/subject_model.dart';
import '../models/student_grade_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mugalim.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Создаем таблицу школ
    await db.execute('''
      CREATE TABLE schools (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        number TEXT NOT NULL,
        address TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Создаем таблицу учителей
    await db.execute('''
      CREATE TABLE teachers (
        id TEXT PRIMARY KEY,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        school_id TEXT NOT NULL,
        is_admin INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (school_id) REFERENCES schools (id)
      )
    ''');

    // Создаем таблицу предметов
    await db.execute('''
      CREATE TABLE subjects (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        name_ky TEXT NOT NULL,
        name_ru TEXT NOT NULL,
        name_en TEXT NOT NULL,
        type TEXT NOT NULL,
        color_value INTEGER NOT NULL
      )
    ''');

    // Создаем таблицу классов
    await db.execute('''
      CREATE TABLE classes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        grade INTEGER NOT NULL,
        letter TEXT NOT NULL,
        school_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (school_id) REFERENCES schools (id)
      )
    ''');

    // Создаем таблицу учеников
    await db.execute('''
      CREATE TABLE students (
        id TEXT PRIMARY KEY,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        class_id TEXT NOT NULL,
        birth_date TEXT,
        photo_url TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (class_id) REFERENCES classes (id)
      )
    ''');

    // Создаем таблицу связи учитель-класс
    await db.execute('''
      CREATE TABLE teacher_classes (
        teacher_id TEXT NOT NULL,
        class_id TEXT NOT NULL,
        PRIMARY KEY (teacher_id, class_id),
        FOREIGN KEY (teacher_id) REFERENCES teachers (id),
        FOREIGN KEY (class_id) REFERENCES classes (id)
      )
    ''');

    // Создаем таблицу связи учитель-предмет
    await db.execute('''
      CREATE TABLE teacher_subjects (
        teacher_id TEXT NOT NULL,
        subject_id TEXT NOT NULL,
        PRIMARY KEY (teacher_id, subject_id),
        FOREIGN KEY (teacher_id) REFERENCES teachers (id),
        FOREIGN KEY (subject_id) REFERENCES subjects (id)
      )
    ''');

    // Создаем таблицу оценок
    await db.execute('''
      CREATE TABLE student_grades (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        subject_id TEXT NOT NULL,
        grade REAL NOT NULL,
        comment TEXT,
        teacher_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students (id),
        FOREIGN KEY (subject_id) REFERENCES subjects (id),
        FOREIGN KEY (teacher_id) REFERENCES teachers (id)
      )
    ''');

    // Заполняем начальными данными
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Добавляем школу
    await db.insert('schools', {
      'id': 'school_1',
      'name': 'Школа-гимназия №1',
      'number': '01',
      'address': 'г. Бишкек, ул. Советская 1',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Добавляем предметы
    final subjects = SubjectModel.defaultSubjects;
    for (final subject in subjects) {
      await db.insert('subjects', {
        'id': subject.id,
        'name': subject.name,
        'name_ky': subject.nameKy,
        'name_ru': subject.nameRu,
        'name_en': subject.nameEn,
        'type': subject.type.name,
        'color_value': subject.color.value,
      });
    }

    // Добавляем учителя (админа)
    await db.insert('teachers', {
      'id': 'teacher_1',
      'first_name': 'Айбек',
      'last_name': 'Сыдыков',
      'email': 'aibek@school01.kg',
      'school_id': 'school_1',
      'is_admin': 1,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Добавляем классы
    final classes = [
      {'id': 'class_1', 'name': '4 А', 'grade': 4, 'letter': 'А'},
      {'id': 'class_2', 'name': '4 Б', 'grade': 4, 'letter': 'Б'},
      {'id': 'class_3', 'name': '4 В', 'grade': 4, 'letter': 'В'},
      {'id': 'class_4', 'name': '4 Г', 'grade': 4, 'letter': 'Г'},
      {'id': 'class_5', 'name': '4 Д', 'grade': 4, 'letter': 'Д'},

      {'id': 'class_6', 'name': '5 А', 'grade': 5, 'letter': 'А'},
      {'id': 'class_7', 'name': '5 Б', 'grade': 5, 'letter': 'Б'},
      {'id': 'class_8', 'name': '5 В', 'grade': 5, 'letter': 'В'},
      {'id': 'class_9', 'name': '5 Г', 'grade': 5, 'letter': 'Г'},
      {'id': 'class_10', 'name': '5 Д', 'grade': 5, 'letter': 'Д'},

      {'id': 'class_11', 'name': '3 А', 'grade': 3, 'letter': 'А'},
      {'id': 'class_12', 'name': '3 Б', 'grade': 3, 'letter': 'Б'},
      {'id': 'class_13', 'name': '3 В', 'grade': 3, 'letter': 'В'},
      {'id': 'class_14', 'name': '3 Г', 'grade': 3, 'letter': 'Г'},
      {'id': 'class_15', 'name': '3 Д', 'grade': 3, 'letter': 'Д'},

    ];

    for (final classData in classes) {
      await db.insert('classes', {
        ...classData,
        'school_id': 'school_1',
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // Связываем учителя с классами
    for (final classData in classes) {
      await db.insert('teacher_classes', {
        'teacher_id': 'teacher_1',
        'class_id': classData['id'],
      });
    }

    // Связываем учителя с предметами
    for (final subject in subjects) {
      await db.insert('teacher_subjects', {
        'teacher_id': 'teacher_1',
        'subject_id': subject.id,
      });
    }

    // Добавляем учеников
    final students = [
      // 4 А класс
      {'first_name': 'Айжан', 'last_name': 'Касымова', 'class_id': 'class_1'},
      {'first_name': 'Бекзат', 'last_name': 'Жумабеков', 'class_id': 'class_1'},
      {'first_name': 'Гульмира', 'last_name': 'Токтогулова', 'class_id': 'class_1'},
      {'first_name': 'Данияр', 'last_name': 'Абдыкеримов', 'class_id': 'class_1'},
      {'first_name': 'Эльмира', 'last_name': 'Сатыбалдиева', 'class_id': 'class_1'},
      {'first_name': 'Нурлан', 'last_name': 'Осмонов', 'class_id': 'class_1'},
      {'first_name': 'Айбек', 'last_name': 'Мамытов', 'class_id': 'class_1'},
      {'first_name': 'Жазгул', 'last_name': 'Кубанычбекова', 'class_id': 'class_1'},
      {'first_name': 'Эрлан', 'last_name': 'Турдуев', 'class_id': 'class_1'},
      {'first_name': 'Айгерим', 'last_name': 'Исмаилова', 'class_id': 'class_1'},
      {'first_name': 'Талгат', 'last_name': 'Сулайманов', 'class_id': 'class_1'},
      {'first_name': 'Гүлнара', 'last_name': 'Абдрахманова', 'class_id': 'class_1'},
      {'first_name': 'Мирлан', 'last_name': 'Кожомкулов', 'class_id': 'class_1'},
      {'first_name': 'Айнура', 'last_name': 'Молдокматова', 'class_id': 'class_1'},
      {'first_name': 'Кубаныч', 'last_name': 'Таштанов', 'class_id': 'class_1'},
      {'first_name': 'Зарина', 'last_name': 'Абдылдаева', 'class_id': 'class_1'},
      {'first_name': 'Алмаз', 'last_name': 'Бекбоев', 'class_id': 'class_1'},
      {'first_name': 'Сабина', 'last_name': 'Муратова', 'class_id': 'class_1'},
      {'first_name': 'Улан', 'last_name': 'Сыдыков', 'class_id': 'class_1'},
      {'first_name': 'Чолпон', 'last_name': 'Айдарова', 'class_id': 'class_1'},
      {'first_name': 'Эмил', 'last_name': 'Жолдошов', 'class_id': 'class_1'},
      {'first_name': 'Айдана', 'last_name': 'Карыбаева', 'class_id': 'class_1'},
      {'first_name': 'Темирлан', 'last_name': 'Нурматов', 'class_id': 'class_1'},
      {'first_name': 'Каныкей', 'last_name': 'Эсеналиева', 'class_id': 'class_1'},
      {'first_name': 'Бакыт', 'last_name': 'Турусбеков', 'class_id': 'class_1'},

      // 4 Б класс
      {'first_name': 'Жаныбек', 'last_name': 'Мамытов', 'class_id': 'class_2'},
      {'first_name': 'Зарина', 'last_name': 'Алымбекова', 'class_id': 'class_2'},
      {'first_name': 'Ибрагим', 'last_name': 'Усенов', 'class_id': 'class_2'},
      {'first_name': 'Камила', 'last_name': 'Турдубекова', 'class_id': 'class_2'},
      {'first_name': 'Максат', 'last_name': 'Эсенбеков', 'class_id': 'class_2'},
      {'first_name': 'Айзат', 'last_name': 'Кубатова', 'class_id': 'class_2'},
      {'first_name': 'Тимур', 'last_name': 'Сагындыков', 'class_id': 'class_2'},
      {'first_name': 'Гүлжан', 'last_name': 'Осмоналиева', 'class_id': 'class_2'},
      {'first_name': 'Элдияр', 'last_name': 'Байгазиев', 'class_id': 'class_2'},
      {'first_name': 'Алина', 'last_name': 'Жакшылыкова', 'class_id': 'class_2'},
      {'first_name': 'Нурсултан', 'last_name': 'Токтосунов', 'class_id': 'class_2'},
      {'first_name': 'Айпери', 'last_name': 'Мусакеева', 'class_id': 'class_2'},
      {'first_name': 'Кубат', 'last_name': 'Абдыразаков', 'class_id': 'class_2'},
      {'first_name': 'Сайкал', 'last_name': 'Таштанова', 'class_id': 'class_2'},
      {'first_name': 'Бектур', 'last_name': 'Курманалиев', 'class_id': 'class_2'},
      {'first_name': 'Медина', 'last_name': 'Сабырова', 'class_id': 'class_2'},
      {'first_name': 'Эрбол', 'last_name': 'Жумалиев', 'class_id': 'class_2'},
      {'first_name': 'Айсулуу', 'last_name': 'Бекболотова', 'class_id': 'class_2'},
      {'first_name': 'Талант', 'last_name': 'Исаев', 'class_id': 'class_2'},
      {'first_name': 'Нуриса', 'last_name': 'Абдыкадырова', 'class_id': 'class_2'},
      {'first_name': 'Алтынбек', 'last_name': 'Шамшиев', 'class_id': 'class_2'},
      {'first_name': 'Жибек', 'last_name': 'Кенжебаева', 'class_id': 'class_2'},
      {'first_name': 'Азамат', 'last_name': 'Турдалиев', 'class_id': 'class_2'},
      {'first_name': 'Айым', 'last_name': 'Сатыбалдиева', 'class_id': 'class_2'},
      {'first_name': 'Нурбек', 'last_name': 'Абылов', 'class_id': 'class_2'},
      {'first_name': 'Гүлзат', 'last_name': 'Молдалиева', 'class_id': 'class_2'},
      {'first_name': 'Эржан', 'last_name': 'Калыков', 'class_id': 'class_2'},

      // 4 В класс
      {'first_name': 'Нурбек', 'last_name': 'Алымов', 'class_id': 'class_3'},
      {'first_name': 'Олеся', 'last_name': 'Петрова', 'class_id': 'class_3'},
      {'first_name': 'Руслан', 'last_name': 'Исаков', 'class_id': 'class_3'},
      {'first_name': 'Сабина', 'last_name': 'Жолдошева', 'class_id': 'class_3'},
      {'first_name': 'Тимур', 'last_name': 'Кадыров', 'class_id': 'class_3'},
      {'first_name': 'Айдар', 'last_name': 'Байзаков', 'class_id': 'class_3'},
      {'first_name': 'Баян', 'last_name': 'Султанова', 'class_id': 'class_3'},
      {'first_name': 'Динара', 'last_name': 'Абдраимова', 'class_id': 'class_3'},
      {'first_name': 'Евгения', 'last_name': 'Иванова', 'class_id': 'class_3'},
      {'first_name': 'Жениш', 'last_name': 'Тюлеев', 'class_id': 'class_3'},
      {'first_name': 'Кенже', 'last_name': 'Мамбетова', 'class_id': 'class_3'},
      {'first_name': 'Лейла', 'last_name': 'Керимова', 'class_id': 'class_3'},
      {'first_name': 'Мирбек', 'last_name': 'Садыков', 'class_id': 'class_3'},
      {'first_name': 'Назгуль', 'last_name': 'Абдыкаримова', 'class_id': 'class_3'},
      {'first_name': 'Орозбек', 'last_name': 'Токтогул', 'class_id': 'class_3'},
      {'first_name': 'Раиса', 'last_name': 'Ахмедова', 'class_id': 'class_3'},
      {'first_name': 'Салават', 'last_name': 'Жумагулов', 'class_id': 'class_3'},
      {'first_name': 'Таалай', 'last_name': 'Бектурсунов', 'class_id': 'class_3'},
      {'first_name': 'Урмат', 'last_name': 'Калыков', 'class_id': 'class_3'},
      {'first_name': 'Фатима', 'last_name': 'Мирзоева', 'class_id': 'class_3'},
      {'first_name': 'Ханзада', 'last_name': 'Сарымсакова', 'class_id': 'class_3'},
      {'first_name': 'Чынгыз', 'last_name': 'Абдылдаев', 'class_id': 'class_3'},
      {'first_name': 'Эркин', 'last_name': 'Жаныбеков', 'class_id': 'class_3'},

      // 4 Г класс
      {'first_name': 'Улан', 'last_name': 'Бакиров', 'class_id': 'class_4'},
      {'first_name': 'Фатима', 'last_name': 'Осмонова', 'class_id': 'class_4'},
      {'first_name': 'Хасан', 'last_name': 'Турсунов', 'class_id': 'class_4'},
      {'first_name': 'Чолпон', 'last_name': 'Асанова', 'class_id': 'class_4'},
      {'first_name': 'Эркин', 'last_name': 'Мурзабеков', 'class_id': 'class_4'},
      {'first_name': 'Айгуль', 'last_name': 'Токтобаева', 'class_id': 'class_4'},
      {'first_name': 'Бекбол', 'last_name': 'Сагынбаев', 'class_id': 'class_4'},
      {'first_name': 'Гүлзар', 'last_name': 'Кубанычбекова', 'class_id': 'class_4'},
      {'first_name': 'Дамир', 'last_name': 'Абдылдаев', 'class_id': 'class_4'},
      {'first_name': 'Элина', 'last_name': 'Жумабекова', 'class_id': 'class_4'},
      {'first_name': 'Жаркын', 'last_name': 'Таштанов', 'class_id': 'class_4'},
      {'first_name': 'Кымбат', 'last_name': 'Сатыбалдиева', 'class_id': 'class_4'},
      {'first_name': 'Марат', 'last_name': 'Кожомкулов', 'class_id': 'class_4'},
      {'first_name': 'Нуржан', 'last_name': 'Абдраимова', 'class_id': 'class_4'},
      {'first_name': 'Омурбек', 'last_name': 'Исаев', 'class_id': 'class_4'},
      {'first_name': 'Перизат', 'last_name': 'Мамытова', 'class_id': 'class_4'},
      {'first_name': 'Рустам', 'last_name': 'Сулайманов', 'class_id': 'class_4'},
      {'first_name': 'Сайра', 'last_name': 'Бекболотова', 'class_id': 'class_4'},
      {'first_name': 'Талгат', 'last_name': 'Калыков', 'class_id': 'class_4'},
      {'first_name': 'Умут', 'last_name': 'Айдарова', 'class_id': 'class_4'},
      {'first_name': 'Ырыс', 'last_name': 'Турдалиева', 'class_id': 'class_4'},
      {'first_name': 'Азамат', 'last_name': 'Жолдошов', 'class_id': 'class_4'},
      {'first_name': 'Бегимай', 'last_name': 'Каримова', 'class_id': 'class_4'},
      {'first_name': 'Даниял', 'last_name': 'Токтосунов', 'class_id': 'class_4'},
      {'first_name': 'Жамиля', 'last_name': 'Мусакеева', 'class_id': 'class_4'},
      {'first_name': 'Кубан', 'last_name': 'Абылов', 'class_id': 'class_4'},

      // 4 Д класс
      {'first_name': 'Айбек', 'last_name': 'Жумагулов', 'class_id': 'class_5'},
      {'first_name': 'Баяман', 'last_name': 'Турсунбаев', 'class_id': 'class_5'},
      {'first_name': 'Гульназ', 'last_name': 'Абдылдаева', 'class_id': 'class_5'},
      {'first_name': 'Дилбар', 'last_name': 'Калыков', 'class_id': 'class_5'},
      {'first_name': 'Эсен', 'last_name': 'Мамбетов', 'class_id': 'class_5'},
      {'first_name': 'Жибек', 'last_name': 'Сарыбаева', 'class_id': 'class_5'},
      {'first_name': 'Канат', 'last_name': 'Токтогул', 'class_id': 'class_5'},
      {'first_name': 'Лейман', 'last_name': 'Абдыразаков', 'class_id': 'class_5'},
      {'first_name': 'Мурат', 'last_name': 'Байзаков', 'class_id': 'class_5'},
      {'first_name': 'Насып', 'last_name': 'Жолдошев', 'class_id': 'class_5'},
      {'first_name': 'Омурзак', 'last_name': 'Кубатбеков', 'class_id': 'class_5'},
      {'first_name': 'Раушан', 'last_name': 'Ибраимова', 'class_id': 'class_5'},
      {'first_name': 'Салтанат', 'last_name': 'Таштанова', 'class_id': 'class_5'},
      {'first_name': 'Тилек', 'last_name': 'Асанбаев', 'class_id': 'class_5'},
      {'first_name': 'Урматбек', 'last_name': 'Сулайманов', 'class_id': 'class_5'},
      {'first_name': 'Фарида', 'last_name': 'Жаныбекова', 'class_id': 'class_5'},
      {'first_name': 'Халима', 'last_name': 'Мирзабекова', 'class_id': 'class_5'},
      {'first_name': 'Чынара', 'last_name': 'Абдрасулова', 'class_id': 'class_5'},
      {'first_name': 'Эрке', 'last_name': 'Токтосунов', 'class_id': 'class_5'},
      {'first_name': 'Айжол', 'last_name': 'Керимов', 'class_id': 'class_5'},
      {'first_name': 'Бекназар', 'last_name': 'Алыбаев', 'class_id': 'class_5'},
      {'first_name': 'Гүлмира', 'last_name': 'Садыкова', 'class_id': 'class_5'},
      {'first_name': 'Данияр', 'last_name': 'Жумаев', 'class_id': 'class_5'},
      {'first_name': 'Елдос', 'last_name': 'Турдалиев', 'class_id': 'class_5'},
      {'first_name': 'Жаныш', 'last_name': 'Кожоев', 'class_id': 'class_5'},
      {'first_name': 'Кенеш', 'last_name': 'Мусабеков', 'class_id': 'class_5'},
      {'first_name': 'Мээрим', 'last_name': 'Абдылдаева', 'class_id': 'class_5'},

      // 5 А класс
      {'first_name': 'Азиз', 'last_name': 'Бекболотов', 'class_id': 'class_6'},
      {'first_name': 'Бишкек', 'last_name': 'Токтобаев', 'class_id': 'class_6'},
      {'first_name': 'Гульсара', 'last_name': 'Жумабаева', 'class_id': 'class_6'},
      {'first_name': 'Дархан', 'last_name': 'Абдыкаров', 'class_id': 'class_6'},
      {'first_name': 'Эрлан', 'last_name': 'Сатыбалдиев', 'class_id': 'class_6'},
      {'first_name': 'Жылдыз', 'last_name': 'Кубанычбекова', 'class_id': 'class_6'},
      {'first_name': 'Калыс', 'last_name': 'Таштанов', 'class_id': 'class_6'},
      {'first_name': 'Майрам', 'last_name': 'Абдраимова', 'class_id': 'class_6'},
      {'first_name': 'Нурдин', 'last_name': 'Исаев', 'class_id': 'class_6'},
      {'first_name': 'Олжобай', 'last_name': 'Мамытов', 'class_id': 'class_6'},
      {'first_name': 'Райхан', 'last_name': 'Жолдошова', 'class_id': 'class_6'},
      {'first_name': 'Сагын', 'last_name': 'Турсунов', 'class_id': 'class_6'},
      {'first_name': 'Тамара', 'last_name': 'Абдылдаева', 'class_id': 'class_6'},
      {'first_name': 'Улукбек', 'last_name': 'Кадыров', 'class_id': 'class_6'},
      {'first_name': 'Фирuza', 'last_name': 'Бектурсунова', 'class_id': 'class_6'},
      {'first_name': 'Хадича', 'last_name': 'Жаныбекова', 'class_id': 'class_6'},
      {'first_name': 'Чолпонбай', 'last_name': 'Асанбаев', 'class_id': 'class_6'},
      {'first_name': 'Эсенгул', 'last_name': 'Сулайманов', 'class_id': 'class_6'},
      {'first_name': 'Айдарбек', 'last_name': 'Мирзабеков', 'class_id': 'class_6'},
      {'first_name': 'Бактыбек', 'last_name': 'Абдыразаков', 'class_id': 'class_6'},
      {'first_name': 'Гульшат', 'last_name': 'Токтогулова', 'class_id': 'class_6'},
      {'first_name': 'Дөөлөт', 'last_name': 'Жумаев', 'class_id': 'class_6'},
      {'first_name': 'Еркин', 'last_name': 'Кубатбеков', 'class_id': 'class_6'},
      {'first_name': 'Жумакан', 'last_name': 'Ибраимова', 'class_id': 'class_6'},
      {'first_name': 'Күмүш', 'last_name': 'Абдылдаева', 'class_id': 'class_6'},

      // 5 Б класс
      {'first_name': 'Айгиз', 'last_name': 'Таштанов', 'class_id': 'class_7'},
      {'first_name': 'Бекжан', 'last_name': 'Жумабаев', 'class_id': 'class_7'},
      {'first_name': 'Гүлбарчын', 'last_name': 'Абдыкаров', 'class_id': 'class_7'},
      {'first_name': 'Дүйшөн', 'last_name': 'Сатыбалдиев', 'class_id': 'class_7'},
      {'first_name': 'Эрнис', 'last_name': 'Кубанычбекова', 'class_id': 'class_7'},
      {'first_name': 'Жанара', 'last_name': 'Токтогул', 'class_id': 'class_7'},
      {'first_name': 'Кайрат', 'last_name': 'Абдраимова', 'class_id': 'class_7'},
      {'first_name': 'Медер', 'last_name': 'Исаев', 'class_id': 'class_7'},
      {'first_name': 'Нургазы', 'last_name': 'Мамытов', 'class_id': 'class_7'},
      {'first_name': 'Орозай', 'last_name': 'Жолдошова', 'class_id': 'class_7'},
      {'first_name': 'Рахат', 'last_name': 'Турсунов', 'class_id': 'class_7'},
      {'first_name': 'Саламат', 'last_name': 'Абдылдаева', 'class_id': 'class_7'},
      {'first_name': 'Төлөмүш', 'last_name': 'Кадыров', 'class_id': 'class_7'},
      {'first_name': 'Убайд', 'last_name': 'Бектурсунова', 'class_id': 'class_7'},
      {'first_name': 'Фархат', 'last_name': 'Жаныбекова', 'class_id': 'class_7'},
      {'first_name': 'Хусан', 'last_name': 'Асанбаев', 'class_id': 'class_7'},
      {'first_name': 'Чыңгыз', 'last_name': 'Сулайманов', 'class_id': 'class_7'},
      {'first_name': 'Эрнияз', 'last_name': 'Мирзабеков', 'class_id': 'class_7'},
      {'first_name': 'Айчүрөк', 'last_name': 'Абдыразаков', 'class_id': 'class_7'},
      {'first_name': 'Баяли', 'last_name': 'Токтогулова', 'class_id': 'class_7'},
      {'first_name': 'Гүлзада', 'last_name': 'Жумаев', 'class_id': 'class_7'},
      {'first_name': 'Дания', 'last_name': 'Кубатбеков', 'class_id': 'class_7'},
      {'first_name': 'Елизавета', 'last_name': 'Ибраимова', 'class_id': 'class_7'},
      {'first_name': 'Жолборс', 'last_name': 'Абдылдаева', 'class_id': 'class_7'},
      {'first_name': 'Казыбек', 'last_name': 'Таштанов', 'class_id': 'class_7'},
      {'first_name': 'Максуд', 'last_name': 'Жумабаев', 'class_id': 'class_7'},
      {'first_name': 'Нуркыз', 'last_name': 'Абдыкаров', 'class_id': 'class_7'},
      {'first_name': 'Омурат', 'last_name': 'Сатыбалдиев', 'class_id': 'class_7'},

      // 5 В класс
      {'first_name': 'Айдархан', 'last_name': 'Кубанычбекова', 'class_id': 'class_8'},
      {'first_name': 'Бекмырза', 'last_name': 'Токтогул', 'class_id': 'class_8'},
      {'first_name': 'Гүлден', 'last_name': 'Абдраимова', 'class_id': 'class_8'},
      {'first_name': 'Даниялбек', 'last_name': 'Исаев', 'class_id': 'class_8'},
      {'first_name': 'Эрден', 'last_name': 'Мамытов', 'class_id': 'class_8'},
      {'first_name': 'Жанболот', 'last_name': 'Жолдошова', 'class_id': 'class_8'},
      {'first_name': 'Каныбек', 'last_name': 'Турсунов', 'class_id': 'class_8'},
      {'first_name': 'Мирза', 'last_name': 'Абдылдаева', 'class_id': 'class_8'},
      {'first_name': 'Нурланбек', 'last_name': 'Кадыров', 'class_id': 'class_8'},
      {'first_name': 'Омуркан', 'last_name': 'Бектурсунова', 'class_id': 'class_8'},
      {'first_name': 'Роза', 'last_name': 'Жаныбекова', 'class_id': 'class_8'},
      {'first_name': 'Сабыр', 'last_name': 'Асанбаев', 'class_id': 'class_8'},
      {'first_name': 'Талас', 'last_name': 'Сулайманов', 'class_id': 'class_8'},
      {'first_name': 'Улугбек', 'last_name': 'Мирзабеков', 'class_id': 'class_8'},
      {'first_name': 'Фатимажан', 'last_name': 'Абдыразаков', 'class_id': 'class_8'},
      {'first_name': 'Хайрулло', 'last_name': 'Токтогулова', 'class_id': 'class_8'},
      {'first_name': 'Чоро', 'last_name': 'Жумаев', 'class_id': 'class_8'},
      {'first_name': 'Элдар', 'last_name': 'Кубатбеков', 'class_id': 'class_8'},
      {'first_name': 'Айгүл', 'last_name': 'Ибраимова', 'class_id': 'class_8'},
      {'first_name': 'Бектемир', 'last_name': 'Абдылдаева', 'class_id': 'class_8'},
      {'first_name': 'Гүлнур', 'last_name': 'Таштанов', 'class_id': 'class_8'},
      {'first_name': 'Дастан', 'last_name': 'Жумабаев', 'class_id': 'class_8'},
      {'first_name': 'Еркебек', 'last_name': 'Абдыкаров', 'class_id': 'class_8'},
      {'first_name': 'Жуматай', 'last_name': 'Сатыбалдиев', 'class_id': 'class_8'},

      // 5 Г класс
      {'first_name': 'Айнур', 'last_name': 'Кубанычбекова', 'class_id': 'class_9'},
      {'first_name': 'Бекзод', 'last_name': 'Токтогул', 'class_id': 'class_9'},
      {'first_name': 'Гүлсарай', 'last_name': 'Абдраимова', 'class_id': 'class_9'},
      {'first_name': 'Дилбархан', 'last_name': 'Исаев', 'class_id': 'class_9'},
      {'first_name': 'Эрланбек', 'last_name': 'Мамытов', 'class_id': 'class_9'},
      {'first_name': 'Жаныл', 'last_name': 'Жолдошова', 'class_id': 'class_9'},
      {'first_name': 'Кубанычбек', 'last_name': 'Турсунов', 'class_id': 'class_9'},
      {'first_name': 'Майрамбек', 'last_name': 'Абдылдаева', 'class_id': 'class_9'},
      {'first_name': 'Нуркемал', 'last_name': 'Кадыров', 'class_id': 'class_9'},
      {'first_name': 'Омурбек', 'last_name': 'Бектурсунова', 'class_id': 'class_9'},
      {'first_name': 'Рыскул', 'last_name': 'Жаныбекова', 'class_id': 'class_9'},
      {'first_name': 'Салима', 'last_name': 'Асанбаев', 'class_id': 'class_9'},
      {'first_name': 'Тажик', 'last_name': 'Сулайманов', 'class_id': 'class_9'},
      {'first_name': 'Урматали', 'last_name': 'Мирзабеков', 'class_id': 'class_9'},
      {'first_name': 'Фатимажан', 'last_name': 'Абдыразаков', 'class_id': 'class_9'},
      {'first_name': 'Халил', 'last_name': 'Токтогулова', 'class_id': 'class_9'},
      {'first_name': 'Чыңгызбек', 'last_name': 'Жумаев', 'class_id': 'class_9'},
      {'first_name': 'Эржигит', 'last_name': 'Кубатбеков', 'class_id': 'class_9'},
      {'first_name': 'Айперис', 'last_name': 'Ибраимова', 'class_id': 'class_9'},
      {'first_name': 'Бакытжан', 'last_name': 'Абдылдаева', 'class_id': 'class_9'},
      {'first_name': 'Гүлшайыр', 'last_name': 'Таштанов', 'class_id': 'class_9'},
      {'first_name': 'Дүйшөнбай', 'last_name': 'Жумабаев', 'class_id': 'class_9'},
      {'first_name': 'Ерланбек', 'last_name': 'Абдыкаров', 'class_id': 'class_9'},
      {'first_name': 'Жалал', 'last_name': 'Сатыбалдиев', 'class_id': 'class_9'},
      {'first_name': 'Камчы', 'last_name': 'Кубанычбекова', 'class_id': 'class_9'},
      {'first_name': 'Мээримжан', 'last_name': 'Токтогул', 'class_id': 'class_9'},

      // 5 Д класс
      {'first_name': 'Айдаркүл', 'last_name': 'Абдраимова', 'class_id': 'class_10'},
      {'first_name': 'Бекболсун', 'last_name': 'Исаев', 'class_id': 'class_10'},
      {'first_name': 'Гүлзара', 'last_name': 'Мамытов', 'class_id': 'class_10'},
      {'first_name': 'Даниярбек', 'last_name': 'Жолдошова', 'class_id': 'class_10'},
      {'first_name': 'Эркинбек', 'last_name': 'Турсунов', 'class_id': 'class_10'},
      {'first_name': 'Жанат', 'last_name': 'Абдылдаева', 'class_id': 'class_10'},
      {'first_name': 'Калыбек', 'last_name': 'Кадыров', 'class_id': 'class_10'},
      {'first_name': 'Мирбекжан', 'last_name': 'Бектурсунова', 'class_id': 'class_10'},
      {'first_name': 'Нурболот', 'last_name': 'Жаныбекова', 'class_id': 'class_10'},
      {'first_name': 'Омуржан', 'last_name': 'Асанбаев', 'class_id': 'class_10'},
      {'first_name': 'Рахман', 'last_name': 'Сулайманов', 'class_id': 'class_10'},
      {'first_name': 'Салтанатбек', 'last_name': 'Мирзабеков', 'class_id': 'class_10'},
      {'first_name': 'Талантбек', 'last_name': 'Абдыразаков', 'class_id': 'class_10'},
      {'first_name': 'Улукман', 'last_name': 'Токтогулова', 'class_id': 'class_10'},
      {'first_name': 'Фариз', 'last_name': 'Жумаев', 'class_id': 'class_10'},
      {'first_name': 'Хайдар', 'last_name': 'Kубатбеков', 'class_id': 'class_10'},
      {'first_name': 'Чынар', 'last_name': 'Ибраимова', 'class_id': 'class_10'},
      {'first_name': 'Эдил', 'last_name': 'Абдылдаева', 'class_id': 'class_10'},
      {'first_name': 'Айжанат', 'last_name': 'Таштанов', 'class_id': 'class_10'},
      {'first_name': 'Бекмырзабек', 'last_name': 'Жумабаев', 'class_id': 'class_10'},
      {'first_name': 'Гүлмирабек', 'last_name': 'Абдыкаров', 'class_id': 'class_10'},
      {'first_name': 'Дүйшөмбү', 'last_name': 'Сатыбалдиев', 'class_id': 'class_10'},
      {'first_name': 'Еркежан', 'last_name': 'Кубанычбекова', 'class_id': 'class_10'},
      {'first_name': 'Жалын', 'last_name': 'Токтогул', 'class_id': 'class_10'},
      {'first_name': 'Кенжебек', 'last_name': 'Абдраимова', 'class_id': 'class_10'},
      {'first_name': 'Максатбек', 'last_name': 'Исаев', 'class_id': 'class_10'},
      {'first_name': 'Нуржамал', 'last_name': 'Мамытов', 'class_id': 'class_10'},
      {'first_name': 'Омурхан', 'last_name': 'Жолдошова', 'class_id': 'class_10'},
      {'first_name': 'Розабек', 'last_name': 'Турсунов', 'class_id': 'class_10'},
      {'first_name': 'Сайракул', 'last_name': 'Абдылдаева', 'class_id': 'class_10'},

      // 3 А класс
      {'first_name': 'Айгүлсүн', 'last_name': 'Кадыров', 'class_id': 'class_11'},
      {'first_name': 'Бекжол', 'last_name': 'Бектурсунова', 'class_id': 'class_11'},
      {'first_name': 'Гүлнура', 'last_name': 'Жаныбекова', 'class_id': 'class_11'},
      {'first_name': 'Даниярхан', 'last_name': 'Асанбаев', 'class_id': 'class_11'},
      {'first_name': 'Эркебай', 'last_name': 'Сулайманов', 'class_id': 'class_11'},
      {'first_name': 'Жанышбек', 'last_name': 'Мирзабеков', 'class_id': 'class_11'},
      {'first_name': 'Кубатжан', 'last_name': 'Абдыразаков', 'class_id': 'class_11'},
      {'first_name': 'Майрамхан', 'last_name': 'Токтогулова', 'class_id': 'class_11'},
      {'first_name': 'Нурман', 'last_name': 'Жумаев', 'class_id': 'class_11'},
      {'first_name': 'Омурбай', 'last_name': 'Кубатбеков', 'class_id': 'class_11'},
      {'first_name': 'Райымбек', 'last_name': 'Ибраимова', 'class_id': 'class_11'},
      {'first_name': 'Саламбек', 'last_name': 'Абдылдаева', 'class_id': 'class_11'},
      {'first_name': 'Таласбек', 'last_name': 'Таштанов', 'class_id': 'class_11'},
      {'first_name': 'Усуп', 'last_name': 'Жумабаев', 'class_id': 'class_11'},
      {'first_name': 'Фатимажан', 'last_name': 'Абдыкаров', 'class_id': 'class_11'},
      {'first_name': 'Хамза', 'last_name': 'Сатыбалдиев', 'class_id': 'class_11'},
      {'first_name': 'Чынарбек', 'last_name': 'Kубанычбекова', 'class_id': 'class_11'},
      {'first_name': 'Эрланжан', 'last_name': 'Токтогул', 'class_id': 'class_11'},
      {'first_name': 'Айжолду', 'last_name': 'Абдраимова', 'class_id': 'class_11'},
      {'first_name': 'Бекзатбек', 'last_name': 'Исаев', 'class_id': 'class_11'},
      {'first_name': 'Гүлжанат', 'last_name': 'Мамытов', 'class_id': 'class_11'},
      {'first_name': 'Дөөлөтбек', 'last_name': 'Жолдошова', 'class_id': 'class_11'},
      {'first_name': 'Ерболат', 'last_name': 'Турсунов', 'class_id': 'class_11'},

      // 3 Б класс
      {'first_name': 'Айгеримжан', 'last_name': 'Абдылдаева', 'class_id': 'class_12'},
      {'first_name': 'Бекмамат', 'last_name': 'Kадыров', 'class_id': 'class_12'},
      {'first_name': 'Гүлсарайым', 'last_name': 'Бектурсунова', 'class_id': 'class_12'},
      {'first_name': 'Даниярбай', 'last_name': 'Жаныбекова', 'class_id': 'class_12'},
      {'first_name': 'Эркинбай', 'last_name': 'Асанбаев', 'class_id': 'class_12'},
      {'first_name': 'Жанатбек', 'last_name': 'Сулайманов', 'class_id': 'class_12'},
      {'first_name': 'Калыбекжан', 'last_name': 'Мирзабеков', 'class_id': 'class_12'},
      {'first_name': 'Мирланбек', 'last_name': 'Абдыразаков', 'class_id': 'class_12'},
      {'first_name': 'Нуржанат', 'last_name': 'Токтогулова', 'class_id': 'class_12'},
      {'first_name': 'Омуржол', 'last_name': 'Жумаев', 'class_id': 'class_12'},
      {'first_name': 'Райымжан', 'last_name': 'Kубатбеков', 'class_id': 'class_12'},
      {'first_name': 'Салтанай', 'last_name': 'Ибраимова', 'class_id': 'class_12'},
      {'first_name': 'Талгатбек', 'last_name': 'Абдылдаева', 'class_id': 'class_12'},
      {'first_name': 'Улукбекжан', 'last_name': 'Таштанов', 'class_id': 'class_12'},
      {'first_name': 'Фатимажол', 'last_name': 'Жумабаев', 'class_id': 'class_12'},
      {'first_name': 'Хайрулла', 'last_name': 'Абдыкаров', 'class_id': 'class_12'},
      {'first_name': 'Чыңгызхан', 'last_name': 'Сатыбалдиев', 'class_id': 'class_12'},
      {'first_name': 'Эрболжан', 'last_name': 'Kубанычбекова', 'class_id': 'class_12'},
      {'first_name': 'Айжанбек', 'last_name': 'Токтогул', 'class_id': 'class_12'},
      {'first_name': 'Бекжолду', 'last_name': 'Абдраимова', 'class_id': 'class_12'},
      {'first_name': 'Гүлшайлоо', 'last_name': 'Исаев', 'class_id': 'class_12'},
      {'first_name': 'Дүйшөнбай', 'last_name': 'Мамытов', 'class_id': 'class_12'},
      {'first_name': 'Еркежол', 'last_name': 'Жолдошова', 'class_id': 'class_12'},
      {'first_name': 'Жанатай', 'last_name': 'Турсунов', 'class_id': 'class_12'},
      {'first_name': 'Кубанычжан', 'last_name': 'Абдылдаева', 'class_id': 'class_12'},
      {'first_name': 'Майрамжан', 'last_name': 'Kадыров', 'class_id': 'class_12'},
      {'first_name': 'Нурбекжан', 'last_name': 'Бектурсунова', 'class_id': 'class_12'},
      {'first_name': 'Омуржайлоо', 'last_name': 'Жаныбекова', 'class_id': 'class_12'},
      {'first_name': 'Рыскелди', 'last_name': 'Асанбаев', 'class_id': 'class_12'},

      // 3 В класс
      {'first_name': 'Айгүлжан', 'last_name': 'Сулайманов', 'class_id': 'class_13'},
      {'first_name': 'Бекболот', 'last_name': 'Мирзабеков', 'class_id': 'class_13'},
      {'first_name': 'Гүлзадажан', 'last_name': 'Абдыразаков', 'class_id': 'class_13'},
      {'first_name': 'Данияржол', 'last_name': 'Токтогулова', 'class_id': 'class_13'},
      {'first_name': 'Эркежанат', 'last_name': 'Жумаев', 'class_id': 'class_13'},
      {'first_name': 'Жанышбай', 'last_name': 'Kубатбеков', 'class_id': 'class_13'},
      {'first_name': 'Калысбек', 'last_name': 'Ибраимова', 'class_id': 'class_13'},
      {'first_name': 'Мирзажан', 'last_name': 'Абдылдаева', 'class_id': 'class_13'},
      {'first_name': 'Нуржайлоо', 'last_name': 'Таштанов', 'class_id': 'class_13'},
      {'first_name': 'Омурбекжан', 'last_name': 'Жумабаев', 'class_id': 'class_13'},
      {'first_name': 'Райханат', 'last_name': 'Абдыкаров', 'class_id': 'class_13'},
      {'first_name': 'Салаватбек', 'last_name': 'Sатыбалдиев', 'class_id': 'class_13'},
      {'first_name': 'Талантжан', 'last_name': 'Kубанычбекова', 'class_id': 'class_13'},
      {'first_name': 'Улукманжан', 'last_name': 'Токтогул', 'class_id': 'class_13'},
      {'first_name': 'Фатимажай', 'last_name': 'Абдраимова', 'class_id': 'class_13'},
      {'first_name': 'Халилжан', 'last_name': 'Исаев', 'class_id': 'class_13'},
      {'first_name': 'Чынаржан', 'last_name': 'Мамытов', 'class_id': 'class_13'},
      {'first_name': 'Эрланбай', 'last_name': 'Жолдошова', 'class_id': 'class_13'},
      {'first_name': 'Айжолдук', 'last_name': 'Турсунов', 'class_id': 'class_13'},
      {'first_name': 'Бекзатжан', 'last_name': 'Абдылдаева', 'class_id': 'class_13'},
      {'first_name': 'Гүлшайыржан', 'last_name': 'Kадыров', 'class_id': 'class_13'},
      {'first_name': 'Дүйшөнжан', 'last_name': 'Бектурсунова', 'class_id': 'class_13'},
      {'first_name': 'Еркежай', 'last_name': 'Жаныбекова', 'class_id': 'class_13'},
      {'first_name': 'Жалалбек', 'last_name': 'Асанбаев', 'class_id': 'class_13'},
      {'first_name': 'Кубанычбай', 'last_name': 'Sулайманов', 'class_id': 'class_13'},
      {'first_name': 'Майрамбекжан', 'last_name': 'Мирзабеков', 'class_id': 'class_13'},
      {'first_name': 'Нуржолду', 'last_name': 'Абдыразаков', 'class_id': 'class_13'},

      // 3 Г класс
      {'first_name': 'Айгүлсүнжан', 'last_name': 'Токтогулова', 'class_id': 'class_14'},
      {'first_name': 'Бекжайлоо', 'last_name': 'Жумаев', 'class_id': 'class_14'},
      {'first_name': 'Гүлзадабек', 'last_name': 'Kубатбеков', 'class_id': 'class_14'},
      {'first_name': 'Данияржай', 'last_name': 'Ибраимова', 'class_id': 'class_14'},
      {'first_name': 'Эркебайжан', 'last_name': 'Абдылдаева', 'class_id': 'class_14'},
      {'first_name': 'Жанышжан', 'last_name': 'Таштанов', 'class_id': 'class_14'},
      {'first_name': 'Калысжай', 'last_name': 'Жумабаев', 'class_id': 'class_14'},
      {'first_name': 'Мирзабекжан', 'last_name': 'Абдыкаров', 'class_id': 'class_14'},
      {'first_name': 'Нуржайжан', 'last_name': 'Sатыбалдиев', 'class_id': 'class_14'},
      {'first_name': 'Омурбекжай', 'last_name': 'Kубанычбекова', 'class_id': 'class_14'},
      {'first_name': 'Райымжай', 'last_name': 'Токтогул', 'class_id': 'class_14'},
      {'first_name': 'Салтанатжан', 'last_name': 'Абдраимова', 'class_id': 'class_14'},
      {'first_name': 'Талантбай', 'last_name': 'Исаев', 'class_id': 'class_14'},
      {'first_name': 'Улукбекжай', 'last_name': 'Mамытов', 'class_id': 'class_14'},
      {'first_name': 'Фатимажолду', 'last_name': 'Жолдошова', 'class_id': 'class_14'},
      {'first_name': 'Халилжай', 'last_name': 'Турсунов', 'class_id': 'class_14'},
      {'first_name': 'Чынарбекжан', 'last_name': 'Абдылдаева', 'class_id': 'class_14'},
      {'first_name': 'Эрланжай', 'last_name': 'Kадыров', 'class_id': 'class_14'},
      {'first_name': 'Айжолбек', 'last_name': 'Бектурсунова', 'class_id': 'class_14'},
      {'first_name': 'Бекзатжай', 'last_name': 'Жаныбекова', 'class_id': 'class_14'},
      {'first_name': 'Gүлшайырбек', 'last_name': 'Асанбаев', 'class_id': 'class_14'},
      {'first_name': 'Дүйшөнбайжан', 'last_name': 'Sулайманов', 'class_id': 'class_14'},
      {'first_name': 'Eркежолду', 'last_name': 'Mирзабеков', 'class_id': 'class_14'},
      {'first_name': 'Жалалжан', 'last_name': 'Aбдыразаков', 'class_id': 'class_14'},
      {'first_name': 'Kубанычжай', 'last_name': 'Токтогулova', 'class_id': 'class_14'},

      // 3 Д класс
      {'first_name': 'Айгүлжайлоо', 'last_name': 'Жумаев', 'class_id': 'class_15'},
      {'first_name': 'Бекжолдук', 'last_name': 'Kубатбеков', 'class_id': 'class_15'},
      {'first_name': 'Gүлзадажай', 'last_name': 'Ибраимова', 'class_id': 'class_15'},
      {'first_name': 'Даниярбекжан', 'last_name': 'Aбдылдаева', 'class_id': 'class_15'},
      {'first_name': 'Эркежайлоо', 'last_name': 'Tаштанов', 'class_id': 'class_15'},
      {'first_name': 'Жанышжай', 'last_name': 'Жумабаев', 'class_id': 'class_15'},
      {'first_name': 'Kалысбекжан', 'last_name': 'Aбдыкаров', 'class_id': 'class_15'},
      {'first_name': 'Mирзажай', 'last_name': 'Sатыбалдиев', 'class_id': 'class_15'},
      {'first_name': 'Nуржайбек', 'last_name': 'Kубанычбекова', 'class_id': 'class_15'},
      {'first_name': 'Oмурбекжол', 'last_name': 'Tоктогул', 'class_id': 'class_15'},
      {'first_name': 'Rайымжол', 'last_name': 'Aбдраимова', 'class_id': 'class_15'},
      {'first_name': 'Sалтанатжай', 'last_name': 'Исаев', 'class_id': 'class_15'},
      {'first_name': 'Tалантжай', 'last_name': 'Mамытов', 'class_id': 'class_15'},
      {'first_name': 'Uлукбекжол', 'last_name': 'Жолдошова', 'class_id': 'class_15'},
      {'first_name': 'Fатимажайлоо', 'last_name': 'Tурсунов', 'class_id': 'class_15'},
      {'first_name': 'Hалилжол', 'last_name': 'Aбдылдаева', 'class_id': 'class_15'},
      {'first_name': 'Чынаржай', 'last_name': 'Kадыров', 'class_id': 'class_15'},
      {'first_name': 'Эрланбекжан', 'last_name': 'Bектурсунова', 'class_id': 'class_15'},
      {'first_name': 'Aйжолжай', 'last_name': 'Жаныбекова', 'class_id': 'class_15'},
      {'first_name': 'Bекзатжол', 'last_name': 'Aсанбаев', 'class_id': 'class_15'},
      {'first_name': 'Gүлшайыржай', 'last_name': 'Sулайманов', 'class_id': 'class_15'},
      {'first_name': 'Dүйшөнжай', 'last_name': 'Mирзабеков', 'class_id': 'class_15'},
      {'first_name': 'Eркежайжан', 'last_name': 'Aбдыразаков', 'class_id': 'class_15'},
      {'first_name': 'Жалалжай', 'last_name': 'Tоктогулова', 'class_id': 'class_15'},
      {'first_name': 'Kубанычбекжан', 'last_name': 'Жумаев', 'class_id': 'class_15'},
      {'first_name': 'Mайрамжай', 'last_name': 'Kубатбеков', 'class_id': 'class_15'},
    ];

    int studentIndex = 1;
    for (final student in students) {
      await db.insert('students', {
        'id': 'student_$studentIndex',
        'first_name': student['first_name'],
        'last_name': student['last_name'],
        'class_id': student['class_id'],
        'created_at': DateTime.now().toIso8601String(),
      });
      studentIndex++;
    }

    // Добавляем случайные оценки для демонстрации
    await _insertRandomGrades(db, subjects);
  }

  Future<void> _insertRandomGrades(Database db, List<SubjectModel> subjects) async {
    final random = [3.0, 3.5, 4.0, 4.5, 5.0];

    for (int studentId = 1; studentId <= 20; studentId++) {
      for (final subject in subjects) {
        // Добавляем 3-5 оценок для каждого ученика по каждому предмету
        final gradeCount = 3 + (studentId % 3);
        for (int i = 0; i < gradeCount; i++) {
          await db.insert('student_grades', {
            'id': 'grade_${studentId}_${subject.id}_$i',
            'student_id': 'student_$studentId',
            'subject_id': subject.id,
            'grade': random[studentId % random.length],
            'teacher_id': 'teacher_1',
            'created_at': DateTime.now().subtract(Duration(days: i * 7)).toIso8601String(),
          });
        }
      }
    }
  }

  // CRUD операции для классов
  Future<List<Map<String, dynamic>>> getClassesByTeacher(String teacherId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT c.*, COUNT(s.id) as student_count
      FROM classes c
      INNER JOIN teacher_classes tc ON c.id = tc.class_id
      LEFT JOIN students s ON c.id = s.class_id
      WHERE tc.teacher_id = ?
      GROUP BY c.id
      ORDER BY c.grade, c.letter
    ''', [teacherId]);
  }

  // CRUD операции для учеников
  Future<List<Map<String, dynamic>>> getStudentsByClass(String classId) async {
    final db = await database;
    return await db.query(
      'students',
      where: 'class_id = ?',
      whereArgs: [classId],
      orderBy: 'first_name, last_name',
    );
  }

  Future<List<Map<String, dynamic>>> searchStudents(String classId, String query) async {
    final db = await database;
    return await db.query(
      'students',
      where: 'class_id = ? AND (first_name LIKE ? OR last_name LIKE ?)',
      whereArgs: [classId, '%$query%', '%$query%'],
      orderBy: 'first_name, last_name',
    );
  }

  // CRUD операции для предметов
  Future<List<Map<String, dynamic>>> getSubjectsByTeacher(String teacherId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT s.*
      FROM subjects s
      INNER JOIN teacher_subjects ts ON s.id = ts.subject_id
      WHERE ts.teacher_id = ?
      ORDER BY s.name
    ''', [teacherId]);
  }

  // CRUD операции для оценок
  Future<List<Map<String, dynamic>>> getStudentGrades(String studentId, String subjectId) async {
    final db = await database;
    return await db.query(
      'student_grades',
      where: 'student_id = ? AND subject_id = ?',
      whereArgs: [studentId, subjectId],
      orderBy: 'created_at DESC',
    );
  }

  Future<double> getStudentAverageGrade(String studentId, String subjectId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT AVG(grade) as average
      FROM student_grades
      WHERE student_id = ? AND subject_id = ?
    ''', [studentId, subjectId]);

    return result.first['average'] as double? ?? 0.0;
  }

  // Админ операции
  Future<void> assignClassToTeacher(String teacherId, String classId) async {
    final db = await database;
    await db.insert('teacher_classes', {
      'teacher_id': teacherId,
      'class_id': classId,
    });
  }

  Future<void> removeClassFromTeacher(String teacherId, String classId) async {
    final db = await database;
    await db.delete(
      'teacher_classes',
      where: 'teacher_id = ? AND class_id = ?',
      whereArgs: [teacherId, classId],
    );
  }

  Future<void> assignSubjectToTeacher(String teacherId, String subjectId) async {
    final db = await database;
    await db.insert('teacher_subjects', {
      'teacher_id': teacherId,
      'subject_id': subjectId,
    });
  }

  Future<void> removeSubjectFromTeacher(String teacherId, String subjectId) async {
    final db = await database;
    await db.delete(
      'teacher_subjects',
      where: 'teacher_id = ? AND subject_id = ?',
      whereArgs: [teacherId, subjectId],
    );
  }
}