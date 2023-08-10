import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solveria/controllers/sudoku_controller.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool salvarAcesso = false;

  final sudokuController = Get.put(SudokuBoardController());

  String getTextoLoading() {
    return "Carregando Configurações...";
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      carregarControllers();
    });

    super.initState();
  }

  carregarControllers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    salvarAcesso = prefs.getBool("salvarAcesso") ?? false;
    try {
      if (!salvarAcesso) {
        await sudokuController.loadJsonDataAndInsertToDatabase();

        await SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('salvarAcesso', true);
        });
      }
      Get.offAllNamed('/menu');
    } catch (e) {
      carregarControllers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/images/loading.json",
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            Text(
              getTextoLoading(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
