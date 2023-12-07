
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/function/mode_color.dart';
import 'package:coolcoolcoffee_front/provider/alarm_permission_provider.dart';
import 'package:coolcoolcoffee_front/provider/color_mode_provider.dart';
import 'package:coolcoolcoffee_front/provider/long_term_noti_provider.dart';
import 'package:coolcoolcoffee_front/provider/short_term_noti_provider.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../service/user_caffeine_service.dart';
import 'caffeine_left.dart';
import 'drink_list.dart';
import 'clock.dart';
import 'package:coolcoolcoffee_front/page/home/longterm_popup_A.dart';
import 'package:coolcoolcoffee_front/page/home/longterm_popup_B.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:coolcoolcoffee_front/notification/notification_global.dart';

import '../menu/menu_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();
  DateFormat dayFormatter = DateFormat('yyyy-MM-dd');
  String date = '';

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(alarmPermissionProvider);
      _requestNotificationPermissions();
    });
    _initializeSleepParam();
  }

  void _requestNotificationPermissions() async {
    //알림 권한 요청
    final status = await NotificationGlobal().requestNotificationPermissions();
    print('허용함??? ${ref.watch(alarmPermissionProvider).isPermissioned} 오늘 이미 뜸?? ${ref.watch(alarmPermissionProvider).isToday}');
    if(status.isGranted){
      ref.watch(alarmPermissionProvider.notifier).setIsPermissioned(true);
      return;
    }
    //오늘 보냈었냐??
    if (ref.watch(alarmPermissionProvider).isToday) {
      return;
    }
    if (status.isDenied && context.mounted) {
      ref.watch(alarmPermissionProvider.notifier).setIsPermissioned(false);
      //오늘 이미 보냈다잉
      ref.watch(alarmPermissionProvider.notifier).setPermissionDay(true);
      showDialog(
        // 알림 권한이 거부되었을 경우 다이얼로그 출력
        context: context,
        builder: (context) => AlertDialog(
          title: Text('알림 권한이 거부되었습니다.'),
          content: Text('알림을 받으려면 앱 설정에서 권한을 허용해야 합니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('설정'), //다이얼로그 버튼의 죄측 텍스트
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); //설정 클릭시 권한설정 화면으로 이동
              },
            ),
            TextButton(
              child: Text('취소'), //다이얼로그 버튼의 우측 텍스트
              onPressed: () {
                Navigator.of(context).pop();
              }, //다이얼로그 닫기
            ),
          ],
        ),
      );
    }
  }

  Future<void> _initializeSleepParam() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DateTime today = DateTime.now();
    int now_hour = today.hour;
    String todaydate = today.toLocal().toIso8601String().split('T')[0];
    DateTime yesterday = today.subtract(Duration(days: 1));
    String yesterdaydate = yesterday.toLocal().toIso8601String().split('T')[0];
    DocumentSnapshot<Map<String, dynamic>> userSleepDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(todaydate).get();

    DocumentSnapshot<Map<String, dynamic>> yesUserSleepDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(yesterdaydate).get();
    bool isToday = userSleepDoc.exists && userSleepDoc.data()!.containsKey('wake_time')&&userSleepDoc.data()!.containsKey('sleep_quality_score');
    bool isYesterday = yesUserSleepDoc.exists&&yesUserSleepDoc.data()!.containsKey('wake_time')&&yesUserSleepDoc.data()!.containsKey('sleep_quality_score');

    if(now_hour>=6&&!isToday){
      ref.watch(sleepParmaProvider.notifier).changeWakeTime("");
      ref.watch(sleepParmaProvider.notifier).changeSleepQuality(-1);
      ref.watch(shortTermNotiProvider.notifier).setPredictSleepTime('');
      ref.watch(sleepParmaProvider.notifier).setIsAllSet(false);
    }
    else if(isToday){
      ref.watch(sleepParmaProvider.notifier).changeWakeTime(userSleepDoc['wake_time']);
      ref.watch(sleepParmaProvider.notifier).changeSleepQuality(userSleepDoc['sleep_quality_score']);
      ref.watch(sleepParmaProvider.notifier).setIsAllSet(true);
      ref.watch(sleepParmaProvider.notifier).setIsToday(true);
    }
    //오늘 꺼가 없으면 어제꺼로
    else if(isYesterday){
      ref.watch(sleepParmaProvider.notifier).changeWakeTime(yesUserSleepDoc['wake_time']);
      ref.watch(sleepParmaProvider.notifier).changeSleepQuality(yesUserSleepDoc['sleep_quality_score']);
      ref.watch(sleepParmaProvider.notifier).setIsAllSet(true);
      ref.watch(sleepParmaProvider.notifier).setIsToday(false);
    }
    else{
      ref.watch(sleepParmaProvider.notifier).changeWakeTime("");
      ref.watch(sleepParmaProvider.notifier).changeSleepQuality(-1);
      ref.watch(sleepParmaProvider.notifier).setIsAllSet(false);
    }
    if(ref.watch(sleepParmaProvider).isToday){
      setState(() {
        now = today;
      });
    }else{
      setState(() {
        now = yesterday;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    //DateFormat timeFormatter = DateFormat('HH:mm:ss');
    date = dayFormatter.format(now);
    UserCaffeineService userCaffeineService = UserCaffeineService();
    userCaffeineService.checkExits(date);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ref.watch(colorModeProvider).isControlMode ? modeColor.controlModeColor['background_color']:modeColor.noSleepModeColor['background_color'],
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '쿨쿨 커피',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 24
            ),
          ),
          actions: [         // 조절, 밤샘 모드 선택 토글
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: ToggleSwitch(
                minWidth: 50.0,
                initialLabelIndex: ref.watch(colorModeProvider).selectedIndex,
                cornerRadius: 10.0,
                activeFgColor: Colors.white,
                activeBgColors: [[Colors.brown.withOpacity(0.4)], const [Colors.brown]],
                inactiveFgColor: Colors.white,
                inactiveBgColor: Colors.grey.withOpacity(0.8),
                totalSwitches: 2,
                customTextStyles: const [
                  TextStyle(
                      overflow: TextOverflow.visible, fontSize: 18, inherit: false, fontFamily: 'KNPSKkomi')
                ],
                labels: [
                  "조절",
                  "밤샘",
                ],
                onToggle: (index) {
                  setState(() {
                    ref.watch(colorModeProvider.notifier).switchMode(index!);
                    ref.watch(colorModeProvider.notifier).switchIndex(index);
                    ref.watch(shortTermNotiProvider.notifier).switchMode(index);
                  });
                },
              ),
            ),
          ],
          toolbarHeight: 50,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClockWidget(),
              SizedBox(height: 10),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Users').doc(userCaffeineService.uid).collection('user_caffeine').doc(date).snapshots(),
                  builder: (context,snapshot){
                    print('좀 바뀌어라 ㅅㅂ');
                    return CaffeineLeftWidget(snapshots: snapshot,);
                  }),
              SizedBox(height: 20),
              DrinkListWidget(),
            ],
          ),
        )
    );
  }
}
