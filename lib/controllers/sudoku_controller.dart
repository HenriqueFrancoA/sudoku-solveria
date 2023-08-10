import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sudoku_solveria/models/sudoku.dart';
import 'package:sudoku_solveria/utils/sudokuDAO.dart';

class SudokuBoardController {
  RxInt selectedRow = 0.obs;
  RxInt selectedCol = 0.obs;

  RxList niveis = RxList();

  final SudokuDAO sudokuDAO = SudokuDAO();

  Future<void> loadJsonDataAndInsertToDatabase() async {
    const String jsonAssetPath = 'assets/jsons/tabuleiros.json';
    int contadorEasy = 0;
    int contadorMedium = 0;
    int contadorHard = 0;
    final jsonData = await rootBundle.loadString(jsonAssetPath);
    final List<Map<String, dynamic>> jsonList =
        List<Map<String, dynamic>>.from(jsonDecode(jsonData));

    for (final jsonItem in jsonList) {
      final newboard = jsonItem['newboard'];
      final List<dynamic> grids = newboard['grids'];

      for (final gridData in grids) {
        final List<List<int>> gridValues = List<List<int>>.from(
            gridData['value'].map((row) => List<int>.from(row)));
        final List<List<int>> solutionValues = List<List<int>>.from(
            gridData['solution'].map((row) => List<int>.from(row)));

        final String difficulty = gridData['difficulty'];

        final Sudoku sudoku;
        if (difficulty == "Easy") {
          contadorEasy++;
          sudoku = Sudoku(
            difficulty: difficulty,
            grid: gridValues,
            solution: solutionValues,
            nivel: contadorEasy,
          );
        } else if (difficulty == "Medium") {
          contadorMedium++;
          sudoku = Sudoku(
            difficulty: difficulty,
            grid: gridValues,
            solution: solutionValues,
            nivel: contadorMedium,
          );
        } else {
          contadorHard++;
          sudoku = Sudoku(
            difficulty: difficulty,
            grid: gridValues,
            solution: solutionValues,
            nivel: contadorHard,
          );
        }

        await sudokuDAO.insertSudokus(sudoku);
      }
    }
  }

  Future<void> obterFases(String dificuldade) async {
    niveis.clear();
    niveis.addAll(await sudokuDAO.getTabuleiroByDifilcudade(dificuldade));
  }

  void updateSelectedCell(List<List<int>> matrix, int number) {
    if (selectedRow.value != -1 && selectedCol.value != -1) {
      matrix[selectedRow.value][selectedCol.value] = number;
    }
  }

  Future<Sudoku> proximaFase(String dificuldade, int nivel) async {
    List<Sudoku> lista = await sudokuDAO.getProximaFase(dificuldade, nivel);
    return lista.first;
  }
}
