import 'dart:io';

import 'package:Vajro/Bloc/apiEvents.dart';
import 'package:Vajro/Screen/listView.dart';
import 'package:Vajro/Utils/colorUtils.dart';
import 'package:Vajro/Utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

import 'package:Vajro/Bloc/api_Bloc.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  List<PasswordError> passwordValidator(String password) {
    List<PasswordError> errors = [];
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add(PasswordError.upperCase);
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errors.add(PasswordError.lowerCase);
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      errors.add(PasswordError.digit);
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      errors.add(PasswordError.specialCharacter);
    }
    if (!RegExp(r'.{8,}').hasMatch(password)) {
      errors.add(PasswordError.eigthCharacter);
    }

    return errors;
  }

  GlobalKey key = GlobalKey();
  bool obscureText = true;
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    // _image =

    var imgPath = localStorage.getItem('imagePath');

    return Scaffold(
      backgroundColor: ColorUtils.backgroundColor,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: ColorUtils.backgroundColor,
        child: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                const Spacer(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () => _showImagePickerDialog(context),
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: MediaQuery.sizeOf(context).height * 0.15,
                        width: MediaQuery.sizeOf(context).height * 0.15,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: imgPath != null
                            ? Image.file(
                                File(imgPath),
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.no_photography,
                                color: ColorUtils.secondaryTextColor),
                      ),
                    ),
                    Positioned(
                      top: -5,
                      right: -10,
                      child: Container(
                        height: 40,
                        width: 40,
                        // padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: ColorUtils.primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                          onPressed: () {
                            // Show alert dialog to choose image source
                            _showImagePickerDialog(context);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                    child: Column(children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    focusNode: focusNodeEmail,
                    decoration: const InputDecoration(
                        labelText: 'Email', hintText: 'Enter your email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      // Basic validation
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: focusNodePassword,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          obscureText == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) {
                      if (password != null) {
                        // Get all errors
                        final validators = passwordValidator(password);

                        // Returns null if password is valid
                        if (validators.isEmpty) return null;

                        // Join all errors that start with "-"
                        return validators
                            .map((e) => '- ${e.message}')
                            .join('\n');
                      }

                      return null;
                    },
                  ),
                ])),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Your submit logic here
                    if (_formKey.currentState!.validate()) {
                      // Process data and submit
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      // ... any further actions, e.g., API call

                      if (email.toLowerCase() == 'vajro@gmail.com' &&
                          password == 'Vajro@1234') {
                        localStorage.setItem('isLoggedIn', "true");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider<ApiBloc>(
                                create: (context) => ApiBloc()
                                  ..add(const FetchData(page: 1, pageSize: 10)),
                                child: const ListingPage(),
                              ),
                            ),
                            (route) => false
                            // MaterialPageRoute(
                            //     builder: (context) => const ListingPage()),
                            );
                      } else {
                        focusNodePassword.unfocus();
                        focusNodeEmail.unfocus();
                        // Scaffold(body: return ,);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter valid credentials')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        ColorUtils.primaryColor, // Background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12), // Adjust padding as needed
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8)), // Rounded corners
                    foregroundColor: Colors.white, // Text color
                  ),

                  child: const Text('Submit',
                      style: TextStyle(fontSize: 16)), // Text style
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    XFile? image;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          key: key,
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Gallery'),
                onTap: () async {
                  image = await pickImage(ImageSource.gallery, context,
                      source: ImageSource.gallery);
                  if (image?.path != null) {
                    localStorage.setItem('imagePath', image?.path ?? "");
                  }
                  setState(() {});
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              ListTile(
                title: const Text('Camera'),
                onTap: () async {
                  image = await pickImage(ImageSource.gallery, context,
                      source: ImageSource.camera);
                  if (image?.path != null) {
                    localStorage.setItem('imagePath', image?.path ?? "");
                  }
                  setState(() {});
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
