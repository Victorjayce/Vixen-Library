import 'package:flutter/material.dart';

class Book {
  final int id;
  final String title;
  final String author;
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

class StatItem {
  final int id;
  int value;
  final String tag;

  StatItem({required this.id, required this.value, required this.tag});
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
  final List<int> rentId;

  User({required this.id, required this.name, required this.rentId});
}

class Rental {
  final int id;
  final int bookid;
  final int userid;
  final int quantity;

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
  final List<int> booksId;

  Author({required this.id, required this.name, required this.booksId});
}

class AuthorDetailArgs {
  final List<int> booksId;
  final int authorId;

  AuthorDetailArgs({required this.booksId, required this.authorId});
}

class UserDetailsArgs {
  final List<int> rentalsId;
  final String userName;
  UserDetailsArgs({required this.rentalsId, required this.userName});
}

class Library extends ChangeNotifier {
  final List<Book> _books = [
    Book(
      id: 1,
      title: 'The Hobbit',
      author: 'J.R.R. Tolkien',
      available: 5,
      rented: 3,
    ),
    Book(
      id: 2,
      title: '1984',
      author: 'George Orwell',
      available: 5,
      rented: 3,
    ),
    Book(
      id: 3,
      title: 'Dune',
      author: 'Frank Herbert',
      available: 5,
      rented: 3,
    ),
    Book(id: 4, title: 'Subtle Art', author: 'Victor Jayc3', available: 5),
    Book(id: 5, title: 'Crucial Convo', author: 'Victor Jayc3', available: 5),
    Book(
      id: 6,
      title: 'The Hobbit2',
      author: 'J.R.R. Tolkien',
      available: 5,
      rented: 3,
    ),
    Book(id: 7, title: '1985', author: 'George Orwell', available: 5),
    Book(
      id: 8,
      title: 'Shadow Master',
      author: 'Guity Three',
      available: 20,
      rented: 2,
    ),
    Book(
      id: 9,
      title: 'Shadow Slave',
      author: 'Guity Three',
      available: 20,
      rented: 1,
    ),
    Book(
      id: 10,
      title: 'Sunless',
      author: 'Guity Three',
      available: 20,
      rented: 3,
    ),
    Book(
      id: 11,
      title: 'Flaming Sun',
      author: 'Guity Three',
      available: 20,
      rented: 90,
    ),
    Book(
      id: 12,
      title: 'Wraiths',
      author: 'Guity Three',
      available: 20,
      rented: 90,
    ),
    Book(
      id: 13,
      title: 'LOTM',
      author: 'Cuttlefish',
      available: 39,
      rented: 34,
    ),
    Book(
      id: 14,
      title: 'Kill the Sun',
      author: 'Prince Esper',
      available: 29,
      rented: 4,
    ),
    Book(
      id: 15,
      title: 'Mother of Learning',
      author: 'Novada Rain',
      available: 79,
      rented: 23,
    ),
    Book(
      id: 16,
      title: 'Young Master',
      author: 'Master Yeung',
      available: 28,
      rented: 5,
    ),
    Book(
      id: 17,
      title: 'City of Gold',
      author: 'Guity Three',
      available: 20,
      rented: 90,
    ),
    Book(id: 18, title: 'COI', author: 'Cuttlefish', available: 39, rented: 5),
    Book(
      id: 19,
      title: 'Nick the Specter',
      author: 'Prince Esper',
      available: 29,
      rented: 2,
    ),
    Book(
      id: 20,
      title: 'Home Magus',
      author: 'Novada Rain',
      available: 79,
      rented: 3,
    ),
    Book(
      id: 21,
      title: 'Young Master\'s POV',
      author: 'Master Yeung',
      available: 28,
      rented: 5,
    ),
    Book(
      id: 22,
      title: 'Great Old Ones',
      author: 'Cuttlefish',
      available: 39,
      rented: 34,
    ),
    Book(
      id: 23,
      title: 'The Fool',
      author: 'Cuttlefish',
      available: 39,
      rented: 34,
    ),
    Book(
      id: 24,
      title: 'Gehrman the Sparrow',
      author: 'Cuttlefish',
      available: 39,
      rented: 34,
    ),
    Book(
      id: 25,
      title: 'The Outer Lords',
      author: 'Prince Esper',
      available: 29,
      rented: 1,
    ),
  ];

  final List<Author> _authors = [
    Author(id: 1, name: 'J.R.R. Tolkien', booksId: [1, 6]),
    Author(id: 2, name: 'George Orwell', booksId: [2, 7]),
    Author(id: 3, name: 'Victor Jayc3', booksId: [4, 5]),
    Author(id: 4, name: 'Frank Herbert', booksId: [3]),
    Author(id: 5, name: 'Guilty Three', booksId: [8, 9, 10, 11, 12, 17]),
    Author(id: 6, name: 'Cuttlefish', booksId: [13, 18, 22, 23, 24]),
    Author(id: 7, name: 'Prince Esper', booksId: [14, 19, 25]),
    Author(id: 8, name: 'Novada Rain', booksId: [15, 20]),
    Author(id: 9, name: 'Master Yeung', booksId: [16, 21]),
    Author(id: 10, name: 'Harry Simpson', booksId: []),
  ];

  final List<User> _users = [
    User(id: 1, name: 'Victor Mart', rentId: [1, 2, 3]),
    User(id: 2, name: 'Jerry Miah', rentId: [9, 7, 8]),
    User(id: 3, name: 'Merl Ancah', rentId: [4, 5, 6]),
  ];

