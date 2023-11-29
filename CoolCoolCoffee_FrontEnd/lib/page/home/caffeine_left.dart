import 'dart:math';

import 'package:coolcoolcoffee_front/page/home/graph_page.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user_caffeine.dart';

class CaffeineLeftWidget extends ConsumerStatefulWidget {
  final bool isControlMode;
  const CaffeineLeftWidget({Key? key, required this.isControlMode}) : super(key: key);

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
              width: MediaQuery.of(context).size.width - 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white ,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                  ElevatedButton(
                    onPressed: () {
                      final prov = ref.watch(sleepParmaProvider.notifier);
                      if(prov.state.wake_time == ""|| prov.state.sleep_quality == -1) {
                        _showPopup(context);
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>GraphPage()));
                      }
                      // 버튼을 누르면 팝업 창 표시
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isControlMode ? Color(0xff93796A) : Color(0xffF9F8F7),
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
                          color: widget.isControlMode ? Colors.white : Colors.black,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '그래프',
                          style: TextStyle(
                            color: widget.isControlMode ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('카페인 반감기 그래프'),
            content: Container(
              width: double.maxFinite,
              height: 250,
              color: Colors.brown[100],
              child:
              Center(
                child: Text('오늘의 수면 정보를 업데이트 해주세요!')
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
