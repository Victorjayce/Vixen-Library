import 'package:flutter/material.dart';
import 'dbservice.dart';

class Book {
  final int id;
  final String title;
  final int author;
  int available;
  int rented = 0;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.available,
    this.rented = 0,
  });
}

class ActivityItem {
  final String name;
  final String subtitle;
  final DateTime timestamp;
  final ActivityEnum activityenum;

  ActivityItem({
    required this.name,
    required this.subtitle,
    required this.timestamp,
    required this.activityenum,
  });
}

enum ActivityEnum {
  newBook(Icons.auto_stories_rounded, 'New book added'),
  bookReturned(Icons.restart_alt_rounded, 'Book returned'),
  userRegistered(Icons.person_add_alt_rounded, 'User registered'),
  authorAdded(Icons.person_add_alt_rounded, 'Author added'),
  userDeleted(Icons.person_remove_alt_1_rounded, 'User deleted'),
  authorDeleted(Icons.person_remove_alt_1_rounded, 'Author deleted'),
  newPieces(Icons.my_library_add_rounded, 'New pieces added'),
  bookDeleted(Icons.delete_outline, 'Book deleted'),
  authorEdited(Icons.edit, 'Author edited'),
  userEdited(Icons.edit, 'User edited'),
  bookRented(Icons.bookmark_added, 'Book Rented');

  final IconData icon;
  final String title;
  const ActivityEnum(this.icon, this.title);
}

class User {
  final int id;
  String name;

  User({required this.id, required this.name});
}

class Rental {
  final int id;
  final int bookid;
  final int userid;
  int quantity;

  Rental({
    required this.id,
    required this.bookid,
    required this.userid,
    required this.quantity,
  });
}

class Author {
  final int id;
  String name;

  Author({required this.id, required this.name});
}

class AuthorDetailArgs {
  final int authorId;

  AuthorDetailArgs({required this.authorId});
}

class UserDetailsArgs {
  final List<int> rentalsId;
  final String userName;
  UserDetailsArgs({required this.rentalsId, required this.userName});
}

class Library extends ChangeNotifier {
  final db = DbService.instance;
  late List<Book> _books;

  late List<Author> _authors;

  late List<User> _users;

  late List<Rental> _rented;

  late List<ActivityItem> _activities;

  Future<void> loadData() async {
    _books = await db.loadBook();
    _activities = await db.loadActivity();
    _authors = await db.loadAuthor();
    _rented = await db.loadRental();
    _users = await db.loadUser();
  }

  bool isLoading = false;
  bool hasMore = true;
  Future<void> loadMoreActivites() async {
    if (isLoading || !hasMore) {
      return;
    }
    isLoading = true;
    final more = await db.loadActivity(
      limit: 50,
      offset: recentActivities.length,
    );
    if (more.isEmpty) {
      hasMore = false;
    } else {
      _activities.addAll(more);
    }
    isLoading = false;
    notifyListeners();
  }

  int get totalBooks => _books.length;
  int get totalAuthors => _authors.length;
  int get totalUsers => _users.length;
  int get totalRented =>
      _rented.fold(0, (total, rental) => total + rental.quantity);
  int get totalCopies =>
      _books.fold(0, (total, book) => total + book.available);
  List<Book> get books => List.unmodifiable(_books);
  List<User> get users => List.unmodifiable(_users);
  List<Rental> get rentals => List.unmodifiable(_rented);
  List<Author> get authors => List.unmodifiable(_authors);
  List<String> get authorNames =>
      _authors.map((author) => author.name).toList();
  List<String> get bookNames => _books.map((book) => book.title).toList();
  List<String> get userNames => _users.map((u) => u.name).toList();
  List<Book> get rented => List.unmodifiable(_books.where((b) => b.rented > 0));
  List<ActivityItem> get recentActivities => List.unmodifiable(_activities);

  void addActivity(
    ActivityEnum activityEnum,
    DateTime timestamp,
    String name,
    String subtitle,
  ) {
    final activity = ActivityItem(
      name: name,
      subtitle: subtitle,
      timestamp: timestamp,
      activityenum: activityEnum,
    );
    _activities.add(activity);
    db.addActivity(activity);
    notifyListeners();
  }

  bool addBook(String title, int author, int quantity) {
    if (_books.any((b) => b.title.toLowerCase() == title.toLowerCase())) {
      return false;
    }
    final newBook = Book(
      id: _books.length + 1,
      title: title,
      author: author,
      available: quantity,
    );
    _books.add(newBook);
    addActivity(
      ActivityEnum.newBook,
      DateTime.now(),
      title,
      '$quantity pcs was added to library',
    );
    db.addBook(newBook);
    notifyListeners();
    return true;
  }

  bool addUser(String name) {
    if (_users.any((u) => u.name.toLowerCase() == name.toLowerCase())) {
      return false;
    }

    final newUser = User(id: _users.length + 1, name: name);
    _users.add(newUser);
    addActivity(
      ActivityEnum.userRegistered,
      DateTime.now(),
      name,
      'joined the library',
    );
    db.addUser(newUser);
    notifyListeners();
    return true;
  }

  bool updateUser(int id, String newname) {
    if (_users.any((u) => u.name.toLowerCase() == newname.toLowerCase())) {
      return false;
    }
    final user = _users.firstWhere((u) => u.id == id);
    String oldname = user.name;
    user.name = newname;
    addActivity(
      ActivityEnum.userEdited,
      DateTime.now(),
      newname,
      'Changed from $oldname',
    );
    db.updateUser(user);
    notifyListeners();
    return true;
  }

