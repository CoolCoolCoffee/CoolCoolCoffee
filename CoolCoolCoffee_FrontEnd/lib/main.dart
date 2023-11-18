import 'package:coolcoolcoffee_front/page/camera/app_capture.dart';
import 'package:coolcoolcoffee_front/page/login/login_page.dart';
import 'package:coolcoolcoffee_front/page_state/page_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // 로그인 상태 유지 -> authStateChanges로 감지해서 Stream으로 상태 확인하는 걸로 바꿈
  // final auth = FirebaseAuth.instanceFor(app: Firebase.app(), persistence: Persistence.NONE);
  // await auth.setPersistence(Persistence.LOCAL);

  runApp(
      ProviderScope(
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
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(scaffoldBackgroundColor: Colors.brown.withOpacity(0.1)),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if(userSnapshot.hasData && userSnapshot.data != null){
            return PageStates();
          } else{
            return LoginPage();
          }
        },
      ),
    );
  }
}
