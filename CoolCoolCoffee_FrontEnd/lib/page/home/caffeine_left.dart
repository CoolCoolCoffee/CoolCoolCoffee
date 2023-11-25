import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaffeineLeftWidget extends ConsumerStatefulWidget {
  const CaffeineLeftWidget({Key? key}) : super(key: key);

  @override
  _CaffeineLeftWidgetState createState() => _CaffeineLeftWidgetState();
}

class _CaffeineLeftWidgetState extends ConsumerState<CaffeineLeftWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '체내 잔여 카페인 양',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '230/320 (mg)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _showPopup(context); // 버튼을 누르면 팝업 창 표시
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                minimumSize: Size(5, 90),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '그래프',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    final prov = ref.watch(sleepParmaProvider.notifier);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('카페인 반감기 그래프'),
          content: Container(
            width: double.maxFinite,
            height: 200,
            color: Colors.brown[100],
            child: Center(
              child: Column(
                children: [
                  for(int i = 0;i<prov.state.caff_list.length;i++)
                    Text(
                      prov.state.caff_list[i].menuId,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  Text(
                    prov.state.sleep_quality.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    prov.state.wake_time,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    prov.state.tw.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    prov.state.goal_sleep_time,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}