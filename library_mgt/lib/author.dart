import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'widgets/addauthor.dart';

class AuthorPage extends StatefulWidget {
  const AuthorPage({super.key});
  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.inversePrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(22),
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Authors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: scheme.onPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${library.authors.length} author profiles',
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              tooltip: 'Close',
              icon: const Icon(Icons.close),
              color: scheme.onPrimary,
              iconSize: 24,
              style: IconButton.styleFrom(
                backgroundColor: scheme.surface.withValues(alpha: 0.18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.inversePrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.person_pin_rounded,
                    color: scheme.onPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage authors',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Keep your author directory tidy and ready for new books.',
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _callAddAuthorDialog(context),
                  tooltip: 'Add Author',
                  iconSize: 34,
                  color: scheme.onPrimary,
                  icon: const Icon(Icons.person_add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: library.authors.length,
              itemBuilder: (context, index) {
                final author = library.authors[index];
                final authorbooks = library.books.where(
                  (a) => a.author == author.id,
                );
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(
                      alpha: 0.45,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: scheme.outlineVariant.withValues(alpha: 0.35),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detailscreen',
                        arguments: AuthorDetailArgs(authorId: author.id),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: 'name-${author.name}',
                                transitionOnUserGestures: true,
                                child: Text(
                                  author.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                authorbooks.isNotEmpty
                                    ? '${authorbooks.length.toString()} Books Published'
                                    : 'No Books Published',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final delete = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                if (authorbooks.isNotEmpty) {
                                  return AlertDialog(
                                    icon: const Icon(
                                      Icons.error,
                                      color: Colors.orange,
                                      size: 40,
                                    ),
                                    content: Text(
                                      'You can\'t delete an author with more than 1 books published in library\n delete all the books from library first before continuing this action',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                }
                                return AlertDialog(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                  title: Text('Delete ${author.name}'),
                                  content: Text(
                                    'You are about to permanently delete ${author.name}\nwould you like to continue',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('Continue'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (delete!) {
                              library.deleteAuthor(author.id);
                              deletesnackbar(delete, author.name);
                            }
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  const Divider(indent: 16, endIndent: 16, thickness: 1),
            ),
          ),
        ],
      ),
    );
  }

  void _callAddAuthorDialog(BuildContext context) async {
    final newAuthorName = await showAddAuthor(context);
    if (!context.mounted) return;
    if (newAuthorName != null && newAuthorName.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Author: \'$newAuthorName\'         saved'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    }
  }

  void deletesnackbar(bool delete, String name) {
    if (delete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Author: $name deleted from Library'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    }
  }
}
