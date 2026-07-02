import 'package:flutter/material.dart';
import 'package:library_mgt/dashboard.dart';
import 'package:library_mgt/book.dart';
import 'package:library_mgt/rented.dart';
import 'widgets/containertitle.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  final List<Widget> pages = [DashBoard(), HomePage(), RentedPage()];
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final exit = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              icon: const Icon(
                Icons.error_outline,
                color: Colors.orange,
                size: 40,
              ),
              title: Text(
                'Exit App',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              content: Text(
                'You are about to exit the application.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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

        if (exit == true) {
          SystemNavigator.pop(); // Pops the last route (exits if it's the root)
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Vixen Library'),
          automaticallyImplyLeading: false,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                color: Theme.of(context).colorScheme.surface,
                iconSize: 40,
                onPressed: () => _opendrawer(context),
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            children: <Widget>[
              const ContainerTitle(title: 'Menu'),
              ListTile(
                leading: const Icon(Icons.bookmark_add),
                title: const Text(
                  'Rent Books',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                    color: Colors.blue,
                  ),
                ),
                iconColor: Colors.blue,
                onTap: null,
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_added),
                title: const Text(
                  'Rented Books',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                    color: Colors.blue,
                  ),
                ),
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.pushNamed(context, '/rentedscreen');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  'Authors',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                    color: Colors.blue,
                  ),
                ),
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.pushNamed(context, '/authorscreen');
                },
              ),
            ],
          ),
        ),
        body: IndexedStack(index: selectedIndex, children: pages),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            if (index == 3) {
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).colorScheme.surface,
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),

                        // Drag handle
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        const SizedBox(height: 16),
                        ListTile(
                          leading: Icon(Icons.person, color: Colors.blue),
                          title: Text(
                            'Authors',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/authorscreen');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.people, color: Colors.blue),
                          title: Text(
                            'Users',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/userscreen');
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
              return;
            }
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: Colors.blue),
              selectedIcon: Icon(Icons.dashboard, color: Colors.blue),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.book_outlined, color: Colors.blue),
              selectedIcon: Icon(Icons.book, color: Colors.blue),
              label: 'Books',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_added_outlined, color: Colors.blue),
              selectedIcon: Icon(Icons.bookmark_added, color: Colors.blue),
              label: 'Rentals',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz, color: Colors.blue),
              selectedIcon: Icon(Icons.more_horiz, color: Colors.blue),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }

  void _opendrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
}
