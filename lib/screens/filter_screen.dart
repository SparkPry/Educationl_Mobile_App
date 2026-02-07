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
  RangeValues _priceRange = const RangeValues(50, 300);
  int _rating = 0;
  String _selectedDuration = '0–3 hours';

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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSectionTitle('Category'),
                    _buildCategoryChips(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Level'),
                    _buildLevelChips(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Price Range'),
                    _buildPriceRangeSlider(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Rating'),
                    _buildRatingStars(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Duration'),
                    _buildDurationChips(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildApplyButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
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
              _priceRange = const RangeValues(50, 300);
              _rating = 0;
              _selectedDuration = '0–3 hours';
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      'All',
      'Programming',
      'Mobile Development',
      'Web Development',
      'Frontend Development',
      'Backend Development',
      'Database',
    ];
    return Wrap(
      spacing: 8,
      children: categories.map((category) {
        return ChoiceChip(
          label: Text(category),
          selected: _selectedCategory == category,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedCategory = category;
              });
            }
          },
          selectedColor: Colors.blue,
          labelStyle: TextStyle(
            color: _selectedCategory == category ? Colors.white : Colors.black,
          ),
          backgroundColor: Colors.lightBlue[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.transparent),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLevelChips() {
    final levels = ['All', 'Beginner', 'Intermediate', 'Advance', 'Business'];
    return Wrap(
      spacing: 8.0,
      children: levels.map((level) {
        return ChoiceChip(
          label: Text(level),
          selected: _selectedLevel == level,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedLevel = level;
              });
            }
          },
          selectedColor: Colors.blue,
          labelStyle: TextStyle(
            color: _selectedLevel == level ? Colors.white : Colors.black,
          ),
          backgroundColor: Colors.lightBlue[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.transparent),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: 50,
          max: 300,
          divisions: 50,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
          activeColor: Colors.blue,
          inactiveColor: Colors.grey[300],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${_priceRange.start.round()}'),
              Text('\$${_priceRange.end.round()}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStars() {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return IconButton(
            icon: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              color: index < _rating ? Colors.orange : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _rating = index + 1;
              });
            },
          );
        }),
        const SizedBox(width: 8),
        Text('${_rating}/5', style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildDurationChips() {
    final durations = ['0–3 hours', '4–7 hours', '8–17 hours', '17–3...'];
    return Wrap(
      spacing: 8.0,
      children: durations.map((duration) {
        return ChoiceChip(
          label: Text(duration),
          selected: _selectedDuration == duration,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedDuration = duration;
              });
            }
          },
          selectedColor: Colors.blue,
          labelStyle: TextStyle(
            color: _selectedDuration == duration ? Colors.white : Colors.black,
          ),
          backgroundColor: Colors.lightBlue[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.transparent),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, {
            'category': _selectedCategory,
            'level': _selectedLevel,
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          'Apply',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
