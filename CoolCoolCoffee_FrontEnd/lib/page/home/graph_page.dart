import 'dart:async';
import 'dart:math';

import 'package:coolcoolcoffee_front/function/sleep_cal_functions.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:coolcoolcoffee_front/provider/user_caffeine_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/sleep_param.dart';
import '../../model/user_caffeine.dart';

class GraphPage extends ConsumerStatefulWidget {
  const GraphPage({super.key, required this.bedTime});
  final String bedTime;
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends ConsumerState<GraphPage> {
  final h1Points = <FlSpot>[];
  final h2Points = <FlSpot>[];
  final sleepPoints = <FlSpot>[];
  double predictSleepTime = 0;
  double goalSleepTime = 0;
  String bedTime ='';
  late Timer timer;
  late SleepParam provider;
  bool initFin = false;
  SleepCalFunc sleepCalFunc = SleepCalFunc();
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = ref.watch(sleepParmaProvider);
    });
    setHGraph();
  }
  void setHGraph(){
    double t = 0;
    double step = 0.1666666;
    double h1 = 0.75;
    double h2 = 0.2469;
    double a = 0.09478;
    int count = 0;

    timer = Timer.periodic(const Duration(milliseconds: 5), (timer) {
      if(t>36) {
        timer.cancel();
        initFin = true;
      }
      if(t>3){
        setState((){
          h1Points.add(FlSpot(t, 100 *(h1 + a * sin(2 * pi * sleepCalFunc.timeMap(t)))));
          h2Points.add(FlSpot(t, 100 * (h2 + a * sin(2 * pi * sleepCalFunc.timeMap(t)))));
          if(calSleepGraph(t) != null) {
            sleepPoints.add(calSleepGraph(t)!);
          }
        });
      }
      t+=step;
      count++;
      if(count%6 == 0) t = t.ceilToDouble();
    });
    bedTime = widget.bedTime;
  }

  @override
  Widget build(BuildContext context) {
    final prov = ref.watch(sleepParmaProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('카페인 - 수면 그래프'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: initFin ?
      Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(margin: EdgeInsets.only(top: 20),),
                Row(
                  children: [
                    Container(margin:EdgeInsets.only(left:20,right: 10),width: 30,height: 2,color: Colors.greenAccent,),
                    Text('수면 욕구 그래프',style: TextStyle(fontSize: 20),),
                  ],
                ),
                Row(
                  children: [
                    Container(margin:EdgeInsets.only(left:20,right: 10),width: 30,height: 2,color: Colors.blue,),
                    Text('생체리듬 그래프',style: TextStyle(fontSize: 20)),
                  ],
                ),
                Row(
                  children: [
                    Container(margin:EdgeInsets.only(left:20,right: 10),width: 30,height: 2,color: Colors.blue,),
                    Text('와',style: TextStyle(fontSize: 20)),
                    Container(margin:EdgeInsets.only(left:20,right: 10),width: 30,height: 2,color: Colors.greenAccent,),
                    Text('사이의 간격 : 피로 누적 정도',style: TextStyle(fontSize: 20)),
                  ],
                ),
                Row(
                  children: [
                    Container(margin:EdgeInsets.only(left:20,right: 10),width: 30,height: 2,color: Colors.purple,),
                    Text('과',style: TextStyle(fontSize: 20)),
                    Container(margin:EdgeInsets.only(left:20,right: 10),width: 30,height: 2,color: Colors.greenAccent,),
                    Text('가 만나는 지점 : 예상 수면 시간',style: TextStyle(fontSize: 20)),
                  ],
                ),
                Container(margin: EdgeInsets.only(top: 20),),
              ],
            ),
          ),
          AspectRatio(aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.only(top:20, bottom: 20),
              child: LineChart(
                LineChartData(
                  minX: h1Points.first.x,
                  maxX: h1Points.last.x,
                  lineTouchData: LineTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (value){
                        int count = 0;
                        return value.map((e){
                          if(count == 1){
                            count++;
                            return LineTooltipItem(sleepCalFunc.setPredictedBedTime(e.x), TextStyle(fontSize: 15));
                          }
                          else{
                            count++;
                            return LineTooltipItem('', TextStyle(fontSize: 5));
                          }
                        }).toList();
                      },
                      tooltipBgColor: Colors.blueGrey.withOpacity(0.3),
                    ),
                  ),
                  borderData:  FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                        left: const BorderSide(color: Colors.transparent),
                        right: const BorderSide(color: Colors.transparent),
                        top: const BorderSide(color: Colors.transparent),
                      )
                  ),
                  titlesData: FlTitlesData(
                      show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottimTitleWidgets
                      )
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)
                    ),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)
                    ),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)
                    ),
                  ),
                  lineBarsData: [
                    h1Line(h1Points),
                    h2Line(h2Points),
                    sleepLine(sleepPoints),
                  ]
                )
              ),
            ),
          ),
        ],
      )
      :Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            children: [
              CircularProgressIndicator(backgroundColor: Colors.grey.withOpacity(0.2),),
              SizedBox(
                height: 20,
              ),
              Text(
                '수면 그래프 분석중...',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
  FlSpot? calSleepGraph(double t){
    double h2 = 0.2469;
    double a = 0.09478;
    double tired_scale = 0.01;
    double ret = 0;

    var prov = ref.watch(sleepParmaProvider.notifier);
    var tiredness = prov.state.sleep_quality * tired_scale;
    var user_wake_time = sleepCalFunc.formatTime(prov.state.wake_time);
    var tw = prov.state.tw;
    var half_time = prov.state.half_time;
    var caff_list = sleepCalFunc.formatCaff(prov.state.caff_list);
    var user_t0 = sleepCalFunc.timeMap(user_wake_time);

    double caff_threshold = 50 * 0.0012;
    double caff = 0;
    if(t<user_wake_time) return null;

    var user_wake_h_graph = h2 + a * sin(2 * pi * sleepCalFunc.timeMap(user_wake_time));
    var r_t = (sleepCalFunc.timeMap(t) - user_t0);
    if(r_t<0) r_t+=1;
    if(t>=user_wake_time+24) r_t+=1;
    for(var key in caff_list.keys){
      caff += double.parse(sleepCalFunc.calCaff(caff_list[key]!, key, t, half_time.toDouble()).toStringAsFixed(8));
    }
    if(caff <=caff_threshold) {
      ret = 1-(1-user_wake_h_graph)*exp(-r_t/tw) +tiredness;
    } else {
      ret = 1-(1-user_wake_h_graph)*exp(-r_t/tw) +tiredness - caff;
    }
    ret = ret*100;
    return FlSpot(t, ret);
  }

  LineChartBarData h1Line(List<FlSpot> points){
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      color: Colors.purple,
      barWidth: 3,
      isCurved: true,
    );
  }
  LineChartBarData h2Line(List<FlSpot> points){
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      color: Colors.blue,
      barWidth: 3,
      isCurved: true,
    );
  }
  LineChartBarData sleepLine(List<FlSpot> points){
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      color: Colors.greenAccent,
      barWidth: 3,

      //isCurved: true,
    );
  }


  Widget bottimTitleWidgets(double value, TitleMeta meta){
    const style = TextStyle(
      fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.grey
    );
    Widget text;
    switch (value){
      case 5.0:
        text = const Text('5AM', style: style,);
        break;
      case 10.0:
        text = const Text('10AM',style: style,);
        break;
      case 15.0:
        text = const Text('3PM',style: style,);
        break;
      case 20.0:
        text = const Text('8PM',style: style,);
        break;
      case 25.0:
        text = const Text('1AM',style: style,);
        break;
      case 30.0:
        text = const Text('6AM',style: style,);
        break;
      case 35.0:
        text = const Text('11AM',style: style,);
        break;
      default:
        text = const Text('');
        break;
    }
    return SideTitleWidget(child: text, space: 5,axisSide: meta.axisSide);

  }
}
