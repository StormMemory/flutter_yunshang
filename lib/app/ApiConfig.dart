class ApiConfig {
  static final String host = "http://courage.cqscrb.top";
  // pic上传和拼接地址
  static final String picHost = "http://image.cqscrb.top";
  // leancloud 地址
  static final String lcHost = "https://WSII1rqO.api.lncldglobal.com";
  // 请求新闻类型
  static final String lcNewsType =
      "/1.1/classes/NewsType/5da972b652d053000994c5c1";
  // 获取新闻内容
  static final String lcNewsContent =
      "/1.1/classes/NewsContent/5da9845752d053000994da79";

  //mock
  static final String mockHost = "http://mock-api.com/ynWo0Pn6.mock";

  static final String getNewsType = "/getNewsType";

  static final String getNewsContent = "/getNewsContent";

  // 登录
  static final String login = "/system/login";
  // 根据条件查询说说
  static final String getTalkList = "/user/talk/getTalkList/";
  // 发送验证码
  static final String sendCode = "/system/sendCode";
  // 注册
  static final String register = "/system/register";
  // 重置密码
  static final String resetPassword = "/system/resetPassword";
  // 修改用户信息
  static String updateUser = "/user/personal/updateUser";
  // 关注或粉丝列表
  static String getUserFollowList = "/user/follow/getUserFollowList";
  // 关注和取消关注
  static String follow = "/user/follow/follow";
  // 根据userId获取用户信息
  static String queryUser = "/user/personal/queryUser";
  // 查询是否关注该用户
  static String isFollow = "/user/follow/isFollow";
  // 互动通知
  static String getUserTalkByUserId = "/user/userTalk/getUserTalkByUserId";
  // 发布动态
  static String publishTalk = "/user/talk/publishTalk";
  // 获取评论列表
  static String getCommentList = "/user/talk/getCommentList";
  // 添加评论
  static String commentTalk = "/user/talk/commentTalk";
  // 点赞
  static String userTalkOperation = "/user/userTalk/userTalkOperation";
  // 屏蔽
  static String block = "/user/personal/block";
  // 举报动态
  static String reportTalk = "/user/talk/reportTalk";
  // 推荐动态
  static String getRecommandTalk = "/user/talk/getRecommandTalk";
  // 获取banner
  static String getBannerList = "/banner/getBannerList";

  // 用户协议
  static final String agreement = "http://www.lianmaiba.com/agreement";
  // 上传图片
  static String uploadPicture = "/upload";
}
