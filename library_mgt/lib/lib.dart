import 'package:flutter/widgets.dart';

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

class Author {
  final int id;
  final String name;
  final List<int> booksId;

  Author({required this.id, required this.name, required this.booksId});
}

class AuthorDetailArgs {
  final List<int> booksId;
  final String name;

  AuthorDetailArgs({required this.booksId, required this.name});
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
      rented: 90,
    ),
    Book(
      id: 9,
      title: 'Shadow Slave',
      author: 'Guity Three',
      available: 20,
      rented: 90,
    ),
    Book(
      id: 10,
      title: 'Sunless',
      author: 'Guity Three',
      available: 20,
      rented: 90,
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
      rented: 12,
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
    Book(id: 18, title: 'COI', author: 'Cuttlefish', available: 39, rented: 34),
    Book(
      id: 19,
      title: 'Nick the Specter',
      author: 'Prince Esper',
      available: 29,
      rented: 12,
    ),
    Book(
      id: 20,
      title: 'Home Magus',
      author: 'Novada Rain',
      available: 79,
      rented: 23,
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
      rented: 12,
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

  List<Book> get books => List.unmodifiable(_books);
  List<Author> get authors => List.unmodifiable(_authors);
  List<String> get authorNames =>
      _authors.map((author) => author.name).toList();
  List<String> get bookNames => _books.map((book) => book.title).toList();
  List<Book> get rented => List.unmodifiable(_books.where((b) => b.rented > 0));

  void addBook(String title, String author, int quantity) {
    final newBook = Book(
      id: _books.length + 1,
      title: title,
      author: author,
      available: quantity,
    );

    final abook = _authors.firstWhere(
      (a) => a.name == author,
      orElse: () => throw StateError('Author not found'),
    );

    abook.booksId.add(newBook.id);
    _books.add(newBook);
    notifyListeners();
  }

  void addMore(int id, int quantity) {
    final book = _books.firstWhere(
      (b) => b.id == id,
      orElse: () => throw StateError('Book not found'),
    );

    book.available += quantity;
    notifyListeners();
  }

  List<Book> authorBooks(List<int> ids) {
    return _books.where((book) => ids.contains(book.id)).toList();
  }

  void rentBook(int bookId, int amount) {
    if (_books.isEmpty) {
      return;
    }

    final book = _books.firstWhere(
      (b) => b.id == bookId,
      orElse: () => throw StateError('Book not found'),
    );

    if (book.available >= amount) {
      book.available -= amount;
      book.rented += amount;
      notifyListeners();
    }
  }

  void returnBook(int bookId, int amount) {
    if (rented.isEmpty) return;
    final book = _books.firstWhere(
      (b) => b.id == bookId,
      orElse: () => throw StateError('Book not found'),
    );
    if (book.rented >= amount) {
      book.rented -= amount;
      book.available += amount;
      notifyListeners();
    }
  }

  void addAuthor(String name, List<int> booksId) {
    final newAuthor = Author(
      id: _authors.length + 1,
      name: name,
      booksId: booksId,
    );
    _authors.add(newAuthor);
    notifyListeners();
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
