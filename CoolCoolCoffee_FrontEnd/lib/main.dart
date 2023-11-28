import 'package:coolcoolcoffee_front/page/camera/app_capture.dart';
import 'package:coolcoolcoffee_front/page/login/login_page.dart';
import 'package:coolcoolcoffee_front/page_state/page_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:coolcoolcoffee_front/notification/notification_global.dart';
import 'package:theme_provider/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  await NotificationGlobal.initializeNotifications();

  runApp(
      const ProviderScope(
          child: CoolCoolCoffee()
      )
  );
}


/*Future<void> main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}*/

class CoolCoolCoffee extends StatelessWidget {
  const CoolCoolCoffee({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      defaultThemeId: "조절모드",
      saveThemesOnChange: true,
      // loadThemeOnInit: true,
      themes: [
        AppTheme.light(id: "조절모드"),
        AppTheme(
          id: "밤샘모드",
          description: "밤샘모드",
          data: ThemeData(
            primaryColor: Colors.brown,
            hintColor: Colors.white,
          )
        )
      ],
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        // Do some other task here if you need to
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        }
      },
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) =>
              MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeProvider
                    .themeOf(themeContext)
                    .data,
                home: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.hasData && userSnapshot.data != null) {
                      NotificationGlobal.showDailyNotification();
                      return PageStates();
                    } else {
                      return LoginPage();
                    }
                  },
                ),

              ),
        ),
      ),
    );
  }
}