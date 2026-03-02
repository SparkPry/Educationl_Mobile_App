import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:education_app/utils/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  late AnimationController _bobController;
  late Animation<double> _bobAnimation;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bobAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(parent: _bobController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _bobController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Content Layer with individual backgrounds per page
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              _buildStandardPage(
                index: 0,
                image: 'assets/images/onboarding1.png',
                title: "Choose the right online course for growth",
              ),
              _buildSpecialPage2(),
              _buildStandardPage(
                index: 2,
                image: 'assets/images/onboarding3.png',
                title: "Start you path to mastery with teacher",
              ),
            ],
          ),

          // Back Button (Top Left) - Global layer
          if (_currentIndex > 0)
            Positioned(
              top: 50,
              left: 10,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: _currentIndex == 1 ? Colors.white : Colors.black54,
                ),
                onPressed: () => _controller.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStandardPage({
    required int index,
    required String image,
    required String title,
  }) {
    return Stack(
      children: [
        // Background for Standard Pages
        Stack(
          children: [
            Container(color: Colors.white),
            ClipPath(
              clipper: CurveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.58,
                color: const Color(0xFFF2F2F2),
              ),
            ),
          ],
        ),
        SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 55,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Image.asset(
                      image,
                      key: ValueKey('img_$index'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 45,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "You can learn everything here. Growth you knowledge make your future bright.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildIndicator(false),
                      const SizedBox(height: 40),
                      _buildButton(index, false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialPage2() {
    return Stack(
      children: [
        // Background for Special Page 2
        Container(
          color: AppColors.primaryColor,
          child: CustomPaint(
            size: Size.infinite,
            painter: AbstractLinesPainter(),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                      children: [
                        TextSpan(
                          text: "Easy Learning,\n",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Wherever & \nHowever \nyou want",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: _bobAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bobAnimation.value),
                      child: Container(
                        height: 400,
                        child: Image.asset(
                          'assets/images/onboarding2.png',
                          key: const ValueKey('img_special_2'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildIndicator(true),
                const SizedBox(height: 40),
                _buildButton(1, true),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(bool isDark) {
    return SmoothPageIndicator(
      controller: _controller,
      count: 3,
      effect: ExpandingDotsEffect(
        activeDotColor: isDark ? Colors.white : AppColors.primaryColor,
        dotColor: isDark ? Colors.white.withOpacity(0.3) : Colors.grey[300]!,
        dotHeight: 8,
        dotWidth: 8,
        expansionFactor: 3,
      ),
    );
  }

  Widget _buildButton(int index, bool isDark) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          if (index == 2) {
            _completeOnboarding();
          } else {
            _controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white : AppColors.primaryColor,
          foregroundColor: isDark ? AppColors.primaryColor : Colors.white,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: Text(
          index == 2 ? "Get Started" : "Next",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AbstractLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.2);
    path1.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width,
      size.height * 0.3,
    );
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(-50, size.height * 0.5);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.6,
      size.width * 0.8,
      size.height * 0.4,
    );
    canvas.drawPath(path2, paint);

    final path3 = Path();
    path3.moveTo(size.width * 0.2, size.height);
    path3.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.8,
      size.width,
      size.height * 0.9,
    );
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
