
class GanZhiDay {
  /* *http://m.jjdzc.com/suanming/10326.html
  日干支计算口诀
      乘五除四九加日，
      双月间隔三十天。
      一二自加整少一，
      三五七八十尾前。
这口诀的具体意思是说：
年份的后三位乘5+年的后三位除4+9+阳历日子数+单月（为0）双月（30）+每个月的调节数】÷60＝取余数个位数为天干，
余数除12取余为地支，每个月调节数（一、四、五为1）、（二、六、七为2）、（三为0）（八为3）、
（九、十为4）、（十一、十二为5）不过闰年，就是一月、二月，要减去1，后算天干地支数。
例一：1996年1月16日
（96×5＋96÷4＋9＋16）÷60＝8余49，49即为六十甲子序数。9对应天干壬，49除12余1对应地支子，对应干支为“壬子”。
例二：1997年2月16日
（97×5＋97÷4＋9＋16＋30＋2）÷60＝9余26，26即为六十甲子序数。6对应天干己，26除12余2对应地支丑，对应干支为“己丑”。
  *
  * */
  List<String> TianGan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸",];
  List<String> DiZhi =   ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥",];

  String getGanZhiDay(int solarYear, int solarMonth, int solarDay){
    int monthAdjust = 0;
    // leap year adjust
    if ((solarYear%4 == 0) &&
        (solarMonth == 2 || solarMonth == 1)) {
      monthAdjust --;
    }
    if (solarMonth == 1 || solarMonth == 4 || solarMonth == 5) {
      monthAdjust = 1;
    }
    if (solarMonth == 2 || solarMonth == 6 || solarMonth == 7) {
      monthAdjust = 2;
    }
    if (solarMonth == 8) {
      monthAdjust = 3;
    }
    if (solarMonth == 9 || solarMonth == 10) {
      monthAdjust = 4;
    }
    if (solarMonth == 11 || solarMonth == 12) {
      monthAdjust = 5;
    }

    //单月（为0）双月（30）
    int oddEvenMonthAdjust = 0;
    if ((solarMonth % 2) == 0) {
      oddEvenMonthAdjust = 30;
    }
    int tmp1 = solarYear % 100;
    if (solarYear >= 2000) {
      tmp1 += 100;
    }
    int tmp = (tmp1 * 5 + (tmp1/4).truncate() + 9 + solarDay + oddEvenMonthAdjust + monthAdjust) % 60;
    // 个位对应干
    var g = tmp % 10 - 1;
    // circular
    if (g == -1) {
      g += 10;
    }
    var gan = TianGan[g];

    // this is zhi
    var z = tmp % 12 - 1;
    // circular
    if (z == -1) {
      z += 12;
    }
    var zhi = DiZhi[z];

    return gan + zhi;
  }
}