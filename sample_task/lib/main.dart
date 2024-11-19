import 'package:Vajro/Bloc/apiEvents.dart';
import 'package:Vajro/Bloc/api_Bloc.dart';
import 'package:Vajro/Screen/listView.dart';
import 'package:Vajro/Screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String? isLoggedIn = localStorage.getItem('isLoggedIn') ?? '';
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: isLoggedIn == "true"
          ? const MyHomePage()
          : BlocProvider<ApiBloc>(
              create: (context) => ApiBloc()..add(FetchData()),
              child: const ListingPage(),
            ),
    );
  }
}
