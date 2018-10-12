//
//  AppDetailViewController.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 12..
//  Copyright © 2018년 junjungwook. All rights reserved.
//

import UIKit
import FloatRatingView

class AppDetailViewController : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = SearchData()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AppDetailViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        <#code#>
    }
}

class AppDetailTopCell : UITableViewCell{
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var subName: UILabel!
    @IBOutlet weak var installBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
}

class AppDetailRatingCell : UITableViewCell{
    @IBOutlet weak var ratingText: UILabel!
    
    @IBOutlet weak var rating: FloatRatingView!
    
    @IBOutlet weak var ageText: UILabel!
    
    @IBOutlet weak var ratingCountText: UILabel!
    
}

class AppDetailUpdateContentCell : UITableViewCell{
    
    @IBOutlet weak var versionText: UILabel!
    
    @IBOutlet weak var agoDateText: UILabel!
    
    @IBOutlet weak var contentText: UILabel!
}

class AppDetailContentCell : UITableViewCell{
    
    @IBOutlet weak var contentText: UILabel!
    
    @IBOutlet weak var contentMoreBtn: UIButton!
    
}

class AppDetailDeveloperCell : UITableViewCell{
    @IBOutlet weak var devName: UILabel!
    
}
