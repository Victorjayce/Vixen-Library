import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'lib.dart';

class Dbservice {
  static final Dbservice instance = Dbservice._constructor();
  Dbservice._constructor();

  Future<Database> initDb() async {
    final dbDirPath = await getDatabasesPath();
    final dbPath = join(dbDirPath, 'vixen.db');
    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE User(
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
)
''');

        await db.execute('''
CREATE TABLE Authors(
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
)
''');
        await db.execute('''
CREATE TABLE Books(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  author INTEGER NOT NULL,
  available INTEGER NOT NULL,
  rented INTEGER NOT NULL DEFAULT 0
  FOREIGN KEY(author) REFERENCES Author(id)
)
''');

        await db.execute('''
CREATE TABLE Rentals(
  id INTEGER PRIMARY KEY,
  bookId INTEGER NOT NULL,
  userId INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  FOREIGN KEY(bookId) REFERENCES Books(id),
  FOREIGN KEY(userId) REFERENCES Users(id)
)
''');

        await db.execute('''
CREATE TABLE Activities(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  subtitle TEXT NOT NULL,
  timestamp TEXT NOT NULL,
  activityEnum INTEGER NOT NULL
)
''');
      },
    );
    return db;
  }

  static Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  void addBook(Book book) async {
    final db = await database;
    await db.insert('Books', {
      'id': book.id,
      'title': book.title,
      'author': book.author,
      'available': book.available,
      'rented': book.rented,
    });
  }

  void updateBook(Book book) async {
    final db = await database;
    await db.update(
      'Books',
      {
        'title': book.title,
        'author': book.author,
        'available': book.available,
        'rented': book.rented,
      },
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  void deleteBook(int id) async {
    final db = await database;
    await db.delete('Books', where: 'id = ?', whereArgs: [id]);
  }

  void addAuthor(Author author) async {
    final db = await database;
    await db.insert('Authors', {'id': author.id, 'name': author.name});
  }

  void updateAuthor(Author author) async {
    final db = await database;
    await db.update(
      'Authors',
      {'name': author.name},
      where: 'id = ?',
      whereArgs: [author.id],
    );
  }

  void deleteAuthor(int id) async {
    final db = await database;
    await db.delete('Authors', where: 'id = ?', whereArgs: [id]);
  }

  void addUser(User user) async {
    final db = await database;
    await db.insert('Users', {'id': user.id, 'name': user.name});
  }

  void updateUser(User user) async {
    final db = await database;
    await db.update(
      'Users',
      {'name': user.name},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  void deleteUser(int id) async {
    final db = await database;
    await db.delete('Users', where: 'id = ?', whereArgs: [id]);
  }

  void addRental(Rental rental, Book book) async {
    final db = await database;
    await db.transaction((tx) async {
      await tx.insert('Rentals', {
        'id': rental.id,
        'bookId': rental.bookid,
        'userId': rental.userid,
        'quantity': rental.quantity,
      });
      await tx.update(
        'Books',
        {
          'available': book.available - rental.quantity,
          'rented': book.rented + rental.quantity,
        },
        where: 'id = ?',
        whereArgs: [book.id],
      );
    });
  }

  void deleteRental(Rental rental, Book book) async {
    final db = await database;
    await db.transaction((tx) async {
      await tx.delete('Rentals', where: 'id = ?', whereArgs: [rental.id]);
      await tx.update(
        'Books',
        {
          'available': book.available + rental.quantity,
          'rented': book.rented - rental.quantity,
        },
        where: 'id = ?',
        whereArgs: [book.id],
      );
    });
  }

  void addActivity(ActivityItem activity) async {
    final db = await database;
    await db.insert('Activities', {
      'name': activity.name,
      'subtitle': activity.subtitle,
      'timestamp': activity.timestamp.toIso8601String(),
      'activityEnum': activity.activityenum.index,
    });
  }

  Future<List<Book>> loadBook() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Books');

    final books = maps
        .map(
          (e) => Book(
            id: e['id'],
            title: e['title'],
            author: e['author'],
            available: e['available'],
            rented: e['rented'],
          ),
        )
        .toList();
    return books;
  }

  Future<List<Author>> loadAuthor() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Authors');

    final authors = maps
        .map(
          (e) => Author(
            id: e['id'],
            name: e['name'],
            booksId: [], // Populate separately if needed
          ),
        )
        .toList();
    return authors;
  }

  Future<List<User>> loadUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Users');

    final users = maps
        .map(
          (e) => User(
            id: e['id'],
            name: e['name'],
            rentId: [], // Populate separately if needed
          ),
        )
        .toList();
    return users;
  }

  Future<List<Rental>> loadRental() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Rentals');

    final rentals = maps
        .map(
          (e) => Rental(
            id: e['id'],
            bookid: e['bookId'],
            userid: e['userId'],
            quantity: e['quantity'],
          ),
        )
        .toList();
    return rentals;
  }

  Future<List<ActivityItem>> loadActivity() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Activities');

    final activities = maps
        .map(
          (e) => ActivityItem(
            name: e['name'],
            subtitle: e['subtitle'],
            timestamp: DateTime.parse(e['timestamp']),
            activityenum: ActivityEnum.values[e['activityEnum']],
          ),
        )
        .toList();
    return activities;
  }
}
