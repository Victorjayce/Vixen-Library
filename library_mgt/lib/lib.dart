
class Book {
  final int id;
  final String title;
  final String author;
  int available;
  int borrowed = 0;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.available,
  });

  //@override
  //String toString() => 'ID: $id | Title: $title | Author: $author | Available: $available';
}

class Author{
  final int id;
  final String name;
  final List<int> booksId;
  Author({
    required this.id,
    required this.name,
    required this.booksId,
  });
}

class Library {
  final List<Book> _books = [
  Book(id: 1, title: 'The Hobbit', author: 'J.R.R. Tolkien', available: 5),
  Book(id: 2, title: '1984', author: 'George Orwell', available: 5),
  Book(id: 3, title: 'Dune', author: 'Frank Herbert', available: 5),
  Book(id: 4, title: 'Subtle Art', author: 'Victor Jayc3', available: 5),
  Book(id: 5, title: 'Crucial Convo', author: 'Victor Jayc3', available: 5),
  Book(id: 6, title: 'The Hobbit2', author: 'J.R.R. Tolkien', available: 5),
  Book(id: 7, title: '1985', author: 'George Orwell', available: 5),
  ];

  

  final List<Author> _authors = [
    Author(id: 1, name: 'J.R.R. Tolkien', booksId: [1, 6]),
    Author(id: 2, name: 'George Orwell', booksId: [2, 7]),
    Author(id: 3, name: 'Victor Jayc3', booksId: [4, 5]),
    Author(id: 4, name: 'Frank Herbert', booksId: [3])
  ];

  void addBook(String title, String author, int quantity) {

    final newBook = Book(
      id: _books.length + 1,
      title: title,
      author: author,
      available: quantity,
    );

    _books.add(newBook);
  }

  String borrowBook(int bookId, int amount) {
    if (_books.isEmpty) {
      return 'No Books available';
    }
    var displayMsg = '';
    
    final book = _books.cast<Book?>().firstWhere(
      (b) => b?.id == bookId,
      orElse: () => null,
    );

    if (book != null) {
      if (book.available > amount) {
        book.available -= amount;
        book.borrowed += amount;
      } else {
        
      }
    } else {
      displayMsg = 'Error: Book not found.';
    }
    return displayMsg;
  }


  void addauthor(String name, List<int> booksId) {

    final newauth = Author(
      id: _authors.length = 1,
      name: name,
      booksId: booksId,
    );
    _authors.add(newauth);
  }
}