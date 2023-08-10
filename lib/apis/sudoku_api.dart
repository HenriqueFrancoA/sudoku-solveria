import 'package:dio/dio.dart';
import 'package:sudoku_solveria/models/sudoku.dart';

abstract class SudokuApi {
  static Future<Sudoku?> obterTabuleiro() async {
    try {
      final response = await Dio().get(
        'https://sudoku-api.vercel.app/api/dosuku',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        return Sudoku.fromJson(responseData['newboard']['grids'][0]);
      }

      return null;
    } catch (error) {
      print('Error fetching Sudoku data: $error');
      return null;
    }
  }
}
