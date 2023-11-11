import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'package:coolcoolcoffee_front/page/login/user_form_first_page.dart';
import 'package:coolcoolcoffee_front/page_state/page_state.dart';
import 'package:coolcoolcoffee_front/provider/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserProvider(),),
          // 다른 provider 추가하기
          ],
          child: const CoolCoolCoffee()
      ),
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
    return const MaterialApp(
      //theme: ThemeData(primarySwatch: ),
      home: UserFormFirstPage(),
    );
  }
}
