import 'package:flutter/material.dart';
import 'package:flutter_application_2/BiometricService.dart';
import 'package:flutter_application_2/Securestorg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secure_application/secure_application.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;
  @override
  State<MainPage> createState() => _MainpageState();
}

class _MainpageState extends State<MainPage> {
  BiometricsService biometric =
      BiometricsService(localAuthentication: LocalAuthentication());
  String _text = '';
  bool failedAuth = false;
  double blurr = 20;
  double opacity = 0.6;

  void changeText(String text) {
    setState(() {
      _text = text;
    });
  }
@override
  void initState() {
      Securestorg.read().then((value) => setState(() { _text=value?? 'void';
      if(value=='Захист ввімкнено'){
         SecureApplicationProvider.of(context, listen: false)
                            ?.lock();
      }
      }));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SecureApplication(
      nativeRemoveDelay: 100,
      autoUnlockNative: true,
      child: Builder(builder: (context) {
        return SecureGate(
          blurr: blurr,
          opacity: opacity,
          lockedBuilder: (context, secureNotifier) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                child: const Text('Виключити захист'),
                onPressed: () {
                  secureNotifier?.authSuccess(unlock: true);
                  changeText('Захист вимкнено');
                  Securestorg.write('Захист вимкнено');
                },
              ),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text(
                widget.title,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _text,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      child: const Text('Заблокувати'),
                      onPressed: () {
                        changeText('Заблоковано');
                         Securestorg.write('Заблоковано');
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      child:  const Text('Розблокувати'),
                      onPressed: () async {
                        if (await biometric.isFingerPrintEnabled) {
                          await biometric.authenticateWithFingerPrint();
                        } else {
                          debugPrint('Немає відбитку пальця');
                        }
                        changeText('Аутентифікація');
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      child: const Text('Включити захист'),
                      onPressed: () {
                        SecureApplicationProvider.of(context, listen: false)
                            ?.lock();
                        changeText('Захист ввімкнено');
                         Securestorg.write('Захист ввімкнено');
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}