  final List<Rental> _rented = [
    Rental(id: 1, bookid: 20, userid: 1, quantity: 3),
    Rental(id: 2, bookid: 7, userid: 1, quantity: 1),
    Rental(id: 3, bookid: 14, userid: 1, quantity: 4),
    Rental(id: 4, bookid: 18, userid: 3, quantity: 5),
    Rental(id: 5, bookid: 19, userid: 3, quantity: 2),
    Rental(id: 6, bookid: 25, userid: 3, quantity: 1),
    Rental(id: 7, bookid: 8, userid: 2, quantity: 2),
    Rental(id: 8, bookid: 9, userid: 2, quantity: 1),
    Rental(id: 9, bookid: 10, userid: 2, quantity: 3),
  ];

  final List<ActivityItem> activities = [
    ActivityItem(
      name: 'The Hobbit',
      subtitle: ' • 20 pcs was added to library',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      activityenum: ActivityEnum.newBook,
    ),
    ActivityItem(
      name: 'Atomic Habits',
      subtitle: ' • by Victor Mart',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      activityenum: ActivityEnum.bookRented,
    ),
    ActivityItem(
      name: 'Amina',
      subtitle: ' • joined the library',
      timestamp: DateTime.now(),
      activityenum: ActivityEnum.userRegistered,
    ),
  ];
  final List<StatItem> stats = [
    StatItem(id: 1, value: 0, tag: 'Books'),
    StatItem(id: 2, value: 0, tag: 'Authors'),
    StatItem(id: 3, value: 0, tag: 'Users'),
    StatItem(id: 4, value: 0, tag: 'Rented'),
  ];
  void setStat(int id) {
    final statitem = stats.firstWhere((s) => s.id == id);
    statitem.value = books.length;
    switch (statitem.id) {
      case 1:
        statitem.value = books.length;
        break;
      case 2:
        statitem.value = authors.length;
        break;
      case 3:
        statitem.value = users.length;
        break;
      case 4:
        statitem.value = rentals.fold(
          0,
          (total, rental) => total + rental.quantity,
        );
      default:
    }
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
  List<ActivityItem> get recentActivities =>
      List.unmodifiable(activities.reversed.toList());
  List<StatItem> get statsList => List.unmodifiable(stats);

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
    activities.add(activity);
    notifyListeners();
  }

  bool addBook(String title, String author, int quantity) {
    if (_books.any((b) => b.title.toLowerCase() == title.toLowerCase())) {
      return false;
    }
    final newBook = Book(
      id: _books.length + 1,
      title: title,
      author: author,
      available: quantity,
    );

    final abook = _authors.firstWhere(
      (a) => a.name.toLowerCase() == author.toLowerCase(),
      orElse: () => throw StateError('Author not found'),
    );

    abook.booksId.add(newBook.id);
    _books.add(newBook);
    addActivity(
      ActivityEnum.newBook,
      DateTime.now(),
      title,
      '$quantity pcs was added to library',
    );
    notifyListeners();
    return true;
  }

  bool addUser(String name) {
    if (_users.any((u) => u.name.toLowerCase() == name.toLowerCase())) {
      return false;
    }

    final newUser = User(id: _users.length + 1, name: name, rentId: []);
    _users.add(newUser);
    addActivity(
      ActivityEnum.userRegistered,
      DateTime.now(),
      name,
      'joined the library',
    );
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
    notifyListeners();
  }

  List<Book> authorBooks(List<int> ids) {
    return _books.where((book) => ids.contains(book.id)).toList();
  }

  List<Rental> userRentals(List<int> ids) {
    return _rented.where((r) => ids.contains(r.id)).toList();
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
      user.rentId.add(newrental.id);
      addActivity(
        ActivityEnum.bookRented,
        DateTime.now(),
        book.title,
        'by ${user.name}',
      );
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
      _rented.remove(rental);
      user.rentId.remove(rentId);
      addActivity(
        ActivityEnum.bookReturned,
        DateTime.now(),
        book.title,
        'by ${user.name}',
      );
      notifyListeners();
    }
  }

  bool addAuthor(String name, List<int> booksId) {
    if (_authors.any((a) => a.name.toLowerCase() == name.toLowerCase())) {
      return false;
    }
    final newAuthor = Author(
      id: _authors.length + 1,
      name: name,
      booksId: booksId,
    );
    _authors.add(newAuthor);
    addActivity(
      ActivityEnum.authorAdded,
      DateTime.now(),
      name,
      'Author logged to library',
    );
    notifyListeners();
    return true;
  }

  // bool updateAuthor(int id, String newname) {
  //   if (_authors.any((a) => a.name.toLowerCase() == newname.toLowerCase())) {
  //     return false;
  //   }
  //   final author = _authors.firstWhere((a) => a.id == id);
  //   String oldname = author.name;
  //   author.name = newname;
  //   addActivity(ActivityEnum.authorEdited, DateTime.now(), author.name, 'from $oldname');
  //   notifyListeners();
  //   return true;
  // }

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
    notifyListeners();
    return true;
  }

  bool deleteAuthor(int id) {
    final author = _authors.firstWhere((a) => a.id == id);
    if (author.booksId.isNotEmpty) return false;
    _authors.remove(author);
    addActivity(
      ActivityEnum.authorDeleted,
      DateTime.now(),
      author.name,
      'Deleted from library logs',
    );
    notifyListeners();
    return true;
  }

  bool deleteUser(int id) {
    final user = _users.firstWhere((a) => a.id == id);
    if (user.rentId.isNotEmpty) return false;
    _users.remove(user);
    addActivity(
      ActivityEnum.userDeleted,
      DateTime.now(),
      user.name,
      'left the library',
    );
    notifyListeners();
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
