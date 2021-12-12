// import 'package:lunar_time/JieQi.dart';
import 'JieQi.dart';

class TianGanDiZhi {
// int Gan = 0;
  String GanYear = "";
  String ZhiYear = "";
  String tianGanDizhiYear = "";

  // int Di = 0;

  int Zhi = 0;
  List<String> TianGan = [
    "癸",
    "甲",
    "乙",
    "丙",
    "丁",
    "戊",
    "己",
    "庚",
    "辛",
    "壬"
  ]; //10 癸从最后挪到第一位, 方便计算  奇数为阳, 偶数为阴
  List<String> DiZhi = [
    "亥",
    "子",
    "丑",
    "寅",
    "卯",
    "辰",
    "巳",
    "午",
    "未",
    "申",
    "酉",
    "戌"
  ]; //12 亥从最后挪到第一位,方便计算

// 支月计算：五虎遁
/* 甲己年起丙寅月
　　乙庚年起戊寅月
　　丙辛年起庚寅月
　　丁壬年起壬寅月
　　戊癸年起甲寅月
* */

// List<String> TianganxiangheCN = ["甲","己","乙","庚","丙","辛","丁","壬", "戊","癸"];
  var TianganxiangheCN = {
    "甲": "丙",
    "己": "丙",
    "乙": "戊",
    "庚": "戊",
    "丙": "庚",
    "辛": "庚",
    "丁": "壬",
    "壬": "壬",
    "戊": "甲",
    "癸": "甲"
  };
  List<String> ZhiMonth = [
    "寅",
    "卯",
    "辰",
    "巳",
    "午",
    "未",
    "申",
    "酉",
    "戌",
    "亥",
    "子",
    "丑",
  ];

  // To call any API, need to call InitGanZhiYear first
  void initGanZhiYear(int lunarYear) {
    /*1、（年份- 3）/10余数对天干：如1894-3=1891 ，1891除以10余数是1即为甲。
    2、（年份- 3）/12余数对地支：如1894-3=1891 ，1891除以12余数是7即为午，即1894年是甲午年。*/
    int tmpGan = (lunarYear - 3) % 10;
    GanYear = TianGan[tmpGan];
    int tmpZhi = (lunarYear - 3) % 12;
    ZhiYear = DiZhi[tmpZhi];
    tianGanDizhiYear = GanYear + ZhiYear;
  }


  String getGanZhiYear(int year) {
    return tianGanDizhiYear;
  }

//润月需要在节气之中搞定,不涉及到这里
  String getGanMonth(int lunarYear) {

    return TianganxiangheCN[GanYear];
  }

  String getZhiMonth(int jieQiMonth) {
    return ZhiMonth[jieQiMonth - 1];
  }

  String getGanZhiMonth(int lunarYear, int jieQiMonth) {
    return getGanMonth(lunarYear) + getZhiMonth(jieQiMonth);
  }


  int testGanZhiMonth(int solarYear, int solarMonth, int solarDay) {
    initGanZhiYear(solarYear);
    var jieQi = new JieQi();
    var jieQiStartDay = jieQi.getJieQiStartDayIn20Century(solarYear, solarMonth);
    var jieQiMonth = jieQi.getJieQiMonth(solarMonth, jieQiStartDay, solarDay);
    return jieQiMonth;
  }

  void testTianGanDiZhiYear() async {
    for (int i = 2000; i < 2050; i++) {
      await new Future.delayed(const Duration(seconds: 1));
      initGanZhiYear(i);
      print(i.toString() + " " + tianGanDizhiYear + "年");
    }
  }

  void testGanZhiYearMonthDay(int solarYear, int solarMonth, int solarDay) {
    initGanZhiYear(solarYear);
    //todo
  }

}
