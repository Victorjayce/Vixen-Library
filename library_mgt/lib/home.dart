import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:library_mgt/dashboard.dart';
import 'package:library_mgt/book.dart';
import 'package:library_mgt/rented.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final pageController = PageController();
  int selectedIndex = 0;
  final List<Widget> pages = [DashBoard(), HomePage(), RentedPage()];
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> _showAboutDialog(BuildContext context) async {
    final scheme = Theme.of(context).colorScheme;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: CircleAvatar(
            backgroundColor: scheme.primaryContainer,
            child: Icon(Icons.info_outline, color: scheme.primary),
          ),
          title: Text(
            'About',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: RichText(
            text: TextSpan(
              style: TextStyle(
                color: scheme.onSurface,
                height: 1.6,
                fontSize: 14,
              ),
              children: [
                const TextSpan(
                  text:
                      'Vixen library is a simple library management system built by ',
                ),
                const TextSpan(text: 'Nkegbu Ebubechukwu Victor  '),
                TextSpan(
                  text: '@victorjayce',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      Navigator.pop(context);
                      await _launchRepository();
                    },
                ),
                const TextSpan(
                  text:
                      ', while learning dart and flutter to practice and gain experience.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _launchRepository();
              },
              icon: Icon(Icons.open_in_new, color: scheme.primary),
              label: Text(
                'Open GitHub repo',
                style: TextStyle(color: scheme.primary),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchRepository() async {
    final Uri url = Uri.parse('https://github.com/Victorjayce/Vixen-Library');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the repository link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
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
                'Vixen Library',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Library management system',
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
                tooltip: 'About',
                icon: const Icon(Icons.info_outline),
                color: scheme.onPrimary,
                iconSize: 26,
                style: IconButton.styleFrom(
                  backgroundColor: scheme.surface.withValues(alpha: 0.18),
                ),
                onPressed: () => _showAboutDialog(context),
              ),
            ),
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: pages,
        ),
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
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: Colors.blue),
              selectedIcon: Icon(Icons.dashboard, color: Colors.blue),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined, color: Colors.blue),
              selectedIcon: Icon(Icons.auto_stories, color: Colors.blue),
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
}
