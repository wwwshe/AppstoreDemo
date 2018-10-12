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
    static func dateStringToDate(date : String) ->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let returnDate = formatter.date(from: date)

        return returnDate!
    }
    
    static func dateToAgoDateText(dateString : String) -> String{
     
        let date = dateStringToDate(date: dateString)
        let intevar = Date().timeIntervalSince(date)
        let days = intevar / 86400
        let time = intevar / 3600
        let min = intevar / 60
        if days >= 365 {
            
            return String(format : "\(Int(days / 365))년 전")
        }else if days >= 30{
            return String("\(Int(days / 30))개월 전")
        }else if days > 0{
            return String("\(Int(days))일 전")
        }else if time > 0{
            return String("\(Int(time))시간 전")
        }else if min > 0 {
            return String("\(Int(min))분 전")
        }else{
            return String("\(intevar)초 전")
        }
    }
    // 사용될 문자와 폰트, 뷰프레인을 받아 문자의 실제 사용될 frame 값을 리턴
    //
    static func stringRect(frame: CGRect, textStr: String, textFont: UIFont) -> CGRect {
        let rect = NSString(string: textStr).boundingRect(with: CGSize(width: frame.width, height:10000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: textFont], context: nil)
        return rect
    }
    // 라벨이 몇줄인지 가져오기
    static func labelGetlines(label : UILabel,string : String) -> Int{
        var lineCount = 0
        let rect = stringRect(frame: CGRect(x: 0, y: 0, width: label.frame.width, height: label.frame.height), textStr: string, textFont: label.font)
        let charSize = lroundf(Float(label.font.lineHeight))
        
        lineCount = Int(rect.height)/charSize
        return lineCount
    }
}
extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}
