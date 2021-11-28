
int Tian = 0;
int Di = 0;
List<String> TianGan = ["癸", "甲","乙","丙","丁","戊","己", "庚","辛","壬",]; //10 癸从最后挪到第一位, 方便计算
List<String> DiZhi = ["亥", "空", "子","丑","寅","卯","辰","巳", "午","未","申","酉","戌",]; //12 亥从最后挪到第一位,方便计算
String GetTianGanDizhiYear(int year){
  /*1、（年份- 3）/10余数对天干：如1894-3=1891 ，1891除以10余数是1即为甲。
    2、（年份- 3）/12余数对地支：如1894-3=1891 ，1891除以12余数是7即为午，即1894年是甲午年。*/
  Tian = (year - 3)%10;
  String TianGanYear = TianGan[Tian];
  Di = (year - 3)%12;
  String DiZhiYear = DiZhi[Di];
  String TianGanDizhiYear = TianGanYear + DiZhiYear;
  return TianGanDizhiYear;
}

String GetTianGanDizhiMonth(int month) {


}
String GetTianGanDizhiDay(int month) {


}
