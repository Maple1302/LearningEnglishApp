import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maple/models/user_model.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    UserModel? user = authViewModel.user;
    return user != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[100],
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileEditPage()));
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Avatar and basic info
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.network(
                                user.urlAvatar,
                                width:
                                    90, // Ensure the image fits within the circle
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const Icon(Icons.person);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.username!,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(user.email!),
                        Text('Đã tham gia ${user.dateCreate}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/flag_america.png', width: 24),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Stats
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatCard(
                              icon: 'images/fire.png',
                              value: user.streak,
                              label: 'Ngày streak',
                            ),
                            StatCard(
                              icon: 'images/score_icon.png',
                              value: user.kN,
                              label: 'Tổng KN',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Additional achievements or other sections can go here
                ],
              ),
            ),
          )
        : Container();
  }
}

class StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const StatCard(
      {super.key,
      required this.icon,
      required this.value,
      required this.label,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        width: 140,
        height: 140,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey, width: 2)),
        child: Column(
          children: [
            Image.asset(
              icon,
              width: 40,
              height: 40,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ));
  }
}

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  dynamic images;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authViewModel = Provider.of<AuthViewModel>(context);
    UserModel? user = authViewModel.user;
    images = user!.urlAvatar;
    imageUrl = user.urlAvatar;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    UserModel? user = authViewModel.user;
    final picker = ImagePicker();
    List<TextEditingController> textEditingController =
        List.generate(3, (index) => TextEditingController());
    textEditingController[0].text = user!.username!;
    textEditingController[1].text = user.email!;
    textEditingController[2].text = '●●●●●●●●';

    Future<void> getImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          images = File(pickedFile.path);
        });
      }
    }

    Future<String> uploadImageToFirebase(File image) async {
      final fileName = image.path.split('/').last;
      final storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        actions: [
          TextButton(
            onPressed: () async {
              if (images is File) {
                imageUrl = await uploadImageToFirebase(images);
              }
              imageUrl == user.urlAvatar ? user.urlAvatar : imageUrl;
              UserModel newUser = UserModel(
                  uid: user.uid,
                  role: user.role,
                  email: user.email,
                  dateCreate: user.dateCreate,
                  urlAvatar: imageUrl,
                  signInMethod: user.signInMethod,
                  completedLessons: user.completedLessons,
                  progress: user.progress,
                  username: textEditingController[0].text,
                  streak: user.streak,
                  language: user.language,
                  heart: user.heart,
                  gem: user.gem,
                  kN: user.kN,
                  lastCompletionDate: user.lastCompletionDate);

              if (authViewModel.user != newUser) {
                // ignore: use_build_context_synchronously
                authViewModel.updateUser(newUser);
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lưu thay đổi thành công')),
                );
              }

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text(
              'LƯU LẠI',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50, // Increase the radius for a larger CircleAvatar
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => getImage(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                50), // Match the border radius with the CircleAvatar radius
                            child: Container(
                              width:
                                  100, // Increase the width for a larger image
                              height:
                                  100, // Increase the height for a larger image
                              color: Colors.grey[300],
                              child: (images != null || images != '')
                                  ? (images is File
                                      ? Image.file(
                                          images,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(images as String,
                                          fit: BoxFit.cover, errorBuilder:
                                              (BuildContext context,
                                                  Object exception,
                                                  StackTrace? stackTrace) {
                                          return const Icon(Icons.person);
                                        }))
                                  : const Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 100, // Increase the icon size
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 16),
            buildTextField('Tên', textEditingController[0], false),
            buildTextField('Email', textEditingController[1], true),
            if (user.signInMethod == 'email')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mật khẩu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      obscureText: true,
                      readOnly: true,
                      controller: textEditingController[2],
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen(),
                              ),
                            );
                          },
                        ),
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                authViewModel.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, readonly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            readOnly: readonly,
            controller: controller,
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mật khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (viewModel.isLoading) const CircularProgressIndicator(),
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu cũ',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrentPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu cũ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu mới';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    viewModel
                        .changePasswordEmail(
                      _currentPasswordController.text,
                      _newPasswordController.text,
                    )
                        .then((_) {
                      if (viewModel.errorMessage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Thay đổi mật khẩu thành công')),
                        );
                        Navigator.pop(
                            context); // Go back to the previous screen
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(15),
                 
                ),
                child: const Text('Đổi mật khẩu',  style:TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
