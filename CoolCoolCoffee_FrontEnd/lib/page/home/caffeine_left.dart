import 'dart:math';

import 'package:coolcoolcoffee_front/page/home/graph_page.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user_caffeine.dart';
import '../../page_state/page_state.dart';
import '../sleep/sleep_page.dart';

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
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white ,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: widget.isControlMode? Colors.grey.withOpacity(0.3) : Colors.grey.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
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
                        SizedBox(height: 10),
                        Text(
                          '230/320 (mg)',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 90,
                    height: 80,
                    child: ElevatedButton(
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
                        backgroundColor: Color(0xff93796A),
                        // minimumSize: const Size(5, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '그래프',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
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
            backgroundColor: Colors.white,
            title: const Center(child: Text('수면욕구 그래프', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),)),
            content: Container(
              padding: const EdgeInsets.all(10),
              width: double.maxFinite,
              height: 250,
              color: Color(0xffF9F8F7),
              child:
              const Center(
                child: Text('수면 정보를 업데이트 해주세요!', style: TextStyle(fontSize: 18),)
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('닫기', style: TextStyle(color: Colors.black),),
              ),
            ],
          );
      },
    );
  }
}
