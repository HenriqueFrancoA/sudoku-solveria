import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sudoku_solveria/controllers/sudoku_controller.dart';
import 'package:sudoku_solveria/models/sudoku.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  final sudoku = Get.arguments['sudoku'] as Sudoku;
  final SudokuBoardController sudokuBoardController = SudokuBoardController();
  List<List<int>> initialMatrix = List.generate(9, (_) => List.filled(9, 0));
  List<List<int>> currentMatrix = List.generate(9, (_) => List.filled(9, 0));
  BannerAd? myBannerTop;
  BannerAd? myBanner;
  RewardedAd? rewardedAd;
  RxInt dicas = 0.obs;
  bool ativouDica = false;

  void carregarDicas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dicas.value = prefs.getInt("dicas") ?? 2;
  }

  void loadAd() async {
    await RewardedAd.load(
        adUnitId:
            'ca-app-pub-4824022930012497/2243544717', //online ca-app-pub-4824022930012497/2243544717
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    carregarDicas();
    loadAd();
    myBannerTop = BannerAd(
      size: AdSize.banner,
      adUnitId:
          'ca-app-pub-4824022930012497/1245323664', //online-> 'ca-app-pub-4824022930012497/1245323664',
      listener: BannerAdListener(
        onAdClosed: (ad) {
          setState(() {
            ad.dispose();
            myBannerTop = null;
          });
        },
        onAdOpened: (Ad ad) {
          setState(() {
            ad.dispose();
            myBannerTop = null;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
    myBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-4824022930012497/1245323664",
      // 'ca-app-pub-3940256099942544/6300978111', //online-> 'ca-app-pub-4824022930012497/1245323664',
      listener: BannerAdListener(
        onAdClosed: (ad) {
          setState(() {
            ad.dispose();
            myBanner = null;
          });
        },
        onAdOpened: (Ad ad) {
          setState(() {
            ad.dispose();
            myBanner = null;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
    initialMatrix = List.generate(
      9,
      (index) => List.from(sudoku.grid[index]),
    );
    currentMatrix = List.generate(
      9,
      (index) => List.from(sudoku.grid[index]),
    );
    super.initState();
  }

  void showHint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (dicas.value > 0) {
      final emptyCells = <Offset>[];
      for (var row = 0; row < currentMatrix.length; row++) {
        for (var col = 0; col < currentMatrix[row].length; col++) {
          if (currentMatrix[row][col] == 0) {
            emptyCells.add(Offset(row.toDouble(), col.toDouble()));
          }
        }
      }
      if (emptyCells.isNotEmpty && emptyCells.length > 1) {
        final randomEmptyCell =
            emptyCells[DateTime.now().millisecond % emptyCells.length];
        final randomValue = sudoku.solution[randomEmptyCell.dx.toInt()]
            [randomEmptyCell.dy.toInt()];
        setState(() {
          currentMatrix[randomEmptyCell.dx.toInt()]
              [randomEmptyCell.dy.toInt()] = randomValue;
        });
      }
      dicas--;

      prefs.setInt("dicas", dicas.value);
    } else if (!ativouDica) {
      rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        dicas.value += 2;
        prefs.setInt("dicas", dicas.value);
        ativouDica = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          backgroundColor: Colors.white,
          title: myBannerTop != null
              ? Stack(
                  children: [
                    Container(
                      width: queryData.size.width,
                      height: 50,
                      color: Colors.black,
                      child: AdWidget(
                        ad: myBannerTop!,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          myBannerTop!.dispose();
                          myBannerTop = null;
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ],
                )
              : null,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Quebra-Cabeça de Sudoku',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed("/transicao", arguments: {
                        "destino": "/menu",
                      });
                    },
                    child: Text(
                      'Sair',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showHint();
                      });
                    },
                    child: Obx(
                      () {
                        return dicas.value != 0 || ativouDica
                            ? Text(
                                'Dicas: ${dicas.value}',
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            : Row(
                                children: [
                                  Text(
                                    'Assista ',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const Icon(
                                    Icons.video_call,
                                    color: Colors.black,
                                  ),
                                ],
                              );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentMatrix = List.generate(
                          9,
                          (_) => List.from(initialMatrix[_]),
                        );
                      });
                    },
                    child: Text(
                      'Limpar',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Dificuldade: ${sudoku.difficulty == "Easy" ? "Fácil" : sudoku.difficulty == "Medium" ? "Média" : "Díficil"}",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  TabuleiroComponent(
                    controller: sudokuBoardController,
                    initialMatrix: initialMatrix,
                    currentMatrix: currentMatrix,
                    dificuldade: sudoku.difficulty,
                    nivel: sudoku.nivel,
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomSheet: myBanner != null
            ? Stack(
                children: [
                  Container(
                    width: queryData.size.width,
                    height: 50,
                    color: Colors.black,
                    child: AdWidget(
                      ad: myBanner!,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        myBanner!.dispose();
                        myBanner = null;
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 16,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

class TabuleiroComponent extends StatefulWidget {
  final SudokuBoardController controller;
  final List<List<int>> initialMatrix;
  final List<List<int>> currentMatrix;
  final int nivel;
  final String dificuldade;

  const TabuleiroComponent({
    super.key,
    required this.controller,
    required this.initialMatrix,
    required this.currentMatrix,
    required this.nivel,
    required this.dificuldade,
  });

  @override
  TabuleiroComponentState createState() => TabuleiroComponentState();
}

class TabuleiroComponentState extends State<TabuleiroComponent> {
  final List<List<int>> sudokuMatrix =
      List.generate(9, (_) => List.filled(9, 0));
  int selectedRow = -1;
  int selectedCol = -1;

  void selectCell(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  bool isSudokuCompleted() {
    for (var i = 0; i < widget.currentMatrix.length; i++) {
      for (var j = 0; j < widget.currentMatrix[i].length; j++) {
        if (widget.currentMatrix[i][j] == 0 ||
            _isConflicting(
                widget.currentMatrix, i, j, widget.currentMatrix[i][j])) {
          return false;
        }
      }
    }

    return true;
  }

  void showCompletionDialog() {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: queryData.size.width * 0.9,
              height: queryData.size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Lottie.asset(
                    'assets/images/finish.json',
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Parabéns!",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Você concluiu a fase!",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                int nivelFacil = prefs.getInt("facil") ?? 1;
                                int nivelMedio = prefs.getInt("medio") ?? 1;
                                int nivelHard = prefs.getInt("dificil") ?? 1;
                                Sudoku proxFase = await widget.controller
                                    .proximaFase(
                                        widget.dificuldade, widget.nivel + 1);
                                if (widget.dificuldade == "Easy" &&
                                    nivelFacil < widget.nivel + 1) {
                                  await SharedPreferences.getInstance()
                                      .then((prefs) {
                                    prefs.setInt('facil', widget.nivel + 1);
                                  });
                                }
                                if (widget.dificuldade == "Medium" &&
                                    nivelMedio < widget.nivel + 1) {
                                  await SharedPreferences.getInstance()
                                      .then((prefs) {
                                    prefs.setInt('medio', widget.nivel + 1);
                                  });
                                }
                                if (widget.dificuldade == "Hard" &&
                                    nivelHard < widget.nivel + 1) {
                                  await SharedPreferences.getInstance()
                                      .then((prefs) {
                                    prefs.setInt('dificil', widget.nivel + 1);
                                  });
                                }
                                Get.offAllNamed("/transicao", arguments: {
                                  "sudoku": proxFase,
                                  "destino": "/destino"
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                              ),
                              child: Text(
                                "Próximo Nível",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                int nivelFacil = prefs.getInt("facil") ?? 1;
                                int nivelMedio = prefs.getInt("medio") ?? 1;
                                int nivelHard = prefs.getInt("dificil") ?? 1;
                                if (widget.dificuldade == "Easy" &&
                                    nivelFacil < widget.nivel + 1) {
                                  await SharedPreferences.getInstance()
                                      .then((prefs) {
                                    prefs.setInt('facil', widget.nivel + 1);
                                  });
                                }
                                if (widget.dificuldade == "Medium" &&
                                    nivelMedio < widget.nivel + 1) {
                                  await SharedPreferences.getInstance()
                                      .then((prefs) {
                                    prefs.setInt('medio', widget.nivel + 1);
                                  });
                                }
                                if (widget.dificuldade == "Hard" &&
                                    nivelHard < widget.nivel + 1) {
                                  await SharedPreferences.getInstance()
                                      .then((prefs) {
                                    prefs.setInt('dificil', widget.nivel + 1);
                                  });
                                }
                                Get.offAllNamed("/transicao", arguments: {
                                  "destino": "/menu",
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                              ),
                              child: Text(
                                "Voltar ao Menu",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 350,
          height: 350,
          color: Colors.grey[300],
          child: Column(
            children: List.generate(9, (rowIndex) {
              return Row(
                children: List.generate(9, (colIndex) {
                  final isHighlighted = (rowIndex ~/ 3 ==
                              widget.controller.selectedRow.value ~/ 3 &&
                          colIndex ~/ 3 ==
                              widget.controller.selectedCol.value ~/ 3) ||
                      rowIndex == widget.controller.selectedRow.value ||
                      colIndex == widget.controller.selectedCol.value;

                  final isGrayBlock = (rowIndex ~/ 3 + colIndex ~/ 3) % 2 == 0;

                  final cellValue = widget.currentMatrix[rowIndex][colIndex];

                  final isConflicting = _isConflicting(
                      widget.currentMatrix, rowIndex, colIndex, cellValue);

                  final isInitialValue =
                      widget.initialMatrix[rowIndex][colIndex] != 0;

                  return GestureDetector(
                    onTap: () {
                      if (!isInitialValue) {
                        setState(() {
                          widget.controller.selectedRow.value = rowIndex;
                          widget.controller.selectedCol.value = colIndex;
                        });
                      }
                    },
                    child: Container(
                      width: 38.8,
                      height: 38.8,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: isHighlighted
                            ? Colors.lightBlue[300]
                            : (isGrayBlock ? Colors.grey[400] : Colors.white),
                      ),
                      child: Center(
                        child: Text(
                          cellValue == 0 ? '' : cellValue.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: isConflicting
                                ? Colors.red
                                : isInitialValue
                                    ? Colors.grey[600]
                                    : Colors.black,
                            fontWeight: isInitialValue
                                ? FontWeight.w900
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
        NumberPad(
          onNumberPressed: (number) {
            setState(() {
              widget.controller
                  .updateSelectedCell(widget.currentMatrix, number);
              if (isSudokuCompleted()) {
                showCompletionDialog();
              }
            });
          },
          onClearPressed: () {
            setState(() {
              widget.controller.updateSelectedCell(widget.currentMatrix, 0);
            });
          },
        ),
      ],
    );
  }

  bool _isConflicting(List<List<int>> matrix, int row, int col, int value) {
    for (var i = 0; i < 9; i++) {
      if (matrix[row][i] == value && i != col) {
        return true;
      }
      if (matrix[i][col] == value && i != row) {
        return true;
      }
    }

    final boxRowStart = row - row % 3;
    final boxColStart = col - col % 3;

    for (var i = boxRowStart; i < boxRowStart + 3; i++) {
      for (var j = boxColStart; j < boxColStart + 3; j++) {
        if (matrix[i][j] == value && (i != row || j != col)) {
          return true;
        }
      }
    }

    return false;
  }
}

class NumberPad extends StatefulWidget {
  final Function(int) onNumberPressed;
  final Function() onClearPressed;

  const NumberPad(
      {super.key, required this.onNumberPressed, required this.onClearPressed});

  @override
  State<NumberPad> createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: List.generate(4, (rowIndex) {
          if (rowIndex < 3) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (colIndex) {
                final number = rowIndex * 3 + colIndex + 1;
                return GestureDetector(
                  onTap: () {
                    widget.onNumberPressed(number);
                  },
                  child: Container(
                    width: 38.8,
                    height: 38.8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        number.toString(),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                );
              }),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onClearPressed();
                  },
                  child: Container(
                    width: 38.8,
                    height: 38.8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.backspace,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
