class OtherUsefulFunction {
  OtherUsefulFunction._();

  //将被转义的字符变换原符号
  static String decodeString(String str) {
    return str
        .replaceAll('&amp;', '/')
        .replaceAll("&quot;", "\"")
        .replaceAll("&ldquo;", "“")
        .replaceAll("&rdquo;", "”")
        .replaceAll("<br>", "\n")
        .replaceAll("&gt;", ">")
        .replaceAll("&lt;", "<");
  }
}