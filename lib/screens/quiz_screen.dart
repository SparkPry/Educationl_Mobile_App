import 'package:flutter/material.dart';
import 'package:education_app/utils/app_colors.dart';

// Data model for a single quiz question
class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showSubmitButton = false;
  final Map<int, String?> _selectedOptions = {}; // Map to store selected option for each question

  // Placeholder data for the quiz
  final String quizTitle = "General Knowledge Quiz";
  final String quizDescription =
      "Test your general knowledge with a series of multiple-choice questions.";

  final List<Question> _quizQuestions = [
    Question(
      questionText: "What is the capital of France?",
      options: ["Berlin", "Madrid", "Paris", "Rome"],
      correctAnswer: "Paris",
    ),
    Question(
      questionText: "Which planet is known as the Red Planet?",
      options: ["Earth", "Mars", "Jupiter", "Venus"],
      correctAnswer: "Mars",
    ),
    Question(
      questionText: "What is the largest ocean on Earth?",
      options: ["Atlantic", "Indian", "Arctic", "Pacific"],
      correctAnswer: "Pacific",
    ),
    Question(
      questionText: "Who wrote 'Romeo and Juliet'?",
      options: ["Charles Dickens", "William Shakespeare", "Jane Austen", "Mark Twain"],
      correctAnswer: "William Shakespeare",
    ),
    Question(
      questionText: "What is the chemical symbol for water?",
      options: ["O2", "H2O", "CO2", "NaCl"],
      correctAnswer: "H2O",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Show button if scrolled down, hide if at the very top (or near top)
    if (_scrollController.offset > 50 && !_showSubmitButton) { // Threshold for showing button
      setState(() {
        _showSubmitButton = true;
      });
    } else if (_scrollController.offset <= 50 && _showSubmitButton) {
      setState(() {
        _showSubmitButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // Screen background
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0), // Margin for the card
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Card background
                borderRadius: BorderRadius.circular(16), // Rounded card
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4), // Soft shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0), // Padding inside the card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quiz Title
                  Text(
                    quizTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold, // Medium-bold font
                      color: Colors.black87, // Dark gray
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quiz Description
                  Text(
                    quizDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600], // Light gray text
                      height: 1.5, // Comfortable line height
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Questions and Options
                  ListView.builder(
                    shrinkWrap: true, // Important for nested scroll views
                    physics: const NeverScrollableScrollPhysics(), // Managed by parent SingleChildScrollView
                    itemCount: _quizQuestions.length,
                    itemBuilder: (context, questionIndex) {
                      final question = _quizQuestions[questionIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Question ${questionIndex + 1}: ${question.questionText}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: question.options.map((option) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: option,
                                      groupValue: _selectedOptions[questionIndex], // Group by question index
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedOptions[questionIndex] = value;
                                        });
                                      },
                                      activeColor: AppColors.primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded( // Use Expanded to prevent overflow
                                      child: Text(
                                        option,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24), // Space between questions
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 200), // Extra space to make content scrollable
                ],
              ),
            ),
          ),
          // Submit button (conditionally visible)
          if (_showSubmitButton)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submit logic here
                    print("Submit Quiz: $_selectedOptions");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor, // Primary blue background
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    elevation: 5, // Elevated / shadow
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // White text
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}