  void addMore(int id, int quantity) {
    final book = _books.firstWhere(
      (b) => b.id == id,
      orElse: () => throw StateError('Book not found'),
    );

    book.available += quantity;
    addActivity(
      ActivityEnum.newPieces,
      DateTime.now(),
      book.title,
      '$quantity pieces added',
    );
    db.updateBook(book);
    notifyListeners();
  }

  List<Book> authorBooks(List<int> ids) {
    return _books.where((book) => ids.contains(book.id)).toList();
  }

  void rentBook(int bookId, int amount, int userId) {
    if (_books.isEmpty) {
      return;
    }

    final book = _books.firstWhere(
      (b) => b.id == bookId,
      orElse: () => throw StateError('Book not found'),
    );
    final user = _users.firstWhere((u) => u.id == userId);

    if (book.available >= amount) {
      book.available -= amount;
      book.rented += amount;
      final newrental = Rental(
        id: _rented.length + 1,
        bookid: bookId,
        userid: userId,
        quantity: amount,
      );
      _rented.add(newrental);
      addActivity(
        ActivityEnum.bookRented,
        DateTime.now(),
        book.title,
        'by ${user.name}',
      );
      db.addRental(newrental, book);
      notifyListeners();
    }
  }

  void returnBook(int rentId, int amount) {
    if (rented.isEmpty || _rented.isEmpty) return;
    final rental = _rented.firstWhere((r) => r.id == rentId);
    final book = _books.firstWhere(
      (b) => b.id == rental.bookid,
      orElse: () => throw StateError('Book not found'),
    );
    final user = _users.firstWhere((u) => u.id == rental.userid);
    if (book.rented >= amount && rental.quantity >= amount) {
      book.rented -= amount;
      book.available += amount;
      if (amount == rental.quantity) {
        _rented.remove(rental);
      } else {
        rental.quantity -= amount;
      }
      addActivity(
        ActivityEnum.bookReturned,
        DateTime.now(),
        book.title,
        'by ${user.name}',
      );
      db.deleteRental(rental, book);
      notifyListeners();
    }
  }

  bool addAuthor(String name) {
    if (_authors.any((a) => a.name.toLowerCase() == name.toLowerCase())) {
      return false;
    }
    final newAuthor = Author(id: _authors.length + 1, name: name);
    _authors.add(newAuthor);
    addActivity(
      ActivityEnum.authorAdded,
      DateTime.now(),
      name,
      'Author logged to library',
    );
    db.addAuthor(newAuthor);
    notifyListeners();
    return true;
  }

  bool editAuthor(String oldname, int id, String newname) {
    if (!_authors.any((a) => a.name == oldname) ||
        _authors.any((a) => a.name == newname)) {
      return false;
    }
    final author = _authors.firstWhere((a) => a.id == id);
    author.name = newname;
    addActivity(
      ActivityEnum.authorEdited,
      DateTime.now(),
      author.name,
      'from $oldname',
    );
    notifyListeners();
    db.updateAuthor(author);
    return true;
  }

  bool editUser(String oldname, int id, String newname) {
    if (!_users.any((a) => a.name == oldname) ||
        _users.any((a) => a.name == newname)) {
      return false;
    }
    final user = _users.firstWhere((a) => a.id == id);
    user.name = newname;
    addActivity(
      ActivityEnum.userEdited,
      DateTime.now(),
      user.name,
      'from $oldname',
    );
    db.updateUser(user);
    notifyListeners();
    return true;
  }

  bool deleteAuthor(int id) {
    final author = _authors.firstWhere((a) => a.id == id);
    final authorbooks = books.where((a) => a.author == author.id).toList();
    if (authorbooks.isNotEmpty) return false;
    _authors.remove(author);
    addActivity(
      ActivityEnum.authorDeleted,
      DateTime.now(),
      author.name,
      'Deleted from library logs',
    );
    notifyListeners();
    db.deleteAuthor(author.id);
    return true;
  }

  bool deleteUser(int id) {
    final user = _users.firstWhere((a) => a.id == id);
    final userentals = rentals.where((a) => a.userid == user.id).toList();
    if (userentals.isNotEmpty) return false;
    _users.remove(user);
    addActivity(
      ActivityEnum.userDeleted,
      DateTime.now(),
      user.name,
      'left the library',
    );
    notifyListeners();
    db.deleteUser(user.id);
    return true;
  }

  void deleteBook(int id) {
    final book = _books.firstWhere((a) => a.id == id);
    _books.remove(book);
    addActivity(
      ActivityEnum.bookDeleted,
      DateTime.now(),
      book.title,
      'was deleted from the library',
    );
    notifyListeners();
    db.deleteBook(book.id);
  }

  Author getauthor(int id) {
    return _authors.firstWhere((a) => a.id == id);
  }

  Book getbook(int id) {
    return _books.firstWhere((a) => a.id == id);
  }

  User getuser(int id) {
    return _users.firstWhere((u) => u.id == id);
  }

  Rental getrental(int id) {
    return _rented.firstWhere((r) => r.id == id);
  }
}

final library = Library();

class LibraryProvider extends InheritedNotifier<Library> {
  const LibraryProvider({
    super.key,
    required Library library,
    required super.child,
  }) : super(notifier: library);

  static Library of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<LibraryProvider>();
    assert(provider != null, 'No LibraryProvider found in context.');
    return provider!.notifier!;
  }
}
