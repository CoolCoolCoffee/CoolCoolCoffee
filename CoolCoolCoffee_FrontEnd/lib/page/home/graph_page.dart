import 'dart:async';
import 'dart:math';

import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:coolcoolcoffee_front/provider/user_caffeine_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user_caffeine.dart';

class GraphPage extends ConsumerStatefulWidget {
  const GraphPage({super.key});

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends ConsumerState<GraphPage> {
  final H1Points = <FlSpot>[];
  final H2Points = <FlSpot>[];
  final SleepPoints = <FlSpot>[];

  late Timer timer;
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(sleepParmaProvider);
    });
    setHGraph();
  }
  void setHGraph(){
    double t = 0;
    double step = 0.25;
    double h1 = 0.75;
    double h2 = 0.2469;
    double a = 0.09478;

    timer = Timer.periodic(const Duration(milliseconds: 5), (timer) {
      if(t>40) timer.cancel();
      setState((){
        H1Points.add(FlSpot(t, h1 + a * sin(2 * pi * timeMap(t))));
        H2Points.add(FlSpot(t, h2 + a * sin(2 * pi * timeMap(t))));
        if(calSleepGraph(t) != null) SleepPoints.add(calSleepGraph(t)!);
      });
      t+=step;
    });
  }
  FlSpot? calSleepGraph(double t){
    double h2 = 0.2469;
    double a = 0.09478;
    double tired_scale = 0.01;
    double ret = 0;
    var prov = ref.watch(sleepParmaProvider.notifier);
    var tiredness = prov.state.sleep_quality * tired_scale;
    var user_wake_time = formatTime(prov.state.wake_time);
    var tw = prov.state.tw;
    var half_time = prov.state.half_time;
    var caff_list = formatCaff(prov.state.caff_list);
    var user_t0 = timeMap(user_wake_time);
    double caff_threshold = 50 * 0.0012;
    double caff = 0;
    if(t<user_wake_time) return null;

    var user_wake_h_graph = h2 + a * sin(2 * pi * timeMap(user_wake_time));
    var r_t = (timeMap(t) - user_t0);
    if(r_t>1) r_t -=1;
    if(r_t<0) r_t+=1;
    for(var key in caff_list.keys){
      caff += double.parse(calCaff(caff_list[key]!, key, t, half_time.toDouble()).toStringAsFixed(8));
    }
    print(caff);
    if(caff <=caff_threshold)
      ret = 1-(1-user_wake_h_graph)*exp(-r_t/tw) +tiredness;
    else
      ret = 1-1-(1-user_wake_h_graph)*exp(-r_t/tw) +tiredness - caff;
    return FlSpot(t, ret);
  }
  double calCaff(double caffeine, double eat_time,double now,double half_time){
    print("caff : $caffeine");
    double scaling = 0.0012;
    double scaled_caff = caffeine *scaling;
    double ret = 0;
    if(now<eat_time) return ret;
    if(now>=eat_time && now<=(eat_time + 1)) {
      ret = (scaled_caff)*(now-eat_time);
    } else {
      ret = scaled_caff * pow(0.5,((now - eat_time)/half_time));
    }
    return ret;
  }
  @override
  Widget build(BuildContext context) {
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
      body: H1Points.isNotEmpty ?
      Center(
        child: AspectRatio(aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.only(top:20, bottom: 20),
            child: LineChart(
              LineChartData(
                minX: H1Points.first.x,
                maxX: H1Points.last.x,
                lineTouchData: LineTouchData(enabled: false),
                clipData: FlClipData.all(),
                borderData:  FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey),
                      left: const BorderSide(color: Colors.transparent),
                      right: const BorderSide(color: Colors.transparent),
                      top: const BorderSide(color: Colors.transparent),
                    )
                ),
                titlesData: FlTitlesData(show: false),
                lineBarsData: [
                  h1Line(H1Points),
                  h2Line(H2Points),
                  sleepLine(SleepPoints),
                ]
              )
            ),
          ),
        ),
      )
      :Center(
        child:retGoalSleepTime(context),
      ),
    );
  }
  LineChartBarData h1Line(List<FlSpot> points){
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      color: Colors.purple,
      barWidth: 5,
      isCurved: true,
    );
  }
  LineChartBarData h2Line(List<FlSpot> points){
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      color: Colors.blue,
      barWidth: 5,
      isCurved: true,
    );
  }
  LineChartBarData sleepLine(List<FlSpot> points){
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      color: Colors.greenAccent,
      barWidth: 5,
      isCurved: true,
    );
  }
  Widget retGoalSleepTime(BuildContext context){
    String goal_sleep_time = "";
    final prov = ref.watch(sleepParmaProvider.notifier);
    goal_sleep_time = prov.state.goal_sleep_time;
    
    return Text(goal_sleep_time);
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
    }
    return ret;
  }
  double timeMap(double t) {
    double C = 0.45145833333;
    if(t>24) t = t-24;
    if(t>10.835) t= t/24-C;
    else t=(t+24)/24 -C;
    return t;
  }
  /*LineChartBarData h1LineChartBarData() {

    return LineChartBarData(
        isCurved: true,
        color: Colors.purple,
        barWidth: 6,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          for(double t = 0;t<36;(t+0.1))
            ),
        ]);
  }*/
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
}
