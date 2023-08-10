import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solveria/screens/game/game_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';
import 'package:sudoku_solveria/screens/loading/loading_screen.dart';
import 'package:sudoku_solveria/screens/menu/menu_screen.dart';
import 'package:sudoku_solveria/screens/transicao/transicao_screen.dart';
import 'package:sudoku_solveria/shared/themes/themes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  int dicas = prefs.getInt("dicas") ?? 2;
  int lastDay = prefs.getInt("lastDay") ?? 0;
  int currentDay = DateTime.now().day;
  if (currentDay != lastDay && dicas < 2) {
    prefs.setInt("lastDay", currentDay);
    prefs.setInt("dicas", 2);
  }

  initializeDateFormatting('pt_BR', null).then((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    runApp(const Main());
  });
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          key: UniqueKey(),
          themeMode: ThemeMode.light,
          theme: lightTheme,
          debugShowCheckedModeBanner: false,
          home: const LoadingScreen(),
          getPages: [
            GetPage(
              name: '/game',
              page: () => const GameScreen(),
            ),
            GetPage(
              name: '/menu',
              page: () => const MenuScreen(),
            ),
            GetPage(
              name: '/transicao',
              page: () => const TransicaoScreen(),
            ),
          ],
        );
      },
    );
  }
}
