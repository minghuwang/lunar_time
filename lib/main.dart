import 'package:lunar_calendar/lunar_calendar.dart';
import 'package:flutter/material.dart';
import 'package:lunar_time/GanZhiDay.dart';
import 'JieQi.dart';
import 'TianGanDiZhi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() : super();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '时辰',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '当日时辰'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<int> lunarTimeDigital;
  List<String> lunarTimeString;

  DateTime currentSolarTime;
  String currentHour;
  String currentMin;
  String currentSec;

  String ganZhiYear;
  int jieQiMonth; // 可以直接转成干支月的阴历月
  String ganZhiMonth; // 从jieQiMonth转过来的
  String ganZhiDay;
  String ganZhiHour;

  // For date picker
  DateTime selectedDate = DateTime.now();
  // For time picker
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectGanZhiYear;
  String selectGanZhiMonth;
  String selectGanZhiDay;
  String selectGanZhiHour;// = changeSolar2ganZhiHour(selectedTime.hour);
  List<String> selectLunarTimeString;

  var tianGanDiZhi = new TianGanDiZhi();
  var jieQi = new JieQi(); //节气用来计算干支月
  var myGanZhiDay = new GanZhiDay();



  void getCurrentTime() async {
    // testGanZhiYear();
    // tiangandizhi.testGanZhiMonth();
    // jieQi.testGetJieQiStartDay();
    // jieQi.testGetMonthFirstJieQiDayFromTable();
    // First time need to be running to avoid null point
    // as in while it has 1 second delay to flush
    currentSolarTime = DateTime.now();
    prepareCurrentDate(currentSolarTime);
    while(true) {
      await new Future.delayed(const Duration(seconds: 1));
      currentSolarTime = DateTime.now();
      prepareCurrentDate(currentSolarTime);
      setState(() {
        ganZhiHour = changeSolar2ganZhiHour(currentSolarTime.hour);

        currentHour = currentSolarTime.hour.toString();
        if (currentSolarTime.hour < 10) {
          currentHour = "0" + currentHour;
        }
        currentMin = currentSolarTime.minute.toString();
        if (currentSolarTime.minute < 10) {
          currentMin = "0" + currentMin;
        }
        currentSec = currentSolarTime.second.toString();
        if (currentSolarTime.second < 10) {
          currentSec = "0" + currentSec;
        }
      });
    }
  }

  // Create this function for avoiding dup code only
  void prepareCurrentDate(DateTime solarTime) {
    lunarTimeDigital = CalendarConverter.solarToLunar(
        solarTime.year, solarTime.month, solarTime.day, Timezone.Chinese);
    lunarTimeString = transferDigit2Chinese(lunarTimeDigital);
    ganZhiYear = tianGanDiZhi.initGanZhiStringYear(tianGanDiZhi.initGanZhiIntYear(solarTime.year, solarTime.month, solarTime.day));
    var jieQiStartDay = jieQi.getMonthFirstJieQiDayFromTable(solarTime.year, solarTime.month);
    jieQiMonth = jieQi.getJieQiMonth(solarTime.month, jieQiStartDay, solarTime.day);
    ganZhiMonth = tianGanDiZhi.getGanZhiMonth(jieQiMonth);
    ganZhiDay = myGanZhiDay.getGanZhiDay(solarTime.year, solarTime.month, solarTime.day);

  }
  void prepareSelectedDate(DateTime selectedDate) {
    var selectLunarTimeDigital = CalendarConverter.solarToLunar(
        selectedDate.year, selectedDate.month, selectedDate.day, Timezone.Chinese);
    selectLunarTimeString = transferDigit2Chinese(selectLunarTimeDigital);
    selectGanZhiYear = tianGanDiZhi.initGanZhiStringYear(tianGanDiZhi.initGanZhiIntYear(selectedDate.year, selectedDate.month, selectedDate.day));
    var jieQiStartDay = jieQi.getMonthFirstJieQiDayFromTable(selectedDate.year, selectedDate.month);
    var jieQiMonth = jieQi.getJieQiMonth(selectedDate.month, jieQiStartDay, selectedDate.day);
    selectGanZhiMonth = tianGanDiZhi.getGanZhiMonth(jieQiMonth);
    selectGanZhiDay = myGanZhiDay.getGanZhiDay(selectedDate.year, selectedDate.month, selectedDate.day);
  }

  String changeSolar2ganZhiHour(int solarHour) {
    List<String> ganZhiHour = [
      "子时", "丑时", "寅时", "卯时",
      "辰时", "巳时", "午时", "未时",
      "申时", "酉时", "戌时", "亥时",
    ];
    if (solarHour >= 23 || solarHour < 1) return ganZhiHour[0];
    if (solarHour >= 1 && solarHour < 3) return ganZhiHour[1];
    if (solarHour >= 3 && solarHour < 5) return ganZhiHour[2];
    if (solarHour >= 5 && solarHour < 7) return ganZhiHour[3];
    if (solarHour >= 7 && solarHour < 9) return ganZhiHour[4];
    if (solarHour >= 9 && solarHour < 11) return ganZhiHour[5];
    if (solarHour >= 11 && solarHour < 13) return ganZhiHour[6];
    if (solarHour >= 13 && solarHour < 15) return ganZhiHour[7];
    if (solarHour >= 15 && solarHour < 17) return ganZhiHour[8];
    if (solarHour >= 17 && solarHour < 19) return ganZhiHour[9];
    if (solarHour >= 19 && solarHour < 21) return ganZhiHour[10];
    if (solarHour >= 21 && solarHour < 23) return ganZhiHour[11];
  }
  //Transfer 2021 to 二零二一
  List<String> transferDigit2Chinese(List<int> lunarTime) {
    List<String> l = [];
    l.add(changeDigit2ChineseStringForMonthNDay(lunarTime[0])); // day
    l.add(changeDigit2ChineseStringForMonthNDay(lunarTime[1])); //month
    l.add(changeDigit2ChineseStringForYear(lunarTime[2])); //year
    return l;
  }

  String changeDigit2ChineseStringForMonthNDay(int time) {
    List<String> zeroTo31 = [
      // 零 is stub
      "零", "一", "二", "三", "四", "五", "六", "七", "八", "九",
      "十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九",
      "二十", "二十一", "二十二", "二十三", "二十四", "二十五", "二十六", "二十七", "二十八", "二十九",
      "三十", "三十一",
    ];
    return zeroTo31[time];
  }

  String changeDigit2ChineseStringForYear(int time) {
    List<String> zero2nine = [
      "零", "一", "二", "三", "四", "五", "六", "七", "八", "九",
    ];

    String sTime = time.toString();
    List<String> list;
    String tmp = "";
    for (var i = 0; i < sTime.length; i++) {
      tmp += (zero2nine[int.parse(sTime[i])]);
    }
    return tmp;
  }

  String getGanZhiStringYear() {
    return ganZhiYear;
  }

  @override
  Widget build(BuildContext context) {
    getCurrentTime();
    prepareSelectedDate(selectedDate);
    selectGanZhiHour = changeSolar2ganZhiHour(selectedTime.hour);
        return DefaultTabController(
        length: 3,
        child:Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                // Tab(icon: Icon(Icons.directions_car)),
                Tab(text:"当日时辰"),
                // Tab(icon: Icon(Icons.directions_transit)),
                Tab(text:"时辰"),
                // Tab(icon: Icon(Icons.directions_bike)),
                Tab(text: "其他"),
              ],
            ),
            title: Text("蔡竺螢国学院"),
          ),
          body: TabBarView(
            children: [
              currentGanZhi(),
              selectedGanZhi(),
              Icon(Icons.directions_bike),
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: getCurrentTime,
          //   tooltip: '刷新',
          //   child: Icon(Icons.refresh
          //   ),),

        ));// This trailing comma makes auto-formatting nicer for build methods.
  }

  Widget currentGanZhi() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('现在时辰',style: TextStyle(color: Colors.black,fontSize:30 ), ),
          Text('\n公历: ${currentSolarTime.year}年${currentSolarTime.month}月${currentSolarTime.day}日$currentHour:$currentMin:$currentSec',style: TextStyle(color: Colors.black54,fontSize:20), ),
          Text('\n农历: ${lunarTimeString[2]}年${lunarTimeString[1]}月${lunarTimeString[0]}日',style: TextStyle(color: Colors.black54,fontSize:20), ),
          Text('\n${getGanZhiStringYear()}年$ganZhiMonth月$ganZhiDay日',style: TextStyle(color: Colors.black54,fontSize:20), ),
          Text('\n$ganZhiHour',style: TextStyle(color: Colors.black54,fontSize:20),),
        ],
      ),
    );
  }
  Widget selectedGanZhi() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child:ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text("选择阳历日期", style: TextStyle(fontSize:20),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child:ElevatedButton(
                  onPressed: () {
                    _selectTime(context);
                  },
                  child: Text("选择时间", style: TextStyle(fontSize:20),),
                ),
              ),
            ],
          ),
          (() { if (selectedDate != null) {
            return Text('\n公历: ${selectedDate.year}年${selectedDate.month}月${selectedDate.day}日${selectedTime.hour}:${selectedTime.minute}',
              style: TextStyle(color: Colors.black54,fontSize:20), );}
            else{ return Text('');}
          }()),
          (() { if (selectLunarTimeString != null) {
            return Text('\n农历: ${selectLunarTimeString[2]}年${selectLunarTimeString[1]}月${selectLunarTimeString[0]}日',
              style: TextStyle(color: Colors.black54,fontSize:20), );}
            else{ return Text('');}
          }()),
          (() { if (selectGanZhiYear != null) {
            return Text('\n$selectGanZhiYear年$selectGanZhiMonth月$selectGanZhiDay日',
              style: TextStyle(color: Colors.black54,fontSize:20), );}
            else{ return Text('');}
          }()),
          (() {
            if (selectGanZhiHour != null) {
            return Text('\n$selectGanZhiHour',style: TextStyle(color: Colors.black54,fontSize:20),);}
            else{ return Text('');}
          }()),
    // Todo
        ],
      ),
    );
  }
  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1901),
      lastDate: DateTime(2099),

    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        prepareSelectedDate(selectedDate);
      });
  }
  _selectTime(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
        selectGanZhiHour = changeSolar2ganZhiHour(selectedTime.hour);
      });
    }
  }

}
