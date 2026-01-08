import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> contents = [
    {"t1": "Choose the right online\ncourse ", "t2": "for growth"},
    {"t1": "Easy learning, Wherever &\nWherever ", "t2": "you want"},
    {"t1": "Start you path to mastery\nwith ", "t2": "teacher"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () => _navigateToLogin(),
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemCount: contents.length,
              itemBuilder: (context, index) {
                // Placeholder for Image
                return Center(
                  child: Icon(
                    index == 2 ? Icons.school : Icons.menu_book,
                    size: 200,
                    color: const Color(0xFF6B66FF).withAlpha(128),
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: contents[_currentIndex]["t1"]),
                      TextSpan(
                        text: contents[_currentIndex]["t2"],
                        style: const TextStyle(color: Color(0xFF6B66FF)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "You can learn everything here. Growth you knowledge make your future bright.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: List.generate(3, (i) => _buildDot(i))),
                    GestureDetector(
                      onTap: () {
                        if (_currentIndex == 2) {
                          _navigateToLogin();
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6B66FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildDot(int index) {
    return Container(
      height: 8,
      width: _currentIndex == index ? 24 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentIndex == index
            ? const Color(0xFF6B66FF)
            : Colors.grey[300],
      ),
    );
  }
}
