import 'package:path/path.dart';
import 'package:plan_dial_renewal/models/dial.dart';
import 'package:plan_dial_renewal/models/schedule.dart';
import 'package:plan_dial_renewal/models/week_schedule.dart';
import 'package:sqflite/sqflite.dart';

// TODO 체크리스트 DB 쿼리 작성
class DbManager {
  static const _version = 1;
  static const _dbName = "dialTable.db";

  static final DbManager _instance = DbManager._internal();

  factory DbManager() {
    return _instance;
  }

  DbManager._internal() {
    // TODO 최초 1회 생성자 내용 넣기
  }

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE dial(id INTEGER PRIMARY KEY, name TEXT, startTime TEXT, disabled INTEGER)");
        db.execute(
            "CREATE TABLE schedule(id INTEGER, name TEXT, monday TEXT, tuesday TEXT, wednesday TEXT, thursday TEXT, friday TEXT, saturday TEXT, sunday TEXT)");
        db.execute(
            "CREATE TABLE checklist(id INTEGER, name TEXT, date TEXT, archived INTEGER)");
      },
      version: _version,
    );
  }

  Future<void> clear() async {
    deleteDatabase(join(await getDatabasesPath(), _dbName));
  }

  Future<Map<int, Dial>> loadAllDials() async {
    final result = <int, Dial>{};
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query('dial INNER JOIN schedule ON dial.id = schedule.id');

    for (var map in maps) {
      result[map['id']] = Dial(
        id: map['id'],
        name: map['name'],
        startTime: DateTime.parse(map['startTime']),
        weekSchedule: WeekSchedule(
          monday: Schedule.parse(map['monday']),
          tuesday: Schedule.parse(map['tuesday']),
          wednesday: Schedule.parse(map['wednesday']),
          thursday: Schedule.parse(map['thursday']),
          friday: Schedule.parse(map['friday']),
          saturday: Schedule.parse(map['saturday']),
          sunday: Schedule.parse(map['sunday']),
        ),
        disabled: map['disabled'] == 1,
      );
    }

    return result;
  }

  Future<void> deleteDialByIndex(int index) async {
    final Database db = await _getDatabase();

    await db.delete(
      'dial',
      where: "id = ?",
      whereArgs: [index],
    );

    await db.delete(
      'schedule',
      where: "id = ?",
      whereArgs: [index],
    );

    await db.delete(
      'checklist',
      where: "id = ?",
      whereArgs: [index],
    );
  }

  Future<int> addDial(Dial dial) async {
    final Database db = await _getDatabase();

    int id = await db.insert(
      'dial',
      {
        'name': dial.name,
        'startTime': dial.startTime.toString(),
        'disabled': dial.disabled ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'schedule',
      {
        'id': id,
        'name': dial.name,
        'monday': (dial.weekSchedule.monday ?? "").toString(),
        'tuesday': (dial.weekSchedule.tuesday ?? "").toString(),
        'wednesday': (dial.weekSchedule.wednesday ?? "").toString(),
        'thursday': (dial.weekSchedule.thursday ?? "").toString(),
        'friday': (dial.weekSchedule.friday ?? "").toString(),
        'saturday': (dial.weekSchedule.saturday ?? "").toString(),
        'sunday': (dial.weekSchedule.sunday ?? "").toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<void> updateDial(Dial dial) async {
    final Database db = await _getDatabase();

    await db.update(
      'dial',
      {
        'name': dial.name,
        'startTime': dial.startTime.toString(),
        'disabled': dial.disabled ? 1 : 0,
      },
      where: "id = ?",
      whereArgs: [dial.id],
    );

    await db.update(
      'schedule',
      {
        'id': dial.id,
        'name': dial.name,
        'monday': (dial.weekSchedule.monday ?? "").toString(),
        'tuesday': (dial.weekSchedule.tuesday ?? "").toString(),
        'wednesday': (dial.weekSchedule.wednesday ?? "").toString(),
        'thursday': (dial.weekSchedule.thursday ?? "").toString(),
        'friday': (dial.weekSchedule.friday ?? "").toString(),
        'saturday': (dial.weekSchedule.saturday ?? "").toString(),
        'sunday': (dial.weekSchedule.sunday ?? "").toString(),
      },
      where: "id = ?",
      whereArgs: [dial.id],
    );
  }

  Future<int> getNextId() async {
    final Database db = await _getDatabase();

    List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT MAX(id) FROM dial');

    return (maps[0]['id'] ?? 0) + 1;
  }
}
