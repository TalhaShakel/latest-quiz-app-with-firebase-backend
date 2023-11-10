import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/pages/forgot_password.dart';
import 'package:quiz_app/pages/home.dart';
import 'package:quiz_app/pages/select_avatar.dart';
import 'package:quiz_app/pages/sign_up.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import 'package:quiz_app/utils/snackbars.dart';
import 'package:quiz_app/widgets/social_logins.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../blocs/ads_bloc.dart';
import '../blocs/settings_bloc.dart';
import '../blocs/user_bloc.dart';
import '../configs/color_config.dart';
import '../services/firebase_service.dart';
import '../utils/next_screen.dart';
import '../widgets/privacy_info.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginController = RoundedLoadingButtonController();
  final _googleController = RoundedLoadingButtonController();
  final _fbController = RoundedLoadingButtonController();
  final _appleController = RoundedLoadingButtonController();

  final TextEditingController _emailCtlr = TextEditingController();
  final TextEditingController _passCtlr = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obsecureText = true;
  Icon lockIcon = IconUtils.lockPassword;

  _onSuffixIconPressed() {
    if (_obsecureText == true) {
      setState(() {
        _obsecureText = false;
        lockIcon = IconUtils.openPassword;
      });
    } else {
      setState(() {
        _obsecureText = true;
        lockIcon = IconUtils.lockPassword;
      });
    }
  }

  Future _getRequiredData() async {
    await context.read<UserBloc>().getUserData()
    .then((value) => context.read<SettingsBloc>().getSettingsData()
    .then((value) => context.read<SettingsBloc>().getSpecialCategories()
    .then((value) => context.read<AdsBloc>().checkAds())));

    debugPrint('Data getting done');
  }

  _gotoHomeScreen() {
    Future.delayed(const Duration(seconds: 1)).then((value) => NextScreen().nextScreenReplace(context, const HomePage()));
  }

  _gotoSelectAvatarScreen(String userId) {
    Future.delayed(const Duration(seconds: 1)).then((value) => NextScreen().nextScreenReplace(context, SelectAvatar(userId: userId)));
  }

  _afterSignUpWithSocialAccount(UserCredential userCredential, RoundedLoadingButtonController btnCtlr) async {
    final int initialReward = await FirebaseService().getNewUserReward();
    final String newPointsHistory = 'New User Reward +$initialReward at ${DateTime.now()}';
    await FirebaseService()
        .saveUserData(
            userCredential.user!.uid, userCredential.user!.displayName ?? 'No Name', userCredential.user!.email ?? 'Not Given', null, initialReward)
        .then((value) async => await FirebaseService()
            .increaseUserCount()
            .then((value) async => await FirebaseService().updateUserPointHistory(userCredential.user!.uid, newPointsHistory)));
    btnCtlr.success();
    _gotoSelectAvatarScreen(userCredential.user!.uid);
  }

  _handleSignInWithGoogle() async {
    _googleController.start();
    await AuthService().signInWithGoogle().then((UserCredential? userCredential) async {
      if (userCredential != null) {
        await FirebaseService().checkUserExists(userCredential.user!.uid).then((bool userExist) async {
          if (!userExist) {
            _afterSignUpWithSocialAccount(userCredential, _googleController);
          } else {
            await _getRequiredData();
            _googleController.success();
            _gotoHomeScreen();
          }
        });
      }
    }).onError((error, stackTrace) {
      _googleController.reset();
      debugPrint('google login error: $error');
      openSnackbar(context, 'Error with google login. Please try again!');
    });
  }

  _handleSignInWithFacebook() async {
    _fbController.start();
    await AuthService().signInWithFacebook().then((UserCredential? userCredential) async {
      if (userCredential != null) {
        await FirebaseService().checkUserExists(userCredential.user!.uid).then((bool userExist) async {
          if (!userExist) {
            _afterSignUpWithSocialAccount(userCredential, _fbController);
          } else {
            await _getRequiredData();
            _fbController.success();
            _gotoHomeScreen();
          }
        });
      }
    }).onError((error, stackTrace) {
      _fbController.reset();
      debugPrint('fb login error: $error');
      openSnackbar(context, 'Error with facebook login. Please try again!');
    });
  }

  _handleSignInWithApple() async {
    _appleController.start();
    await AuthService().signInWithApple().then((UserCredential? userCredential) async {
      if (userCredential != null) {
        await FirebaseService().checkUserExists(userCredential.user!.uid).then((bool userExist) async {
          if (!userExist) {
            _afterSignUpWithSocialAccount(userCredential, _appleController);
          } else {
            await _getRequiredData();
            _appleController.success();
            _gotoHomeScreen();
          }
        });
      }
    }).onError((error, stackTrace) {
      _appleController.reset();
      debugPrint('apple login error: $error');
      openSnackbar(context, 'Error with apple login. Please try again!');
    });
  }

  _handleLoginWithEmail() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _loginController.start();
      try {
        await AuthService().loginWithEmailPassword(_emailCtlr.text, _passCtlr.text).then((UserCredential? userCredential) async {
          if (userCredential != null) {
            await _getRequiredData();
            _loginController.success();
            _gotoHomeScreen();
          }
        });
      } on FirebaseAuthException catch (e) {
        _loginController.reset();
        debugPrint('login error: ${e.code}');
        openSnackbar(context, 'Email/Password is invalid. Please try again!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.secondaryBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.grey[900],
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('login',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      )).tr(),
              SocialLogins(
                  onGooglePressed: _handleSignInWithGoogle,
                  onFbPressed: _handleSignInWithFacebook,
                  onApplePressed: _handleSignInWithApple,
                  googleBtnCtlr: _googleController,
                  fbBtnCtlr: _fbController,
                  appleBtnCtlr: _appleController),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: Text(
                  '-----OR-----',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConfig.bodyTextColor,
                      ),
                )),
              ),
              Container(
                color: Colors.white,
                child: TextFormField(
                  controller: _emailCtlr,
                  validator: (value) {
                    if (value!.isEmpty) return "Email can't be empty!";
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'email'.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      suffixIcon: IconButton(icon: const Icon(Icons.close), onPressed: () => _emailCtlr.clear())),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                child: TextFormField(
                  obscureText: _obsecureText,
                  controller: _passCtlr,
                  validator: (value) {
                    if (value!.isEmpty) return "Password can't be empty!";
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'password'.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      suffixIcon: IconButton(onPressed: _onSuffixIconPressed, icon: lockIcon)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text('forgot-password').tr(),
                    onPressed: () => NextScreen.nextScreenNormal(context, const ForgotPasswordPage()),
                  ),
                ],
              ),
              RoundedLoadingButton(
                animateOnTap: false,
                borderRadius: 5,
                controller: _loginController,
                onPressed: () => _handleLoginWithEmail(),
                width: MediaQuery.of(context).size.width * 1.0,
                color: Theme.of(context).primaryColor,
                elevation: 0,
                child: Wrap(
                  children: [
                    const Text(
                      'login',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ).tr()
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'no-account',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ).tr(),
                    TextButton(
                        child: Text(
                          'signup',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        onPressed: () => NextScreen().nextScreenReplace(context, const SignUpPage()))
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Center(child: PrivacyInfo())
            ],
          ),
        ),
      ),
    );
  }
}
