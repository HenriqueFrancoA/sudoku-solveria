import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sudoku_solveria/models/banner_anuncio.dart';
import 'package:sudoku_solveria/models/sudoku.dart';

class TransicaoScreen extends StatefulWidget {
  const TransicaoScreen({Key? key}) : super(key: key);

  @override
  TransicaoScreenState createState() => TransicaoScreenState();
}

class TransicaoScreenState extends State<TransicaoScreen> {
  String telaDestino = Get.arguments['destino'] as String;
  Sudoku? sudoku = Get.arguments['sudoku'] as Sudoku?;
  InterstitialAd? interstitialAd;

  bool shouldShowAd = false;

  @override
  void initState() {
    super.initState();
    shouldShowAd = gerarChanceDeAnuncio();
    if (shouldShowAd && interstitialAd != null) {
      loadAd();
    }
    iniciarTransicao();
  }

  bool gerarChanceDeAnuncio() {
    int valorAleatorio = DateTime.now().millisecondsSinceEpoch % 100;
    return valorAleatorio < 10;
  }

  void loadAd() async {
    InterstitialAd.load(
      adUnitId: kReleaseMode
          ? BannerAnuncio.idEsticado
          : BannerAnuncio.testeIdEsticado,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          interstitialAd!.show();
        },
        onAdFailedToLoad: (error) {
          interstitialAd = null;
        },
      ),
    );
  }

  void iniciarTransicao() async {
    await Future.delayed(const Duration(milliseconds: 500));
    Get.offAllNamed(telaDestino, arguments: {"sudoku": sudoku});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 500),
          child: Center(),
        ),
      ),
    );
  }
}
