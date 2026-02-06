import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String _selectedCategory = 'All';
  String _selectedLevel = 'All';
  // String _selectedDuration = '0–3 hours';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Category'),
                  _buildCategoryChips(),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Level'),
                  _buildLevelChips(),
                  const SizedBox(height: 24),

                  // _buildSectionTitle('Duration'),
                  // _buildDurationChips(),
                  // const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildApplyButton(),
    );
  }

  // ================= APP BAR =================

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Filter',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _selectedCategory = 'All';
              _selectedLevel = 'All';
              // _selectedDuration = '0–3 hours';
            });
          },
          child: const Text(
            'Reset',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ],
    );
  }

  // ================= SECTIONS =================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ================= CATEGORY =================

  Widget _buildCategoryChips() {
    final categories = [
      'All',
      'Programming',
      'Mobile Development',
      'Web Development',
      'Backend Development',
      'Design',
    ];

    return Wrap(
      spacing: 8,
      children: categories.map((category) {
        final isSelected = _selectedCategory == category;

        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (_) {
            setState(() => _selectedCategory = category);
          },
          selectedColor: AppColors.primaryColor,
          backgroundColor: Colors.lightBlue[50],
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  // ================= LEVEL =================

  Widget _buildLevelChips() {
    final levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

    return Wrap(
      spacing: 8,
      children: levels.map((level) {
        final isSelected = _selectedLevel == level;

        return ChoiceChip(
          label: Text(level),
          selected: isSelected,
          onSelected: (_) {
            setState(() => _selectedLevel = level);
          },
          selectedColor: AppColors.primaryColor,
          backgroundColor: Colors.lightBlue[50],
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  // // ================= DURATION =================

  // Widget _buildDurationChips() {
  //   final durations = ['0–3 hours', '4–7 hours', '8–17 hours', '17+ hours'];

  //   return Wrap(
  //     spacing: 8,
  //     children: durations.map((duration) {
  //       final isSelected = _selectedDuration == duration;

  //       return ChoiceChip(
  //         label: Text(duration),
  //         selected: isSelected,
  //         onSelected: (_) {
  //           setState(() => _selectedDuration = duration);
  //         },
  //         selectedColor: AppColors.primaryColor,
  //         backgroundColor: Colors.lightBlue[50],
  //         labelStyle: TextStyle(
  //           color: isSelected ? Colors.white : Colors.black,
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  // ================= APPLY =================

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, {
            'category': _selectedCategory == 'All' ? null : _selectedCategory,
            'level': _selectedLevel == 'All' ? null : _selectedLevel,
            // 'duration': _selectedDuration,
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Apply',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
