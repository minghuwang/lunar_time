import 'package:flutter/material.dart';

import 'ganZhiDay.dart';
import 'jieQi.dart';
import 'lunar_solar_converter.dart';
import 'tianGanDiZhi.dart';

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
      home: MyHomePage(title: "当日时辰"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, String? title}) : super(key: key);

  String title = "当日时辰";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // List<int> lunarTimeDigital;
  static List<String> lunarTimeString = [];
  // static String? lunarTimeString;

  static DateTime? currentSolarTime;
  static String? currentHour;
  static String? currentMin;
  static String? currentSec;

  static String? ganZhiYear;
  static int? jieQiMonth; // 可以直接转成干支月的阴历月
  static String? ganZhiMonth; // 从jieQiMonth转过来的
  static String? ganZhiDay;
  static String? ganZhiHour;

  // For date picker
  static DateTime selectedSolarDate = DateTime.now();
  static DateTime selectedLunarDate =
      DateTime.now(); // the initial selected lunar date is not useful just a stub to avoid panic
  // For time picker
  static TimeOfDay selectedTime = TimeOfDay.now();
  static String? selectGanZhiYear;
  static String? selectGanZhiMonth;
  static String? selectGanZhiDay;
  static String? selectGanZhiHour;
  static List<String> selectLunarTimeString = [];
  // static String? selectLunarTimeString;

  var tianGanDiZhi = new TianGanDiZhi();
  var jieQi = new JieQi(); //节气用来计算干支月
  var myGanZhiDay = new GanZhiDay();
  @override
  void initState() {
    super.initState();
    currentSolarTime = DateTime.now();
    getCurrentSolarDate(currentSolarTime!);
    getSelectedSolarDate(currentSolarTime!);
    selectGanZhiHour = changeSolar2ganZhiHour(selectedTime.hour);
    getCurrentTime();
  }

  void getCurrentTime() async {
    // testGanZhiYear();
    // tiangandizhi.testGanZhiMonth();
    // jieQi.testGetJieQiStartDay();
    // jieQi.testGetMonthFirstJieQiDayFromTable();
    // First time need to be running to avoid null point
    // as in while it has 1 second delay to flush
    print("getCurrentTime is called ++++++++++++++++++++++++++++++");

    while (true) {
      await new Future.delayed(const Duration(seconds: 1));
      currentSolarTime = DateTime.now();
      getCurrentSolarDate(currentSolarTime!);
      setState(() {
        ganZhiHour = changeSolar2ganZhiHour(currentSolarTime!.hour);

        currentHour = currentSolarTime!.hour.toString();
        if (currentSolarTime!.hour < 10) {
          currentHour = "0" + currentHour!;
        }
        currentMin = currentSolarTime!.minute.toString();
        if (currentSolarTime!.minute < 10) {
          currentMin = "0" + currentMin!;
        }
        currentSec = currentSolarTime!.second.toString();
        if (currentSolarTime!.second < 10) {
          currentSec = "0" + currentSec!;
        }
      });
    }
  }

  // Create this function for avoiding dup code only
  static void getCurrentSolarDate(DateTime mySolarTime) {
    // lunarTimeDigital = CalendarConverter.solarToLunar(
    //     solarTime.year, solarTime.month, solarTime.day, Timezone.Chinese);
    var solarTime = Solar(
        solarYear: currentSolarTime!.year,
        solarMonth: currentSolarTime!.month,
        solarDay: currentSolarTime!.day);
    Lunar myLunarTime = LunarSolarConverter.solarToLunar(solarTime);
    // lunarTimeString = myLunarTime.toString(); //transferDigit2Chinese(myLunarTime);
    lunarTimeString = transferDigit2Chinese(myLunarTime);
    ganZhiYear = TianGanDiZhi.initGanZhiStringYear(
        TianGanDiZhi.initGanZhiIntYear(mySolarTime.year, mySolarTime.month, mySolarTime.day));
    var jieQiStartDay = JieQi.getMonthFirstJieQiDayFromTable(mySolarTime.year, mySolarTime.month);
    jieQiMonth = JieQi.getJieQiMonth(mySolarTime.month, jieQiStartDay, mySolarTime.day);
    ganZhiMonth = TianGanDiZhi.getGanZhiMonth(jieQiMonth!);
    ganZhiDay = GanZhiDay.getGanZhiDay(mySolarTime.year, mySolarTime.month, mySolarTime.day);
  }

  // This is for electing date/time
  static void getSelectedSolarDate(DateTime mySelectedSolarDate) {
    // var selectLunarTimeDigital = CalendarConverter.solarToLunar(
    //     mySelectedSolarDate.year, mySelectedSolarDate.month, mySelectedSolarDate.day, Timezone.Chinese);
    var selectSolarTime = Solar(
        solarYear: mySelectedSolarDate.year,
        solarMonth: mySelectedSolarDate.month,
        solarDay: mySelectedSolarDate.day);
    Lunar myLunarTime = LunarSolarConverter.solarToLunar(selectSolarTime);
    selectLunarTimeString = transferDigit2Chinese(myLunarTime);
    // selectLunarTimeString = myLunarTime.toString(); // transferDigit2Chinese(myLunarTime);
    selectGanZhiYear = TianGanDiZhi.initGanZhiStringYear(TianGanDiZhi.initGanZhiIntYear(
        mySelectedSolarDate.year, mySelectedSolarDate.month, mySelectedSolarDate.day));
    var jieQiStartDay =
        JieQi.getMonthFirstJieQiDayFromTable(mySelectedSolarDate.year, mySelectedSolarDate.month);
    var jieQiMonth =
        JieQi.getJieQiMonth(mySelectedSolarDate.month, jieQiStartDay, mySelectedSolarDate.day);
    selectGanZhiMonth = TianGanDiZhi.getGanZhiMonth(jieQiMonth);
    selectGanZhiDay = GanZhiDay.getGanZhiDay(
        mySelectedSolarDate.year, mySelectedSolarDate.month, mySelectedSolarDate.day);
  }

  // This is for election lunar data/time
  static void getSelectedLunarDate(DateTime mySelectedLunarDate) {
    // var selectLunarTimeDigital = CalendarConverter.solarToLunar(
    //     mySelectedLunarDate.year, mySelectedLunarDate.month, mySelectedLunarDate.day, Timezone.Chinese);
    Lunar myLunarTime = Lunar(
        lunarYear: mySelectedLunarDate.year,
        lunarMonth: mySelectedLunarDate.month,
        lunarDay: mySelectedLunarDate.day,
        isLeap: (mySelectedLunarDate.year % 4 == 0));
    selectLunarTimeString = transferDigit2Chinese(myLunarTime);
    // selectLunarTimeString = myLunarTime.toString(); // transferDigit2Chinese(myLunarTime);
    Solar mySolarTime = LunarSolarConverter.lunarToSolar(myLunarTime);
    //when selecting a lunar, the solar time should also be updated. lunar decides solar.
    selectedSolarDate = mySolarTime.dateTime;
    selectGanZhiYear = TianGanDiZhi.initGanZhiStringYear(TianGanDiZhi.initGanZhiIntYear(
        selectedSolarDate.year, selectedSolarDate.month, selectedSolarDate.day));
    var jieQiStartDay =
        JieQi.getMonthFirstJieQiDayFromTable(mySolarTime.solarYear, mySolarTime.solarMonth);
    var jieQiMonth =
        JieQi.getJieQiMonth(mySolarTime.solarMonth, jieQiStartDay, mySolarTime.solarDay);
    selectGanZhiMonth = TianGanDiZhi.getGanZhiMonth(jieQiMonth);
    selectGanZhiDay =
        GanZhiDay.getGanZhiDay(mySolarTime.solarYear, mySolarTime.solarMonth, mySolarTime.solarDay);
  }

  static String changeSolar2ganZhiHour(int solarHour) {
    List<String> ganZhiHour = [
      "子时",
      "丑时",
      "寅时",
      "卯时",
      "辰时",
      "巳时",
      "午时",
      "未时",
      "申时",
      "酉时",
      "戌时",
      "亥时",
    ];

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
    if (solarHour >= 23 || solarHour < 1) return ganZhiHour[0];
    // cannot be here
    return "";
  }

  //Transfer 2021 to 二零二一
  static List<String> transferDigit2Chinese(Lunar lunarTime) {
    List<String> l = [];
    l.add(changeDigit2ChineseStringForDay(lunarTime.lunarDay)); // day
    l.add(changeDigit2ChineseStringForMonth(lunarTime.lunarMonth)); //month
    l.add(changeDigit2ChineseStringForYear(lunarTime.lunarYear)); //year
    return l;
  }

  static String changeDigit2ChineseStringForMonth(int time) {
    List<String> zeroTo12 = [
      // 零 is stub
      "零", "正", "二", "三", "四", "五", "六", "七", "八", "九",
      "十", "十一", "腊",
    ];
    return zeroTo12[time];
  }

  static String changeDigit2ChineseStringForDay(int time) {
    List<String> zeroTo31 = [
      // 零 is stub
      "零", "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九",
      "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九",
      "二十", "二十一", "二十二", "二十三", "二十四", "二十五", "二十六", "二十七", "二十八", "二十九",
      "三十", "三十一",
    ];
    return zeroTo31[time];
  }

  static String changeDigit2ChineseStringForYear(int time) {
    List<String> zero2nine = [
      "零",
      "一",
      "二",
      "三",
      "四",
      "五",
      "六",
      "七",
      "八",
      "九",
    ];

    String sTime = time.toString();
    List<String> list;
    String tmp = "";
    for (var i = 0; i < sTime.length; i++) {
      tmp += (zero2nine[int.parse(sTime[i])]);
    }
    return tmp;
  }

  String? getGanZhiStringYear() {
    return ganZhiYear;
  }

  @override
  Widget build(BuildContext context) {
    // getCurrentTime();
    // prepareSelectedSolarDate(selectedSolarDate);
    // selectGanZhiHour = changeSolar2ganZhiHour(selectedTime.hour);
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              labelColor: Colors.pink,
              tabs: [
                // Tab(icon: Icon(Icons.directions_car)),
                Tab(text: "当日时辰"),
                // Tab(icon: Icon(Icons.directions_transit)),
                Tab(text: "时辰"),
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
        )); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Widget currentGanZhi() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '现在时辰',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          Text(
            '\n公历: ${currentSolarTime!.year}年${currentSolarTime!.month}月${currentSolarTime!.day}日'
            '$currentHour:$currentMin:$currentSec',
            style: TextStyle(color: Colors.black54, fontSize: 20),
          ),
          Text(
            '\n农历: ${lunarTimeString[2]}年${lunarTimeString[1]}月${lunarTimeString[0]}日',
            style: TextStyle(color: Colors.black54, fontSize: 20),
          ),
          // Text(
          //   '\n农历: $lunarTimeString',
          //   style: TextStyle(color: Colors.black54, fontSize: 20),
          // ),
          Text(
            '\n${getGanZhiStringYear()}年$ganZhiMonth月$ganZhiDay日',
            style: TextStyle(color: Colors.black54, fontSize: 20),
          ),
          Text(
            '\n$ganZhiHour',
            style: TextStyle(color: Colors.black54, fontSize: 20),
          ),
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
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5, right: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _selectSolarDate(context);
                      },
                      child: Text(
                        "选择阳历日期",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _selectLunarDate(context);
                      },
                      child: Text(
                        "选择阴历日期",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      child: Text(
                        "选择时间",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          (() {
            if (selectedSolarDate != null) {
              return Text(
                '\n公历: ${selectedSolarDate.year}年${selectedSolarDate.month}月${selectedSolarDate.day}日'
                '${selectedTime.hour}:${selectedTime.minute}',
                style: TextStyle(color: Colors.black54, fontSize: 20),
              );
            } else {
              return Text('');
            }
          }()),
          (() {
            if (selectLunarTimeString != null) {
              return Text(
                // '\n农历: $selectLunarTimeString',
                '\n农历: ${selectLunarTimeString[2]}年${selectLunarTimeString[1]}月${selectLunarTimeString[0]}日',
                style: TextStyle(color: Colors.black54, fontSize: 20),
              );
            } else {
              return Text('');
            }
          }()),
          (() {
            if (selectGanZhiYear != null) {
              return Text(
                '\n$selectGanZhiYear年$selectGanZhiMonth月$selectGanZhiDay日',
                style: TextStyle(color: Colors.black54, fontSize: 20),
              );
            } else {
              return Text('');
            }
          }()),
          (() {
            if (selectGanZhiHour != null) {
              return Text(
                '\n$selectGanZhiHour',
                style: TextStyle(color: Colors.black54, fontSize: 20),
              );
            } else {
              return Text('');
            }
          }()),
          // Todo
        ],
      ),
    );
  }

  _selectSolarDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedSolarDate,
      firstDate: DateTime(1901),
      lastDate: DateTime(2099),
    );
    if (selected != null && selected != selectedSolarDate)
      setState(() {
        selectedSolarDate = selected;
        getSelectedSolarDate(selectedSolarDate);
      });
  }

  _selectLunarDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedLunarDate,
      firstDate: DateTime(1901),
      lastDate: DateTime(2099),
    );
    if (selected != null && selected != selectedLunarDate)
      setState(() {
        selectedLunarDate = selected;
        getSelectedLunarDate(selectedLunarDate);
      });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        selectGanZhiHour = changeSolar2ganZhiHour(selectedTime.hour);
      });
    }
  }
}
