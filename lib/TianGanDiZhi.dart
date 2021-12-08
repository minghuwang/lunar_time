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


// 五虎遁
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

  String getGanZhiYear(int year) {
    if (tianGanDizhiYear == "") {
        InitGanzhiYear(year);
    }
  }

//润月需要在节气之中搞定,不涉及到这里
  String getGanMonth(int lunarYear) {
  if (GanYear == "") {
  InitGanzhiYear(lunarYear);
  }
  return TianganxiangheCN[GanYear];
  }

  String getZhiMonth(int lunarMonth) {
  return ZhiMonth[lunarMonth - 1];
  }

  String getGanzhiMonth(int lunarYear, int lunarMonth) {
    return getGanMonth(lunarYear) + getZhiMonth(lunarMonth);
  }

  void testGanZhiMonth() async {
  for (int i = 2000; i < 2050; i++) {
  InitGanzhiYear(i);
  await new Future.delayed(const Duration(microseconds: 10));
  for (int month = 1; month < 12; month ++) {
  print(GanYear + "年　" + getGanzhiMonth(i, month) + "月");
  }
  }
  }

  void InitGanzhiYear(int year) {
    /*1、（年份- 3）/10余数对天干：如1894-3=1891 ，1891除以10余数是1即为甲。
    2、（年份- 3）/12余数对地支：如1894-3=1891 ，1891除以12余数是7即为午，即1894年是甲午年。*/
    int tmpGan = (year - 3) % 10;
    GanYear = TianGan[tmpGan];
    int tmpZhi = (year - 3) % 12;
    ZhiYear = DiZhi[tmpZhi];
    tianGanDizhiYear = GanYear + ZhiYear;
  }

  void testTianGanDiZhiYear() async {
    for (int i = 2000; i < 2050; i++) {
      await new Future.delayed(const Duration(seconds: 1));
      InitGanzhiYear(i);
      print(i.toString() + " " + tianGanDizhiYear + "年");
    }
  }


  String GetTianGanDizhiDay(int month) {


  }

}