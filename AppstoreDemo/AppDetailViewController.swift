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
    var titleView : UIImageView!

    var infoTitles = ["판매자","크기","카테고리","언어","연령","저작권"]
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        createNavigationItems()
    }
    
    // 네비게이션 타이틀뷰 추가
    func createNavigationItems(){
        let height = 44
        let view = UIView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        titleView = UIImageView(frame : CGRect(x: (height - 24) / 2, y: (height - 24) / 2, width: 24, height: 24))
        titleView.kf.setImage(with: URL(string : data.artworkUrl60))
        titleView.layer.masksToBounds = false
        titleView.layer.cornerRadius =  10
        titleView.clipsToBounds = true
        view.addSubview(titleView)
        self.navigationItem.titleView = view
        titleView.isHidden = true
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

    @objc
    func appMoreBtnFunc(){
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "앱 공유하기...", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            let textToShare = [self.data.trackViewUrl]
            let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            
            // 현재 뷰에서 present
            self.present(activityVC, animated: true, completion: nil)
        })
        
        let otherAppAction = UIAlertAction(title: "이 개발자의 다른 앱 보기", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
           
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
   
        })
        optionMenu.addAction(shareAction)
        optionMenu.addAction(otherAppAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true)
      
    }
    
}

extension AppDetailViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 6{
            return infoTitles.count
        }else{
            return 1
        }
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
            return 44
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel(frame: CGRect(x: 16.0, y: 30.0, width: 150.0, height: 15.0))
        if section == 3 {
            titleLabel.text = "미리보기"
        }else if section == 6{
            titleLabel.text = "정보"
        }
        titleLabel.backgroundColor = .clear
        headerView.addSubview(titleLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 44
        case 6:
            return 44
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
            cell.moreBtn.addTarget(self, action: #selector(appMoreBtnFunc), for: .touchUpInside)
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
            cell.infoTitleText.text = infoTitles[indexPath.row]
            switch(indexPath.row){
            case 0 :
                cell.infoText.text = data.sellerName
            case 1:
                cell.infoText.text = "\((data.fileSizeBytes / 1048576))MB"
            case 2:
                cell.infoText.text = data.genres[0]
            case 3:
                var strings = [String]()
                for code in data.languageCodesISO2A{
                    strings.append(Util.languageCodesToKor(code: code))
                }
                cell.infoText.text =  strings.joined(separator: ",")
            case 4:
                cell.infoText.text = data.trackContentRating
            case 5:
                cell.infoText.text = "ⓒ \(data.sellerName)"
            default:
                break;
            }
  
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    //스크롤 이벤트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 테이블 section 헤더 sticky 기능 막기
        let sectionHeaderHeight : CGFloat = 44.0
        if scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if scrollView.contentOffset.y > sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
        }
        
        
        let scrollOffset = tableView.contentOffset.y
        if scrollOffset >= 133 {
           titleView.isHidden = false
        }else{
            titleView.isHidden = true
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
    
    @IBOutlet weak var infoTitleText: UILabel!
    @IBOutlet weak var infoText: UILabel!
}
