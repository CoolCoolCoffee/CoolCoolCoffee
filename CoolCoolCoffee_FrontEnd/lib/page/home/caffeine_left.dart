import 'dart:html';
import 'dart:math';

import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user_caffeine.dart';

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

  double formatTime(String time){
    bool isAM;
    if(time.contains('AM')) isAM= true;
    else isAM = false;
    var split = time.split(' ');
    var timeComponents = split[0].split(':');
    double hour = double.parse(timeComponents[0]);
    double min = double.parse(timeComponents[1])/60.0;
    double ret = double.parse((hour + min).toStringAsFixed(8));
    return ret;
  }
  Map<double,double> formatCaff(List<UserCaffeine> caff_list){
    Map<double,double> ret = {};
    for(int i = 0;i<caff_list.length;i++){
      var timeCompo = caff_list[i].drinkTime.split(':');
      double hour = double.parse(timeCompo[0]);
      double min = double.parse(timeCompo[1])/60.0;
      double drinkTime = double.parse((hour + min).toStringAsFixed(8));
      num caff = caff_list[i].caffeineContent;
      ret.addAll({drinkTime: caff.toDouble()});
      print(ret);
    }
    return ret;
  }
  void _showPopup(BuildContext context) {
    //H1 = h1+a*sin(2*pi*t)
    //H2 = h2+a*sin(2*pi*t)
    final prov = ref.watch(sleepParmaProvider.notifier);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if(prov.state.wake_time == ""|| prov.state.sleep_quality == -1){
          return AlertDialog(
            title: Text('카페인 반감기 그래프'),
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
        }
        else{
          double wake_time = formatTime(prov.state.wake_time);
          return AlertDialog(
            title: Text('카페인 반감기 그래프'),
            content: Container(
              width: double.maxFinite,
              height: 250,
              color: Colors.brown[100],
              child:
                LineChart(
                  duration: const Duration(milliseconds: 300),
                  LineChartData(
                    minX: 0,
                    maxX: 36,
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                        left: const BorderSide(color: Colors.transparent),
                        right: const BorderSide(color: Colors.transparent),
                        top: const BorderSide(color: Colors.transparent),
                      )
                    ),
                    titlesData: const FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottimTitleWidgets,
                          interval: 1,
                          reservedSize: 32,
                        )
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    lineBarsData: [
                      H1LineChartBarData(),
                    ]
                  )
                ),
             /* Center(
                child: Column(
                  children: [
                    for(int i = 0;i<prov.state.caff_list.length;i++)
                      Text(
                        '${prov.state.caff_list[i].drinkTime} : ${prov.state.caff_list[i].menuId} : ${prov.state.caff_list[i].caffeineContent}',
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
              ),*/
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
        }
      },
    );
  }
}
double timeMap(double t) {
  double C = 0.45145833333;
  if(t>24) t = t-24;
  if(t>10.835) t= t/24-C;
  else t=(t+24)/24 -C;
  return t;
}
LineChartBarData H1LineChartBarData() {
  double h1 = 0.75;
  double a = 0.09478;
  return LineChartBarData(
      isCurved: true,
      color: Colors.purple,
      barWidth: 6,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: [
        for(double t = 0;t<36;(t+0.1))
          FlSpot(t, h1+a*sin(2*pi*timeMap(t))),
      ]);
}

Widget bottimTitleWidgets(double value, TitleMeta meta){
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey
  );
  Widget text;
  switch (value.toInt()){
    case 5:
      text = const Text('5', style: style,);
      break;
    case 10:
      text = const Text('10',style: style,);
      break;
    case 15:
      text = const Text('15',style: style,);
      break;
    case 20:
      text = const Text('15',style: style,);
      break;
    case 25:
      text = const Text('15',style: style,);
      break;
    case 30:
      text = const Text('15',style: style,);
      break;
    case 35:
      text = const Text('15',style: style,);
      break;
    default:
      text = const Text('');
      break;
  }
  return SideTitleWidget(child: text, space: 5,axisSide: meta.axisSide);

}