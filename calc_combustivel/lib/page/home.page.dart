import 'dart:async';

import 'package:calccombustivel/widgets/logo.widget.dart';
import 'package:calccombustivel/widgets/submit-form.dart';
import 'package:calccombustivel/widgets/sucess.widget.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
//import 'package:admob_flutter/admob_flutter.dart';
import 'package:calccombustivel/services/admob_service.dart';
import 'package:calccombustivel/admob_flutter.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final ams = AdMobService();
  Color _color = Colors.deepPurple;
  var _busy = false;
  var _completed = false;
  var _resultText = "Compensa utilizar álcool";
  var _gasCtrl = new MoneyMaskedTextController();
  var _alcCtrl = new MoneyMaskedTextController();


  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();
  int _coins = 0;
  final _nativeAdController = NativeAdmobController();
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        targetingInfo: targetingInfo,
        adUnitId: 'ca-app-pub-6747634137249077/3482927431',
        listener: (MobileAdEvent event) {
          print('interstitial event: $event');
        });
  }

  BannerAd createBannerAdd() {
    return BannerAd(
        targetingInfo: targetingInfo,
        adUnitId: 'ca-app-pub-6747634137249077/5090523460',
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) {
          print('Bnner Event: $event');
        });
  }


  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 10), () {
      _bannerAd?.show();
    });
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AnimatedContainer(
        duration: Duration(
          milliseconds: 2000,
        ),
        color: _color,
        child: ListView(
          children: <Widget>[
            Logo(),

            _completed
                ? Succes(
              result: _resultText,
              reset: reset,
            )
                : SubmitForm(
              alcCtrl: _alcCtrl,
              gasCtrl: _gasCtrl,
              busy: _busy,
              submitFunc: calculate,
            ),

          ],
        ),

      ),
    );
  }

  Future calculate() {
    double alc =
        double.parse(_alcCtrl.text.replaceAll(new RegExp(r'[,.]'), '')) / 100;
    double gas =
        double.parse(_gasCtrl.text.replaceAll(new RegExp(r'[,.]'), '')) / 100;
    double res = alc / gas;

    setState(() {
      _color = Colors.deepPurpleAccent;
      _completed = false;
      _busy = true;
    });

    return new Future.delayed(
        const Duration(seconds: 2),
            () => {

          setState(() {
            if (res >= 0.7) {
              _resultText = "Compensa utilizar Gasolina!";
            } else {
              _resultText = "Compensa utilizar Álcool!";
            }

            _busy = false;
            _completed = true;
          })
        });
  }

  reset() {
    setState(() {
      _color = Colors.deepPurple;
      _alcCtrl = new MoneyMaskedTextController();
      _gasCtrl = new MoneyMaskedTextController();
      _completed = false;
      _busy = false;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-6747634137249077~3595727631');
    _bannerAd = createBannerAdd()..load();
    _interstitialAd = createInterstitialAd()..load();
    RewardedVideoAd.instance.load(
        adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print('Rewarded event: $event');
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
      }
    };
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }
}
