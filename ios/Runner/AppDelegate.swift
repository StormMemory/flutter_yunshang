import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller:FlutterViewController = window.rootViewController as! FlutterViewController
    let userdefault = FlutterMethodChannel(name: "str.cqscrb.yunshang/content", binaryMessenger: controller as! FlutterBinaryMessenger)
   
    userdefault.setMethodCallHandler { (call, result) in
           if "OpenContent" == call.method{
               self.setNewsContent(tokenStr: call.arguments as! String)
           }
           
       }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    fileprivate func setNewsContent(tokenStr:String){
           if let url=URL(string: tokenStr){
               if #available(iOS 10, *){
                   UIApplication.shared.open(url,options: [:],completionHandler: {
                       (success)in
                   })
               }else{
                   UIApplication.shared.openURL(url)
               }
           }
       }
}
