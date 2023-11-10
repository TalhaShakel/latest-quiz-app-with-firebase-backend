import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/configs/feature_config.dart';
import 'package:quiz_app/pages/login.dart';
import 'package:quiz_app/pages/sign_up.dart';
import 'package:quiz_app/utils/next_screen.dart';
import 'package:quiz_app/widgets/language.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  _onLogin() {
    NextScreen.nextScreenNormal(context, const LoginPage());
  }

  _onSignUp() {
    NextScreen.nextScreenNormal(context, const SignUpPage());
  }

  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottmBar(context),
      body: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: PageView(
                  controller: _pageController,
                  children: [
                    IntroView(color: Config.intros[1]![0], imageDir: Config.intros[1]![1], title: 'intro-title1'),
                    IntroView(color: Config.intros[2]![0], imageDir: Config.intros[2]![1], title: 'intro-title2'),
                    IntroView(color: Config.intros[3]![0], imageDir: Config.intros[3]![1], title: 'intro-title3'),
                  ],
                ),
              ),
              Visibility(
                visible: FeatureConfig.multiLanguageEnabled,
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      padding: const EdgeInsets.only(right: 15, top: 10),
                      icon: const Icon(
                        LineIcons.language,
                        color: Colors.white,
                      ),
                      onPressed: () => NextScreen().nextScreenPopup(context, const LanguagePopup()),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: Config.intros.length,
              effect: WormEffect(activeDotColor: Theme.of(context).primaryColor, dotColor: Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }

  Container _bottmBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
      //color: Colors.green,
      child: Wrap(
        children: [
          SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.resolveWith((states) => Size(MediaQuery.of(context).size.width * 0.42, 40)),
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                      shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 12))),
                  onPressed: _onLogin,
                  child: Text(
                    'login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ).tr(),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor),
                      minimumSize: MaterialStateProperty.resolveWith((states) => Size(MediaQuery.of(context).size.width * 0.42, 40)),
                      shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 12))),
                  onPressed: _onSignUp,
                  child: const Text(
                    'signup',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ).tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IntroView extends StatelessWidget {
  const IntroView({Key? key, required this.color, required this.imageDir, required this.title}) : super(key: key);

  final Color color;
  final String imageDir;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          color: color,
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.65,
          width: double.infinity,
          child: SvgPicture.asset(
            imageDir,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            height: 400,
            width: 200,
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(40, 30, 40, 20),
          child: AutoSizeText(
            title.tr(),
            presetFontSizes: const [23.0, 22.0],
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 93, 64, 64)),
          ),
        )
      ],
    );
  }
}
