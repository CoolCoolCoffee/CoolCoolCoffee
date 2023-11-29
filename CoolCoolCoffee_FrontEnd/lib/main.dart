import 'package:coolcoolcoffee_front/page/camera/app_capture.dart';
import 'package:coolcoolcoffee_front/page/login/login_page.dart';
import 'package:coolcoolcoffee_front/page_state/page_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:coolcoolcoffee_front/notification/notification_global.dart';

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
    return MaterialApp(
            theme: ThemeData(
                primarySwatch: Colors.brown,
            ),
            debugShowCheckedModeBanner: false,
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
    );
  }
}