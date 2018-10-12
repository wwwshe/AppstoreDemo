//
//  Util.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 11..
//  Copyright © 2018년 junjungwook. All rights reserved.
//

import UIKit

class Util{
    static func alertMsg(viewController : UIViewController, msg : String, handler : ((UIAlertAction) -> Swift.Void)? = nil){
        let alertController = UIAlertController(title: "알림", message:
            msg, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default,handler: handler))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func changeUnitNumber(num : Int) -> String{
        var string = ""
        let i = num / 10000
        if i > 0 {
            let d = (Double(num) / 10000.0) - Double(i)
            let result = d + Double(i)
            string = "\(String(format: "%.1f",result))만"
        }else if num / 1000 > 0{
            let share = num / 1000
            let d = (Double(num) / 1000.0) - Double(share)
            let result = d + Double(share)
            string = "\(String(format: "%.1f",result))천"
        }else{
            string = String(num)
        }
        return string
    }
    

}
