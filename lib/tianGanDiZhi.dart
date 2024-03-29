import 'jieQi.dart';

class TianGanDiZhi {
  static String ganYear = "";
  static String zhiYear = "";
  static List<String> tianGan = [
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
  static List<String> DiZhi = [
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

// 支月计算每年的起始月：五虎遁
/* 甲己年起丙寅月
　　乙庚年起戊寅月
　　丙辛年起庚寅月
　　丁壬年起壬寅月
　　戊癸年起甲寅月
* */

  static var TianganxiangheCN = {
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
  static Map<String, int> ganMonth2NumberMap = {
    "甲": 0,
    "乙": 1,
    "丙": 2,
    "丁": 3,
    "戊": 4,
    "己": 5,
    "庚": 6,
    "辛": 7,
    "壬": 8,
    "癸": 9,
  };
  static List<String> ganMonthMap = [
    "甲",
    "乙",
    "丙",
    "丁",
    "戊",
    "己",
    "庚",
    "辛",
    "壬",
    "癸",
  ];
  static List<String> zhiMonthMap = [
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

  //This is neither solar nor lunar year. Adjust the key period before Feb.3~4 and adjust the year.
  static int initGanZhiIntYear(int solarYear, int solarMonth, int solarDay) {
    var ganZhiDigitalYear = solarYear;
    var jieQi = new JieQi();
    // Focus on Jan and Feb.
    if (solarMonth == 1) {
      ganZhiDigitalYear = solarYear - 1;
    }
    if (solarMonth == 2) {
      var jieQiDay = JieQi.getMonthFirstJieQiDayFromTable(solarYear, solarMonth);
      if (jieQiDay > solarDay) {
        ganZhiDigitalYear = solarYear - 1;
      }
    }
    return ganZhiDigitalYear;
  }

  static String initGanZhiStringYear(int ganZhiDigitalYear) {
    /*1、（年份- 3）/10余数对天干：如1894-3=1891 ，1891除以10余数是1即为甲。
    2、（年份- 3）/12余数对地支：如1894-3=1891 ，1891除以12余数是7即为午，即1894年是甲午年。*/
    int tmpGan = (ganZhiDigitalYear - 3) % 10;
    ganYear = tianGan[tmpGan];
    int tmpZhi = (ganZhiDigitalYear - 3) % 12;
    zhiYear = DiZhi[tmpZhi];
    var ganZhiYear = ganYear + zhiYear;
    return ganZhiYear;
  }

  //润月需要在节气之中搞定,不涉及到这里
  static String getGanMonth(int jieQiMonth) {
    // ganYear must be init before this.
    String? startGanMonth = TianganxiangheCN[ganYear];
    int? ganMonthMapIndex = ganMonth2NumberMap[startGanMonth];
    return ganMonthMap[(ganMonthMapIndex! + jieQiMonth - 1) % 10];
  }

  static String getZhiMonth(int jieQiMonth) {
    return zhiMonthMap[jieQiMonth - 1];
  }

  static String getGanZhiMonth(int jieQiMonth) {
    return getGanMonth(jieQiMonth) + getZhiMonth(jieQiMonth);
  }

  int testGanZhiMonth(int solarYear, int solarMonth, int solarDay) {
    // var ganZhiYear = initGanZhiStringYear(solarYear);
    var jieQi = new JieQi();
    var jieQiStartDay = JieQi.getMonthFirstJieQiDayFromTable(solarYear, solarMonth);
    var jieQiMonth = JieQi.getJieQiMonth(solarMonth, jieQiStartDay, solarDay);
    return jieQiMonth;
  }

  void testTianGanDiZhiYear() async {
    for (int i = 2000; i < 2050; i++) {
      await new Future.delayed(const Duration(seconds: 1));
      var ganZhiYear = initGanZhiStringYear(i);
      print(i.toString() + " " + ganZhiYear + "年");
    }
  }

  void testGanZhiYearMonthDay(int solarYear, int solarMonth, int solarDay) {
    initGanZhiStringYear(solarYear);
    //todo
  }
}
