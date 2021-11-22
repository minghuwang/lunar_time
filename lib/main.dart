import 'package:lunar_calendar/lunar_calendar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '时辰',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
  List<String> lunarVi;
  DateTime myTime;
  String lunarHour;
  String currentHour;
  String currentMin;
  String currentSec;

  void getCurrentTime() {
    setState(() {
      myTime = DateTime.now();

      // int hour = myTime.hour;
      lunarHour = change2LunarHour(myTime.hour);
      List<int> tmpLunarVi = CalendarConverter.solarToLunar(
          myTime.year, myTime.month, myTime.day, Timezone.Chinese);
      lunarVi = transfer2Upper(tmpLunarVi);
      currentHour = myTime.hour.toString();
      if (myTime.hour < 10) {
        currentHour = "0" + currentHour;
      }
      currentMin = myTime.minute.toString();
      if (myTime.minute < 10) {
        currentMin = "0" + currentMin;
      }
        currentSec = myTime.second.toString();
      if (myTime.second < 10) {
        currentSec = "0" + currentSec;
      }

    });
  }

  String change2LunarHour(int hour) {
    List<String> lunarHour = [
      "子时", "丑时", "寅时", "卯时",
      "辰时", "巳时", "午时", "未时",
      "申时", "酉时", "戌时", "亥时",
    ];
    if (hour >= 23 && hour < 1) return lunarHour[0];
    if (hour >= 1 && hour < 3) return lunarHour[1];
    if (hour >= 3 && hour < 5) return lunarHour[2];
    if (hour >= 5 && hour < 7) return lunarHour[3];
    if (hour >= 7 && hour < 9) return lunarHour[4];
    if (hour >= 9 && hour < 11) return lunarHour[5];
    if (hour >= 11 && hour < 13) return lunarHour[6];
    if (hour >= 13 && hour < 15) return lunarHour[7];
    if (hour >= 15 && hour < 17) return lunarHour[8];
    if (hour >= 17 && hour < 19) return lunarHour[9];
    if (hour >= 19 && hour < 21) return lunarHour[10];
    if (hour >= 21 && hour < 23) return lunarHour[11];
  }
  //Transfer 2021 to 二零二一
  List<String> transfer2Upper(List<int> lunarVi) {
    List<String> l = [];
    l.add(changeInt2UpperStringForMonthNDay(lunarVi[0])); // day
    l.add(changeInt2UpperStringForMonthNDay(lunarVi[1])); //month
    l.add(changeInt2UpperStringForYear(lunarVi[2])); //year
    return l;
  }

  String changeInt2UpperStringForMonthNDay(int time) {
    List<String> zeroTo31 = [
      // 零 is stub
      "零", "一", "二", "三", "四", "五", "六", "七", "八", "九",
      "十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九",
      "二十", "二十一", "二十二", "二十三", "二十四", "二十五", "二十六", "二十七", "二十八", "二十九",
      "三十", "三十一",
    ];
    return zeroTo31[time];
  }

  String changeInt2UpperStringForYear(int time) {
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

  @override
  Widget build(BuildContext context) {
    getCurrentTime();
    // return MaterialApp(
        // theme: ThemeData(
        //   // primarySwatch: COLORS.APP_THEME_COLOR,
        //   // primaryTextTheme: TextTheme(
        //   //   title: TextStyle(color: Colors.white),
        //   // ),
        //   fontFamily: 'Georgia',
        // ),
        // debugShowCheckedModeBanner: false,
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text('现在时辰',
                //   style: Theme
                //       .of(context)
                //       .textTheme
                //       .headline5,
                // ),
                Text('现在时辰',style: TextStyle(color: Colors.black,fontSize:30 ), ),
                Text('\n公历: ${myTime.year}年${myTime.month}月${myTime.day}日${currentHour}:${currentMin}:${currentSec}',style: TextStyle(color: Colors.black54,fontSize:20), ),
                Text('\n农历: ${lunarVi[2]}年${lunarVi[1]}月${lunarVi[0]}日',style: TextStyle(color: Colors.black54,fontSize:20), ),
                Text('${lunarHour}',style: TextStyle(color: Colors.black,fontSize:20),),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: getCurrentTime,
            tooltip: '刷新',
            child: Icon(Icons.refresh
            ),
          ),
        );// This trailing comma makes auto-formatting nicer for build methods.
        // );
  }
}
