import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    Center(child: Text("My Courses")),
    Center(child: Text("Inbox")),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_index != 0) {
          setState(() {
            _index = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _pages[_index],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _index,
          selectedItemColor: const Color(0xFF6B66FF),
          unselectedItemColor: Colors.grey,
          onTap: (i) {
            setState(() => _index = i);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              label: "My Courses",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inbox_outlined),
              label: "Inbox",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
