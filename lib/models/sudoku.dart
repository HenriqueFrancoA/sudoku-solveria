import 'dart:convert';

class Sudoku {
  final String difficulty;
  final List<List<int>> grid;
  final List<List<int>> solution;
  final int nivel;

  Sudoku({
    required this.difficulty,
    required this.grid,
    required this.solution,
    required this.nivel,
  });

  factory Sudoku.fromMap(Map<String, dynamic> map) {
    return Sudoku(
      difficulty: map['dificuldade'],
      grid: _parseGrid(map['tabuleiro']),
      solution: _parseGrid(map['solucao']),
      nivel: map['nivel'],
    );
  }

  static List<List<int>> _parseGrid(String jsonString) {
    final List<dynamic> jsonArray = json.decode(jsonString);
    return jsonArray.map<List<int>>((row) => List<int>.from(row)).toList();
  }

  factory Sudoku.fromJson(Map<String, dynamic> json) {
    return Sudoku(
      difficulty: json['difficulty'],
      grid:
          List<List<int>>.from(json['grid'].map((row) => List<int>.from(row))),
      solution: List<List<int>>.from(
          json['solution'].map((row) => List<int>.from(row))),
      nivel: json['nivel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'difficulty': difficulty,
      'grid': grid,
      'solution': solution,
      'nivel': nivel,
    };
  }
}
