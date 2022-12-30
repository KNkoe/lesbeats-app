String numberFormat(dynamic n) {
  String num = n.toString();
  int len = num.length;

  if (n >= 1000 && n < 1000000) {
    return '${num.substring(0, len - 3)}.${num.substring(len - 3, 1 + (len - 3))}k';
  } else if (n >= 1000000 && n < 1000000000) {
    return '${num.substring(0, len - 6)}.${num.substring(len - 6, 1 + (len - 6))}m';
  } else if (n > 1000000000) {
    return '${num.substring(0, len - 9)}.${num.substring(len - 9, 1 + (len - 9))}b';
  } else {
    return num.toString();
  }
}
