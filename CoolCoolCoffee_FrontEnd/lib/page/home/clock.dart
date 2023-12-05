import 'package:coolcoolcoffee_front/function/mode_color.dart';
import 'package:coolcoolcoffee_front/provider/color_mode_provider.dart';
import 'package:coolcoolcoffee_front/provider/short_term_noti_provider.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPopup extends StatefulWidget {
  final Function(String) onSave;
  final void Function(String) updateParentState;
  final String sleepTime;

  const EditPopup({
    Key? key,
    required this.onSave,
    required this.updateParentState,
    required this.sleepTime, // Add sleepTime parameter to the constructor
  }) : super(key: key);

  @override
  _EditPopupState createState() => _EditPopupState();
}

class _EditPopupState extends State<EditPopup> {
  TextEditingController sleepHoursController = TextEditingController();
  TextEditingController sleepMinutesController = TextEditingController();

  bool sleepIsAM = true;
  bool isCancelled = false;

  @override
  void initState() {
    super.initState();
    // Set initial values for controllers based on sleepTime and wakeTime
    List<String> sleepTimeParts = widget.sleepTime.split(':');
    if (sleepTimeParts.length == 2) {
      sleepHoursController.text = sleepTimeParts[0];
      List<String> minutesAndAMPM = sleepTimeParts[1].split(' ');
      if (minutesAndAMPM.length == 2) {
        sleepMinutesController.text = minutesAndAMPM[0];
        sleepIsAM = minutesAndAMPM[1] == 'AM';
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    List<bool> _isSelected = [sleepIsAM, !sleepIsAM];
    void toggleSelect(value) {
      print(value);

      if(value == 0){
        sleepIsAM = true;
      } else{
        sleepIsAM = false;
      }

      setState(() {
        _isSelected = [sleepIsAM, !sleepIsAM];
        print(_isSelected);
      });
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(child: Text('목표 취침 시간을 입력해주세요', style: TextStyle(fontSize: 18),)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    ToggleButtons(
                        direction: Axis.vertical,
                        isSelected: _isSelected,
                        onPressed: toggleSelect,
                        selectedColor: Colors.white,
                        fillColor: Colors.brown.withOpacity(0.6),
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        constraints: const BoxConstraints(
                          minHeight: 45.0,
                          minWidth: 60.0,
                        ),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('AM', style: TextStyle(fontSize: 20),),),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('PM', style: TextStyle(fontSize: 20),),),
                        ]
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      width: 60,
                      height: 60,
                      child: TextField(
                        controller: sleepHoursController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '시',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Text(' : ', style: TextStyle(fontSize: 20),),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      width: 60,
                      height: 60,
                      child: TextField(
                        controller: sleepMinutesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '분',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            isCancelled = true;
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(60, 40),
          ),
          child: Text('취소', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),),
        ),
        TextButton(
          onPressed: () async {
            String sleepEnteredTime =
                '${sleepHoursController.text}:${sleepMinutesController.text} ${sleepIsAM ? 'AM' : 'PM'}';

            List<String> timeComponents = sleepEnteredTime.split(':');
            int hours = int.parse(timeComponents[0]);
            if (!sleepIsAM && hours < 12) {
              hours += 12;
            } else if (sleepIsAM && hours == 12) {
              hours = 0;
            }
            String convertedTime = '$hours:${timeComponents[1]}';
            convertedTime = convertedTime.replaceAll(RegExp(r'\s?[APMapm]{2}\s?$'), '');

            String uid = FirebaseAuth.instance.currentUser!.uid;
            DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(uid);
            bool docExists = (await userDocRef.get()).exists;

            Future<void> updateFirestore() async {
              try {
                if (docExists) {
                  // 필드 있으면 goal_sleep_time 필드를 업데이트
                  await userDocRef.update({
                    'goal_sleep_time': convertedTime,
                  });
                } else {
                  // 필드 없으면 만들어 업데이트
                  await userDocRef.set({
                    'goal_sleep_time': convertedTime,
                  });
                }
                widget.updateParentState(sleepEnteredTime);

                Navigator.of(context).pop();
              } catch (error) {
                print('error : $error');
              }
            }
            updateFirestore();
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(60, 40),
          ),
          child: Text('입력', style: TextStyle(fontSize: 24, color: Color(0xff93796A), fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }
}


class ClockWidget extends ConsumerStatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends ConsumerState<ClockWidget>{
  String sleepEnteredTime = '';
  String resultText = '';

  @override
  void initState() {
    super.initState();
    _getSleepEnteredTime();
    //여기서부터 추가
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(sleepParmaProvider);
      ref.watch(shortTermNotiProvider);
      if(ref.watch(sleepParmaProvider.notifier).state.goal_sleep_time.isNotEmpty){
        setState(() {});
      }
    });
  }

  Future<void> _getSleepEnteredTime() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists && userDoc.data()!.containsKey('goal_sleep_time')) {

        String storedTime = userDoc['goal_sleep_time'];

        List<String> timeComponents = storedTime.split(':');
        int hours = int.parse(timeComponents[0]);
        String minutes = timeComponents[1];

        String amPm = (hours >= 12) ? 'PM' : 'AM';

        if (hours > 12) {
          hours -= 12;
        }

        String formattedTime = '$hours:$minutes $amPm';
        print(formattedTime);
        setState(() {
          sleepEnteredTime = formattedTime;

          ref.watch(sleepParmaProvider.notifier).changeGoalSleepTime(sleepEnteredTime);
          ref.watch(shortTermNotiProvider.notifier).setGoalSleepTime(sleepEnteredTime);

          ref.watch(sleepParmaProvider.notifier).changeTw(userDoc['tw']);
          ref.watch(sleepParmaProvider.notifier).changeHalfTime(userDoc['caffeine_half_life']);
        });
      } else {
        print('error1');
      }
    } catch (e) {
      print('error2 : $e');
    }
  }

  @override
  Widget build(BuildContext context){
    final prov = ref.watch(sleepParmaProvider);
    final short_term = ref.watch(shortTermNotiProvider);

    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (prov.goal_sleep_time.isEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              if (prov.goal_sleep_time.isEmpty)
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: "목표 수면 시간을 설정해주세요.",
                    style: TextStyle(
                      color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['black_color']:modeColor.noSleepModeColor['white_color'],
                      fontSize: 20,
                    ),
                  ),
                ),
              //Sized침Box(width: 55),
              ElevatedButton(
                onPressed: () {
                  _showEditPopup(context);
                  print("dddd $sleepEnteredTime");
                },
                style: ElevatedButton.styleFrom(
                  primary: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit, // 연필 아이콘
                      color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['main_color']:modeColor.noSleepModeColor['main_color'],
                      size: 18,

                    ),
                    const SizedBox(width: 3),
                    Text(
                      prov.goal_sleep_time.isNotEmpty
                          ? '수정'
                          : '설정',
                      style: TextStyle(
                        color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['main_color']:modeColor.noSleepModeColor['main_color'],
                        fontSize: 17,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Stack(
            children: [
              Container(
                height: 300,
                width: 300,
                margin: const EdgeInsets.only(top:20, bottom: 20),
                child: Image.asset('assets/coffee.png'),
              ),
              Positioned(
                left: 90,
                top: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      //'취침 시간\n $sleepEnteredTime',
                      prov.goal_sleep_time.isNotEmpty
                          ? '목표 취침 시간'
                          : '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      //'취침 시간\n $sleepEnteredTime',
                      prov.goal_sleep_time.isNotEmpty
                          ? '${prov.goal_sleep_time}'
                          : '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // 수정 아이콘
                    if (prov.goal_sleep_time.isEmpty == false)
                    ElevatedButton(
                      onPressed: () {
                        _showEditPopup(context);
                        print("dddd $sleepEnteredTime");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit, // 연필 아이콘
                            color: Colors.black,
                            size: 18,

                          ),
                          const SizedBox(width: 3),
                          Text(
                            prov.goal_sleep_time.isNotEmpty
                                ? '수정'
                                : '설정',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
        )
        // Container(
        //   margin: const EdgeInsets.all(10),
        //   width: 250,
        //   height: 250,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['main_color']:modeColor.noSleepModeColor['main_color'],
        //   ),
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           //'취침 시간\n $sleepEnteredTime',
        //           prov.goal_sleep_time.isNotEmpty
        //               ? '목표 취침 시간\n     ${prov.goal_sleep_time}'
        //               : '아직 목표 취침시간이 설정되지 않았네요!\n 목표 취침시간을 설정해볼까요?',
        //           style: TextStyle(
        //             color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['white_color']:modeColor.noSleepModeColor['black_color'],
        //             fontSize: 20,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

//시간 수정 팝업
  void _showEditPopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPopup(
          onSave: (sleepTime) {
          },
          updateParentState: (sleepTime) {
            setState(() {
              sleepEnteredTime = sleepTime;
              ref.watch(sleepParmaProvider.notifier).changeGoalSleepTime(sleepEnteredTime);
            });
          },
          sleepTime: sleepEnteredTime,
        );
      },
    );
  }
}