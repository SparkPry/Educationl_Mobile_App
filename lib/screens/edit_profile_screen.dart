import 'package:flutter/material.dart';

// Color Scheme
const Color kPrimaryColor = Color(0xFF5B5CF6);
const Color kBackgroundColor = Color(0xFFF5F5F5);
const Color kPrimaryTextColor = Color(0xFF9E9E9E);
const Color kSecondaryTextColor = Color(0xFF424242);

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final List<Map<String, String>> _countryCodes = [
    {'code': '+855', 'flag': '🇰🇭'}, // Cambodia
    {'code': '+84', 'flag': '🇻🇳'}, // Vietnam
    {'code': '+65', 'flag': '🇸🇬'}, // Singapore
    {'code': '+60', 'flag': '🇲🇾'}, // Malaysia
    {'code': '+1', 'flag': '🇺🇸'}, // USA
    {'code': '+1', 'flag': '🇨🇦'}, // Canada
    {'code': '+44', 'flag': '🇬🇧'}, // UK
    {'code': '+49', 'flag': '🇩🇪'}, // Germany
    {'code': '+33', 'flag': '🇫🇷'}, // France
    {'code': '+55', 'flag': '🇧🇷'}, // Brazil
    {'code': '+61', 'flag': '🇦🇺'}, // Australia
    {'code': '+81', 'flag': '🇯🇵'}, // Japan
    {'code': '+82', 'flag': '🇰🇷'}, // South Korea
    {'code': '+86', 'flag': '🇨🇳'}, // China
    {'code': '+91', 'flag': '🇮🇳'}, // India
  ];

  late int _selectedCountryIndex;

  @override
  void initState() {
    super.initState();
    _selectedCountryIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kSecondaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: kSecondaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildAvatar(),
              const SizedBox(height: 24),
              const Text(
                'Johnny Sin', // Placeholder for user's name
                style: TextStyle(
                  color: kSecondaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'johnny.sin@example.com', // Placeholder for user's email
                style: TextStyle(
                  color: kPrimaryTextColor.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(label: 'Full Name'),
              const SizedBox(height: 20),
              _buildTextField(label: 'Email'),
              const SizedBox(height: 20),
              _buildPhoneField(),
              const SizedBox(height: 20),
              _buildTextField(label: 'Bio', maxLines: 4),
              const SizedBox(height: 40),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kPrimaryColor, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 65,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150',
              ), // Placeholder image
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                _showImageSourceActionSheet(context);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kPrimaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: TextEditingController(text: initialValue),
          maxLines: maxLines,
          style: const TextStyle(
            color: kSecondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: label, // Use label as hintText
            hintStyle: TextStyle(
              color: kPrimaryTextColor.withOpacity(0.6), // Faded hint style
              fontWeight: FontWeight.normal,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            color: kPrimaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedCountryIndex,
                  items: _countryCodes.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final Map<String, String> country = entry.value;
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(
                        '${country['flag']} ${country['code']}',
                        style: const TextStyle(
                          color: kSecondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newIndex) {
                    if (newIndex != null) {
                      setState(() {
                        _selectedCountryIndex = newIndex;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
                child: VerticalDivider(color: kPrimaryTextColor, thickness: 1),
              ),
              Expanded(
                child: TextFormField(
                  controller: TextEditingController(text: ''),
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: kSecondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: '123456789',
                    hintStyle: TextStyle(
                      color: kPrimaryTextColor.withOpacity(0.6),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Change Profile Photo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kSecondaryTextColor,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: kSecondaryTextColor,
                ),
                title: const Text('Take Photo'),
                onTap: () {
                  // Placeholder for image picker logic
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Camera functionality not implemented.'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: kSecondaryTextColor,
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  // Placeholder for image picker logic
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gallery functionality not implemented.'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Save action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          shadowColor: kPrimaryColor.withOpacity(0.4),
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
