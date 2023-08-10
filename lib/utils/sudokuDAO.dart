import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:sudoku_solveria/models/sudoku.dart';
import 'package:sudoku_solveria/utils/database_helper.dart';

class SudokuDAO {
  Future<void> insertSudokus(Sudoku sudoku) async {
    final db = await DatabaseHelper().database;

    return await db.transaction((txn) async {
      await txn.insert(
        'tb_sudoku',
        {
          'dificuldade': sudoku.difficulty,
          'tabuleiro': jsonEncode(sudoku.grid),
          'solucao': jsonEncode(sudoku.solution),
          'nivel': sudoku.nivel,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<List<Sudoku>> getTabuleiroByDifilcudade(String dificuldade) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db
        .query('tb_sudoku', where: 'dificuldade = ?', whereArgs: [dificuldade]);
    return List.generate(maps.length, (index) => Sudoku.fromMap(maps[index]));
  }

  Future<List<Sudoku>> getProximaFase(String dificuldade, int nivel) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('tb_sudoku',
        where: 'dificuldade = ? AND nivel = ?',
        whereArgs: [dificuldade, nivel]);
    return List.generate(maps.length, (index) => Sudoku.fromMap(maps[index]));
  }
}
