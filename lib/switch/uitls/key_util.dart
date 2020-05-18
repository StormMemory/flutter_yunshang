class KeyUtil {
  static String leancloudappId = "CS91JsEHeISTOICyFJpaUu2G-MdYXbMMI";
  static String leancloudappKey = 'smWC98ehVh25Y0dwWauATrD3';
  static String leancloudObjectId = '5e8546bc743cde00080bc197';
  static String leancloudClass = 'iOS_Project';


  static String getUrl() {
    String apihead = leancloudappId.substring(0, 8);
    return "https://" +
        apihead +
        ".api.lncldglobal.com/1.1/classes/$leancloudClass/$leancloudObjectId";
  }

  //mock
  static String mockUrl = "http://mock-api.com/oKmQJAKX.mock/getController";

}
