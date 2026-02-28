import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:education_app/providers/user_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCountryIndex = 0;

    _nameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _phoneController = TextEditingController(text: '');
    _bioController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.user;

      // Use current values if the fields are left empty
      final nameToSave = _nameController.text.trim().isEmpty 
          ? currentUser.name 
          : _nameController.text.trim();
      
      final emailToSave = _emailController.text.trim().isEmpty 
          ? currentUser.email 
          : _emailController.text.trim();

      await userProvider.updateUser(
        name: nameToSave,
        email: emailToSave,
        bio: _bioController.text.trim().isEmpty ? currentUser.bio : _bioController.text,
        phoneNumber: _phoneController.text.trim().isEmpty ? currentUser.phoneNumber : _phoneController.text,
        avatar: _imageFile?.path,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                children: [
                  _buildAvatar(),
                  const SizedBox(height: 24),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return Text(
                        userProvider.user.name,
                        style: TextStyle(
                          color: kSecondaryTextColor.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return Text(
                        userProvider.user.email,
                        style: TextStyle(
                          color: kPrimaryTextColor.withOpacity(0.4),
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                    label: 'Full Name',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Email',
                    controller: _emailController,
                    hint: 'example@gmail.com',
                    validator: (value) {
                      // Allow empty for no-change fallback
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }
                      if (!value.toLowerCase().trim().endsWith('@gmail.com')) {
                        return 'Email must end with @gmail.com';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildPhoneField(),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Bio',
                    controller: _bioController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 40),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            ),
          ),
      ],
    ),
  );
}

  Widget _buildAvatar() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Center(
          child: Stack(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kPrimaryColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 4),
                                    ),
                                    child: ClipOval(
                                      child: _imageFile != null
                                          ? Image.file(
                                              _imageFile!,
                                              fit: BoxFit.cover,
                                            )
                                          : const Image(
                                              image: AssetImage('assets/images/John Doe.jpg'),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topCenter,
                                            ),
                                    ),
                                  ),              ),
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kSecondaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(
            color: kSecondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint ?? label,
            hintStyle: TextStyle(
              color: kPrimaryTextColor.withOpacity(0.6),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
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
            color: kSecondaryTextColor,
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
                  controller: _phoneController,
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
                    hintText: '123 456 789',
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
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
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: kSecondaryTextColor,
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
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
        onPressed: _isLoading ? null : _saveChanges,
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
