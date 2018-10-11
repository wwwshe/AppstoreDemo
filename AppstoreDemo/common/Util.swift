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

}
