//
//  AppDetailViewController.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 12..
//  Copyright © 2018년 junjungwook. All rights reserved.
//
// 앱 상세 페이지

import UIKit
import FloatRatingView

class AppDetailViewController : UIViewController{
    static func storyboardInstance() -> AppDetailViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AppDetailViewController") as! AppDetailViewController
        return controller
    }
    @IBOutlet weak var tableView: UITableView!
    
    var data = SearchData()
    var updateContentMore = false
    var contentMore = false
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 버전 코멘트나 앱 상세 설명 더보기 이벤트
    @objc
    func contentMoreBtnFunc(_ sender : UIButton){
        let tag = sender.tag
        if tag == 0 {
            updateContentMore = true
            self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
        }else{
            contentMore = true
            self.tableView.reloadSections(IndexSet(integer: 4), with: .none)
        }
    }

    
}

extension AppDetailViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 133
        case 1:
            return 66
        case 2:
            return UITableView.automaticDimension
        case 3:
            return 500
        case 4:
            return UITableView.automaticDimension
        case 5:
            return 69
        case 6:
            return 180
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppDetailTopCell") as! AppDetailTopCell
            cell.appIcon.kf.setImage(with: URL(string : data.artworkUrl100))
            cell.appName.text = data.trackName
            cell.subName.text = data.genres.joined(separator: ",")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppDetailRatingCell") as! AppDetailRatingCell
            cell.rating.rating = data.averageUserRating
            cell.ratingText.text = Util.changeUnitNumber(num: data.userRatingCount) + "개의 평가"
            cell.ageText.text = data.trackContentRating
            cell.categoryText.text = data.genres[0]
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppDetailUpdateContentCell") as! AppDetailUpdateContentCell
            cell.versionText.text = "버전 \(data.version)"
            cell.agoDateText.text = Util.dateToAgoDateText(dateString: data.currentVersionReleaseDate)
            cell.contentText.text = data.releaseNotes
            cell.moreBtn.tag = 0
            cell.moreBtn.addTarget(self, action: #selector(AppDetailViewController.contentMoreBtnFunc(_:)), for: .touchUpInside)
            if Util.labelGetlines(label: cell.contentText,string: data.releaseNotes) <= 3{
                cell.moreBtn.isHidden = true
            }
            
            if updateContentMore == true {
                cell.contentText.numberOfLines = 0
                cell.moreBtn.isHidden = true
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppDetailScreenShotCell") as! AppDetailScreenShotCell
            cell.parentView = self
            cell.screenshots = data.screenshotUrls
            cell.collectionViewSet()
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppDetailContentCell") as! AppDetailContentCell
            cell.contentText.text = data.des
            cell.contentMoreBtn.tag = 1
            cell.contentMoreBtn.addTarget(self, action: #selector(contentMoreBtnFunc(_:)), for: .touchUpInside)
            if Util.labelGetlines(label: cell.contentText,string : data.des) <= 3{
                cell.contentMoreBtn.isHidden = true
            }
            if contentMore == true {
                cell.contentText.numberOfLines = 0
                cell.contentMoreBtn.isHidden = true
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppDetailDeveloperCell") as! AppDetailDeveloperCell
            cell.devName.text = data.artistName
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppDetailInfoCell") as! AppDetailInfoCell
            cell.sellerText.text = data.sellerName
            cell.fileSizeText.text = "\((data.fileSizeBytes / 1048576))MB"
            cell.ageText.text = data.trackContentRating
            cell.copyRight.text = "ⓒ \(data.sellerName)"
            return cell
        default:
            return UITableViewCell()
        }
    }
}

class AppDetailTopCell : UITableViewCell{
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var subName: UILabel!
    @IBOutlet weak var installBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    override func awakeFromNib() {
        self.installBtn.layer.masksToBounds = false
        self.installBtn.layer.cornerRadius =  self.installBtn.frame.height/2
        self.installBtn.clipsToBounds = true
        self.appIcon.layer.masksToBounds = false
        self.appIcon.layer.cornerRadius =  10
        self.appIcon.clipsToBounds = true
        
        self.moreBtn.layer.masksToBounds = false
        self.moreBtn.layer.cornerRadius =  self.moreBtn.frame.height/2
        self.moreBtn.clipsToBounds = true
    
    }
}

class AppDetailRatingCell : UITableViewCell{
    @IBOutlet weak var ratingText: UILabel!
    
    @IBOutlet weak var rating: FloatRatingView!
    
    @IBOutlet weak var ageText: UILabel!
    
    @IBOutlet weak var ratingCountText: UILabel!
    @IBOutlet weak var categoryText: UILabel!
    
}

class AppDetailUpdateContentCell : UITableViewCell{
    
    @IBOutlet weak var versionText: UILabel!
    
    @IBOutlet weak var agoDateText: UILabel!
    
    @IBOutlet weak var contentText: UILabel!
    
    @IBOutlet weak var moreBtn: UIButton!
}

class AppDetailContentCell : UITableViewCell{
    
    @IBOutlet weak var contentText: UILabel!
    
    @IBOutlet weak var contentMoreBtn: UIButton!
    
}

class AppDetailDeveloperCell : UITableViewCell{
    @IBOutlet weak var devName: UILabel!
    
}

class AppDetailInfoCell : UITableViewCell{
    
    @IBOutlet weak var sellerText: UILabel!
    @IBOutlet weak var fileSizeText: UILabel!
    @IBOutlet weak var categoryText: UILabel!
    @IBOutlet weak var ageText: UILabel!
    @IBOutlet weak var copyRight: UILabel!
}
