import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sudoku_solveria/controllers/sudoku_controller.dart';
import 'package:sudoku_solveria/models/sudoku.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  String selectedDifficulty = 'Fácil';
  int nivelFacil = 0;
  int nivelMedio = 0;
  int nivelHard = 0;
  bool nivelDisponivel = false;
  int nivelFinalizado = 0;
  RxInt botaoSelecionado = 0.obs;
  final sudokuController = Get.put(SudokuBoardController());
  BannerAd? myBanner;

  Map<String, int> difficultyLevels = {
    'Fácil': 20,
    'Médio': 100,
    'Difícil': 100,
  };

  obterNiveis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nivelFacil = prefs.getInt("facil") ?? 1;
    nivelMedio = prefs.getInt("medio") ?? 1;
    nivelHard = prefs.getInt("dificil") ?? 1;
  }

  @override
  void initState() {
    obterNiveis();
    myBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-4824022930012497/9367619593",
      // 'ca-app-pub-3940256099942544/6300978111', //online-> 'ca-app-pub-4824022930012497/9367619593',
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
    super.initState();
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
          title: Text(
            "SudokuSolveria",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Escolha um nível: ",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDifficultyButton(context, 'Fácil', "Easy", 1),
                  _buildDifficultyButton(context, 'Médio', "Medium", 2),
                  _buildDifficultyButton(context, 'Difícil', "Hard", 3),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                width: queryData.size.width * 0.9,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Obx(
                  () => botaoSelecionado.value == 0
                      ? Container()
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 0.5.h,
                            crossAxisSpacing: 0.5.h,
                          ),
                          itemCount: sudokuController.niveis.length,
                          itemBuilder: (context, index) {
                            Sudoku sudoku = sudokuController.niveis[index];
                            if (sudoku.difficulty == "Easy" &&
                                sudoku.nivel > nivelFacil) {
                              nivelDisponivel = false;
                            } else if (sudoku.difficulty == "Medium" &&
                                sudoku.nivel > nivelMedio) {
                              nivelDisponivel = false;
                            } else if (sudoku.difficulty == "Hard" &&
                                sudoku.nivel > nivelHard) {
                              nivelDisponivel = false;
                            } else {
                              nivelDisponivel = true;
                              if (sudoku.difficulty == "Easy") {
                                nivelFinalizado = nivelFacil;
                              } else if (sudoku.difficulty == "Medium") {
                                nivelFinalizado = nivelMedio;
                              } else if (sudoku.difficulty == "Hard") {
                                nivelFinalizado = nivelHard;
                              }
                            }
                            return GestureDetector(
                              onTap: nivelDisponivel
                                  ? () {
                                      Get.toNamed("/transicao", arguments: {
                                        "sudoku": sudoku,
                                        "destino": "/game",
                                      });
                                    }
                                  : null,
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: nivelDisponivel
                                      ? BorderSide.none
                                      : const BorderSide(color: Colors.grey),
                                ),
                                color: !nivelDisponivel
                                    ? Colors.grey
                                    : nivelFinalizado > sudoku.nivel
                                        ? Colors.green[400]
                                        : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Center(
                                        child: Text(
                                          "${sudoku.nivel}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                      ),
                                      !nivelDisponivel
                                          ? const Icon(
                                              Icons.lock,
                                              size: 15,
                                            )
                                          : nivelFinalizado > sudoku.nivel
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 15,
                                                )
                                              : const Icon(
                                                  Icons.lock_open,
                                                  size: 15,
                                                ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
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

  Widget _buildDifficultyButton(BuildContext context, String difficulty,
      String dificuldade, int numeroBotao) {
    return ElevatedButton(
      onPressed: () {
        sudokuController.obterFases(dificuldade);
        setState(() {
          botaoSelecionado.value = numeroBotao;
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: numeroBotao == botaoSelecionado.value
            ? Colors.black
            : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
      child: Text(
        difficulty,
        style: numeroBotao == botaoSelecionado.value
            ? Theme.of(context).textTheme.bodyMedium
            : Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
