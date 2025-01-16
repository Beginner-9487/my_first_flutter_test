class CharacterConvertor {
  static String decodeHtml(String str) {
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