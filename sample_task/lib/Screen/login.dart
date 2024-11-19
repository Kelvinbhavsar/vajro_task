import 'package:Vajro/Bloc/apiEvents.dart';
import 'package:Vajro/Bloc/api_Bloc.dart';
import 'package:Vajro/Screen/listView.dart';
import 'package:Vajro/Utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    // _image =

    return Material(
      child: Expanded(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.amber,
          child: Center(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    validator: (value) {
                      // Basic validation
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final XFile? image =
                              await pickImage(source: ImageSource.gallery);
                          setState(() {
                            _image = image;
                          });
                        },
                        icon: const Icon(Icons.photo_library),
                      ),
                      IconButton(
                          onPressed: () async {
                            final XFile? image =
                                await pickImage(source: ImageSource.camera);
                            setState(() {
                              _image = image;
                            });
                          },
                          icon: const Icon(Icons.camera_alt))
                    ],
                  ),
                  //     },
                  //     child: const Text('Pick Image')),
                  // if (_image != null) Image.file(File(_image!.path)),
                  ElevatedButton(
                    onPressed: () {
                      // Your submit logic here
                      if (_formKey.currentState!.validate()) {
                        // Process data and submit
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        // ... any further actions, e.g., API call
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider<ApiBloc>(
                                create: (context) =>
                                    ApiBloc()..add(FetchData()),
                                child: const ListingPage(),
                              ),
                            )
                            // MaterialPageRoute(
                            //     builder: (context) => const ListingPage()),
                            );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
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
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText; // For password fields

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}
